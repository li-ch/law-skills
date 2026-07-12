# Venue Template Mapping

| Venue | Document class | Style file | Bib style | Page limit (body only) | Anonymous? | Notes |
|---|---|---|---|---|---|---|
| `nsdi` | `\documentclass[letterpaper,twocolumn,10pt]{article}` | `usenix2019_v3.sty` | (plain, uses `\bibliographystyle{plain}`) | 12 | yes | Frontiers track may have different limits |
| `sigcomm` | `\documentclass[sigconf,10pt]{acmart}` | N/A (acmart built-in) | `ACM-Reference-Format.bst` | 12 | yes | Experience track may have different limits |
| `apnet` | `\documentclass[sigconf,10pt]{acmart}` | N/A (acmart built-in) | `ACM-Reference-Format.bst` | 6 | yes | Workshop paper; shorter page limit |
| `arxiv` | `\documentclass{article}` | `PRIMEarxiv.sty` | (plain) | none | no | Pre-print; no page limit or anonymization |

## Adding a new venue

1. Add a row to this table
2. Place the venue's `.cls`, `.sty`, `.bst` files in `law-bootstrap/assets/venue-templates/{venue}/`
3. Update `law-bootstrap` SKILL.md to include the new venue in its lookup
