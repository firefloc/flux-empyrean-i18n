#!/usr/bin/env python3
"""Regenere res://Scripts/texts.gd en clair a partir du corpus JSON.

Le script d'origine est un autoload de donnees pures : aucune methode, quatre
variables (texts, discoveries, authors, favorites). On peut donc le remplacer
par une source GDScript equivalente, que le moteur compile au chargement.

Usage: gen_texts_gd.py <corpus.json> <sortie.gd> [<traduction.json>]
"""
import json
import sys


def gd_str(s: str) -> str:
    out = s.replace("\\", "\\\\").replace('"', '\\"')
    out = out.replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t")
    return f'"{out}"'


def gd_value(v, indent: int = 1) -> str:
    pad = "\t" * indent
    if isinstance(v, str):
        return gd_str(v)
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    if v is None:
        return "null"
    if isinstance(v, list):
        if not v:
            return "[]"
        items = ",\n".join(f"{pad}\t{gd_value(e, indent + 1)}" for e in v)
        return f"[\n{items},\n{pad}]"
    if isinstance(v, dict):
        if not v:
            return "{}"
        items = ",\n".join(
            f"{pad}\t{gd_str(str(k))}: {gd_value(e, indent + 1)}" for k, e in v.items()
        )
        return f"{{\n{items},\n{pad}}}"
    raise TypeError(f"type non gere: {type(v)}")


def main() -> None:
    if len(sys.argv) not in (3, 4):
        raise SystemExit(__doc__)
    data = json.load(open(sys.argv[1], encoding="utf-8"))
    if len(sys.argv) == 4:
        tr = json.load(open(sys.argv[3], encoding="utf-8"))
        for key, body in tr.get("texts", {}).items():
            if key in data["texts"]:
                data["texts"][key] = body
        for field in ("discoveries", "authors"):
            for key, val in tr.get(field, {}).items():
                if key in data[field]:
                    data[field][key] = val

    lines = [
        "# Genere par tools/gen_texts_gd.py — ne pas editer a la main.",
        "extends Node",
        "",
    ]
    for name in ("texts", "discoveries", "authors", "favorites"):
        lines.append(f"var {name} = {gd_value(data[name])}")
        lines.append("")
    open(sys.argv[2], "w", encoding="utf-8").write("\n".join(lines))
    print(f"{sys.argv[2]}: {len(data['texts'])} documents")


if __name__ == "__main__":
    main()
