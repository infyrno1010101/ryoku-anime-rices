#!/usr/bin/env python3
from pathlib import Path
import hashlib, json, subprocess, sys

ROOT = Path(__file__).resolve().parents[1]
RICES = ROOT / "rices"
PREVIEWS = ROOT / "previews"
POSTERS = ROOT / "docs" / "posters"
EXPECTED = 20
CUSTOM_LOCKS = {
    "cyberpunk-edgerunners-moonfall-overdrive": "edgerunners-moon-promise",
    "demon-slayer-musical-score-inferno": "demon-slayer-wisteria-blood-moon",
    "fight-club-project-mayhem": "fight-club-cigarette-burn-changeover",
    "lock-stock-debt-domino": "lock-stock-antique-evidence",
    "snatch-fourth-round-diamond": "snatch-diamond-vault",
}

errors = []
rows = []
video_hashes = set()
preview_hashes = set()
custom_locks = 0

def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def probe(path: Path):
    proc = subprocess.run([
        "ffprobe", "-v", "error", "-count_frames",
        "-show_entries", "format=duration:stream=codec_name,width,height,r_frame_rate,nb_read_frames",
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
    preview = PREVIEWS / f"{slug}.gif"
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
        frame_count = int(stream.get("nb_read_frames", 0) or 0)
        if stream.get("codec_name") != "gif" or stream.get("width") != 640 or stream.get("height") != 360 or abs(duration - 5) > 0.11 or frame_count < 45:
            errors.append(f"{slug}: animated GIF preview contract failed: {metadata}")
    if not poster.is_file():
        errors.append(f"{slug}: poster missing")
    expected_lock = CUSTOM_LOCKS.get(slug)
    if expected_lock:
        if assets.get("lock") != expected_lock:
            errors.append(f"{slug}: expected custom lock {expected_lock}, got {assets.get('lock')}")
        lock_dir = directory / "lockscreen" / expected_lock
        required_lock = ["Main.qml", "BackgroundVideo.qml", "metadata.desktop", "theme.conf", "bg.mp4", "preview.gif", "PROVENANCE.txt"]
        for name in required_lock:
            if not (lock_dir / name).is_file():
                errors.append(f"{slug}: missing bundled lockscreen file {name}")
        lock_bg = lock_dir / "bg.mp4"
        if lock_bg.is_file():
            metadata = probe(lock_bg)
            stream = next(iter(metadata.get("streams", [])), {})
            duration = float(metadata.get("format", {}).get("duration", 0))
            if stream.get("codec_name") != "h264" or stream.get("width") != 1920 or stream.get("height") != 1080 or abs(duration - 12) > 0.05:
                errors.append(f"{slug}: lockscreen background contract failed: {metadata}")
        lock_preview = lock_dir / "preview.gif"
        if lock_preview.is_file():
            metadata = probe(lock_preview)
            stream = next(iter(metadata.get("streams", [])), {})
            duration = float(metadata.get("format", {}).get("duration", 0))
            frame_count = int(stream.get("nb_read_frames", 0) or 0)
            if stream.get("codec_name") != "gif" or stream.get("width") != 640 or stream.get("height") != 360 or abs(duration - 5) > 0.11 or frame_count < 45:
                errors.append(f"{slug}: lockscreen GIF contract failed: {metadata}")
        custom_locks += 1
    rows.append({"slug": slug, "keys": keys.get("profile"), "bar": bar.get("barShellStyle"), "preview": preview.name, "lock": assets.get("lock")})

print(json.dumps({"rice_count": len(rice_dirs), "wallpaper_hashes": len(video_hashes), "preview_hashes": len(preview_hashes), "custom_locks": custom_locks, "errors": errors, "rices": rows}, indent=2))
raise SystemExit(1 if errors else 0)
