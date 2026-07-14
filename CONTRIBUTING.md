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

The shared bibliography (`common-law/bib/refs.bib`) grows as papers add citations.

### Via `law-upstream` (recommended)

When you add citations to your paper's `refs.bib` while working, the agent will offer to upstream them:

```
User: Upstream changes
Agent: Changes ready to upstream:
         [Bib entries — 3 new]
           chowdhury2023, li2025, zhang2024
       Select: all → Merged to ~/.common-law/bib/refs.bib
```

Then submit a pull request from your local `~/.common-law/bib/refs.bib` or open an issue with the entries. Use `law-upstream` to find what's new.

### Manually

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

If a writing rule was added or modified locally in a paper's `CLAUDE.md` during a session, use `law-upstream` to sync it back to shared state before submitting.

## Submitting a Skill Fix

1. Fork the repo
2. Make your change in the relevant `law-*/` directory
3. Test by installing locally: `bash install.sh`
4. Open a pull request with a clear description

For script fixes (build.sh, verify.sh, etc.), use `law-upstream` from your paper to identify local modifications before submitting. The upstream skill diffs your paper's scripts against the installed copies.

## Style

- SKILL.md files: follow the existing format (frontmatter, workflow steps, prerequisites)
- Shell scripts: bash, `#!/bin/bash`, POSIX-compatible
- Documentation: active voice, present tense, no emdashes
