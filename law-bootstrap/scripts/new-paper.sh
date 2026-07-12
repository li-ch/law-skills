#!/bin/bash
set -euo pipefail

# new-paper.sh — bootstrap a new academic paper repository
# Usage: bash new-paper.sh --name <name> --venue <venue> --year <year> [--cycle <cycle>]

# --- Parse arguments ---
NAME=""
VENUE=""
YEAR=""
CYCLE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)   NAME="$2"; shift 2 ;;
        --venue)  VENUE="$2"; shift 2 ;;
        --year)   YEAR="$2"; shift 2 ;;
        --cycle)  CYCLE="$2"; shift 2 ;;
        *) echo "Unknown argument: $1"; exit 1 ;;
    esac
done

# --- Validate ---
if [[ -z "$NAME" || -z "$VENUE" || -z "$YEAR" ]]; then
    echo "ERROR: --name, --venue, and --year are required."
    echo "Usage: bash new-paper.sh --name <name> --venue <venue> --year <year> [--cycle <cycle>]"
    exit 1
fi

# Determine the directory where this script lives (the skill's scripts/ dir)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$SKILL_DIR/assets/template"
VENUE_TEMPLATES_DIR="$SKILL_DIR/assets/venue-templates"
COMMON_LAW="$HOME/.common-law"

# --- Build directory name ---
if [[ -n "$CYCLE" ]]; then
    PAPER_DIR="${NAME}-${VENUE}-${YEAR}-${CYCLE}"
else
    PAPER_DIR="${NAME}-${VENUE}-${YEAR}"
fi

# --- Check if directory exists ---
if [[ -d "$PAPER_DIR" ]]; then
    echo "WARNING: Directory '$PAPER_DIR' already exists."
    echo "The agent should have asked for confirmation before reaching this point."
    exit 1
fi

echo "Creating paper repository: $PAPER_DIR"

# --- Copy template ---
cp -r "$TEMPLATE_DIR" "$PAPER_DIR"

