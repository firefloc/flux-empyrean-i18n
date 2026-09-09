#!/usr/bin/env python3
"""Prépare une langue vide, prête à recevoir sa traduction.

Commencer une langue à partir d'un dossier vide, c'est buter sur les mêmes
pièges que nous : ne pas savoir quels mots portent la logique du jeu, ni que
`aliases.json` existe, ni pourquoi il est le fichier le plus important du lot.

Le squelette produit ici répond à ça. Il ne contient **aucune traduction** — ce
serait absurde — mais il contient la liste exacte de ce qu'il faut décider :

- `aliases.json` arrive pré-rempli avec les mots-réponses **qu'une traduction va
  forcément déplacer**, chacun avec une liste vide. Chaque liste laissée vide,
  c'est une énigme que le joueur ne pourra résoudre qu'en anglais. C'est la
  checklist qui manquait.
- Les mots-réponses qu'il ne faut **pas** toucher — nombres, noms propres, mots
  de la langue xérétique, clés de chiffrement — sont listés à part dans
  `glossary.json`. Demander leur équivalent aurait été un piège : traduire
  « minos » ou « 1034 » casse l'énigme au lieu de l'ouvrir.
- `code_overrides.json` liste les six commandes du terminal, même principe.
- `documents.json`, `scenes.json`, `scripts.json` sont des conteneurs vides mais
  valides, pour que `build.py` marche dès le premier jour.
- `glossary.json` pose les noms propres à ne jamais traduire, qui sont des faits
  du jeu et pas des choix de langue.

Les listes de mots viennent de `web/index/verrous.json`, qui décrit le jeu, pas
une traduction — donc valable pour toutes les langues.

Usage:
    init_locale.py <code de langue> [<code> ...]
    init_locale.py --liste            # les langues déjà présentes
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
INDEX = ROOT / "web" / "index"
LOCALES = ROOT / "locales"

# Utile pour le message d'aide, sans prétendre à l'exhaustivité.
CONNUES = {
    "de": "allemand", "es": "espagnol", "it": "italien", "pt-BR": "portugais (Brésil)",
    "ru": "russe", "pl": "polonais", "tr": "turc", "nl": "néerlandais",
    "ja": "japonais", "ko": "coréen", "zh-Hans": "chinois simplifié",
    "uk": "ukrainien", "cs": "tchèque", "sv": "suédois",
}

AVERTISSEMENT = (
    "Indexé par empreinte SHA-1 de la chaîne anglaise, pour ne pas embarquer le "
    "texte du jeu. L'éditeur web et l'outillage la retrouvent dans la copie du joueur."
)


def tokens_du_jeu() -> set[str]:
    verrous = json.loads((INDEX / "verrous.json").read_text(encoding="utf-8"))
    return {t for p in verrous.get("points_de_saisie", []) for t in p.get("tokens", [])}


def a_pourvoir() -> list[str]:
    """Les mots-réponses qu'une traduction va déplacer, et qu'il faut donc aliaser.

    La référence est le jeu de clés du français : c'est la seule langue complète,
    et son jeu s'est constitué en travaillant chaque énigme une par une — il
    couvre notamment les seize titres de « menottes », que `verrous.json` ne
    liste pas parce qu'ils sont comparés ailleurs dans le code.

    Sans le français, on retombe sur les tokens bruts, en acceptant que la liste
    contienne alors des choses à ne pas traduire.
    """
    reference = LOCALES / "fr" / "aliases.json"
    if reference.exists():
        return sorted(json.loads(reference.read_text(encoding="utf-8")))
    return sorted(tokens_du_jeu())


def a_ne_pas_traduire() -> list[str]:
    """Les mots-réponses qui doivent rester à l'identique, quelle que soit la langue."""
    return sorted(tokens_du_jeu() - set(a_pourvoir()))


def commandes_terminal() -> dict[str, list[str]]:
    """Les commandes que `terminal_manager.gd` reconnaît par un `match`."""
    return {c: [] for c in ("help", "unlock", "lock", "download", "key", "flux")}


def creer(code: str) -> bool:
    dossier = LOCALES / code
    if dossier.exists():
        print(f"  {code} : existe déjà, laissé intact")
        return False
    dossier.mkdir(parents=True)

    alias = {mot: [] for mot in a_pourvoir()}
    fichiers = {
        "aliases.json": alias,
        "code_overrides.json": {
            "_note": (
                "Les commandes du terminal acceptent plusieurs motifs : ajoute les "
                "tiennes, les anglaises restent acceptées. `reecritures` sert aux cas "
                "qu'aucun relevé automatique ne trouve — voir locales/fr pour un exemple."
            ),
            "commandes_terminal": commandes_terminal(),
            "reecritures": {},
        },
        "documents.json": {},
        "scenes.json": {},
        "scripts.json": {"avertissement": AVERTISSEMENT, "chaines": {}},
        "decrypt.json": {},
        "glossary.json": {
            "regle": (
                "Les titres de documents, les noms de lieux et les noms propres restent "
                "en anglais : le code du jeu les relit comme clés de dictionnaire et les "
                "écrit tels quels dans la sauvegarde. Ce n'est pas un choix de style."
            ),
            "noms_propres_a_conserver": [
                "Aeon", "Corba", "Feodor", "Flux", "Minos", "Wim", "Xeres", "Xeretic",
            ],
            "reponses_a_ne_jamais_traduire": {
                "_note": (
                    "Le jeu compare ces saisies à l'identique. Ce sont des nombres, des "
                    "noms propres, des mots de la langue xérétique ou des clés de "
                    "chiffrement : les traduire ferme l'énigme au lieu de l'ouvrir. Elles "
                    "n'ont volontairement pas d'entrée dans aliases.json."
                ),
                "mots": a_ne_pas_traduire(),
            },
            "termes": {},
        },
        "arbitrages.json": {
            "_note": (
                "Les décisions transverses de cette langue, avec leur raison. Ce qui "
                "compte n'est pas d'avoir raison mais d'être appliqué partout : le jeu "
                "est bâti sur des renvois entre textes."
            ),
        },
    }
    for nom, contenu in fichiers.items():
        (dossier / nom).write_text(
            json.dumps(contenu, ensure_ascii=False, indent="\t") + "\n", encoding="utf-8"
        )
    print(f"  {code} : créé — {len(alias)} mots-réponses à pourvoir, "
          f"{len(a_ne_pas_traduire())} à laisser tels quels")
    return True


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__ + "\nLangues courantes : " + ", ".join(sorted(CONNUES)))
    if sys.argv[1] == "--liste":
        for d in sorted(p.name for p in LOCALES.iterdir() if p.is_dir()):
            docs = json.loads((LOCALES / d / "documents.json").read_text(encoding="utf-8"))
            faits = sum(1 for v in docs.values() if any(v.get("pages", [])))
            print(f"  {d:8s} {faits:3d} / 167 documents")
        return

    crees = sum(creer(code) for code in sys.argv[1:])
    if crees:
        print(
            f"\n{crees} langue(s) prête(s). Pour traduire : ouvre web/index.html, charge "
            "ton jeu,\npuis les fichiers de la langue. Pour construire : "
            "python3 build.py <exécutable> <code>"
        )


if __name__ == "__main__":
    main()
