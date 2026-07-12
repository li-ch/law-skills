# 21 Writing Rules for Academic Papers in Computer Networking

These rules encode the style and tone conventions extracted from LLM-based paper writing prompts used across multiple successful submissions. Apply them consistently.

---

## Core style rules (1–12)

### 1. Active voice, present tense, first person
"We find that..." not "It was found that..." Use past tense only when discussing prior work.

### 2. Lead every paragraph with its main claim
The first sentence states the conclusion. Supporting detail follows. Never open a paragraph with context or buildup.

### 3. Quantify every claim with specific numbers
No claim without a specific number. Numbers appear in normal weight, not bold.
- Good: "Analysis of 200 incidents over 3 months reveals that 87.4% of failures stem from resource contention."
- Bad: "Analysis of many incidents over several months reveals that most failures stem from resource contention."

### 4. Name your discoveries
If you discovered a phenomenon, give it a name and own it with `\emph{}`.
- Good: "We term this the *Concurrency-Quality Paradox*."
- Bad: "This leads to a situation where parallelism hurts quality."

### 5. Never hedge
Make your claims definitive, not tentative.
- Good: "This exposes a critical gap."
- Bad: "This may suggest a potential gap."
- Good: "Existing schedulers fail precisely when they are needed most."
- Bad: "Existing schedulers sometimes underperform."

### 6. Ground mechanisms in expert behavior
When describing a system design, frame it as replicating observable expert behavior.
- Pattern: "Expert operators do X. Our system replicates this by Y."
- Example: "Expert operators throttle their workload when they sense cognitive overload. CLCC replicates this behavior by adapting congestion control principles from TCP."

### 7. One idea per sentence
No stacked subordinate clauses. If a sentence has more than one "which" or "that" clause, split it.
- Good: "Object detection has two approaches. The one-stage approach uses a unified model. The two-stage approach uses a sequential strategy."
- Bad: "Object detection has two approaches, one of which uses a unified model while the other, which adopts a sequential strategy, first proposes regions and then classifies them."

### 8. No hyphens
Use "which" or "that" clauses instead. Hyphens interrupt the reader's flow and signal lazy sentence construction.

### 9. `\textbf{}` only at paragraph start
`\noindent\textbf{Label.}` for run-in heads. Never `\textbf{something}` mid-paragraph. Never use `\paragraph{}` environment.

### 10. Code names in `\texttt{}`, system name as `\sys`
- Code variables: `\texttt{vruntoken}`
- System name: always use the `\sys` macro (defined per-paper in `AGENTS.md`)

### 11. `\resizebox` for all tables; `algorithm`/`algpseudocode` only
- Single-column: `\resizebox{\columnwidth}{!}{\begin{tabular}...\end{tabular}}`
- Full-width: `\resizebox{\textwidth}{!}{\begin{tabular}...\end{tabular}}`
- Algorithms: only use `\usepackage{algorithm}` and `\usepackage{algpseudocode}`

### 12. Placeholders for missing data
- Missing numbers: `\textcolor{red}{##?}`
- Unfinished work: `\textcolor{red}{TODO:}`
- Never invent numbers to fill gaps.

---

## Section discipline rules (13–17)

### 13. Each section has an explicit "What this does NOT include" boundary
Every section knows its scope. Motivation doesn't preview evaluation. Design doesn't re-litigate the problem. The revision plan or SKILL.md for the section should include a negative checklist.

### 14. No section previews results from later sections
"Section 7 shows..." has no place in Section 2. Mention the existence of a later section only if necessary, and never preview what it contains.

### 15. Design sections reference problems, never re-litigate them
Design sections say "Section 2 established that..." and move on. They do not re-explain the problem. One sentence of forward reference, then into the solution.

### 16. Every prompt includes the full introduction as context
When revising a section, always provide the full paper introduction as `<intro>` context so the agent understands the paper's narrative arc.

### 17. Every task ends with "summary of changes + texts suitable for other sections"
The agent must report what was changed and identify content that was removed from this section but belongs elsewhere.

---

## Revision rules (18–21)

### 18. Revision plans include: narrative arc → what to remove → where it goes → target lengths → quality checklist
A complete revision plan has five parts:
1. The new narrative arc (Context → Conflict → Insight → Solution → Impact)
2. What to remove from this section
3. Where removed parts should go (explicit section labels)
4. Target page lengths per subsection
5. A quality checklist against experience-track or venue criteria

### 19. Never introduce new data/facts in a revision
Reuse what exists. If a reviewer asks for a new experiment, the revision plan must say "no new experiments." If a number is missing, use `\textcolor{red}{##?}` and note it in todo.md.

