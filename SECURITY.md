# Security

These rice packages are declarative desktop configuration plus media. They intentionally contain no install commands, arbitrary hooks, privileged helpers, or `/usr` writes.

Before applying a rice, run:

```bash
ryoku-hub rice preflight <slug>
```

Report a suspected unsafe manifest, credential leak, path traversal, or malicious asset through GitHub's private vulnerability-reporting interface if enabled, or contact the repository owner privately. Do not include secrets in a public issue.
