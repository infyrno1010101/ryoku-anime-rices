# Fight Club — Project Mayhem

A native Ryoku rice centered on Tyler Durden addressing the camera during the identity manifesto: “You’re not your job… You’re not your fucking khakis… You’re the all-singing, all-dancing crap of the world.”

## Desktop
- 10-second 1920×1080 H.264 animated wallpaper at 24 FPS
- Authentic six-second Tyler close-up expanded into a ten-second loop with mostly natural motion and short violent shake/zoom/rotation bursts synchronized to each phrase impact
- Unboxed `FightThis` distressed lettering: “YOU’RE NOT YOUR JOB” stamps high-left; “YOU’RE NOT YOUR / FUCKING KHAKIS” strikes the opposite lower side; “ALL-SINGING”, “ALL-DANCING”, and “CRAP OF THE WORLD” erupt independently around Tyler
- Top full film-strip bar; dock hidden
- Frame visualizer, fixed pink/mint/black palette, animated borders/glow/blur
- Cherry MX Brown key sounds; custom Fastfetch; calendar disabled

## Separate lockscreen
`fight-club-cigarette-burn-changeover` is a distinct 12-second 4K-derived projection-booth scene with Tyler at the reel bench, rotating reel telemetry, a five-second changeover counter, two cigarette-burn cue pulses, splice authentication, and a physical-film unlock wipe.

## Install lockscreen
```bash
mkdir -p ~/.local/share/qylock/themes
cp -a lockscreen/fight-club-cigarette-burn-changeover ~/.local/share/qylock/themes/
```

## Apply
```bash
ryoku-hub rice preflight fight-club-project-mayhem
ryoku-hub rice apply fight-club-project-mayhem
```
Kasane discovers it automatically as a NATIVE rice. Recovery: `ryoku-hub rice apply pre-crime-cinema-baseline`.

See `CREDITS.md`. This is an unofficial noncommercial personal-use fan rice.

The baked wallpaper needs no installed font. `font/FIGHTT3_.ttf` and its original `FightThis.txt` are bundled for reproducible edits.
