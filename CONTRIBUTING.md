# Contributing to LAW Skills

Thanks for helping improve LAW skills. Here's how.

## Reporting Bugs

Open a GitHub issue. Include:

- Which skill (`law-bootstrap`, `law-write`, etc.)
- What you asked OpenCode to do (the exact prompt)
- What you expected to happen
- What actually happened
- Any relevant log output (`temp/main.log` for build failures)

## Submitting Bib Entries

The shared bibliography (`common-law/bib/refs.bib`) grows as papers add citations. To submit a new entry:

1. Add the complete BibTeX entry to `common-law/bib/refs.bib` (alphabetically by citation key)
2. Verify the paper exists (DOI, DBLP, or publisher URL)
3. Open a pull request with the message: `bib: add <citation-key>`

Format requirements:
- Full author list (no `et al.` or `and others`)
- Complete venue information (conference/journal name + year)
- DOI if available

## Proposing a New Writing Rule

1. Open an issue titled: `Writing rule proposal: <short description>`
2. Include: the rule text, a good example, a bad example
3. Explain which existing rule it complements or replaces

Rules are evaluated on: (1) frequency of violation in AI-generated text, (2) objective enforceability, (3) impact on readability.

## Submitting a Skill Fix

1. Fork the repo
2. Make your change in the relevant `law-*/` directory
3. Test by installing locally: `bash install.sh`
4. Open a pull request with a clear description

## Style

- SKILL.md files: follow the existing format (frontmatter, workflow steps, prerequisites)
- Shell scripts: bash, `#!/bin/bash`, POSIX-compatible
- Documentation: active voice, present tense, no emdashes
