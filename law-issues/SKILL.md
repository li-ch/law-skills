# Skill: law-issues

# LAW Issues

Standardize the inline comment/fix cycle for LaTeX papers: the owner
edits `.tex` files and leaves `%` comments; you capture every comment
verbatim into a persistent ISSUES.md ledger, fix each one in the
sources, describe each fix in plain language, promote recurring
lessons into standing rules, and land the round with a verified build
and a commit.

## When to use

- The owner says anything like "I updated the tex, look at the
  comments", "I am disappointed, fix them", or a `.tex` file shows new
  inline `%` comments after an owner edit.
- NOT for external reviewer reports on a submission (use `law-review`
  for those; it builds a todo.md revision tracker) and NOT for
  implementing such a tracker (that is `law-revise`). This skill is
  the tight author-side loop over inline `%` comments.

## Procedure (fixed order; do not reorder)

### Step 1 — CAPTURE (before any fix)

Find the edited files (`git status`, newest mtimes in `sections/`).
Run the capture helper for a numbered verbatim list:

```bash
python3 <skill-dir>/scripts/capture_comments.py <paper-root>
```

Append a new round section to `ISSUES.md` in the paper root BEFORE
touching any source. Numbers continue monotonically across rounds
(never renumber; a 30-item ledger is the point). Quote comments
VERBATIM, exactly as written, including profanity and typos: the
ledger is the record of what the owner actually said. Remove each
comment from the `.tex` only after it is captured here.

Exact ISSUES.md entry format:

```markdown
---

# Round N (YYYY-MM-DD)

**<n>. <short descriptive title>**

> <verbatim comment, wrapped exactly as written>

**Fix.** <plain, simple, direct sentences: what was wrong, what was
done, where in the paper it landed. Written AFTER the fix, in past
tense. Note standing-rule promotions here. For items that cannot be
fixed by writing, state that plainly and name the real work item.>
```

### Step 2 — FIX

Apply fixes in the sources under the current law-write rules (25 of
them at time of writing; rules 24 and 25 themselves came out of this
cycle) and the paper repo's AGENTS.md and CLAUDE.md conventions.
Sweep the whole paper when a comment names a pattern rather than a
spot (tone, voice, banned constructions) — a local fix for a global
rule fails the round.

Honesty rules while fixing:

- Never claim in prose what the artifacts do not show; if a comment
  demands evidence that does not exist, the item entry says so and
  names the experiment or system work that would produce it.
- Never edit verified artifacts (labels, logs, frozen outputs) to
  satisfy a comment; change the paper or schedule the work.
- Repeated comments (the owner re-leaving the same complaint) get
  their own new item number, cross-referenced to the earlier one,
  stating what is newly done in response.

### Step 3 — DESCRIBE

Write each `**Fix.**` paragraph after the fix, in plain, simple,
direct language. The test: the owner reads only ISSUES.md and knows
what changed and why, without opening the diff. No hedging, no
credit-taking beyond what the artifacts show.

### Step 4 — GENERALIZE

If a comment exposes a rule that should apply everywhere (not a local
edit), promote it before finishing the round:

1. Append the rule to `~/.zcode/skills/law-write/references/writing-rules.md`
   as the next numbered rule, with Good/Bad examples.
2. Bump the rule count and summary line in that skill's SKILL.md.
3. Add the same guideline to the paper repo's AGENTS.md and
   CLAUDE.md.
4. Note the promotion in the item's Fix paragraph.

### Step 5 — VERIFY and COMMIT

Rebuild fully (pdflatex + bibtex + pdflatex x2), run `law-verify`
(the round is not done until it passes; fix any new violations the
round's own edits introduced), then `law-pagecount`. Commit sources
plus ISSUES.md together with the message
`address owner review round N (ISSUES.md items a-b)`, one-line body
summarizing the substance.

### Step 6 — REPORT

Final message to the owner: item numbers with one line each, verify
status, page count, and anything that needs the owner's decision
(citations to verify, trade-offs taken, work items the round exposed).
Do not hide unresolved items; list them.

## Invariants (never violate)

- Capture first, fix second; quotes verbatim; numbering monotonic.
- Comments leave the `.tex` only via capture.
- Fixes described after being made, past tense, plainly.
- Global lessons become rules; rules land in all three homes
  (law-write, AGENTS.md, CLAUDE.md).
- Unfixable-by-writing items are said to be exactly that.
- The round ends verified (law-verify passing) and committed, or the
  final message says why not.

## Relationship to sibling skills

- `law-review`: external reviewer feedback → todo.md tracker (per
  review round of a submission). Use that for real reviews.
- `law-revise`: implement a todo.md tracker's items.
- `law-issues` (this skill): owner's inline `%` comments → ISSUES.md
  ledger → fix → describe → generalize → verify → commit.
