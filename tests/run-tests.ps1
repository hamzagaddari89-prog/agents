# Test suite for the Shared Agent Infrastructure (~\.agents).
# Run: powershell -File ~\.agents\tests\run-tests.ps1
# Sections: A unit, B cross-agent, C regression. Exit 0 = all passed.
# Integration (section D) lives in tests\run-integration.ps1.
[CmdletBinding()]
param()
$ErrorActionPreference = 'Continue'
$root = Split-Path $PSScriptRoot
$home_ = $env:USERPROFILE
$pass = 0; $failN = 0

function T([string]$name, [bool]$ok) {
    if ($ok) { $script:pass++; Write-Host "  PASS $name" }
    else { $script:failN++; Write-Host "  FAIL $name" }
}
function Section([string]$n) { Write-Host "`n== $n ==" }
function New-Sandbox {
    $s = Join-Path ([IO.Path]::GetTempPath()) ("agents-test-" + [guid]::NewGuid().ToString('N').Substring(0,8))
    New-Item -ItemType Directory -Path $s -Force | Out-Null
    return $s
}

Section('A1 Git')
T 'git repo exists' (Test-Path (Join-Path $root '.git'))
T 'no remote (local only)' (-not @(git -C $root remote))
T 'working tree clean' (-not @(git -C $root status --porcelain))

Section('A2 Skill discovery')
$skills = Get-ChildItem (Join-Path $root 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }
T '25 skills discovered' ($skills.Count -eq 25)
$skillNames = @()
foreach ($s in $skills) {
    $md = Get-Content (Join-Path $s.FullName 'SKILL.md') -Raw
    if ($md -match '(?m)^name:\s*(\S+)') { $skillNames += $Matches[1] }
}
T 'no duplicate skill names' (-not @($skillNames | Group-Object | Where-Object Count -gt 1))

Section('A3 Rule discovery')
$rules = Get-ChildItem (Join-Path $root 'rules') -Filter '*.md' -File
T '4 rules discovered' ($rules.Count -eq 4)
$rulesOk = $true
foreach ($r in $rules) { if ((Get-Content $r.FullName -Raw) -notmatch '(?m)^#\s+\S') { $rulesOk = $false } }
T 'all rules well-formed' $rulesOk

Section('A4 Rule generation (sandbox)')
$sbx = New-Sandbox
powershell -NoProfile -File (Join-Path $root 'sync-rules.ps1') -TargetHome $sbx | Out-Null
$ccMd = Get-Content (Join-Path $sbx '.claude\CLAUDE.md') -Raw
$missingRules = @($rules | ForEach-Object { if ($ccMd -notmatch "## $($_.BaseName)") { $_.BaseName } })
T 'Claude block contains all 4 rules' ($missingRules.Count -eq 0)
T 'block markers present' ($ccMd.Contains('shared-agents:rules:START') -and $ccMd.Contains('shared-agents:rules:END'))

Section('A5 Agent definition discovery')
$agents = Get-ChildItem (Join-Path $root 'agents') -Filter '*.md' -File
T '5 agent definitions' ($agents.Count -eq 5)
$agentsOk = $true
foreach ($a in $agents) {
    $t = Get-Content $a.FullName -Raw
    if (-not ($t -match '(?m)^read-only:\s*true\r?$' -and $t -match '(?m)^## Purpose\r?$')) { $agentsOk = $false }
}
T 'all definitions have required metadata' $agentsOk

Section('A6 MCP definition validation')
T 'TEMPLATE.md exists' (Test-Path (Join-Path $root 'mcp\servers\TEMPLATE.md'))
$mcp = Get-ChildItem (Join-Path $root 'mcp\servers') -Filter '*.md' | Where-Object Name -ne 'TEMPLATE.md'
$mcpOk = $true
foreach ($m in $mcp) {
    $t = Get-Content $m.FullName -Raw
    if (-not ($t -match '\*\*enabled by default:\*\*\s*no' -and $t -match '\*\*purpose:\*\*')) { $mcpOk = $false }
}
T "all $($mcp.Count) MCP definitions valid" $mcpOk

