# Cyberpunk: Edgerunners — Moonfall Overdrive

A native Ryoku rice grounded in the finale, **My Moon My Man**: David's cyberskeleton assault on Arasaka Tower, his Sandevistan/cyberpsychosis collapse, and the moon promise at the center of his relationship with Lucy.

## Desktop direction

- 10-second 1920×1080 H.264 live wallpaper at 24 FPS
- Cyberskeleton David and Night City parallax
- Sandevistan chromatic afterimages and velocity flashes
- Gravity rings, cyberpsychosis cuts, pursuit telemetry, and immunoblocker warnings
- Bottom full-width combat bar
- Left autohide dock
- Split 96-bar visualizer with mirror/reflection
- Fixed yellow, cyan, hot-pink, and black palette across terminal/apps
- Animated borders, pink glow, blur, dimming, flash-focus, and dynamic cursor
- Cherry MX Blue key sounds
- Custom Edgerunners Fastfetch
- Calendar desktop widget disabled

## Separate custom lockscreen

`edgerunners-moon-promise` is a distinct 12-second Lucy lunar scene—not the desktop wallpaper. It includes an orbital clock, floating zero-g fragments, story text, a dedicated authentication rail, segmented password telemetry, failure shake, and Sandevistan unlock flash.

## Install from this directory

The custom lockscreen must exist before applying the rice:

```bash
mkdir -p ~/.local/share/qylock/themes
cp -a lockscreen/edgerunners-moon-promise ~/.local/share/qylock/themes/
```

Then apply:

```bash
ryoku-hub rice preflight cyberpunk-edgerunners-moonfall-overdrive
ryoku-hub rice apply cyberpunk-edgerunners-moonfall-overdrive
```

## Ryoku Kasane

After this rice directory is installed under `~/.config/ryoku/rices/`, Kasane discovers it automatically as a **NATIVE** rice. Select it and press **Apply Layer**. Use **Roll Back** to restore the previous rice.

## Recovery

The desktop captured immediately before this build is:

```bash
ryoku-hub rice apply pre-edgerunners-baseline
```

## Rights and attribution

This is an unofficial, noncommercial fan rice. See [CREDITS.md](CREDITS.md). Third-party artwork is marked for private personal use and is not relicensed by this package.
