# Skills

Four mechanisms, installed independently.

| Mechanism | Count | Source of truth | Install |
| --------- | ----- | --------------- | ------- |
| `skills` CLI (vercel-labs) -> `~/.agents/skills/*`, symlinked into `~/.claude/skills/` | 50 | [skills.txt](skills.txt) (`source skill`) | `30-skills.sh` |
| Vendored in this repo -> copied to `~/.claude/skills/` | 3 | [`/skills`](../../skills) | `30-skills.sh` |
| Git clone -> `~/.claude/skills/notebooklm` | 1 | PleasePrompto/notebooklm-skill | `30-skills.sh` |
| Plugin-bundled (superpowers, ecc, designer-skills, impeccable, anthropic skills, ...) | ~200 | [plugins-config](../plugins-config/README.md) | `20-plugins.sh` |

## Install

```bash
bash scripts/install/30-skills.sh
```

Manual:

```bash
npx -y skills add coreyhaines31/marketingskills --skill copywriting -g -a claude-code -y   # one per line of skills.txt
npx -y skills add heygen-com/hyperframes --skill '*' -g -a claude-code -y                  # whole repo at once
cp -R skills/* ~/.claude/skills/                                                           # vendored
git clone https://github.com/PleasePrompto/notebooklm-skill ~/.claude/skills/notebooklm      # notebooklm
```

## skills.txt by source

| Source | Skills |
| ------ | ------ |
| coreyhaines31/marketingskills | 23: ab-test-setup, analytics-tracking, competitor-alternatives, copy-editing, copywriting, email-sequence, form-cro, free-tool-strategy, launch-strategy, marketing-ideas, marketing-psychology, onboarding-cro, page-cro, paid-ads, paywall-upgrade-cro, popup-cro, pricing-strategy, programmatic-seo, referral-program, schema-markup, seo-audit, signup-flow-cro, social-content |
| heygen-com/hyperframes | 19: hyperframes, hyperframes-animation/cli/core/creative/keyframes/registry, embedded-captions, faceless-explainer, figma, general-video, media-use, motion-graphics, music-to-video, pr-to-video, product-launch-video, remotion-to-hyperframes, slideshow, talking-head-recut (needs `ffmpeg`) |
| anthropics/skills | canvas-design, skill-creator |
| vercel-labs/skills | find-skills |
| vercel-labs/agent-browser | agent-browser (needs `npm i -g agent-browser`) |
| vercel-labs/deepsec | deepsec |
| nextlevelbuilder/ui-ux-pro-max-skill | ui-ux-pro-max |
| supabase/agent-skills | supabase-postgres-best-practices |
| cloudflare/security-audit-skill | security-audit |

## Vendored (hand-made, no upstream)

- `skills/ask-me-questions-for-context` -- 40-50 question interview that produces a reusable context `.md`
- `skills/critical-thinking-partner` -- constructive-disagreement review mode
- `skills/brand-guidelines` -- generic brand colors/typography for artifacts (not the Anthropic-branded one in `example-skills`)

## Turned off on the reference machine

`settings.json` -> `skillOverrides` sets 44 installed skills to `"off"` (most marketingskills + hyperframes,
agent-browser, deepsec, ui-ux-pro-max, and the two vendored interview/critique skills). They stay installed; the
setting only hides them. Step 50 copies the same overrides. Toggle one:

```bash
jq '.skillOverrides["copywriting"] = "off"' ~/.claude/settings.json > /tmp/s && mv /tmp/s ~/.claude/settings.json   # or: del(.skillOverrides["copywriting"])
```

## Not reproduced

- `~/.claude/skills/learned` -- empty dir created by ecc.
- `~/.claude/skills/synced` -- managed by claude.ai skill sync; appears on its own after login.

## Verify

```bash
ls ~/.claude/skills | wc -l                         # 56 on the reference machine
jq '.skills | length' ~/.agents/.skill-lock.json
```

## More

[list-of-additional-third-party-skills.md](list-of-additional-third-party-skills.md) -- curated extras
(superset: some installed, some not).
