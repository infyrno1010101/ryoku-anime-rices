# Contributing

Contributions are welcome when they preserve the pack's defining rule: every rice must be a genuinely distinct desktop direction rather than a palette swap.

A new submission should include:

- a native Ryoku `rice.json` with relative packaged assets;
- a distinct animated wallpaper and five-second preview;
- a fixed palette and themed Fastfetch configuration;
- a distinct bar/dock/widget composition and visualizer treatment;
- enabled key sounds and a disabled calendar desktop widget;
- a source/credit entry for all third-party media;
- successful `python3 scripts/verify.py` and `sha256sum -c SHA256SUMS` results.

Do not submit credentials, absolute home paths, arbitrary hooks, installation commands inside manifests, or media whose source cannot be identified.
