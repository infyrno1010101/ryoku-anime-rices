#!/usr/bin/env python3
from pathlib import Path
import concurrent.futures, json, os, subprocess

ROOT = Path(__file__).resolve().parents[1]
PREVIEWS = ROOT / "previews"
mp4s = sorted(PREVIEWS.glob("*.mp4"))
if len(mp4s) != 15:
    raise SystemExit(f"expected 15 MP4 previews, found {len(mp4s)}")

def convert(source: Path):
    target = source.with_suffix(".gif")
    temporary = target.with_suffix(".rendering.gif")
    filter_graph = (
        "fps=10,scale=640:360:flags=lanczos,split[s0][s1];"
        "[s0]palettegen=max_colors=128:stats_mode=diff[p];"
        "[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"
    )
    subprocess.run([
        "ffmpeg", "-y", "-loglevel", "error", "-i", str(source),
        "-t", "5", "-filter_complex", filter_graph, "-loop", "0", str(temporary)
    ], check=True)
    probe = subprocess.run([
        "ffprobe", "-v", "error",
        "-show_entries", "format=duration:stream=codec_name,width,height,r_frame_rate,nb_frames",
        "-of", "json", str(temporary)
    ], text=True, capture_output=True, check=True)
    metadata = json.loads(probe.stdout)
    os.replace(temporary, target)
    return source.stem, target.stat().st_size, metadata

with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
    results = list(pool.map(convert, mp4s))

metadata = {slug: probe for slug, _size, probe in results}
(ROOT / "preview-metadata.json").write_text(json.dumps(metadata, indent=2) + "\n")
for source in mp4s:
    source.unlink()
for slug, size, probe in results:
    duration = probe.get("format", {}).get("duration", "unknown")
    print(f"GIF {slug} {size} bytes {duration}s")
