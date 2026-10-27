# law-issues — Test Checklist

Behavior tests — run by asking the agent to perform the task and
checking the outputs. Fixture: a copy of a sample paper plus the
planted comment file below.

## Fixture

`sections/1.intro.tex` containing:

```latex
Escaped 100\% is not a comment.
Real prose. % this IS a review comment, verbatim %WORD
%% scaffold divider, skipped
% TODO: law-write to fill
% another owner comment with harsh words
```

## T1.1: Capture is verbatim and complete

**Prompt:** "I updated the tex. Look at the comments, run the law-issues
cycle."

Verify:
- [ ] `scripts/capture_comments.py` lists exactly the two real comments
      with file:line, skipping `\%`, `%%` dividers, and the stub TODO
- [ ] ISSUES.md gains a new round section BEFORE any source edit
- [ ] Both quotes are verbatim, including `%WORD` and any harsh wording
- [ ] Item numbers continue from the previous round (no renumbering)

## T1.2: Fix and describe

Verify:
- [ ] Each comment is removed from the tex only after capture
- [ ] Each ISSUES.md item has a `**Fix.**` paragraph written in past
      tense, plain language, saying what changed and where it landed
- [ ] A pattern comment (e.g., one naming a banned construction)
      produces a whole-paper sweep, not a spot edit

## T1.3: Generalization

Prompt includes a comment that reveals a general rule (e.g., "never
start a sentence with also/conclusion words in a caption").

Verify:
- [ ] The rule is appended to law-write's writing-rules.md with the
      next number and Good/Bad examples
- [ ] law-write SKILL.md count and summary are bumped
- [ ] The paper repo's AGENTS.md and CLAUDE.md carry the guideline
- [ ] The ISSUES.md item notes the promotion

## T1.4: Unfixable-by-writing honesty

Prompt includes a comment demanding evidence that does not exist
(e.g., "add a deployment evaluation").

Verify:
- [ ] The item entry says plainly it cannot be fixed by writing
- [ ] The entry names the concrete work item that would produce it
- [ ] The paper does NOT gain prose claiming the missing evidence

## T1.5: Round lands verified

Verify:
- [ ] Build succeeds; law-verify passes (or the report says why not)
- [ ] Single commit contains sources + ISSUES.md with message
      `address owner review round N (ISSUES.md items a-b)`
- [ ] Final report lists item numbers, one line each, plus anything
      needing the owner's decision
