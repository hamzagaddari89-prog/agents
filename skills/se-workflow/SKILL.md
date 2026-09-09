---
name: se-workflow
description: Safe software engineering workflow with verification and rollback
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: implementation
---

# Software Engineering Workflow Skill

## Purpose

Implement software changes safely with verification, checkpoints, and rollback capability.

## When to Use This Skill

Use this skill when:
- Implementing new features
- Fixing bugs
- Refactoring code
- Modifying configuration
- Making any filesystem changes

## Core Principles

### Safety First

1. **Verify before change** - Understand current state
2. **Checkpoint before change** - Save state for rollback
3. **Implement change** - Make minimal, focused changes
4. **Verify after change** - Confirm change works
5. **Rollback if needed** - Restore if verification fails

### Implementation Workflow

1. **Pre-Implementation**
   - Read relevant code/config
   - Understand current behavior
   - Identify affected files
   - Check memory for prior decisions
   - Run diagnostics if appropriate

2. **Checkpoint**
   - Use `create_checkpoint` tool
   - Document what is being changed
   - Save affected file states

3. **Implement**
   - Make minimal changes
   - Follow existing conventions
   - Preserve backwards compatibility
   - Document non-obvious decisions

4. **Verify**
   - Run tests if available
   - Check for syntax errors
   - Verify expected behavior
   - Run diagnostics if appropriate

5. **Report**
   - Summarize changes made
   - List files modified
   - Document verification results
   - Note any rollback procedures

## Change Classification

| Level | Type | Approval | Examples |
|-------|------|----------|----------|
| 0 | Read-only | None | Analysis, research |
| 1 | Non-destructive | None | Add file, add code |
| 2 | Config/dependency | Ask | Modify config, update deps |
| 3 | DANGEROUS | STOP | Delete, reset, system changes |

## Verification Checklist

- [ ] Code compiles/builds
- [ ] Tests pass (if available)
- [ ] No syntax errors
- [ ] Expected behavior confirmed
- [ ] No unintended side effects
- [ ] Rollback method documented

## Memory Integration

When implementing:
- Check memory for prior decisions on this code
- Store implementation decisions using `memory_checkpoint`
- Update project memory with new conventions
- Current verified state overrides stale memory

## Diagnostics Integration

Before implementation:
- Use `diagnose` tool to check environment
- Verify dependencies are available
- Check for existing issues

After implementation:
- Re-run diagnostics to verify no regressions
- Use `propose_repair` if issues found

## Security Rules

### NEVER:
- Modify OpenCode Core
- Delete files without explicit approval
- Reset Git repositories
- Commit or push automatically
- Modify system configuration without approval
- Execute destructive commands

### ALWAYS:
- Create checkpoint before changes
- Verify changes work
- Document rollback method
- Get approval for Level 2+ changes
- Follow existing conventions

## Failure Behavior

If implementation fails:
- Stop immediately
- Report the failure
- Use checkpoint to rollback
- Do not leave partial changes
- Document what went wrong

## Example

```markdown
## Task: Add error handling to API endpoint

### Pre-Implementation
- Read: src/api/users.ts (current implementation)
- Memory: No prior decisions on error handling
- Diagnostics: Environment healthy

### Checkpoint
- Created checkpoint: cp-12345
- Files: src/api/users.ts

### Implementation
- Added try/catch around database call
- Added error response with status code
- Added logging for errors

### Verification
- [ ] TypeScript compiles
- [ ] Manual test: valid request works
- [ ] Manual test: invalid request returns 400
- [ ] Manual test: database error returns 500

### Result
SUCCESS - Error handling added with rollback available
```
