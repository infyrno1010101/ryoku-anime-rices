#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]
SLUGS = [
    "jujutsu-kaisen-season-3-culling-game-overdrive",
    "frieren-season-2-aureole-reverie",
    "witch-hat-atelier-silver-ink-coven",
    "bleach-tybw-blood-war-zenith",
    "mushoku-tensei-mana-labyrinth",
    "goodbye-lara-abyssal-farewell",
    "polar-opposites-season-2-chromatic-polarity",
    "ghost-in-the-shell-cyberbrain-rain",
    "daemons-shadow-realm-gate-of-night",
    "jojo-steel-ball-run-golden-spin",
    "hells-paradise-season-2-tao-inferno",
    "dorohedoro-season-2-hole-smoke-ritual",
    "one-piece-elbaph-giants-dawn",
    "nippon-sangoku-ashen-shogunate",
    "black-torch-mononoke-ember",
]
DIRECTIONS = {
    "jujutsu-kaisen-season-3-culling-game-overdrive": "Culling Game ensemble with chromatic glitches, moving barrier bands, and cursed-energy pressure.",
    "frieren-season-2-aureole-reverie": "A serene ultra-wide journey pan with drifting light and a quiet blue-gold atmosphere.",
    "witch-hat-atelier-silver-ink-coven": "Portrait parchment composition animated with rotating drafting circles and living silver ink.",
    "bleach-tybw-blood-war-zenith": "Stark monochrome Soul Reaper poster cut by moving red blades and inversion flashes.",
    "mushoku-tensei-mana-labyrinth": "Cinematic interior parallax with expanding cyan-jade mana rings.",
    "goodbye-lara-abyssal-farewell": "Lake and mermaid imagery animated through water-refraction strips and rising bubbles.",
    "polar-opposites-season-2-chromatic-polarity": "A playful manga-cover split screen moving in opposing pink and cyan directions.",
    "ghost-in-the-shell-cyberbrain-rain": "Cyber portrait with scanlines, block glitches, and falling neural data.",
    "daemons-shadow-realm-gate-of-night": "The official key visual becomes two opposed moving gates divided by a gold seam.",
    "jojo-steel-ball-run-golden-spin": "Johnny, Gyro, and Lucy framed by an animated golden-ratio spiral.",
    "hells-paradise-season-2-tao-inferno": "Shinsenkyo artwork transformed into a living red-and-jade floral kaleidoscope.",
    "dorohedoro-season-2-hole-smoke-ritual": "A gritty character scene distorted by drifting smoke and chromatic corruption.",
    "one-piece-elbaph-giants-dawn": "Elbaph battle art with a rising world-tree camera and rotating sky runes.",
    "nippon-sangoku-ashen-shogunate": "Manga-cover imagery treated as a severe moving ink map with a pulsing red seal.",
    "black-torch-mononoke-ember": "Character key art surrounded by rising embers, spirit particles, and black-flame strokes.",
}

entries = []
for slug in SLUGS:
    manifest = json.loads((ROOT / "rices" / slug / "rice.json").read_text())
    keys = manifest["look"]["hypr"]["plugins"]["keysounds"]
    qsbar = manifest["look"]["shell"]["qsbar"]
    entries.append({
        "slug": slug,
        "name": manifest["name"],
        "blurb": manifest["blurb"],
        "direction": DIRECTIONS[slug],
        "key_profile": keys["profile"],
        "bar": qsbar["barShellStyle"],
        "position": qsbar["barPosition"],
        "lock": manifest["assets"].get("lock", "packaged"),
    })

