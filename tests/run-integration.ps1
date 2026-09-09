# Integration test (section D) for the Shared Agent Infrastructure.
# Adds temporary artifacts to the REAL layer, syncs, verifies exposure,
# then removes everything and verifies via git that nothing else changed.
# Run: powershell -File ~\.agents\tests\run-integration.ps1
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$home_ = $env:USERPROFILE
$pass = 0; $failN = 0
function T([string]$name, [bool]$ok) {
    if ($ok) { $script:pass++; Write-Host "  PASS $name" }
    else { $script:failN++; Write-Host "  FAIL $name" }
}

$before = @(git -C $root status --porcelain)
try {
    Write-Host '== D. Integration test (temporary artifacts on real layer) =='

    # 1. temporary rule
    Set-Content (Join-Path $root 'rules\zzz-itest.md') -Value "# Zzz Integration Test`n`nTemporary rule for integration testing.`n"
    powershell -NoProfile -File (Join-Path $root 'sync-rules.ps1') | Out-Null
    T 'temp rule appears in Claude block' ((Select-String -LiteralPath "$home_\.claude\CLAUDE.md" -SimpleMatch '## zzz-itest' -Quiet))
    T 'temp rule appears in Codex block' ((Select-String -LiteralPath "$home_\.codex\AGENTS.md" -SimpleMatch '## zzz-itest' -Quiet))
    T 'temp rule appears in Qwen block' ((Select-String -LiteralPath "$home_\.qwen\QWEN.md" -SimpleMatch '## zzz-itest' -Quiet))

    # 2. temporary agent definition
    Set-Content (Join-Path $root 'agents\zzz-itester.md') -Value @"
---
name: zzz-itester
description: Temporary integration-test agent. Read-only.
read-only: true
outputs: findings
---

# Zzz ITester

## Purpose

Integration test only.

## Responsibilities

- Nothing.

## Allowed behavior

- Nothing.

## Forbidden behavior

- Everything.

## Tools / capabilities

None.

## Output expectations

None.
"@
    powershell -NoProfile -File (Join-Path $root 'sync-agents.ps1') | Out-Null
    T 'temp agent exposed to Claude' ((Test-Path "$home_\.claude\agents\zzz-itester.md"))
    T 'temp agent exposed to OpenCode' ((Test-Path "$home_\.config\opencode\agent\zzz-itester.md"))
    $zt = Get-Content "$home_\.config\opencode\agent\zzz-itester.md" -Raw
    T 'temp agent has subagent mode' ($zt.Contains('mode: subagent'))

    # 3. temporary MCP definition (no credentials)
    Set-Content (Join-Path $root 'mcp\servers\zzz-itest.md') -Value @'
# zzz-itest ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ MCP server definition

- **name:** zzz-itest
- **purpose:** integration test definition (not real)
- **enabled by default:** no
- **supported agents:** none
- **required environment variables:** `${ZZZ_ITEST_KEY}` (reference only)
- **security considerations:** test file, no real endpoint
'@
    $doc = powershell -NoProfile -File (Join-Path $root 'doctor.ps1')
    T 'doctor validates temp MCP definition' (($doc | Out-String).Contains('MCP definitions: 1'))

    # 4. promotion candidate
    Add-Content (Join-Path $root '.promote.md') -Value "`n## Candidate: zzz-itest`n`n- Date: 2026-09-10`n- Project: integration-test`n- Problem: test`n- Observation: test`n- Proposed improvement: test`n- Destination: rule`n- Status: candidate`n"
    T 'promotion candidate recorded' ((Get-Content (Join-Path $root '.promote.md') -Raw).Contains('## Candidate: zzz-itest'))

    # 5. doctor with everything in place
    $doc = powershell -NoProfile -File (Join-Path $root 'doctor.ps1')
    T 'doctor healthy with temp artifacts (exit 0)' ($LASTEXITCODE -eq 0)
    $null = powershell -NoProfile -File (Join-Path $root 'verify.ps1')
    T 'verify.ps1 still passes' ($LASTEXITCODE -eq 0)
}
finally {
    Write-Host "`n== D-cleanup =="
    # remove temp artifacts and re-sync
    Remove-Item (Join-Path $root 'rules\zzz-itest.md'), (Join-Path $root 'agents\zzz-itester.md'), (Join-Path $root 'mcp\servers\zzz-itest.md') -Force -ErrorAction SilentlyContinue
    $prPath = Join-Path $root '.promote.md'
    $pr = [IO.File]::ReadAllText($prPath, [Text.UTF8Encoding]::new($false))
    $pr = $pr -replace '(?s)\r?\n## Candidate: zzz-itest.*?(?=\r?\n## Candidate: |$)', ''
    $pr = $pr.TrimEnd() + "`n"
    foreach ($s in 'sync-rules.ps1','sync-agents.ps1','sync-adapters.ps1') {
        powershell -NoProfile -File (Join-Path $root $s) | Out-Null
    }
}

# post-cleanup verification
T 'temp rule removed from Claude block' (-not (Select-String -LiteralPath "$home_\.claude\CLAUDE.md" -SimpleMatch '## Zzz Integration Test' -Quiet))
T 'temp agent removed from Claude' (-not (Test-Path "$home_\.claude\agents\zzz-itester.md"))
T 'temp agent removed from OpenCode' (-not (Test-Path "$home_\.config\opencode\agent\zzz-itester.md"))
T 'temp MCP definition removed' (-not (Test-Path (Join-Path $root 'mcp\servers\zzz-itest.md')))
T 'promotion log restored' (-not ((Get-Content (Join-Path $root '.promote.md') -Raw).Contains('zzz-itest')))
$after = @(git -C $root status --porcelain)
T "no unrelated changes (git clean before=$($before.Count), after=$($after.Count))" ($after.Count -eq 0 -and $before.Count -eq 0)

Write-Host ''
if ($failN -eq 0) { Write-Host "INTEGRATION RESULT: ALL PASSED ($pass)"; exit 0 }
Write-Host "INTEGRATION RESULT: FAILURES ($failN of $($pass + $failN))"; exit 1