# --- Copy venue template files ---
VENUE_SRC="$VENUE_TEMPLATES_DIR/$VENUE"
if [[ -d "$VENUE_SRC" ]]; then
    cp "$VENUE_SRC"/* "$PAPER_DIR/" 2>/dev/null || true
else
    echo "WARNING: No template files found for venue '$VENUE' at $VENUE_SRC"
fi

# --- Read venue-map to get page limit ---
VENUE_MAP="$COMMON_LAW/paper-style/venue-map.md"
PAGE_LIMIT="unknown"
if [[ -f "$VENUE_MAP" ]]; then
    # Extract page limit from the venue-map markdown table
    PAGE_LIMIT=$(grep "\`$VENUE\`" "$VENUE_MAP" | head -1 | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $5); print $5}' || true)
    if [[ -z "$PAGE_LIMIT" ]]; then
        PAGE_LIMIT="unknown"
    fi
fi

ANON_MODE="yes"
if [[ -f "$VENUE_MAP" ]]; then
    ANON_CHECK=$(grep "\`$VENUE\`" "$VENUE_MAP" | head -1 | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $6); print $6}')
    if [[ "$ANON_CHECK" == "no" ]]; then
        ANON_MODE="no"
    fi
fi

# --- Copy shared files from ~/.common-law/ ---
if [[ -f "$COMMON_LAW/paper-style/CLAUDE.md" ]]; then
    cp "$COMMON_LAW/paper-style/CLAUDE.md" "$PAPER_DIR/CLAUDE.md"
else
    echo "WARNING: $COMMON_LAW/paper-style/CLAUDE.md not found. Create it first."
fi

if [[ -f "$COMMON_LAW/bib/refs.bib" ]]; then
    cp "$COMMON_LAW/bib/refs.bib" "$PAPER_DIR/refs.bib"
else
    echo "WARNING: $COMMON_LAW/bib/refs.bib not found. Create it first."
fi

# --- Append paper narrative placeholder to CLAUDE.md (only if not already present) ---
if ! grep -q "## Paper Narrative" "$PAPER_DIR/CLAUDE.md"; then
    cat >> "$PAPER_DIR/CLAUDE.md" << 'NARRATIVE_EOF'

---

## Paper Narrative

*This section is paper-specific. Fill it in before writing. It tells the agent what story this paper tells and what technical contributions it makes. No rigid bullet limit — include as many challenges, decisions, and results as the narrative requires.*

### Research question
[One sentence that the paper answers]

### Challenges
- [Challenge 1]
- [Challenge 2]
- ...

### Design decisions
- [Decision 1] — addresses [Challenge X]
- [Decision 2] — addresses [Challenge Y]
- ...

### Key results
- [Result 1]
- [Result 2]
- ...
NARRATIVE_EOF
fi

# --- Write AGENTS.md ---
VENUE_DISPLAY="$VENUE"
if [[ "$VENUE" == "nsdi" ]]; then VENUE_DISPLAY="NSDI"; fi
if [[ "$VENUE" == "sigcomm" ]]; then VENUE_DISPLAY="SIGCOMM"; fi
if [[ "$VENUE" == "apnet" ]]; then VENUE_DISPLAY="APNet"; fi
if [[ "$VENUE" == "arxiv" ]]; then VENUE_DISPLAY="arXiv"; fi

cat > "$PAPER_DIR/AGENTS.md" << AGENTS_EOF
# AGENTS.md — $NAME

## Paper metadata

- **System name macro:** \`\\sys\` → \`[FILL IN]\`
- **Venue:** $VENUE_DISPLAY $YEAR
- **Page limit:** $PAGE_LIMIT pages (main body)
- **Anonymous submission:** $ANON_MODE
- **Active bib file:** \`refs.bib\`

## Build

- \`bash build.sh\` (macOS/Linux) or \`build.bat\` (Windows)
- \`pdflatex\` engine only — no xelatex/lualatex

## Section structure

*Fill in after writing sections:*

| File | Section |
|---|---|
| \`sections/1.intro.tex\` | Introduction |
| \`sections/2.bg.tex\` | Background and Motivation |
| \`sections/3.overview.tex\` | Overview |
| \`sections/4.design.tex\` | Design |
| \`sections/5.implementation.tex\` | Implementation |
| \`sections/6.evaluation.tex\` | Evaluation |
| \`sections/7.related.tex\` | Related Work |
| \`sections/8.conclusion.tex\` | Conclusion |

## LaTeX conventions

- Never modify existing macros, document class, or class/style files.
- The system name macro is \`\\sys\`.
- Use \`\\cref{}\` for all cross-references — never bare \`\\ref{}\`.
- Citation style: \`~\\cite{key}\` (tilde before cite).
- Pseudo-code: use \`algorithm2e\` or \`algpseudocode\`.
- All tables wrapped in \`\\resizebox\`: \`\\resizebox{\\columnwidth}{!}{...}\` or \`\\resizebox{\\textwidth}{!}{...}\`.
- No emdashes (\`---\`), no hyphens in prose, no \`\\textbf{}\` mid-paragraph.

## Author annotation macros

*Fill in:*

\`\`\`latex
% \\newcommand{\\authorA}[1]{\\textcolor{blue}{authorA: #1}}
\`\`\`

## Writing style

Read \`CLAUDE.md\` for the full writing guide. Key invariants:
- Active voice, present tense, first person ("We find that…")
- Do not change or invent citations
- Do not modify LaTeX structure or macros
- Be concise; avoid fluff and adjectives
AGENTS_EOF

# --- Initialize git ---
cd "$PAPER_DIR"
git init
git add -A
git commit -m "Initial commit: bootstrap $NAME for $VENUE_DISPLAY $YEAR" > /dev/null 2>&1
cd - > /dev/null

echo ""
echo "Paper repository created: $PAPER_DIR"
echo ""
echo "Next steps for the human:"
echo "  1. Fill in \\sys macro name in AGENTS.md"
echo "  2. Fill in author annotation macros in AGENTS.md"
echo "  3. Fill in the Paper Narrative section at the bottom of CLAUDE.md"
echo "  4. Run 'cd $PAPER_DIR' and start writing"