header = """# Ryoku Anime Rices

Fifteen highly animated, full-desktop native rices for the Ryoku Arch Linux/Hyprland environment. Each rice packages its animated wallpaper, fixed palette, Fastfetch identity, lockscreen selection, animated bar and dock layout, widgets, Hyprland effects, visualizer, cursor treatment, and mechanical key-sound profile.

> **Fan project:** This repository is unofficial and is not affiliated with, endorsed by, or sponsored by the series creators, publishers, animation studios, or rights holders. Series names and source imagery remain the property of their respective owners. See [Credits and media notice](CREDITS.md).

## Design promise

These are not one template recolored fifteen times. Every rice has a distinct composition and motion language: glitch, serene pan, parchment drafting, blade flash, mana rings, water refraction, split polarity, cyber scan, twin gates, golden spiral, floral kaleidoscope, smoke displacement, world-tree rise, ink-map movement, or black flame.

All fifteen intentionally:

- use a 10-second, 1920×1080, 24 FPS H.264 animated wallpaper;
- include an animated/frosted bar treatment and an active visualizer;
- include a themed Fastfetch presentation;
- enable a mechanical key-sound profile;
- disable the calendar desktop widget;
- work with `ryoku-hub rice ...` and appear automatically in Ryoku Kasane.

## Preview gallery

Click any image to open its five-second MP4 preview.

| Rice | Preview | Motion and shell identity |
|---|---|---|
"""
rows = []
for e in entries:
    rows.append(f'| **{e["name"]}**<br><code>{e["slug"]}</code> | [![Preview for {e["name"]}](docs/posters/{e["slug"]}.jpg)](previews/{e["slug"]}.mp4) | {e["direction"]} **Bar:** {e["position"]} {e["bar"]}. **Keys:** {e["key_profile"]}. |')

install = """

## Install

### Recommended: clone the complete pack

```bash
git clone https://github.com/infyrno1010101/ryoku-anime-rices.git
cd ryoku-anime-rices
./scripts/install.sh all
```

The installer performs user-local file copies only. It does not use `sudo`, execute rice hooks, or modify `/usr`.

### Install one rice

```bash
./scripts/install.sh witch-hat-atelier-silver-ink-coven
```

### Manual installation

```bash
mkdir -p ~/.config/ryoku/rices
cp -a rices/witch-hat-atelier-silver-ink-coven ~/.config/ryoku/rices/
```

## Apply from the terminal

List the installed rices:

```bash
ryoku-hub rice list
```

Inspect one before applying:

```bash
ryoku-hub rice preflight witch-hat-atelier-silver-ink-coven
```

Apply it:

```bash
ryoku-hub rice apply witch-hat-atelier-silver-ink-coven
```

### Apply through Ryoku Kasane

1. Open **Ryoku Kasane**.
2. Select any rice marked **NATIVE**.
3. Use **Preview** to inspect the transaction plan.
4. Press **Apply Layer** to switch the active desktop rice.
5. Use **Roll Back** to return to the previously active rice.

Kasane discovers native rices automatically from `~/.config/ryoku/rices/`; importing an archive is not required.

## Apply commands

"""
commands = []
for e in entries:
    commands.append(f'### {e["name"]}\n\n{e["blurb"]}\n\n```bash\nryoku-hub rice apply {e["slug"]}\n```\n')

footer = """
## Safety and recovery

Capture your current desktop before experimenting:

```bash
snapshot=$(ryoku-hub rice capture "Before Anime Rice Pack")
ryoku-hub rice save "$snapshot"
```

Then restore that captured rice later through `ryoku-hub rice list` and `ryoku-hub rice apply <captured-slug>`.

These manifests contain no install commands or arbitrary hooks. Applying a rice is still a real desktop configuration change, so use `preflight` first and keep a baseline.

## Repository layout

```text
rices/<slug>/          Complete native Ryoku rice
previews/<slug>.mp4    Five-second H.264 preview
docs/posters/<slug>.jpg Clickable preview poster
scripts/install.sh     User-local installer
scripts/verify.py      Manifest/media/integrity validation
CREDITS.md             Artwork attribution and media notice
SHA256SUMS             Integrity checksums
```

## Verification

```bash
python3 scripts/verify.py
sha256sum -c SHA256SUMS
```

The validator checks all fifteen manifests, packaged assets, preview duration and codec, no-calendar policy, animated bar settings, key sounds, and duplicate video hashes.

## Contributing

Please do not submit recolors or lightly modified copies. New rices should have a distinct scene composition, motion language, shell layout, bar/dock treatment, widgets, visualizer geometry, Fastfetch identity, and sound profile.
"""
(ROOT / "README.md").write_text(header + "\n".join(rows) + install + "\n".join(commands) + footer)
(ROOT / "catalog.json").write_text(json.dumps(entries, ensure_ascii=False, indent=2) + "\n")
print(f"wrote README and catalog for {len(entries)} rices")
