# 21 Writing Rules for Academic Papers in Computer Networking

These rules encode the style and tone conventions extracted from LLM-based paper writing prompts used across multiple successful submissions. Apply them consistently.

---

## Core style rules (1–12)

### 1. Active voice, present tense, first person
"We find that..." not "It was found that..." Use past tense only when discussing prior work.

### 2. Lead every paragraph with its main claim
The first sentence states the conclusion. Supporting detail follows. Never open a paragraph with context or buildup.

### 3. Quantify every claim with bold numbers
No claim without a specific number. Numbers in the text must be `\textbf{bolded}`.
- Good: "Analysis of **200 incidents** over **3 months** reveals that **87.4%** of failures stem from resource contention."
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

### 8. No long dashes in prose
`---` (em dash) and `--` (en dash) are not allowed in body text. Use parentheses, commas, colons, or new sentences instead. Hyphens in compound words (e.g., "pattern-correlated", "cost-effective") are fine; use them consistently.

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

---

## Authorial-perspective and contrast rules (22-23, added 2026-10-16)

### 22. Macro entities act through the authors
Sentences whose subject is a macro entity (the prototype, the system, the
paper, the measurement study, the architecture, the framework, the
evaluation) must be written from the authors' perspective: "We build a dual
Solidity and Go prototype that authorizes in 5.6 ms," never "A dual
Solidity and Go prototype authorizes in 5.6 ms." Active voice about macro
artifacts reads as if the artifact acted on its own; the authors are the
actor. Only microscopic entities may be active subjects, and only for
their own mechanics: a function calls another function, a process spawns a
process, a class method verifies, a contract reverts. "The verifier
checks the aggregate" and "The controller dials the router" are correct;
"The prototype verifies aggregates and pushes rules" is not — rewrite as
"We implement a controller that verifies aggregates and pushes rules."
- Bad: "A dual implementation checks the state machines differentially."
- Good: "We implement the state machines twice and check them differentially."
- Bad: "The measurement motivates the system."
- Good: "Our measurement motivates the design." (possessive + design verb,
  or "We measure ... to motivate ...")

### 23. Never use "X, not Y" contrastive apposition
Do not write "The bottleneck is trust, not technology," "a payment cap,
not a defense," "consistent, not identical." The construction appears
punchy but is rhetorical contrast dressing as precision, and it piles up
into a tic. State the positive claim; when the contrast matters, give it
its own sentence with a real verb. The ban covers the variants: "not X
but Y," "X rather than Y," "X instead of Y" used for rhetorical contrast
(ordinary "instead of" describing a mechanism's substitution is fine, and
"rather than" inside a technical comparison of two measured options is
fine when neither is being dismissed rhetorically).
- Bad: "The bottleneck is trust, not technology."
- Good: "The bottleneck is trust. Technology already solves the fast parts."
- Bad: "We report a cap, not a defense."
- Good: "We report a cap. It stops inflated metering; it does not stop
  collusion, which Section 6 bounds separately."


### 24. Never begin a sentence with a number
Do not start a sentence with a numeral or a spelled-out number ("Two
boundaries frame...", "Three propositions formalize...", "Twenty five
years show..."). Sentence-initial numbers read as list fragments and
force the count before the reader knows what is being counted. Rephrase
so the number lands after its subject. The ban covers digits ("25 years
show...") and number words ("Two", "Three", "Ten", "Twenty five").
Numbers inside a sentence, and numbered list labels, are fine.
- Bad: "Two checks gate the labels."
- Good: "The labels pass two checks."
- Bad: "Three propositions formalize the guarantees."
- Good: "The guarantees take the form of three propositions."
- Bad: "Twenty five years of coordination show a stall."
- Good: "Across 25 years of coordination, the record shows a stall."


### 25. Our work takes we/our/ours as the sentence subject; attack enablers get negative framing
Any sentence that describes the authors' own work, results, or
artifacts must use we/our/ours as the grammatical subject wherever
that is grammatical. "We build a 965-episode corpus" beats "A
965-episode corpus was built" and "The corpus holds 965 episodes."
Passive voice for our contributions is banned; reserve passive for
the world and prior work. Corollary on tone: never describe an
attack-enabling condition with positive-toned framing ("keeps attacks
cheap"); use negative verbs: fuels, enables, sustains.
- Bad: "The labels are validated by a gold gate."
- Good: "We validate our labels against an adjudicated gold gate."
- Bad: "The unfiltered remainder keeps spoofed attacks cheap."
- Good: "The unfiltered remainder still fuels spoofed floods."


### 26. No numbers or A/An open titles, paragraphs, or sentences
Section titles, subsection titles, paragraph openings, and sentence
openings contain no numbers in any form: digits (25), number words
(One, Two, Twenty five), and the indefinite articles A and An, which
are number words in disguise (each means "one") and which weaken the
subject position. Rephrase so the opening carries the real subject.
law-verify check 8 enforces this mechanically over joined lines.
- Bad: "\\section{5 Lessons from 25 Years of SAV}"
- Good: "\\section{Lessons from a Quarter Century of SAV}"
- Bad: "A filter installed at one source AS protects only against..."
- Good: "Any filter installed at one source AS protects only against..."
- Bad: "An adversary controlling one plane can..."
- Good: "Any adversary controlling one plane can..."
- Bad: "One unfiltered network is enough."
- Good: "Any single unfiltered network suffices."


## Rules 27-29 (owner-added 2026-10-29, override on conflict)

**27 — Sentence-level coherence.** Adjacent sentences connect by transition, elaboration, contrast, or consequence; abrupt subject changes between neighbors are defects. Rebuild the paragraph around one developing idea rather than bolting on connectives.

**28 — Paragraph depth.** A paragraph is never a single sentence: expand with mechanism, merge, or delete.

**29 — Evidence-scoped claims.** Extraordinary claims require inline evidence or explicit scope: "we could not reproduce any published cross-fabric comparison from its stated inputs (we examined five)" — never "nothing reproduces". This refines rule 5: weak hedging verbs remain forbidden; scoping strong claims to the evidence is required.
