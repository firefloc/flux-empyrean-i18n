#!/usr/bin/env python3
"""Fusionne les lots traduits en un seul fichier consommable par gen_texts_gd.py.

Refuse de fusionner un lot qui n'a pas passé verify_translation.py, sauf
`--force`. Un lot qui casse un verrou d'énigme ne doit jamais atteindre le mod.

Usage: merge_translations.py [--force]
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "work"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true", help="fusionne malgré les erreurs")
    args = parser.parse_args()

    batches = sorted(WORK.glob("lots/lot_*/traduction.json")) + sorted(
        WORK.glob("pilote/traduction.json")
    )
    if not batches:
        print("aucun lot traduit")
        return 1

    texts: dict[str, list[str]] = {}
    rejected: list[str] = []
    glossary_proposals: dict[str, dict[str, list[str]]] = {}
    doubts: list[dict] = []

    for path in batches:
        check = subprocess.run(
            [sys.executable, str(ROOT / "tools" / "verify_translation.py"), str(path)],
            capture_output=True,
            text=True,
        )
        ok = check.returncode == 0
        label = "OK " if ok else "KO "
        print(f"{label} {path.parent.name}")
        if not ok:
            print("\n".join("     " + l for l in check.stdout.splitlines() if "[ERREUR]" in l))
            if not args.force:
                rejected.append(path.parent.name)
                continue

        batch = json.loads(path.read_text(encoding="utf-8"))
        for doc, payload in batch.items():
            if doc in texts:
                print(f"     doublon ignoré : {doc} (déjà fourni par un autre lot)")
                continue
            texts[doc] = payload["pages"]
            for en, fr in (payload.get("glossaire_propose") or {}).items():
                glossary_proposals.setdefault(en, {}).setdefault(fr, []).append(doc)
            for d in payload.get("doutes") or []:
                doubts.append({"document": doc, "doute": d})

    (WORK / "translation_texts.json").write_text(
        json.dumps({"texts": texts}, ensure_ascii=False, indent="\t"), encoding="utf-8"
    )
    conflicts = {en: v for en, v in glossary_proposals.items() if len(v) > 1}
    (WORK / "glossary_proposals.json").write_text(
        json.dumps(
            {"propositions": glossary_proposals, "conflits": conflicts, "doutes": doubts},
            ensure_ascii=False,
            indent="\t",
        ),
        encoding="utf-8",
    )

    corpus = json.loads((WORK / "texts_corpus.json").read_text(encoding="utf-8"))
    print(f"\ndocuments traduits : {len(texts)} / {len(corpus['texts'])}")
    if rejected:
        print(f"lots rejetés : {', '.join(rejected)}")
    if conflicts:
        print(f"conflits de glossaire à arbitrer : {len(conflicts)}")
    if doubts:
        print(f"doutes remontés : {len(doubts)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
