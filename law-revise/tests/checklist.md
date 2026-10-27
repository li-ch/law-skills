# law-revise — Test Checklist

Behavior tests — run by giving the agent revision items and checking the output.

## Test setup

Use `~/.common-law/test-fixtures/sample-paper/`. Create a minimal `todo.md` with test items.

## T7.1: Implements a single item

**Setup todo.md item:**
```
- [ ] R1-1: Add a sentence about scalability to §4.design.tex after the first paragraph.
```

**Prompt:** "Implement item R1-1."

**Verify:**
- [ ] The sentence is added to `sections/4.design.tex`
- [ ] `git log -1` shows commit message `[R1] R1-1: add scalability sentence to §4`
- [ ] Paper rebuilds successfully

## T7.2: Rebuilds after each item

**Setup:** 2 items in todo.md.

**Prompt:** "Implement R1-1 and R1-2."

**Verify:**
- [ ] Agent rebuilds after R1-1, commits, then rebuilds after R1-2, commits
- [ ] Two distinct commits in git log

## T7.3: Build failure → stops

**Setup:** An item that introduces a LaTeX error (e.g., "add an unclosed `\textbf{` to §4").

**Prompt:** "Implement R1-1."

**Verify:**
- [ ] Agent reports build failure to user
- [ ] Agent does NOT attempt to implement the next item
- [ ] Agent does NOT try to fix the error itself

## T7.4: Cross-section item edits all files

**Setup todo.md item:**
```
- [ ] R1-1: Replace all occurrences of "resource allocator" with "adaptive allocator" (§1.intro, §4.design)
```

**Verify:**
- [ ] Both files are modified
- [ ] Single commit contains changes to both files

## T7.5: Stops after completing asked items

**Setup:** 4 items in todo.md.

**Prompt:** "Implement R1-1 through R1-2."

**Verify:**
- [ ] Only items 1 and 2 are implemented
- [ ] Items 3 and 4 remain unchecked
- [ ] Agent says which items were deferred

## T7.6: Summary produced

**Verify:**
- [ ] After all items: agent lists items completed
- [ ] Agent mentions any build failures
- [ ] Agent reminds user to run law-verify if applicable
