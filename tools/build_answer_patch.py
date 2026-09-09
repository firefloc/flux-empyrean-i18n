#!/usr/bin/env python3
"""Rend les énigmes acceptantes des réponses françaises.

Sans ça, la traduction est prise en étau : soit on garde des mots anglais en
plein texte français pour que la saisie passe, soit on traduit proprement et
l'énigme devient insoluble.

Patcher le code lève l'étau : chaque comparaison accepte désormais la réponse
anglaise **et** ses équivalents français. L'anglais reste accepté, donc une
solution trouvée dans un guide ou un forum continue de marcher.

Deux réécritures selon le régime de comparaison :

    if text.to_lower() == "immortal":
    -> if text.to_lower() in ["immortal", "immortel", "immortelle"]:

    if answer in text.to_lower():
    -> if answer in text.to_lower() or _fr_alias(answer, text.to_lower()):

La seconde s'appuie sur un couple const/func ajouté en fin de fichier : en
GDScript, l'ordre des déclarations au niveau du fichier est libre.

Usage: build_answer_patch.py
"""

from __future__ import annotations

import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"
LOCALE = ROOT / "locales" / os.environ.get("LOCALE", "fr")

HELPER = '''

const FR_ALIASES := {aliases}


func _fr_alias(reponse: String, saisie: String) -> bool:
\tfor alias in FR_ALIASES.get(reponse.to_lower(), []):
\t\tif alias in saisie:
\t\t\treturn true
\treturn false


func _fr_accepte(reponses: Array, saisie: String) -> bool:
\tif saisie in reponses:
\t\treturn true
\tfor reponse in reponses:
\t\tif saisie in FR_ALIASES.get(String(reponse).to_lower(), []):
\t\t\treturn true
\treturn false
'''


# Les terminaux des stations ont leur propre analyseur de commandes, un `match`
# que ni `==` ni `in` ne repèrent. Les six commandes sont tapées par le joueur et
# listées en clair par la commande `help` : elles doivent rester saisissables. Un
# `match` GDScript accepte plusieurs motifs séparés par des virgules, donc la
# forme française s'ajoute sans toucher au corps du bloc.
COMMANDES_TERMINAL: dict[str, list[str]] = {}


# Le Hall of Judgment demande de nommer les coupables de sept crimes. Les
# réponses sont des noms de personnes — sauf une, « archive curators », un
# syntagme anglais ordinaire qu'un traducteur rendra forcément en français.
# Le tableau est déclaré en dur, hors de tout `if`, donc invisible pour le
# relevé des points de saisie.
REECRITURES: dict[str, list] = {}


# Les seize énigmes de « menottes » demandent un nom et un titre. Le nom est
# comparé en sous-chaîne, le titre en **égalité stricte** — et les seize titres
# sont des mots anglais ordinaires (`witness`, `judge`, `oblivion`, `fool`…) que
# tout traducteur rendra en français. Le script vit sous `Scenes/` et nomme ses
# exports `name_answer` / `title_answer`, d'où son absence du relevé.




def patch_terminal() -> list[list[str]]:
    remplacements = []
    for commande, alias in COMMANDES_TERMINAL.items():
        if not alias:
            continue
        motifs = ", ".join(f'"{c}"' for c in [commande] + alias)
        remplacements.append([f'\t\t"{commande}":', f"\t\t{motifs}:"])
    return remplacements


def gd_dict(mapping: dict[str, list[str]]) -> str:
    if not mapping:
        return "{}"
    lines = ["{"]
    for key, values in sorted(mapping.items()):
        rendered = ", ".join(f'"{v}"' for v in values)
        lines.append(f'\t"{key}": [{rendered}],')
    lines.append("}")
    return "\n".join(lines)


