# Helper Scripts (`~/.claude/bin`)

| Script | Used by | Needs |
| ------ | ------- | ----- |
| [bin/ollama-cloud](../../bin/ollama-cloud) | "Ollama Cloud" section of the global `CLAUDE.md` (step 10) | `python3`, macOS Keychain item `ollama-cloud-api-key` |

## Install

```bash
bash scripts/install/75-bin.sh                                           # or: install -m 700 bin/* ~/.claude/bin/
security add-generic-password -a "$USER" -s ollama-cloud-api-key -U -w   # once per machine; prompts for the key
```

## Verify

```bash
~/.claude/bin/ollama-cloud --list-models | head -3
```

## Not reproduced

- `~/.claude/bin/cf-images-upload` -- local only: it hardcodes a Cloudflare account id.
