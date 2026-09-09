---
name: ai-priming
description: Personal AI agent priming with persistent memory context injection
---

# AI Priming Skill

## Purpose

Provide relevant context BEFORE work begins using the persistent memory system.

## When to Use This Skill

Use this skill at the start of a session or when switching to a new task area.

## Memory Retrieval Flow

1. **Identify Task Context**
   - What is the current project?
   - What type of work is being done (code, docs, design)?
   - What domain knowledge is relevant?

2. **Retrieve Relevant Memory**
   - Use `memory_search` with task-relevant keywords
   - Filter by scope: project memory first, then global if needed
   - Limit to 3-5 most relevant entries

3. **Inject Context**
   - Summarize relevant memories concisely
   - Reference memory keys for transparency
   - Do NOT inject entire memory system

## Memory Usage Rules

### Reading
- Check project memory first for project-specific context
- Check global memory for user preferences and conventions
- Always verify memory against current filesystem state
- Current verified state STALE memory wins

### Writing
- Only store stable, useful information
- Never store secrets (API keys, passwords, tokens)
- Use descriptive keys with clear names
- Add tags for categorization
- Write decisions to decisions log

### Trust Model
- Memory is potentially stale
- Current filesystem/config state overrides memory
- User instructions in session override stored memory
- When in doubt, verify with filesystem

## What to Remember

### Global Memory (User Preferences)
- Coding conventions (style, patterns)
- Preferred tools and frameworks
- Communication preferences
- Workflow habits

### Project Memory (Project Context)
- Architecture decisions
- Key file locations
- Build/test commands
- Project-specific conventions

### Decisions Log (Audit Trail)
- Architectural decisions with rationale
- Design trade-offs considered
- Milestones achieved
- Issues encountered and resolved

## What NOT to Remember
- Temporary conversation content
- API keys or secrets
- Session-specific debugging output
- Information that belongs in code comments
- Anything that contradicts current filesystem state

## Security Rules

### NEVER:
- Store secrets (API keys, passwords, tokens)
- Expose sensitive information in memory
- Auto-execute based on memory without verification
- Modify files without checkpoint

### ALWAYS:
- Verify memory against current state
- Classify evidence type
- Provide rollback methods
- Get approval for changes

## Retrieval Example

```
Task: "Add authentication to the settings route"

1. Search memory for: "authentication", "settings", "security"
2. Filter: project memory > global memory
3. Inject: "Previous auth decisions: use JWT tokens, store in httpOnly cookies (decision-2026-09-01)"
4. Verify: Check actual auth implementation in codebase
```

## Failure Behavior

If memory system is unavailable:
- Continue without memory context
- Rely on filesystem and AGENTS.md
- Do not block on memory retrieval
- Report memory unavailability if critical
