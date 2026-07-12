---
name: law-bootstrap
description: Create a new academic paper repository with the correct directory structure, venue template, and agent instruction files. Use when the user asks to create a new paper, bootstrap a paper project, start a new submission, or set up a paper repo for a specific venue (NSDI, SIGCOMM, APNet, arxiv).
---

# LAW Bootstrap

Create a new academic paper repository from scratch. This skill initializes the directory structure, copies venue-specific templates, sets up git, and generates AGENTS.md with the paper's metadata.

## Venue template mapping

Read `~/.common-law/paper-style/venue-map.md` for the authoritative mapping of venues to document classes, style files, bib styles, page limits, and anonymization requirements.

Supported venues: `nsdi`, `sigcomm`, `apnet`, `arxiv`.

## Workflow

### Step 1: Gather parameters interactively

Ask the user for each parameter. Do not proceed until all required parameters are provided and confirmed. Do not create anything if any parameter is unclear.

Required:
- Paper name (short lowercase identifier, e.g., `swiftcache`)
- Venue (`nsdi`, `sigcomm`, `apnet`, or `arxiv`)
- Year (e.g., `2027`)

Optional:
- Cycle (`spring`, `fall`, `cycle-2`, etc.) — for venues with multiple deadlines

If the user provides all parameters in one message (e.g., "create a new paper called swiftcache for NSDI 2027 spring"), extract them and confirm before proceeding.

### Step 2: Validate

- Check that the venue is in the venue-map
- Check that the target directory does not already exist
- If it exists, warn and ask for confirmation

### Step 3: Create the paper

Run `scripts/new-paper.sh` with the gathered parameters:

```bash
bash scripts/new-paper.sh --name <name> --venue <venue> --year <year> [--cycle <cycle>]
```

The script:
1. Creates the directory `{name}-{venue}-{year}[-{cycle}]`
2. Copies `assets/template/` into the new directory
3. Copies the appropriate venue template files from `assets/venue-templates/{venue}/` into the paper root
4. Copies `~/.common-law/paper-style/CLAUDE.md` into the paper root
5. Appends the paper narrative placeholder to CLAUDE.md
6. Copies `~/.common-law/bib/refs.bib` into the paper root as `refs.bib`
7. Initializes git with `.gitignore` and creates an initial commit
8. Writes `AGENTS.md` with venue and page limit filled in, placeholders for human-filled fields

### Step 4: Tell the user what to fill in

After creation, list the fields in `AGENTS.md` that still need human input:
- `\sys` macro name
- Section structure (once sections are written)
- Author annotation macros
- Paper narrative in CLAUDE.md

### Step 5: Remind about the narrative

Tell the user: "The most important next step is to fill in the Paper Narrative section at the bottom of CLAUDE.md. This tells agents what story the paper tells and what technical contributions it makes. Without this, agents will not write focused sections."

## Platform support

- macOS/Linux: `new-paper.sh`
- Windows: `new-paper.bat`

Detect the platform and call the correct script.

## Prerequisites

- `git` must be installed
- `bash` (macOS/Linux) or `cmd.exe` (Windows)
- `~/.common-law/` directory must exist with CLAUDE.md, refs.bib, and venue-map.md

If `~/.common-law/` does not exist, create it and tell the user to populate the files before running the skill.
