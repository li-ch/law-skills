# law-bootstrap — Test Checklist

Run each test and check the box when it passes.

## T1.1: Creates correct directory structure with valid args

Run:
```bash
bash scripts/new-paper.sh --name test-paper --venue nsdi --year 2027 --cycle spring
```

Verify:
- [ ] Directory `test-paper-nsdi-2027-spring/` is created
- [ ] It contains: `main.tex`, `CLAUDE.md`, `AGENTS.md`, `refs.bib`, `.gitignore`, `.git/`
- [ ] It contains directories: `sections/`, `figs/`, `reviews/`, `misc/`, `data/`, `templates/`
- [ ] `templates/` contains `dev.plan.md` and `todo.md`

Cleanup: `rm -rf test-paper-nsdi-2027-spring/`

---

## T1.2: Creates working git repo with .gitignore

Run:
```bash
bash scripts/new-paper.sh --name test-git --venue arxiv --year 2025
```

Verify:
- [ ] `git status` in the output directory shows clean state
- [ ] `git log` shows exactly 1 commit with message "Initial commit: bootstrap test-git for arXiv 2025"
- [ ] `.gitignore` exists and contains `temp/`, `*.aux`, `*.log`, `*.pdf`

Cleanup: `rm -rf test-git-arxiv-2025/`

---

## T1.3: CLAUDE.md is copied and narrative placeholder appended

Run:
```bash
bash scripts/new-paper.sh --name test-claude --venue nsdi --year 2027
```

Verify:
- [ ] `test-claude-nsdi-2027/CLAUDE.md` exists
- [ ] Content matches `~/.common-law/paper-style/CLAUDE.md` (check first 10 lines: `diff <(head -10 ~/.common-law/paper-style/CLAUDE.md) <(head -10 test-claude-nsdi-2027/CLAUDE.md)`)
- [ ] Last 30 lines contain "## Paper Narrative"
- [ ] Last 30 lines contain "[One sentence that the paper answers]"

Cleanup: `rm -rf test-claude-nsdi-2027/`

---

## T1.4: refs.bib is copied

Run:
```bash
bash scripts/new-paper.sh --name test-bib --venue arxiv --year 2025
```

Verify:
- [ ] `test-bib-arxiv-2025/refs.bib` exists
- [ ] `diff ~/.common-law/bib/refs.bib test-bib-arxiv-2025/refs.bib` produces no output

Cleanup: `rm -rf test-bib-arxiv-2025/`

---

## T1.5: AGENTS.md has required fields filled

Run:
```bash
bash scripts/new-paper.sh --name test-agents --venue sigcomm --year 2026
```

Verify:
- [ ] AGENTS.md contains `System name macro:` with `[FILL IN]`
- [ ] AGENTS.md contains `SIGCOMM 2026`
- [ ] AGENTS.md contains a page limit number (not "unknown")
- [ ] AGENTS.md contains `\sys` macro usage instructions
- [ ] AGENTS.md contains "No emdashes" convention

Cleanup: `rm -rf test-agents-sigcomm-2026/`

---

## T1.6: main.tex uses correct document class per venue

Run for each venue and verify:
```bash
bash scripts/new-paper.sh --name test-nsdi --venue nsdi --year 2027
bash scripts/new-paper.sh --name test-sigcomm --venue sigcomm --year 2027
bash scripts/new-paper.sh --name test-apnet --venue apnet --year 2027
bash scripts/new-paper.sh --name test-arxiv --venue arxiv --year 2027
```

Verify:
- [ ] `test-nsdi-nsdi-2027/main.tex` contains `\documentclass[letterpaper,twocolumn,10pt]{article}` and `\usepackage{usenix2019_v3}`
- [ ] `test-sigcomm-sigcomm-2027/main.tex` contains `\documentclass[sigconf,10pt]{acmart}`
- [ ] `test-apnet-apnet-2027/main.tex` contains `\documentclass[sigconf,10pt]{acmart}`
- [ ] `test-arxiv-arxiv-2027/main.tex` contains `\documentclass{article}` and `\usepackage{PRIMEarxiv}`

Cleanup: `rm -rf test-nsdi-nsdi-2027/ test-sigcomm-sigcomm-2027/ test-apnet-apnet-2027/ test-arxiv-arxiv-2027/`

---

## T1.7: Correct style files copied to root per venue

Reuse the directories from T1.6.

Verify:
- [ ] `test-nsdi-nsdi-2027/usenix2019_v3.sty` exists
- [ ] `test-sigcomm-sigcomm-2027/acmart.cls` exists
- [ ] `test-sigcomm-sigcomm-2027/ACM-Reference-Format.bst` exists
- [ ] `test-apnet-apnet-2027/acmart.cls` exists
- [ ] `test-arxiv-arxiv-2027/PRIMEarxiv.sty` exists

---

## T1.8: Missing parameter → fails, does not create anything

Run:
```bash
bash scripts/new-paper.sh --name test-missing --venue nsdi
```

Verify:
- [ ] Script exits with non-zero status
- [ ] Error message mentions missing `--year`
- [ ] No directory `test-missing-*` is created

---

## T1.9: Target directory exists → warns

Run:
```bash
mkdir test-exists-nsdi-2027
bash scripts/new-paper.sh --name test-exists --venue nsdi --year 2027
```

Verify:
- [ ] Script exits with non-zero status
- [ ] Warning message mentions directory already exists

Cleanup: `rm -rf test-exists-nsdi-2027/`

---

## T1.10: Script works on macOS

Run all above tests on macOS.

Verify:
- [ ] All T1.1–T1.9 pass on macOS