### 20. SCQA structure for introductions
Situation → Complication → Question → Answer. The reader should understand: (1) what domain we're in, (2) what's broken, (3) what we ask, (4) what we built and found.

### 21. Physical page targets per subsection when revising
Every subsection in a revision plan gets an explicit page target (e.g., "0.4 pages"). This forces discipline in compression and prevents scope creep. The agent tracks actual vs. planned after writing.

### 22. Optimization problems: objective and constraints on separate lines

When defining optimization problems (LP, MILP, min/max formulations), place the objective on one line and each constraint on its own line. Use `\begin{aligned}` within `\begin{equation}`. Align `\forall` clauses with `&&`:

```
\begin{equation}
\begin{aligned}
\min_{x} \; & f(x) \\
\text{s.t.} \;\; & g_i(x) \leq 0 && \forall i \\
& h_j(x) = 0 && \forall j \\
& x \geq 0
\end{aligned}
\end{equation}
```

Never put the objective and constraints on the same line. Never use a single-line `\text{s.t.}` with all constraints separated by `\quad`.

### 23. Appendix must match the main body's column format

The appendix uses the same column layout as the main body. If the paper is two-column, the appendix is two-column. If single-column, the appendix is single-column. Never use `\onecolumn` or `\twocolumn` to switch the appendix to a different column format. If equations overflow in the appendix, break them — do not change the column layout.

### 24. Define equations once, reference by label

Every equation in the paper must have a unique label. If the same equation appears in multiple sections, define it once (at its first occurrence) and reference it with `\cref{label}` in later sections. Never duplicate an equation with different labels or the same label. If the theory section needs to restate an equation for readability, use `\cref` and a brief restatement in words rather than re-typesetting it.

### 25. Appendix appears after the bibliography

The appendix goes after all references, not before. Order in `main.tex`: sections → bibliography → appendix → `\end{document}`. This is the standard convention in computer networking conferences (SIGCOMM, NSDI).

### Writing sample annotations

```
\begin{equation}
\begin{aligned}
\min_{x} \; & f(x) \\
\text{s.t.} \;\; & g_i(x) \leq 0 \qquad \forall i \\
& h_j(x) = 0 \qquad \forall j \\
& x \geq 0
\end{aligned}
\end{equation}
```

Never put the objective and constraints on the same line. Never use a single-line `\text{s.t.}` with all constraints separated by `\quad`.

---

## Writing sample annotations

Each sample below demonstrates specific rules. Reference these when explaining why a piece of text needs revision.

### Sample 1 — Rule 1 (active voice), Rule 3 (quantify), Rule 5 (no hedging)
- **Bad**: "While NDC targeting on the network domain is a novel question, we found that researchers have been focused a lot on image comprehension."
  - Problem: passive construction ("have been focused"), vague quantification ("a lot")
- **Improved**: "We find that three topics in computer vision are closely related to NDC: object detection, visual question-answering (VQA), and multi-modal LLMs."
  - Applied: active voice ("We find"), specific count ("three topics")

### Sample 2 — Rule 7 (one idea per sentence)
- **Bad**: A single 64-word sentence with multiple stacked clauses.
- **Improved**: Split into three sentences, each with one clear idea. "Sequential strategy: The first stage..." uses a colon for elaboration (no emdash).

### Sample 3 — Rule 2 (lead with main idea)
- **Bad**: Opens with a definition of the problem before stating the answer.
- **Improved**: "The most popular VQA approach also has two stages" — the main claim is the first sentence.

### Sample 4 — Rule 5 (no hedging), Rule 6 (concrete over abstract)
- **Bad**: Abstract language ("pivotal in assessing", "emphasizing considerations") with no concrete mechanism named.
- **Improved**: "We adapt LangChain to develop a customized agent framework. The agent framework has four key components." — concrete, named, counted.

### Sample 5 — Rule 4 (name things), Rule 7 (simple sentences)
- **Bad**: Passive voice ("communication is facilitated"), unnamed components ("lab-dependent verifier module").
- **Improved**: "We define a JSON schema. The Question Loader parses the questions." — active, named components.

### Sample 6 — Rule 3 (quantify), Rule 7 (one idea)
- **Bad**: Passive, vague cause-effect chains spanning multiple clauses.
- **Improved**: "For EP's all-to-all traffic, a GPU must receive from all other GPUs, creating flow collisions in the receiving port." — concrete scenario, specific mechanism, one sentence = one idea.