Section('A7 Promotion workflow')
$pr = Get-Content (Join-Path $root '.promote.md') -Raw
T '.promote.md exists with template' ($pr -match 'Destination:' -and $pr -match 'Status: candidate \| promoted \| rejected')
T 'no auto-mutation machinery referenced' (-not ($pr -match '(?i)bm25|embedding|vector|database'))

Section('A8 Secret scanning')
$hits = @()
foreach ($f in (Get-ChildItem $root -Recurse -File | Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Extension -ne '.ps1' })) {
    $t = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($t -match '(?i)(api[_-]?key|secret|password|token)\s*[:=]\s*["'']?[A-Za-z0-9_\-]{16,}') { $hits += $f.Name }
}
T 'no plaintext secrets' ($hits.Count -eq 0)

Section('A9 Junction validation')
$oc = Get-Item "$home_\.config\opencode\skills" -Force -ErrorAction SilentlyContinue
$cc = Get-Item "$home_\.claude\skills" -Force -ErrorAction SilentlyContinue
T 'OpenCode junction -> shared skills' ($oc.LinkType -eq 'Junction' -and (Test-Path $oc.Target[0]))
T 'Claude junction -> shared skills' ($cc.LinkType -eq 'Junction' -and (Test-Path $cc.Target[0]))
$codexJ = @(Get-ChildItem "$home_\.codex\skills" -Force -ErrorAction SilentlyContinue | Where-Object { (Get-Item $_.FullName -Force).LinkType -eq 'Junction' })
T "Codex per-skill junctions >= skills ($($codexJ.Count))" ($codexJ.Count -ge $skills.Count)

Section('A10 Adapter generation (sandbox)')
powershell -NoProfile -File (Join-Path $root 'sync-adapters.ps1') -TargetHome $sbx | Out-Null
powershell -NoProfile -File (Join-Path $root 'sync-agents.ps1') -TargetHome $sbx | Out-Null
T 'sandbox Claude agents generated' (@(Get-ChildItem "$sbx\.claude\agents" -Filter '*.md').Count -eq 5)
T 'sandbox OpenCode agents generated' (@(Get-ChildItem "$sbx\.config\opencode\agent" -Filter '*.md').Count -eq 5)
T 'sandbox Qwen pointer created' ((Get-Content "$sbx\.qwen\QWEN.md" -Raw).Contains('Shared skills pointer'))

Section('A11 Idempotency (sandbox second runs)')
$idem = $true
foreach ($s in 'sync-adapters.ps1','sync-rules.ps1','sync-agents.ps1') {
    $out2 = (powershell -NoProfile -File (Join-Path $root $s) -TargetHome $sbx) | Out-String
    if ($out2 -match '^(created|written|appended|updated)\s') { $idem = $false }
}
T 'all three syncs no-op on second run' $idem
Remove-Item $sbx -Recurse -Force -ErrorAction SilentlyContinue

Section('B Cross-agent visibility (real layer)')
T 'Cline: sees 25 shared skills natively' ($skills.Count -eq 25)
$ocVisible = @(Get-ChildItem "$home_\.config\opencode\skills" -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }).Count
T "OpenCode: $ocVisible skills visible through junction" ($ocVisible -eq 25)
$ccVisible = @(Get-ChildItem "$home_\.claude\skills" -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }).Count
T "Claude: $ccVisible skills visible through junction" ($ccVisible -eq 25)
$cxVisible = 0
foreach ($s in $skills) {
    $p = "$home_\.codex\skills\$($s.Name)"
    if ((Test-Path "$p\SKILL.md") -and (Get-Item $p -Force).LinkType -eq 'Junction') { $cxVisible++ }
}
T "Codex: $cxVisible shared skills via per-skill junctions" ($cxVisible -eq 25)
T 'Codex: system-owned .system intact' (Test-Path "$home_\.codex\skills\.system")
$qw = Get-Content "$home_\.qwen\QWEN.md" -Raw
T 'Qwen: skills pointer present' ($qw.Contains('Shared skills pointer'))
T 'Qwen: memory convention present' ($qw.Contains('.agent/CHECKPOINT.md'))
T 'Claude: rules block present' ((Select-String -LiteralPath "$home_\.claude\CLAUDE.md" -SimpleMatch 'shared-agents:rules:START' -Quiet))
T 'Codex: rules block present' ((Select-String -LiteralPath "$home_\.codex\AGENTS.md" -SimpleMatch 'shared-agents:rules:START' -Quiet))
T 'OpenCode: rules block present' ((Select-String -LiteralPath "$home_\.config\opencode\AGENTS.md" -SimpleMatch 'shared-agents:rules:START' -Quiet))
T 'Qwen: rules block present' (Select-String -LiteralPath "$home_\.qwen\QWEN.md" -SimpleMatch 'shared-agents:rules:START' -Quiet)
T 'Claude: >= 5 generated agents present' (@(Get-ChildItem "$home_\.claude\agents" -Filter '*.md').Count -ge 5)
T 'OpenCode: >= 5 subagent-mode agents present' (@(Get-ChildItem "$home_\.config\opencode\agent" -Filter '*.md').Count -ge 5)
T 'all non-hand-placed Claude agents carry generator marker' (-not @(Get-ChildItem "$home_\.claude\agents" -Filter '*.md' | Where-Object { $_.Name -ne 'cold-reviewer.md' -and -not (Select-String -LiteralPath $_.FullName -SimpleMatch 'GENERATED by' -Quiet) }).Count)

