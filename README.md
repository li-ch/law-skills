# LAW Skills for OpenCode

LAW (Li's Academic Writing) is a set of 10 AI agent skills that automate the paper-writing workflow. They handle venue templates, 4-pass pdflatex compilation, reviewer feedback triage, experiment delegation, page counting, venue resubmission, and shared bibliography management.

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

## Skills Overview

| Skill | What It Does | When |
|---|---|---|
| `law-bootstrap` | Creates a paper repo with venue template, directory structure, git init | Day 1 of a new paper |
| `law-write` | Writes or edits LaTeX sections following 25 writing rules | Drafting or editing any section |
| `law-build` | Runs 4-pass pdflatex, produces timestamped PDF, commits to git | After every edit |
| `law-verify` | Post-build checks: emdashes, refs/cites, bold, hyphens | Auto after build |
| `law-review` | Parses reviewer feedback into a structured `todo.md` | When reviews arrive |
| `law-revise` | Implements `todo.md` items one at a time, builds after each | During revision |
| `law-call4expr` | Writes experiment guides for human execution (CSV + script + figure) | When `todo.md` has ⏳ items |
| `law-pagecount` | Counts pages per section from compiled PDF | Auto after build |
| `law-resubmit` | Copies repo, swaps venue templates, archives old artifacts | After rejection |
| `law-upstream` | Syncs bib entries and writing rules back to shared state | After adding citations |

## How It Works

Each skill reads three things before acting:

1. **Venue rules** — page limits, anonymization, style files (from `venue-map.md`)
2. **Writing rules** — 25 rules from `writing-rules.md` (active voice, no emdashes, etc.)
3. **Paper state** — what's in `todo.md`, what revisions are pending, what experiments are needed

Without skills, you tell the LLM these things every session. With skills, they're implicit.

## The Core Loop (runs dozens of times per paper)

```
law-bootstrap → law-write → law-build → law-verify
```

## The Revision Loop (runs once per review round)

```
law-review → law-revise → law-call4expr
```

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

All the above except OpenCode CLI is optional. They can be installed by OpenCode CLI when any of them is missing in your system.

### Optional

| Requirement | Used By | Notes |
|---|---|---|
| `pdftk` | `law-pagecount` | Alternative to `pikepdf`. `brew install pdftk-java` (macOS) |

### Shared state

`install.sh` creates `~/.common-law/` with:
- `bib/refs.bib` — 144 pre-loaded verified citations
- `paper-style/CLAUDE.md` — 25 writing rules and style guide
- `paper-style/writing-rules.md` — full rule reference with examples
- `paper-style/venue-map.md` — venue-to-template mappings (NSDI, SIGCOMM, APNet, arxiv)
- `paper-style/todo-format.md` — revision tracker format specification

No manual configuration needed — `install.sh` sets everything up.

## License

MIT
