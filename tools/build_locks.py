#!/usr/bin/env python3
"""Construit l'inventaire des verrous d'énigme à partir des sources décompilées.

Deux régimes de comparaison, aux conséquences opposées pour la traduction :

- **sous-chaîne** — `answer in text.to_lower()` : le joueur peut taper une phrase
  entière, il suffit que la réponse y figure. Le token anglais doit donc rester
  littéralement présent dans le document français qui l'enseigne.
- **égalité** — `text.to_lower() == "x"` ou `text.to_lower() in [...]` : le joueur
  doit taper exactement le token. Le document n'a pas à le contenir tel quel,
  mais il doit rendre évident *quoi taper*, en anglais.

Confondre les deux fait soit casser une énigme, soit tordre un texte pour rien.

Usage: build_locks.py
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
SRC = WORK / "src"
JEU = ROOT / "game"

# Le nœud portant la saisie n'est pas toujours nommé « text » : les scènes
# écrivent aussi `$MemorialScreen / … / Answer1.text`. Il faut donc accepter un
# chemin de nœud complet, espaces autour des « / » comprises.
NODE = r"(?:[\w$/.]+(?:\s*/\s*[\w$.]+)*\.text|text)"
SUBSTRING = re.compile(r"(?:if|elif|=)\s*(?:\"([^\"]+)\"|([A-Za-z_]\w*))(?:\.to_lower\(\))?\s+in\s+" + NODE + r"\.to_lower\(\)")
EQUALITY = re.compile(r"(?:if|elif|=)\s*" + NODE + r"\.to_lower\(\)\s*==\s*(?:\"([^\"]+)\"|([A-Za-z_]\w*))")
IN_LIST = re.compile(r"(?:if|elif|=)\s*" + NODE + r"\.to_lower\(\)\s+in\s+\[([^\]]+)\]")
IN_VAR = re.compile(r"(?:if|elif|=)\s*" + NODE + r"\.to_lower\(\)\s+in\s+([A-Za-z_]\w*)\s*:")


def scene_answers(script_name: str, exported: dict) -> list[str]:
    """Les réponses posées en @export sur les nœuds de la scène du même lieu."""
    stem = script_name.rsplit("__", 1)[0].replace("__", "/")
    return exported.get(stem, [])


def main() -> None:
    # Les valeurs @export relevées dans les scènes par find_locks.gd, regroupées
    # par dossier de lieu : c'est là que vivent les réponses, pas dans le code.
    scenes = json.loads((WORK / "puzzle_locks.scenes.json").read_text(encoding="utf-8"))
    exported: dict[str, list[str]] = {}
    for entry in scenes["entrees"]:
        folder = entry["scene"].rsplit("/", 1)[0].replace("res://", "")
        exported.setdefault(folder, []).append(entry["token"])

    points = []
    for path in sorted(SRC.glob("*.gd")):
        text = path.read_text(encoding="utf-8")
        if "LineEdit.text" not in text and ".text.to_lower()" not in text.replace(" ", ""):
            continue
        script = path.name.replace("__", "/").replace(".gd", ".gdc")
        for line in text.splitlines():
            line = line.strip()
            for regime, rx in (("sous_chaine", SUBSTRING), ("egalite", EQUALITY)):
                m = rx.search(line)
                if not m:
                    continue
                literal, variable = m.group(1), m.group(2)
                tokens = [literal] if literal else scene_answers(path.name, exported)
                points.append({
                    "script": script,
                    "regime": regime,
                    "source_du_token": "litteral" if literal else f"@export {variable}",
                    "tokens": sorted(set(tokens)),
                    "code": line,
                })
            m = IN_LIST.search(line)
            if m:
                points.append({
                    "script": script,
                    "regime": "egalite",
                    "source_du_token": "liste litterale",
                    "tokens": re.findall(r'"([^"]*)"', m.group(1)),
                    "code": line,
                })
            m = IN_VAR.search(line)
            if m and not IN_LIST.search(line):
                points.append({
                    "script": script,
                    "regime": "egalite",
                    "source_du_token": f"@export {m.group(1)}",
                    "tokens": sorted(set(scene_answers(path.name, exported))),
                    "code": line,
                })

    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))

    def body(v):
        return "\n".join(v) if isinstance(v, list) else str(v)

    # Un token n'est rattaché à un document que s'il y est rare : chercher
    # « true » dans 167 documents ne dit rien, chercher « sferdan » dit tout.
    for p in points:
        p["documents_source"] = {}
        for tok in p["tokens"]:
            if len(tok) < 4 or tok.isdigit():
                continue
            rx = re.compile(r"\b" + re.escape(tok) + r"\b", re.I)
            hits = [d for d, v in corpus["texts"].items() if rx.search(body(v))]
            p["documents_source"][tok] = hits if len(hits) <= 6 else f"{len(hits)} documents (trop courant pour être discriminant)"

    # Rattachements manuels : une réponse portée par un acrostiche n'apparaît
    # nulle part en clair, aucun relevé automatique ne peut la trouver.
    manuel = json.loads((JEU / "locks_manual.json").read_text(encoding="utf-8"))
    for regle in manuel.get("points", []):
        for p in points:
            if p["script"] != regle["script"]:
                continue
            p["tokens"] = sorted(set(p["tokens"]) | set(regle.get("ajouter_tokens", [])))
            p["documents_source"].update(regle.get("documents_source", {}))
            if regle.get("tokens_par_acrostiche"):
                p["tokens_par_acrostiche"] = regle["tokens_par_acrostiche"]
            p["note"] = regle.get("motif", "")

    out = {
        "regimes": {
            "sous_chaine": "answer in text.to_lower() — le token anglais DOIT rester "
                           "littéralement présent dans le document français.",
            "egalite": "text.to_lower() == token — le joueur tape exactement le token. "
                       "Le document doit rendre évident quoi taper, en anglais.",
        },
        "points_de_saisie": points,
    }
    (WORK / "puzzle_locks.json").write_text(
        json.dumps(out, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    counts = {}
    for p in points:
        counts[p["regime"]] = counts.get(p["regime"], 0) + 1
    print(f"points de saisie: {len(points)} | {counts}")
    for p in points:
        docs = {k: v for k, v in p["documents_source"].items() if isinstance(v, list) and v}
        print(f"  [{p['regime']:11s}] {p['script']:52s} {p['tokens']}")
        for tok, ds in docs.items():
            print(f"                enseigne par « {tok} » -> {ds}")


if __name__ == "__main__":
    main()
