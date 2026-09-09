---
name: project-status
description: Project management with checkpoints, status tracking, and decision logging
license: MIT
compatibility: opencode
metadata:
  audience: teams
  workflow: management
---

# Project Status Skill

## Purpose

Track project status, manage checkpoints, log decisions, and maintain project memory.

## When to Use This Skill

Use this skill when:
- Starting a new project phase
- Recording architectural decisions
- Checking project status
- Creating milestones
- Reviewing progress

## Core Principles

### Decision Tracking

Every significant decision must be logged:
- What was decided
- Why it was decided
- What alternatives were considered
- What the expected impact is

### Checkpoint System

Checkpoints capture project state at key moments:
- Before major changes
- At milestones
- When decisions are made
- At phase boundaries

## Project Status Workflow

1. **Status Check**
   - Review current project state
   - Check memory for prior status
   - Identify active issues
   - Review recent decisions

2. **Decision Recording**
   - Classify decision type
   - Document rationale
   - Log to decisions file
   - Update project memory

3. **Milestone Tracking**
   - Define milestones
   - Track completion
   - Record achievements
   - Plan next steps

## Decision Types

| Type | Description | Example |
|------|-------------|---------|
| architecture | System design choices | "Use JSON for memory storage" |
| design | UI/UX decisions | "Use terminal-based interface" |
| convention | Coding standards | "Use TypeScript strict mode" |
| milestone | Achievement markers | "Phase 1 complete" |
| issue | Problem encountered | "Memory system slow on large datasets" |

## Status Report Format

```markdown
## Project Status: [Date]

### Current Phase
[Description of current work]

### Completed
- [Milestone 1]
- [Milestone 2]

### In Progress
- [Task 1]
- [Task 2]

### Decisions Log
1. [DECISION] Decision 1 (date: [date])
2. [DECISION] Decision 2 (date: [date])

### Open Issues
- [Issue 1]
- [Issue 2]

### Next Steps
- [Step 1]
- [Step 2]
```

## Memory Integration

Project status uses memory system extensively:
- Store project status in project memory
- Use decisions log for decision tracking
- Use `memory_checkpoint` for milestones
- Current verified state overrides stale memory

### Memory Locations

| Data | Location | Purpose |
|------|----------|---------|
| Project status | `.opencode/memory/project.json` | Current state |
| Decisions | `.opencode/memory/decisions.jsonl` | Audit trail |
| Milestones | `.opencode/memory/project.json` | Achievements |

## Diagnostics Integration

Before status review:
- Use `diagnose` tool to check project health
- Verify memory system availability
- Check for configuration issues

## Security Rules

### NEVER:
- Store secrets in project status
- Auto-commit status changes
- Modify project files without approval
- Expose sensitive decisions

### ALWAYS:
- Classify decisions properly
- Maintain audit trail
- Verify memory writes
- Provide rollback methods

## Failure Behavior

If status tracking fails:
- Continue without status updates
- Report failure to user
- Do not block project work
- Use manual status tracking

## Example

```markdown
## Project Status: 2026-09-04

### Current Phase
Phase 3: Skills System Enhancement

### Completed
- Phase 1: Memory System (2026-09-04)
- Phase 2: Self-Diagnostics (2026-09-04)

### In Progress
- Phase 3: Skills Implementation

### Decisions Log
1. [architecture] Use JSON for memory storage (2026-09-04)
   - Rationale: Simple, readable, no dependencies
   - Alternatives: SQLite, YAML
2. [convention] Separate memory by scope (2026-09-04)
   - Rationale: Global vs project memory isolation
   - Alternatives: Single unified store

### Open Issues
- None

### Next Steps
- Complete skills implementation
- Test all skills
- Deliver final report
```
