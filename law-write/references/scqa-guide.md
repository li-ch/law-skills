# SCQA Introduction Guide

Every paper introduction follows the SCQA structure: Situation → Complication → Question → Answer.

## The 6-paragraph template

### Paragraph 1: Context and Importance (Situation)
- Establish the domain
- Explain why the problem matters
- Introduce the high-level solution space
- End with a hook: what is currently impossible or broken

**Example opening:** "GPU clusters for training and inference are some of the most economically critical network infrastructures in operation today."

### Paragraph 2: Problem and Limitations (Complication)
- Describe current approaches and their characteristics
- Identify specific problems (enumerate them: 1, 2, 3)
- Show why existing solutions are inadequate
- Use concrete numbers and named systems

**Example:** "Despite these advantages, we observe that multi-agent systems fail precisely when they are needed most: during production incidents."

### Paragraph 3: Proposed Solution and Challenges (Question)
- Introduce your proposed approach
- State the key challenges you encounter
- Frame the research question
- Name your system and its key insight

**Example:** "We argue that multi-agent NetOps must be treated as an operating system problem."

### Paragraph 4: How You Address Challenges (Answer — mechanisms)
- Describe your key techniques or design decisions
- Connect each technique to the challenges from Paragraph 3
- Ground each mechanism in observable behavior: "X does Y. Our system replicates this by Z."

**Pattern:** "Expert operators throttle their workload when they sense cognitive overload. Our system replicates this behavior by adapting congestion control principles."

### Paragraph 5: Results and Achievements (Answer — evidence)
- Present key performance metrics with bold numbers
- Quantify improvements against baselines
- Mention scale (cluster size, duration, data volume)

**Example:** "In production deployments, our system improves task throughput by **56.39%** and reduces failure rates by **38.2%**."

### Paragraph 6: Contributions list
- Always end the introduction with a numbered list of contributions
- Each contribution is one sentence
- No rigid limit — include as many as the narrative requires
- Each contribution should be specific and evaluable

**Example:**
```
This paper makes four contributions:
(1) A characterization of real incident-driven workloads...
(2) Empirical evidence that existing schedulers fail...
(3) The design of our system...
(4) An evaluation on realistic incident replays...
```

## Common SCQA failures

| Failure | Example | Fix |
|---|---|---|
| Starting with history | "Since the dawn of distributed computing..." | Start with the current reality |
| Vague problem statement | "Existing systems are suboptimal" | Name the specific failure with numbers |
| Solution-first writing | "We built X, which does Y..." before stating the problem | State the problem first, then the solution |
| Missing research question | The reader finishes the intro without knowing what question the paper answers | Ensure one sentence explicitly states the question |
| Contributions as afterthought | A weak bullet list at the end | Contributions should be specific, evaluable claims |

## Length guidelines

| Section | Target |
|---|---|
| Full introduction | 1.0–1.5 pages |
| Situation (P1) | 0.2 pages |
| Complication (P2) | 0.2–0.3 pages |
| Question (P3) | 0.15–0.2 pages |
| Answer mechanisms (P4) | 0.3 pages |
| Answer evidence (P5) | 0.15 pages |
| Contributions (P6) | 0.1 pages |
