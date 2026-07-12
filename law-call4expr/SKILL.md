---
name: law-call4expr
description: Write experiment guides for handing off work from agent to human. Use when the user asks what experiments are needed, requests a task list for a student, or when todo.md contains items the agent cannot complete (code execution, data collection, figure generation, hardware access). Produce a concise guide with specific deliverables per experiment: CSV schema, plotting script, and final figure.
---

# LAW Call for Experiments

Write experiment guides for human execution. These guides hand off work that the agent cannot complete: running code, collecting data, producing figures, or accessing hardware.

## When to use this skill

Use when `todo.md` contains items that the agent cannot complete. These items are marked ⏳ WAITING ON DATA in `todo.md` with a pointer to the experiment guide. The guide is a task list, not a narrative — the person executing it should not need to read reviews or understand the paper's narrative.

## Writing rules

### Rule 1: No justification

The person running experiments knows why. Tell them what to produce, not why. Remove all "because the reviewer said" or "this validates assumption X" language.

### Rule 2: Three deliverables per experiment

Every experiment must specify exactly three outputs:

1. **CSV file** — path in `data/`, column names, what each column contains
2. **Plotting script** — path in `figs/`, what CSV it reads, what plot it produces
3. **Final figure** — path in `figs/`, the PNG file name

Never say "report the results" or "add a figure." Always specify exact file paths.

### Rule 3: Never reference reviewers

The guide is a task list. No reviewer names, no paper state, no priority justifications based on reviewer impact. If prioritization is needed, use a simple numbered list.

### Rule 4: Language matches audience

Write in the language the executor prefers. **Default to Chinese** — the guide targets a Chinese-speaking PhD student. If the user explicitly asks for English, or if the agent cannot determine the audience's language, write in English.

Do not assume Chinese is always correct. If the user says "my student speaks English," write in English.

## Templates

Use the template that matches the language. Default to Chinese unless the user specifies otherwise.

### Chinese template

```markdown
# [Paper Name] 补充实验

## 实验 N: [Name]

### 数据收集
- [Step 1]
- [Step 2]

### 交付物
- **CSV:** `data/xxx.csv`
  - 列：`col1, col2, col3`
- **绘图脚本:** `figs/fig-xxx.py`
  - 读取 `data/xxx.csv`
  - 输出：[description of plot]
- **最终图:** `figs/fig-xxx.png`
```

### English template

```markdown
# [Paper Name] — Supplementary Experiments

## Experiment N: [Name]

### Data Collection
- [Step 1]
- [Step 2]

### Deliverables
- **CSV:** `data/xxx.csv`
  - Columns: `col1, col2, col3`
- **Plotting script:** `figs/fig-xxx.py`
  - Reads `data/xxx.csv`
  - Produces: [description of plot]
- **Final figure:** `figs/fig-xxx.png`
```

## Integration with todo.md

After writing the guide, update `todo.md`:
- Items requiring experiments → mark ⏳ WAITING ON DATA
- Add pointer: "See Experiment N in experiments-guide.md"
- Items completed by the human → agent verifies deliverables exist, then marks done
