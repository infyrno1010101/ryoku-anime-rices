#!/usr/bin/env python3
from pathlib import Path
import hashlib, json, subprocess, sys

ROOT = Path(__file__).resolve().parents[1]
RICES = ROOT / "rices"
PREVIEWS = ROOT / "previews"
POSTERS = ROOT / "docs" / "posters"
EXPECTED = 15

errors = []
rows = []
video_hashes = set()
preview_hashes = set()

def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def probe(path: Path):
    proc = subprocess.run([
        "ffprobe", "-v", "error",
        "-show_entries", "format=duration:stream=codec_name,width,height,r_frame_rate",
        "-of", "json", str(path)
    ], text=True, capture_output=True)
    if proc.returncode:
        errors.append(f"ffprobe failed: {path}: {proc.stderr.strip()}")
        return {}
    return json.loads(proc.stdout)

rice_dirs = sorted(path for path in RICES.iterdir() if path.is_dir())
if len(rice_dirs) != EXPECTED:
    errors.append(f"expected {EXPECTED} rice directories, found {len(rice_dirs)}")

for directory in rice_dirs:
    slug = directory.name
    manifest_path = directory / "rice.json"
    try:
        manifest = json.loads(manifest_path.read_text())
    except Exception as exc:
        errors.append(f"invalid manifest {manifest_path}: {exc}")
        continue
    if manifest.get("slug") != slug:
        errors.append(f"slug mismatch: {slug} != {manifest.get('slug')}")
    assets = manifest.get("assets", {})
    required = ["wallpaper", "hero", "fastfetch", "fastfetchStyle", "palette"]
    for key in required:
        value = assets.get(key)
        if not value or not (directory / value).is_file():
            errors.append(f"{slug}: missing asset {key}={value!r}")
    widgets = manifest.get("look", {}).get("widgets", {})
    if widgets.get("calendarEnabled") is not False:
        errors.append(f"{slug}: calendarEnabled must be false")
    look = manifest.get("look", {})
    keys = look.get("hypr", {}).get("plugins", {}).get("keysounds", {})
    if keys.get("enabled") is not True or not keys.get("profile"):
        errors.append(f"{slug}: key sounds are not enabled/configured")
    bar = look.get("shell", {}).get("qsbar", {})
    if bar.get("barFrostEnabled") is not True or float(bar.get("barAnim", 0)) < 2:
        errors.append(f"{slug}: animated/frosted bar contract not met")
    wall = directory / assets.get("wallpaper", "wall.mp4")
    if wall.is_file():
        wall_hash = digest(wall)
        if wall_hash in video_hashes:
            errors.append(f"{slug}: duplicate wallpaper hash")
        video_hashes.add(wall_hash)
        metadata = probe(wall)
        stream = next(iter(metadata.get("streams", [])), {})
        duration = float(metadata.get("format", {}).get("duration", 0))
        if stream.get("codec_name") != "h264" or stream.get("width") != 1920 or stream.get("height") != 1080 or abs(duration - 10) > 0.05:
            errors.append(f"{slug}: wallpaper media contract failed: {metadata}")
    preview = PREVIEWS / f"{slug}.mp4"
    poster = POSTERS / f"{slug}.jpg"
    if not preview.is_file():
        errors.append(f"{slug}: preview missing")
    else:
        preview_hash = digest(preview)
        if preview_hash in preview_hashes:
            errors.append(f"{slug}: duplicate preview hash")
        preview_hashes.add(preview_hash)
        metadata = probe(preview)
        stream = next(iter(metadata.get("streams", [])), {})
        duration = float(metadata.get("format", {}).get("duration", 0))
        if stream.get("codec_name") != "h264" or stream.get("width") != 1280 or stream.get("height") != 720 or abs(duration - 5) > 0.05:
            errors.append(f"{slug}: preview media contract failed: {metadata}")
    if not poster.is_file():
        errors.append(f"{slug}: poster missing")
    rows.append({"slug": slug, "keys": keys.get("profile"), "bar": bar.get("barShellStyle"), "preview": preview.name})

print(json.dumps({"rice_count": len(rice_dirs), "wallpaper_hashes": len(video_hashes), "preview_hashes": len(preview_hashes), "errors": errors, "rices": rows}, indent=2))
raise SystemExit(1 if errors else 0)