def main() -> None:
    global COMMANDES_TERMINAL, REECRITURES
    surcharges = json.loads((LOCALE / "code_overrides.json").read_text(encoding="utf-8"))
    COMMANDES_TERMINAL = surcharges.get("commandes_terminal", {})
    REECRITURES = surcharges.get("reecritures", {})

    locks = json.loads((WORK / "puzzle_locks.json").read_text(encoding="utf-8"))
    aliases_file = LOCALE / "aliases.json"
    aliases: dict[str, list[str]] = (
        json.loads(aliases_file.read_text(encoding="utf-8")) if aliases_file.exists() else {}
    )

    patches: dict[str, list[list[str]]] = {}
    helpers: dict[str, dict[str, list[str]]] = {}
    ignores: list[str] = []

    for point in locks["points_de_saisie"]:
        script, code = point["script"], point["code"]
        concerned = aliases
        if not any(aliases.get(t) for t in point["tokens"]) and point["regime"] == "egalite":
            ignores.append(f"{script} :: {point['tokens']}")
            continue

        if point["regime"] == "egalite":
            m = re.search(r'to_lower\(\)\s*==\s*"([^"]+)"', code)
            if m:
                token = m.group(1)
                accepted = [token] + aliases.get(token, [])
                rendered = ", ".join(f'"{a}"' for a in accepted)
                new = code.replace(m.group(0), f"to_lower() in [{rendered}]")
                patches.setdefault(script, []).append([code, new])
                continue
            m = re.search(r"to_lower\(\)\s+in\s+\[([^\]]+)\]", code)
            if m:
                existing = re.findall(r'"([^"]*)"', m.group(1))
                extra = [a for t in existing for a in aliases.get(t, []) if a not in existing]
                if extra:
                    rendered = ", ".join(f'"{a}"' for a in existing + extra)
                    new = code.replace(m.group(1), rendered)
                    patches.setdefault(script, []).append([code, new])
                continue
            # appartenance à un tableau @export : yes/no/true/false et compagnie
            m = re.search(r"(?:if|elif)\s+(.+?)\.to_lower\(\)\s+in\s+([A-Za-z_]\w*)\s*:", code)
            if m:
                new = code.replace(
                    f"{m.group(1)}.to_lower() in {m.group(2)}",
                    f"_fr_accepte({m.group(2)}, {m.group(1)}.to_lower())",
                )
                patches.setdefault(script, []).append([code, new])
                helpers.setdefault(script, {}).update(concerned)
                continue
            # comparaison contre une variable @export : on passe par l'aide
            m = re.search(r"to_lower\(\)\s*==\s*([A-Za-z_]\w*)", code)
            if m:
                var = m.group(1)
                new = code.replace(
                    m.group(0), f"{m.group(0)} or _fr_alias({var}, {code.split('.to_lower')[0].split()[-1]}.to_lower())"
                )
                patches.setdefault(script, []).append([code, new])
                helpers.setdefault(script, {}).update(concerned)
            continue

        # régime sous-chaîne : la réponse vient d'une variable @export
        m = re.search(r"([A-Za-z_]\w*)(?:\.to_lower\(\))?\s+in\s+([\w$/. ]*\.to_lower\(\))", code)
        if m and not code.lstrip().startswith('if "'):
            new = code.replace(m.group(0), f"{m.group(0)} or _fr_alias({m.group(1)}, {m.group(2)})")
            patches.setdefault(script, []).append([code, new])
            helpers.setdefault(script, {}).update(concerned)
        else:
            m = re.search(r'"([^"]+)"\s+in\s+([\w$/. ]*\.to_lower\(\))', code)
            if m:
                token = m.group(1)
                extra = " or ".join(f'"{a}" in {m.group(2)}' for a in aliases.get(token, []))
                new = code.replace(m.group(0), f"{m.group(0)} or {extra}")
                patches.setdefault(script, []).append([code, new])

    patches["Scripts/terminal_manager.gdc"] = patch_terminal()
    for script, paires in REECRITURES.items():
        patches[script] = [list(p) for p in paires]
        # Un script réécrit à la main peut avoir besoin de la table d'alias.
        if any("_fr_alias" in p[1] or "_fr_accepte" in p[1] for p in paires):
            helpers[script] = aliases

    out = {
        "remplacements": patches,
        "aides": {s: HELPER.format(aliases=gd_dict(a)) for s, a in helpers.items()},
    }
    (WORK / "answer_patch.json").write_text(
        json.dumps(out, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    print(f"scripts patchés : {len(patches)} | aides à injecter : {len(helpers)}")
    for script, pairs in patches.items():
        for before, after in pairs:
            print(f"  {script}\n    - {before}\n    + {after}")
    if ignores:
        print(f"\nsans alias, donc inchangés ({len(ignores)}) :")
        for i in ignores:
            print(f"  {i}")


if __name__ == "__main__":
    main()
