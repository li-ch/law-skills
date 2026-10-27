# law-write — Test Checklist

These are behavior tests — run by asking the agent to perform the task and checking the output.

## Test setup

Use the sample paper at `~/.common-law/test-fixtures/sample-paper/`. Make sure it has been built at least once so `temp/main.log` exists.

## T2.1: Writes a new section

**Prompt:** "Write section 5 on Implementation for the sample paper."

Verify:
- [ ] Output file `sections/5.implementation.tex` is created
- [ ] File starts with `\section{Implementation}`
- [ ] Content uses `\sys` macro, not "TestSys" literally
- [ ] Content follows active voice, present tense

---

## T2.2: Follows writing rules

**Prompt:** "In section 4 (Design), add a paragraph about failure handling."

Verify:
- [ ] Bold numbers are used for metrics (e.g., `\textbf{99.9\%}`)
- [ ] No hyphens in prose
- [ ] No `\textbf{}` mid-paragraph except for numbers
- [ ] Paragraph starts with its main claim
- [ ] No hedging language ("may", "could potentially", "it is possible that")
- [ ] No banned words (delve, certainly, leverage, robust, etc.)

---

## T2.3: Reads narrative before writing

**Prompt:** "Write a new background section for the sample paper."

Before the test: ensure `CLAUDE.md` has a filled Paper Narrative section with a specific research question.

Verify:
- [ ] The section's content aligns with the stated narrative
- [ ] The section introduces challenges named in the narrative
- [ ] The agent's response mentions reading CLAUDE.md

---

## T2.4: Uses correct macros

**Prompt:** "Add a forward reference to the evaluation section in section 1."

Verify:
- [ ] Uses `\cref{sec:eval}` (or whichever label exists), not bare `\ref{}`
- [ ] Uses `\sys`, not "TestSys"
- [ ] Citations use `~\cite{key}` format (tilde before cite)

---

## T2.5: Uses placeholders for missing data

**Prompt:** "Write an evaluation section with throughput numbers. Don't give me the actual numbers."

Verify:
- [ ] Missing numbers use `\textcolor{red}{##?}`
- [ ] No invented numbers
- [ ] Unfinished work uses `\textcolor{red}{TODO:}`

---

## T2.6: Calls humanizer after writing

**Prompt:** "Improve the prose in section 1."

Verify:
- [ ] Agent's response mentions running the humanizer
- [ ] Or: agent tells user humanizer is not installed with install command

---

## T2.7: Humanizer not installed → prompt

**Test precondition:** Remove humanizer skill.

**Prompt:** "Write a conclusion section."

Verify:
- [ ] Agent tells user to install humanizer with the correct curl command
- [ ] The text is still written (humanizer failure does not block writing)

---

## T2.8: Produces summary and texts for other sections

**Prompt:** "Rewrite section 2. Move the detailed workload analysis to a later section."

Verify:
- [ ] Response ends with "Summary of changes:" section
- [ ] Response includes "Texts suitable for other sections:" section
- [ ] The moved content is listed with target section suggestions
