#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "SHA256SUMS"
paths = sorted(
    path for path in ROOT.rglob("*")
    if path.is_file()
    and path != OUTPUT
    and ".git" not in path.parts
    and "__pycache__" not in path.parts
)
lines = []
for path in paths:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    lines.append(f"{h.hexdigest()}  {path.relative_to(ROOT)}")
OUTPUT.write_text("\n".join(lines) + "\n")
print(f"wrote {len(lines)} checksums")
