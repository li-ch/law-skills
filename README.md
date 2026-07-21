# LAW Skills for OpenCode

**Li's Academic Writing Skills (LAW Skills) are 10 AI agent skills that let you write an academic paper with OpenCode in a principled way.**

You bootstrap a paper repo with one sentence. The agent writes sections following 25 writing rules. You say "build" and it runs pdflatex 4 times, produces a timestamped PDF, runs post-build checks, and commits to git — all in one step. When reviews come back, it parses them into a structured checklist, implements text fixes one at a time, and writes experiment guides for your students.

Every skill reads your venue rules, writing guide, and paper state before acting. You don't repeat instructions. The agent already knows.

---

```
User: Create a paper called swiftcache for SIGCOMM 2027
→ swiftcache-sigcomm-2027/ created with template, bib, git

User: Write the Introduction
→ sections/1.intro.tex drafted with SCQA structure, humanized

User: Build
→ main-202607141530.pdf (12 pages)  ✓ verified  ✓ committed
```

---

## Quick Install

```bash
git clone https://github.com/li-ch/law-skills.git
cd law-skills
bash install.sh
```

Restart OpenCode. All 10 skills will be available.

You also need the humanizer skill (not included):

```bash
curl -sL "https://www.skillhub.club/api/v1/skills/blader-humanizer/install?agents=opencode&format=sh" | bash
```

---

## Skills Overview

| Skill | What it does | Example prompt |
|---|---|---|
| `law-bootstrap` | Creates a paper repo with venue template, git init | "Create a paper called swiftcache for NSDI 2027 Fall" |
| `law-write` | Writes/edits LaTeX sections following writing rules | "Write the Introduction" |
| `law-build` | 4-pass pdflatex, timestamped PDF, git commit | "Build" |
| `law-verify` | Post-build checks: emdashes, refs, formatting | Automatic after build |
| `law-review` | Parses reviewer feedback into structured `todo.md` | "Reviews are in reviews/" |
| `law-revise` | Implements `todo.md` items one at a time | "Fix R1-1" |
| `law-call4expr` | Writes experiment guides for human execution | "What experiments should my student run?" |
| `law-pagecount` | Counts pages per section from compiled PDF | Automatic after build |
| `law-resubmit` | Copies repo, swaps venue templates | "Resubmit to SIGCOMM 2027" |
| `law-upstream` | Syncs bib entries and writing rules to shared state | "Upstream changes" |

---

## Complete Workflow

### Day 1: Bootstrap and write

```bash
# 1. Create the paper
User: Create a paper called swiftcache for NSDI 2027 Fall
Agent: → swiftcache-nsdi-2027-fall/ created
       → Fill in \sys macro and the Paper Narrative in CLAUDE.md

# 2. Fill in the narrative (the most important step)
# Edit CLAUDE.md — 10 sentences describing the problem, key insight,
# and three contributions. Every law-write call reads this.

# 3. Write sections
User: Write the Introduction
Agent: → sections/1.intro.tex (SCQA structure, humanized)

User: Write the System Design
Agent: → sections/4.design.tex

# 4. Build
User: Build
Agent: → main-202607141530.pdf (12 pages)
       → §1: 1.5p  §4: 5.2p ← too long
       → ✓ All refs resolve  ✓ All cites resolve
       → Committed: "write §1 introduction, §4 design"
```

### After reviews arrive

```bash
# 5. Triage reviews
User: Reviews are in reviews/
Agent: → 28 items extracted: 9 P0, 12 P1, 7 P2
       → 14 experiment items detected
       → Wrote todo.md

# 6. Fix text items
User: Fix R1-1
Agent: → Edited §4.3, added subsections
       → Built, verified, committed: "[R1] R1-1: add coherence model §4.3"

# 7. Delegate experiments
User: What experiments should my student run?
Agent: → Wrote expr.todo.md
       → 4 experiments, each with CSV + script + figure specs
```

### After rejection

```bash
# 8. Switch venues
User: Resubmit to SIGCOMM 2027
Agent: → swiftcache-sigcomm-2027/ (new template)
       → All sections, figures, data preserved
       → Old PDFs and reviews archived
```

---

## How It Works

Each skill reads three things before acting:

1. **Venue rules** — page limits, anonymization, style files (from `venue-map.md`)
2. **Writing rules** — 17 rules from `writing-rules.md` (active voice, no emdashes, etc.)
3. **Paper state** — what's in `todo.md`, what revisions are pending, what experiments are needed

Without skills, you tell the LLM these things every session. With skills, they're implicit.

### The Core Loop (runs dozens of times per paper)

```
law-bootstrap → law-write → law-build → law-verify
```

### The Revision Loop (runs once per review round)

```
law-review → law-revise → law-call4expr
```

---

## Prerequisites

| Requirement | Used By | Install |
|---|---|---|
| [OpenCode CLI](https://opencode.ai) | All skills | OpenCode agent platform |
| `git` | `law-bootstrap` | `brew install git` (macOS) or `apt install git` (Linux) |
| `pdflatex` + `bibtex` | `law-build` | [MacTeX](https://tug.org/mactex/) (macOS) or [TeX Live](https://tug.org/texlive/) (Windows/Linux) |
| `bash` | All skill scripts | Pre-installed on macOS/Linux. Windows: use Git Bash or WSL. |
| Python 3 + `pikepdf` | `law-pagecount` | `pip install pikepdf` |
| `curl` | Humanizer install | Pre-installed on macOS/Linux |
| Humanizer skill | `law-write` (auto) | See install command above |

### Optional

| Requirement | Used By | Notes |
|---|---|---|
| `pdftk` | `law-pagecount` | Alternative to `pikepdf`. `brew install pdftk-java` (macOS) |

### Shared state

`install.sh` creates `~/.common-law/` with:
- `bib/refs.bib` — 144 pre-loaded verified citations
- `paper-style/CLAUDE.md` — writing rules and style guide
- `paper-style/writing-rules.md` — full rule reference with examples
- `paper-style/venue-map.md` — venue-to-template mappings (NSDI, SIGCOMM, APNet, arxiv)
- `paper-style/todo-format.md` — revision tracker format specification

No manual configuration needed — `install.sh` sets everything up.

---

## More Resources

- **[Lecture Slides](https://li-ch.github.io/law-skills/)** — 80-slide presentation covering all 10 skills with a case study
- **[Contributing](CONTRIBUTING.md)** — how to report bugs, submit bib entries, or propose rule changes

---

## License

MIT
