#!/usr/bin/env python3
"""Recolle un .pck dans un exe Godot a pack embarque.

Usage: splice.py <exe_origine> <nouveau_pck> <exe_sortie>

Le pack embarque se termine par un pied de 12 octets : taille (int64 LE)
puis la magie "GDPC". On garde l'entete de l'exe telle quelle et on
remplace tout ce qui suit.
"""
import os
import struct
import sys


def pack_offset(exe: str) -> int:
    with open(exe, "rb") as f:
        f.seek(-12, os.SEEK_END)
        tail = f.read()
        size = struct.unpack("<q", tail[0:8])[0]
        if tail[8:12] != b"GDPC":
            raise SystemExit(f"{exe}: pas de pack embarque (magie {tail[8:12]!r})")
        return f.seek(0, os.SEEK_END) - 12 - size


def main() -> None:
    if len(sys.argv) != 4:
        raise SystemExit(__doc__)
    src, pck, dst = sys.argv[1:4]
    start = pack_offset(src)
    size = os.path.getsize(pck)
    with open(dst, "wb") as out:
        with open(src, "rb") as f:
            out.write(f.read(start))
        with open(pck, "rb") as f:
            while chunk := f.read(1 << 20):
                out.write(chunk)
        out.write(struct.pack("<q", size) + b"GDPC")
    os.chmod(dst, 0o755)
    print(f"{dst}: {os.path.getsize(dst)} octets (entete {start}, pack {size})")


if __name__ == "__main__":
    main()