Section('C Regression (previously working behavior)')
$required = 'continue','plan','implement','audit','research','test','review','checkpoint','verify','cold-review','context-management','task-delegation'
T 'all 12 workflow skills present' (@($required | Where-Object { $skillNames -notcontains $_ }).Count -eq 0)
$preexisting = @($skillNames | Where-Object { $_ -in 'se-workflow','project-status','self-repair','research-methodology','ponytail','ai-priming','developing-with-streamlit' })
T "pre-existing skills intact ($($preexisting.Count))" ($preexisting.Count -eq 7)
$null = powershell -NoProfile -File (Join-Path $root 'verify.ps1')
T 'verify.ps1 passes' ($LASTEXITCODE -eq 0)
$cp = Get-Content (Join-Path $root 'skills\checkpoint\SKILL.md') -Raw
T 'checkpoint convention documented' ($cp.Contains('.agent/CHECKPOINT.md') -and $cp.Contains('.agent/DECISIONS.md'))
$cont = Get-Content (Join-Path $root 'skills\continue\SKILL.md') -Raw
T 'continue skill reads project memory' ($cont.Contains('CHECKPOINT.md') -and $cont.Contains('git status'))
$td = Get-Content (Join-Path $root 'skills\task-delegation\SKILL.md') -Raw
T 'sub-agent policy unchanged (native-only)' ($td -match 'native sub-agents' -and $td -match 'not imitate')
$sd = Get-Content (Join-Path $root 'skills\systematic-debugging\SKILL.md') -Raw
T 'systematic-debugging skill covers the methodology' ($sd -match 'symptom' -and $sd -match 'reproduc' -and $sd -match 'hypothes' -and $sd -match 'root cause')
$tm = Get-Content (Join-Path $root 'rules\testing.md') -Raw
T 'debugging gates present; V2 #1 wording intact' ($tm -match 'systematic-debugging' -and $tm -match 'Verification before completion' -and $tm -match 'Never mask a symptom')
$tst = Get-Content (Join-Path $root 'skills\test\SKILL.md') -Raw
T 'TDD loop in testing rules (intended failure, REFACTOR, escape hatch)' ($tm -match 'fails for the intended reason' -and $tm -match 'REFACTOR' -and $tm -match 'docs-only')
T 'test skill documents test-first (RED) mode with intended-failure check' ($tst -match 'test-first' -and $tst -match 'fails for the intended reason')
$snap = @(git -C $root status --porcelain)
powershell -NoProfile -File (Join-Path $root 'sync-adapters.ps1') | Out-Null
T 'sync-adapters.ps1 idempotent on real layer' (-not $snap -and -not @(git -C $root status --porcelain))
T 'cold-reviewer agents present (both runtimes)' ((Test-Path "$home_\.claude\agents\cold-reviewer.md") -and (Test-Path "$home_\.config\opencode\agent\cold-reviewer.md"))

Write-Host ''
if ($failN -eq 0) { Write-Host "TEST RESULT: ALL PASSED ($pass)"; exit 0 }
Write-Host "TEST RESULT: FAILURES ($failN of $($pass + $failN))"; exit 1
