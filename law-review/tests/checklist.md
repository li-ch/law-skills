# law-review — Test Checklist

Behavior tests — run by giving the agent review files and checking the todo.md output.

## T6.1: Correctly structured todo.md

**Setup:** Agent has read `~/.common-law/paper-style/todo-format.md`

**Prompt:** "Triage the reviews in reviews/reviews-r1.txt."

**Verify:**
- [ ] Output is written to `todo.md`
- [ ] Contains P0, P1, and P2 sections
- [ ] Items use R1-1, R1-2, ... format
- [ ] Includes "Current Status" header with date
- [ ] Items are specific and actionable ("Add X to §Y")

## T6.2: Priority assignment

**Verify:**
- [ ] P0 items are acceptance-critical (reviewer said "must fix" or "required")
- [ ] P1 items are major concerns (affects score)
- [ ] P2 items are minor (typos, formatting, clarifications)

## T6.3: Groups by review round

**Prompt:** "Now triage reviews-r2.txt on top of the existing todo.md."

**Verify:**
- [ ] New items use R2-1, R2-2, ... format
- [ ] R1 items remain unchanged
- [ ] "Completed" section shows R1 history if items were checked off

## T6.4: Cross-section items

**Verify:**
- [ ] Items affecting multiple sections tag all sections: "(§4.2, §7)"
- [ ] Single-section items don't have section tags

## T6.5: Uncertain items flagged

**Prompt:** Use a review that contains vague feedback ("The authors should consider...")

**Verify:**
- [ ] Vague items prefixed with `⚠️ UNCERTAIN:`
- [ ] At least one item is flagged

## T6.6: Review prompt included

**Verify:**
- [ ] Agent's response tells user to review priorities before implementing
- [ ] Agent states number of items extracted by priority
