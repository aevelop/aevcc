# The Impeccable Workflow: From Raw to Refined

## Philosophy

Impeccable exists to solve one problem: every LLM learned from the same generic templates, producing predictable "AI slop" —
Inter font, purple gradients, cards-in-cards, gray text on colored backgrounds. The workflow below systematically eliminates
these tells and builds distinctive, production-grade design.

The plugin provides 1 core skill (frontend-design) with 7 deep reference files, plus 17 commands that form a design vocabulary.
The skill provides the knowledge; the commands provide the actions.

---
### Phase 0: Setup (One Time Per Project)

/impeccable:teach-impeccable

Run this once at the start. It:
1. Explores your codebase (README, components, tokens, style guides)
2. Asks UX-focused questions about users, brand, personality, aesthetic preferences
3. Writes a persistent design context block into your CLAUDE.md

This is critical because every other command depends on understanding your brand personality, target audience, and aesthetic
direction. Without it, the AI guesses — and guessing is how you get AI slop.

★ Insight ─────────────────────────────────────
The teach-impeccable step is what separates Impeccable from generic "make it pretty" prompts. By persisting design context into
CLAUDE.md, every future conversation inherits your design DNA — even months later. This is the same principle behind design
systems: encode decisions once, apply everywhere.
─────────────────────────────────────────────────

---
#### Phase 1: Understand the Current State

Before changing anything, know what you're working with.

##### Step 1: /impeccable:audit

Runs a comprehensive technical quality check across 5 dimensions:
- Accessibility — contrast, ARIA, keyboard navigation, semantic HTML
- Performance — layout thrashing, expensive animations, optimization gaps
- Theming — hard-coded colors, dark mode issues, inconsistent tokens
- Responsive — fixed widths, touch targets, overflow, text scaling
- Anti-patterns — the brutal "AI slop" check (does it look AI-generated?)

Produces a severity-rated report (Critical / High / Medium / Low) with specific fix recommendations.

##### Step 2: /impeccable:critique

Evaluates design effectiveness from a UX perspective across 10 dimensions:
1. AI Slop detection (the most important check)
2. Visual hierarchy and eye flow
3. Information architecture
4. Emotional resonance
5. Discoverability & affordance
6. Composition & balance
7. Typography as communication
8. Color with purpose
9. States & edge cases
10. Microcopy & voice

Produces a critique report with "what's working", "priority issues", and suggested commands to fix each one.

★ Insight ─────────────────────────────────────
Audit and Critique may sound similar, but they serve different purposes. Audit is technical (is the code correct?), while
Critique is perceptual (does the design communicate well?). A page can pass audit with perfect accessibility scores but fail
critique because the hierarchy is confusing. Always run both.
─────────────────────────────────────────────────

---
#### Phase 2: Establish the Foundation

Now fix structural issues before adding enhancements. Order matters here.

##### Step 3: /impeccable:normalize

If your project has a design system (even a partial one), normalize first:
- Align typography, colors, spacing, and components to existing tokens
- Fix inconsistencies across pages
- Ensure DRY usage of design primitives

Skip this if the project has no design system at all — you'll build one later with /extract.

##### Step 4: /impeccable:distill

Strip away unnecessary complexity:
- Remove redundant UI elements
- Simplify information architecture
- Apply progressive disclosure (hide complexity until needed)
- Flatten nested structures (especially cards-in-cards)
- Reduce the number of colors, font sizes, and spacing values

This is counter-intuitive — you're making the site simpler before making it better. But removing noise is what lets good design
breathe.

★ Insight ─────────────────────────────────────
Distilling before enhancing follows the design principle of "subtract before you add." Every decorative element you remove now
is one less thing competing for attention when you add purposeful design later. It's the same reason sculptors remove material
rather than adding it.
─────────────────────────────────────────────────

---
#### Phase 3: Build the Visual Identity

With a clean foundation, now shape the personality.

##### Step 5: /impeccable:colorize

Introduce strategic color using:
- Brand-aligned palette (not generic purple-blue gradients)
- OKLCH color space for perceptually uniform colors
- 60/30/10 rule (dominant/secondary/accent)
- Semantic color for states (success, error, warning, info)
- Tinted neutrals (never pure gray — always warm or cool tint)
- Accessibility-verified contrast ratios

##### Step 6: /impeccable:bolder or /impeccable:quieter

Adjust the intensity dial based on your brand:

- /bolder — For sites that feel too safe or generic. Amplifies typography scale, introduces dramatic spacing, adds visual
effects, and creates focal points. Critical warning: it avoids AI-default "boldness" like cyan-purple gradients and
glassmorphism.
- /quieter — For sites that are too loud or aggressive. Reduces saturation, softens contrasts, adds white space, refines
motion. Quiet ≠ boring; quiet = refined and confident.

Most projects starting from scratch will need /bolder since AI defaults tend toward safe and generic.

★ Insight ─────────────────────────────────────
The bolder/quieter pair is Impeccable's most unique concept. Instead of asking "make it look good" (which the AI interprets as
"add more stuff"), you're giving a precise directional instruction on a single axis: intensity. This is how professional
designers think — not in absolutes, but in adjustments relative to the current state.
─────────────────────────────────────────────────

---
#### Phase 4: Refine Content & Interactions

##### Step 7: /impeccable:clarify

Improve all UX copy:
- Error messages that explain and suggest fixes (not blame)
- Form labels that are specific and show format expectations
- Button text that describes the action (not "Submit" or "Click Here")
- Empty states that are welcoming and show the next step
- Loading states that set expectations

##### Step 8: /impeccable:onboard

Design first-time user experiences:
- Welcome flows that show value immediately
- Empty states that guide toward first action
- Feature discovery through tooltips and progressive disclosure
- Interactive tutorials where appropriate

