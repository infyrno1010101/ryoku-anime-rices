#!/usr/bin/env python3
from pathlib import Path
import hashlib
root=Path(__file__).resolve().parent;out=root/'SHA256SUMS';lines=[]
for p in sorted(x for x in root.rglob('*') if x.is_file() and x!=out):
 h=hashlib.sha256(p.read_bytes()).hexdigest();lines.append(f'{h}  {p.relative_to(root)}')
out.write_text('\n'.join(lines)+'\n');print(f'wrote {len(lines)} checksums')
