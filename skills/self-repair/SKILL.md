---
name: self-repair
description: Safe self-diagnostics and repair for OpenCode environment
---

# Self-Repair Skill

## Purpose

Detect, diagnose, explain, and safely repair issues in the OpenCode environment without modifying OpenCode Core.

## Primary Principle

```
DETECT → DIAGNOSE → EXPLAIN → PROPOSE REPAIR → APPROVAL IF REQUIRED → EXECUTE → VERIFY → REPORT → CHECKPOINT
```

## Repair Levels

| Level | Name | Auto-Execute | Examples |
|-------|------|--------------|----------|
| 0 | OBSERVE | Read-only | Diagnostics, health checks |
| 1 | SAFE | Yes | Recreate missing cache, regenerate metadata |
| 2 | APPROVAL | No | Config changes, dependency updates |
| 3 | DANGEROUS | NEVER | System changes, deletions, OpenCode Core |

## When to Use This Skill

Use this skill when:
- Environment issues are suspected
- Configuration problems detected
- Memory system unavailable
- Extensions failing
- User requests health check

## Diagnostic Flow

1. **Run Diagnostics**
   - Use `diagnose` tool with category parameter
   - Review results: healthy, warning, error, info

2. **Analyze Issues**
   - Check repairable status
   - Review risk level
   - Identify root cause

3. **Propose Repair**
   - Use `propose_repair` tool
   - Get repair ID and details
   - Check approval status

4. **Execute (if safe)**
   - Level 0-1: Can auto-execute
   - Level 2+: Requires user approval
   - Level 3: NEVER auto-execute

5. **Verify**
   - Re-run diagnostics
   - Confirm issue resolved
   - Check no new issues introduced

6. **Checkpoint**
   - Use `create_checkpoint` before repair
   - Use `restore_checkpoint` if needed

## Safety Rules

### NEVER:
- Modify OpenCode Core
- Delete files automatically
- Reset Git repositories
- Commit or push changes
- Modify registry or PATH
- Install software automatically
- Expose secrets
- Execute arbitrary external commands
- Overwrite config without backup
- Perform destructive repairs without approval

### ALWAYS:
- Create checkpoint before repair
- Verify repair success
- Log to audit trail
- Provide rollback method
- Get approval for Level 2+

## Tools Available

| Tool | Purpose |
|------|---------|
| `diagnose` | Run system diagnostics |
| `propose_repair` | Propose repair without executing |
| `execute_repair` | Execute approved repair |
| `list_repairs` | View repair history |
| `create_checkpoint` | Save file state before changes |
| `restore_checkpoint` | Restore from checkpoint |

## Audit Trail

All operations logged to `.opencode/diagnostics/audit.jsonl`:
- timestamp
- diagnosis
- repair
- risk level
- approval status
- result
- verification

## Failure Behavior

If diagnostic system fails:
- Continue without diagnostics
- Report failure to user
- Do not block OpenCode operation
- Memory system remains available

## Example Flow

```
User: "Check if my environment is healthy"

1. diagnose(category="all")
   → Returns: 8 healthy, 1 warning

2. Warning: "Global memory not found"

3. propose_repair(check="global_memory", riskLevel=1)
   → Returns: repair-1234, auto-executable

4. execute_repair(repairId="repair-1234", approved=true)
   → Creates global.json

5. diagnose(category="memory")
   → Returns: All healthy

6. create_checkpoint(description="After memory repair")
   → Checkpoint saved
```