Skip this if the project doesn't have user-facing onboarding needs.

---
#### Phase 5: Add Life & Personality

##### Step 9: /impeccable:animate

Add purposeful motion:
- Entrance animations (page load choreography, content reveals)
- Micro-interactions (button feedback, form responses, toggle switches)
- State transitions (show/hide, expand/collapse, loading)
- Navigation flow (page transitions, tab switching)

Every animation must: run at 60fps, use natural easing (never bounce/elastic), respect prefers-reduced-motion, and serve a
purpose.

##### Step 10: /impeccable:delight

Add moments of joy and personality:
- Success celebrations (confetti, satisfying checkmarks)
- Playful error recovery
- Easter eggs and hidden interactions
- Contextual personality in copy
- Satisfying micro-interactions (drag-and-drop feel, toggle snaps)

The rule: delight amplifies, never blocks. It should still work perfectly if every delight moment were removed.

★ Insight ─────────────────────────────────────
Animate and Delight are deliberately separate steps. Animation serves usability (helping users understand spatial relationships
and state changes), while Delight serves emotion (making the experience memorable). Mixing them leads to gratuitous animation
that slows users down. Animate first for function, then delight for feeling.
─────────────────────────────────────────────────

---
#### Phase 6: Harden & Optimize

##### Step 11: /impeccable:harden

Make the interface production-resilient:
- Text overflow and wrapping for all languages
- RTL support and internationalization
- Error handling for network failures, API errors, edge cases
- Empty/loading/error states for every data-dependent component
- Input validation and sanitization
- Accessibility resilience (keyboard, screen reader, motion, contrast)

##### Step 12: /impeccable:optimize

Performance improvements:
- Image optimization (formats, lazy loading, srcset)
- Bundle size reduction (code splitting, tree shaking)
- Rendering performance (avoid layout thrashing, GPU-accelerate animations)
- Core Web Vitals (LCP, INP, CLS)
- Framework-specific optimizations (React.memo, virtualization, etc.)

---
#### Phase 7: Systemize

##### Step 13: /impeccable:extract

Pull reusable patterns into your design system:
- Identify repeated components and consolidate
- Create design tokens from hard-coded values
- Build a component library with clear APIs and variants
- Document patterns with usage guidelines
- Migrate all instances to use the extracted components

This is intentionally late in the workflow — you need to see the final design before you know what's truly reusable.

---
#### Phase 8: Final Pass

##### Step 14: /impeccable:adapt

Ensure cross-device consistency:
- Mobile adaptation (single column, bottom navigation, touch targets)
- Tablet adaptation (master-detail, two-column)
- Desktop adaptation (multi-column, hover states, keyboard shortcuts)
- Print adaptation if relevant

##### Step 15: /impeccable:polish

The final quality gate before shipping. Checks:
- Pixel-perfect alignment and consistent spacing
- Typography refinement (line length, height, widows/orphans)
- Every interaction state (default, hover, focus, active, disabled, loading, error, success)
- Smooth transitions with appropriate easing
- No console.logs, dead code, or missing alt text
- All edge cases handled

★ Insight ─────────────────────────────────────
Polish is last because it's a refinement pass, not a design pass. If you polish too early, you'll waste time perfecting
elements that get changed later. This mirrors how film production works: you don't color-grade individual shots until the final
edit is locked.
─────────────────────────────────────────────────

---
Quick Reference: The Complete Pipeline

┌───────────────┬──────┬────────────────────────────────┬─────────────────────────────────┐
│     Phase     │ Step │            Command             │             Purpose             │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 0. Setup      │ 1    │ /impeccable:teach-impeccable   │ Establish design context (once) │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 1. Understand │ 2    │ /impeccable:audit              │ Technical quality report        │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 3    │ /impeccable:critique           │ UX design evaluation            │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 2. Foundation │ 4    │ /impeccable:normalize          │ Align to design system          │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 5    │ /impeccable:distill            │ Remove complexity               │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 3. Identity   │ 6    │ /impeccable:colorize           │ Strategic color                 │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 7    │ /impeccable:bolder or /quieter │ Adjust intensity                │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 4. Content    │ 8    │ /impeccable:clarify            │ Improve UX copy                 │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 9    │ /impeccable:onboard            │ First-time experience           │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 5. Life       │ 10   │ /impeccable:animate            │ Purposeful motion               │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 11   │ /impeccable:delight            │ Moments of joy                  │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 6. Harden     │ 12   │ /impeccable:harden             │ Resilience & edge cases         │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 13   │ /impeccable:optimize           │ Performance                     │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 7. Systemize  │ 14   │ /impeccable:extract            │ Reusable components             │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│ 8. Final      │ 15   │ /impeccable:adapt              │ Cross-device                    │
├───────────────┼──────┼────────────────────────────────┼─────────────────────────────────┤
│               │ 16   │ /impeccable:polish             │ Ship-ready quality gate         │
└───────────────┴──────┴────────────────────────────────┴─────────────────────────────────┘

---
## Tips for Real-World Usage

1. You don't always need all 16 steps. For a quick improvement to an existing page, try: audit → critique → fix the top 3
issues → polish.
2. Each command accepts a target argument to focus on a specific component: /impeccable:polish checkout-form or
/impeccable:colorize hero-section.
3. Re-run audit/critique after major changes to verify you haven't introduced new issues.
4. The frontend-design skill loads automatically when you're doing design work, but you can force it by saying "use the
frontend-design skill" in your prompt.
5. Bolder and quieter are opposites — if you overshoot with one, use the other to pull back.
6. The AI slop check is the most important anti-pattern. If your audit or critique flags it, prioritize fixing it above
everything else. Distinctive design is the entire point.
