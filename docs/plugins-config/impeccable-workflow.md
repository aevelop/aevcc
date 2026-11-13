# The Impeccable Workflow (4.x)

Written for impeccable 4.8.0 (`impeccable@impeccable`, enabled user-wide). Upstream docs: https://impeccable.style/docs

Impeccable fights generic "AI slop" UI: the Inter font, purple gradients, cards in cards, gray text on color. In 4.x
it is one skill, `/impeccable`, with verbs, plus a design-detector hook. Two ways to use it:

- `/impeccable <verb> [target]`, for example `/impeccable audit src/app/pricing` or `/impeccable polish the header`.
- Plain language ("make this dashboard feel less cramped"). The skill triggers on its own for frontend design work and
  picks the verb itself.

## What changed from 1.3.0

| 1.3.0 | 4.x |
| ----- | --- |
| 17 separate commands (`/impeccable:teach-impeccable`, `/impeccable:polish`, ...) | one skill with 24 verbs: `/impeccable polish` |
| `teach-impeccable` wrote a design block into `CLAUDE.md` | `init` writes `PRODUCT.md` (`teach` still works as an alias) |
| no record of the existing visual system | `document` writes `DESIGN.md` from the current code |
| prompts only | hooks: a detector runs after UI file edits and a deeper pass at Stop |
| -- | `shape` (plan before code), `live` / `generate` (variants in the browser), `doctor`, `hooks` |
| `craft` | deprecated alias for an ordinary build request; adds nothing |

Per-project state now lives in `PRODUCT.md`, `DESIGN.md` and `.impeccable/config.json`, not in `CLAUDE.md`.

## Phase 0: set up a project (once)

1. `/impeccable init` runs a discovery interview (users, brand, principles, platform) and writes `PRODUCT.md`.
   Every other verb reads it. A new surface without `PRODUCT.md` is routed through `init` first; a small fix to
   existing code proceeds and offers `init` afterwards.
2. `/impeccable document` (existing projects) extracts colors, type, spacing, radii and component patterns into
   `DESIGN.md`, so refinements keep the current identity instead of inventing a new one.
3. Later, `/impeccable doctor` finds and repairs drift between those files, the config, the hook and what this
   version expects. Run it after upgrading the plugin.

## Phase 1: plan (new screens and redesigns)

`/impeccable shape [feature]` interviews you (one round by default) and produces a design brief you confirm before
any code is written. Every brief picks one mode, chosen from the surface rather than the product:

| Mode | The visitor succeeds when they... | Typical surfaces |
| ---- | --------------------------------- | ---------------- |
| Persuade | decide and act | landing, marketing, pricing |
| Operate | finish a task | app UI, dashboards, admin, settings |
| Read | understand something | docs, articles, help, changelogs |
| Experience | are inside the work itself | portfolios, galleries, showcases |

A tool's landing page is Persuade even though the product is a tool.

## Phase 2: build

Ask for the screen in plain language, or follow the confirmed `shape` brief. Refinement keeps the existing identity,
copy and anything out of scope; redesign replaces them, and impeccable asks before it replaces real copy. For landing
and showcase pages it can build to a generated comp first when the harness can make images (the `buildPath` setting).

## Phase 3: evaluate

- `/impeccable critique` is a UX review: hierarchy, information architecture, cognitive load, emotional fit.
- `/impeccable audit` runs technical checks (accessibility, performance, theming, responsiveness, anti-patterns) and
  returns a scored report with P0-P3 severities.

Run both on anything you are unsure about; the audit's P0/P1 items are the fix list for phase 4.

## Phase 4: refine

Pick the verb that names the problem:

| Problem | Verb |
| ------- | ---- |
| bland, safe | `bolder`, `colorize`, `delight`, `overdrive` (shaders, spring physics, scroll-driven effects) |
| loud, busy | `quieter`, `distill` |
| cramped, uneven, weak hierarchy | `layout`, `typeset` |
| breaks on other screens or devices | `adapt` |
| static or janky motion | `animate`, `optimize` |
| confusing words | `clarify` |
| fragile with real data (errors, overflow, i18n) | `harden` |
| first run and empty states | `onboard` |

## Phase 5: ship

- `/impeccable polish` is the final pass: alignment, spacing, consistency, micro-details.
- `/impeccable extract` pulls repeated patterns and tokens into the design system once a few screens exist.

## Live variants (optional)

With the dev server running (HMR) and the page open in a browser:

- `/impeccable live`: pick elements in the browser, choose an action, cycle through generated HTML+CSS variants.
- `/impeccable generate 3 bold variants of the pricing cards`: same, but impeccable finds the element itself.

## Hooks and maintenance

- The detector hook runs after every Edit/Write of `.tsx`, `.jsx`, `.html`, `.vue`, `.svelte`, `.astro`, `.css`,
  `.scss`, `.ts`, `.js` and similar files, in every project. It only adds reminders and never blocks an edit. The Stop
  hook adds a deeper pass (up to 30s).
- `/impeccable hooks off` (or `on`, `status`, `ignore-rule`, `ignore-file`, `ignore-value`, `reset`) controls it per
  project in `.impeccable/config.json`. `IMPECCABLE_HOOK_DISABLED=1` turns it off for one run.
- The engine is a native binary in `~/.impeccable/bin/<version>/`, downloaded on first use from the repo's GitHub
  releases and checked against `engine-checksums.txt` shipped with the plugin.
- Pin a verb as its own slash command: ask "pin polish" (the skill runs `scripts/impeccable pin pin polish`).

## Typical sequences

- New landing page: `init` -> `shape` -> build -> `critique` -> one or two phase-4 verbs -> `audit` -> `polish`.
- Existing app screen: `document` (once) -> `audit` -> fix P0/P1 -> `layout` / `typeset` as needed -> `polish`.
- Before shipping anything: `audit`, `harden`, `polish`.

## On this machine

- Telemetry: `IMPECCABLE_NO_TELEMETRY=1` in `~/.claude/settings.json` `env` (step 50). New designs still fetch
  directions from impeccable.style; only the anonymous "which direction was picked" record is off.
- Overlap: `frontend-design` (official plugin, enabled), the `make-interfaces-feel-better` skill and
  `ecc:make-interfaces-feel-better` also cover UI polish. Use impeccable when you want its verbs and the detector;
  the others trigger on their own for small UI touch-ups.
