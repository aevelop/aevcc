---
name: ask-me-questions-for-context
description: Interview the user with 40-50 targeted questions to build a reusable context .md file for Claude Code (or any AI). Use when the user asks to "create a context file", "build an .md file for Claude", "capture my voice", "capture my business context", "interview me", "stop re-explaining my work", "set up Claude Code context", or wants a profile covering business context, writing voice, client/project work, content creation, or analyst/research work. Produces a saved .md file the user can drop into a Claude Code project folder.
---

# Ask Me Questions For Context

Interview the user one question at a time. Compile their answers into a saved `.md` file that future Claude sessions can read instead of forcing the user to re-explain themselves.

## Why this exists

Users repeatedly re-explain their business, voice, or workflow at the start of every AI conversation. A well-built `.md` file ends that. The file's quality depends entirely on **how the interview is conducted** — not on the questions alone. A lazy interview produces generic boilerplate that helps nobody.

The insight that makes this work: **80% of a useful profile is what the user rejects** — phrases they'd never use, positions they'd never take, things they'd never send to a client. Pursue rejections harder than preferences.

## Workflow

### 1. Pick a variant

Ask which variant fits. Do NOT skip this — the variant determines which question set to load:

| Variant | For |
|---------|-----|
| `business-context` | Business owners, freelancers, consultants — meeting prep, client calls, proposals |
| `writer-voice` | Newsletter writers, bloggers, anyone whose drafts should sound like *them* |
| `client-work` | Consultants, agencies, PMs — delivery standards, client comms |
| `content-creator` | YouTubers, podcasters, social creators — ideation, scripting, repurposing |
| `analyst-research` | Analysts, researchers, strategists — report format, rigor standards |

Use `AskUserQuestion` to present these as choices. If the user is unsure, ask what they want the file to help with first, then pick.

### 2. Load the matching question set

Read the reference file for the chosen variant:

- `references/business-context.md`
- `references/writer-voice.md`
- `references/client-work.md`
- `references/content-creator.md`
- `references/analyst-research.md`

Each file contains the question themes to cover and variant-specific framings.

### 3. Confirm scope before starting

Tell the user: "I'll ask 40-50 questions, one at a time. The whole thing takes ~30-45 minutes. We can pause and resume anytime. Ready?"

If the user wants a faster version, offer **short mode (~10-15 questions)** — but warn them the resulting file will be thinner and more generic.

### 4. Interview — one question at a time

Use `AskUserQuestion` when there are clear discrete options. Use plain text questions when you need open-ended detail (most of the time).

**Apply these interview rules on every answer. They are the load-bearing part of this skill:**

1. **Push back on vague answers.** "I want professional outputs" is useless. Ask: "What does that look like in a specific example?" Demand a real artifact — an actual email, paragraph, deliverable, decision.
2. **Call out contradictions.** If an answer conflicts with an earlier one, surface it: "Earlier you said X — this seems to contradict that. Which is true?"
3. **Don't accept "I don't know."** Reframe the question or approach it sideways. Try: "If a new employee did this wrong, what would they have done?"
4. **Go deeper on interesting threads.** If something unusual surfaces, follow it for 2-3 more questions before moving on. The unusual stuff is what makes the file specific.
5. **Don't validate.** No "great point", "that's interesting", "love that". Just ask the next question or push deeper.
6. **Catch aspirational answers.** If an answer sounds like how the user *wishes* they worked rather than how they actually do, call it: "Is that what you actually do, or what you'd like to? Show me proof."
7. **Reject generic answers.** If the answer could describe anyone in their profession, flag it: "That could describe any [consultant/writer/analyst]. What's specific to *you*?"
8. **Pursue rejections.** When you ask what they'd never do — slow down and get specific examples. This is the gold.

**Cadence:** One question per turn. Wait for the answer. Apply the rules. Decide whether to follow up or move on. Do not batch multiple questions in one message.

### 5. Mid-interview check-in

Around question 20, summarize 3-5 emerging themes back to the user in one paragraph. Ask: "Does this sound like you, or am I misreading something?" Adjust based on the answer.

### 6. Compile the file

When the interview ends, write a `.md` file with these sections (adapt section names to the variant):

```markdown
# [Variant Name] Context for [User]

## Who I Am / What I Do
[Plain-language description from their own words, not website-speak]

## How I Actually Work
[Concrete behaviors, with examples]

## My Non-Negotiables
[Hard rules — things to never do/say/suggest]

## What Good Output Looks Like
[With at least one full real example from the interview]

## What I Reject
[Phrases, formats, positions, approaches they'd never use]

## Examples & Artifacts
[Verbatim samples the user shared — emails, paragraphs, decisions]

## How To Use This File
[1-2 lines telling future Claude: read this before any task in this folder]
```

**Critical compilation rules:**

- **Quote the user verbatim** wherever possible. Their actual phrasing is the asset; do not paraphrase it into AI-speak.
- **Keep examples alongside rules.** A rule without an example is useless. "I write directly" → useless. "I write like this: [3-sentence sample]" → useful.
- **Lead each section with rules, not preamble.** No "In my work, I find that..." Just: "Never send a bullet-pointed email to a client."
- **Do not invent details.** If the user didn't answer something, leave it out. Do not pad.

### 7. Save the file

Ask the user for a filename (suggest one based on the variant, e.g. `voice_profile.md`, `business_context.md`). Save it to the current working directory unless the user specifies otherwise.

After saving, tell the user:
> Drop this in the Claude Code project folder you work from most. Then at the start of any task in that folder, add: *"Read [filename].md first"* — Claude Code will pick it up at the top of the session. (Tip: renaming the file to `CLAUDE.md` makes Claude Code load it automatically every session.)

### 8. Offer iteration

End by asking: "Want me to do another variant (e.g. add a writing-voice file alongside this business one)?" — variants compose well in the same folder.

## Short mode

If the user picks short mode in step 3:
- Cover only the 3 most-load-bearing themes from the variant file
- Aim for 10-15 questions
- Skip the mid-interview check-in
- Still apply all 8 interview rules — they matter more in short mode, not less

## What NOT to do

- Don't ask multiple questions in one turn.
- Don't write the file before the interview ends. No "draft as we go".
- Don't soften the interview rules to be polite. The user asked for this because they want a useful file, not a pleasant chat.
- Don't generate questions the variant file doesn't cover unless a thread genuinely needs it.
- Don't accept the user's first answer if it's vague. Push once. If they push back ("that's really my answer"), move on.
