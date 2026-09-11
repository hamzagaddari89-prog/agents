# SHARED AGENTS DOCTOR - diagnostics for the Shared Agent Infrastructure at ~\.agents.
# Read-only except for a temporary sandbox used by the Idempotency check.
# Exit code 0 = HEALTHY, 1 = failures found.
[CmdletBinding()]
param()
$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$home_ = $env:USERPROFILE
$fail = 0
$warn = 0

function Report {
    # Accepts Report('FAIL', 'msg') style; PowerShell passes ('FAIL','msg')
    # as a single array argument, so normalize both call shapes.
    $status = $args[0]
    $msg = $args[1]
    if ($status -is [array]) { $msg = $status[1]; $status = $status[0] }
    Write-Host ("[{0,-5}] {1}" -f $status, $msg)
    if ($status -eq 'FAIL') { $script:fail++ }
    if ($status -eq 'WARN') { $script:warn++ }
}
function Section([string]$name) { Write-Host "`n-- $name" }

Write-Host "SHARED AGENTS DOCTOR"
Write-Host "===================="

Section('Core')
Report('PASS', "layer exists: $root")
if (-not (Test-Path (Join-Path $root '.git'))) { Report('FAIL', 'git repository missing in ~/.agents') }
else {
    $dirty = @(git -C $root status --porcelain)
    if ($dirty.Count) { Report('WARN', "git working tree dirty ($($dirty.Count) change(s)) - commit for auditability") }
    else { Report('PASS', 'git working tree clean') }
    $remote = @(git -C $root remote)
    if ($remote.Count) { Report('PASS', "remote configured: $($remote -join ', ')") }
    else { Report('PASS', 'no remote (local only)') }
}
foreach ($d in 'skills', 'rules', 'agents', 'mcp\servers') {
    if (Test-Path (Join-Path $root $d)) { Report('PASS', "directory: $d") } else { Report('FAIL', "missing directory: $d") }
}

Section('Skills')
$skills = Get-ChildItem (Join-Path $root 'skills') -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }
$badSkills = @()
$names = @()
foreach ($s in $skills) {
    $md = Get-Content (Join-Path $s.FullName 'SKILL.md') -Raw
    $nm = if ($md -match '(?m)^name:\s*(\S+)') { $Matches[1] } else { '' }
    $names += $nm
    if ($s.Name -ne $nm -or -not ($md -match '(?m)^description:\s*\S')) { $badSkills += $s.Name }
}
$dups = @($names | Group-Object | Where-Object Count -gt 1)
if ($badSkills.Count -eq 0 -and $dups.Count -eq 0) { Report('PASS', "skills: $($skills.Count), all valid, no duplicates") }
else { Report('FAIL', "invalid skills: $($badSkills -join ', '); duplicates: $(@($dups | % Name) -join ', ')") }

Section('Rules')
$rules = Get-ChildItem (Join-Path $root 'rules') -Filter '*.md' -File -ErrorAction SilentlyContinue
$badRules = @()
foreach ($r in $rules) {
    $t = Get-Content $r.FullName -Raw
    if (-not $t -or $t -notmatch '(?m)^#\s+\S') { $badRules += $r.Name }
}
if ($badRules.Count -eq 0) { Report('PASS', "rules: $($rules.Count), all well-formed") }
else { Report('FAIL', "malformed rules: $($badRules -join ', ')") }

Section('Agents')
$agents = Get-ChildItem (Join-Path $root 'agents') -Filter '*.md' -File -ErrorAction SilentlyContinue
$badAgents = @()
foreach ($a in $agents) {
    $t = Get-Content $a.FullName -Raw
    $ok = $t -match '(?m)^## Purpose\r?$' -and $t -match '(?m)^## Forbidden behavior\r?$' -and
          $t -match '(?m)^## Output expectations\r?$' -and $t -match '(?m)^read-only:\s*true\r?$'
    if (-not $ok) { $badAgents += $a.Name }
}
if ($badAgents.Count -eq 0) { Report('PASS', "agent definitions: $($agents.Count), all valid") }
else { Report('FAIL', "invalid agent definitions: $($badAgents -join ', ')") }

Section('MCP definitions')
$mcp = Get-ChildItem (Join-Path $root 'mcp\servers') -Filter '*.md' -File |
    Where-Object Name -ne 'TEMPLATE.md'
$badMcp = @()
foreach ($m in $mcp) {
    $t = Get-Content $m.FullName -Raw
    $ok = $t -match '\*\*name:\*\*' -and $t -match '\*\*purpose:\*\*' -and
          $t -match '\*\*security considerations:\*\*' -and $t -match '\*\*enabled by default:\*\*\s*no'
    if (-not $ok) { $badMcp += $m.Name }
}
if ($badMcp.Count -eq 0) { Report('PASS', "MCP definitions: $($mcp.Count), all valid") }
else { Report('FAIL', "invalid MCP definitions: $($badMcp -join ', ')") }

Section('Adapters')
if (Test-Path (Join-Path $root 'skills')) { Report('PASS', 'Cline: reads ~\.agents\skills natively') }
if ((Get-Item "$home_\.config\opencode\skills" -Force -ErrorAction SilentlyContinue).LinkType -eq 'Junction') { Report('PASS', 'OpenCode skills junction') } else { Report('FAIL', 'OpenCode skills junction missing') }
if ((Get-Item "$home_\.claude\skills" -Force -ErrorAction SilentlyContinue).LinkType -eq 'Junction') { Report('PASS', 'Claude skills junction') } else { Report('FAIL', 'Claude skills junction missing') }
$codexJ = @(Get-ChildItem "$home_\.codex\skills" -Force -ErrorAction SilentlyContinue |
    Where-Object { (Get-Item $_.FullName -Force).LinkType -eq 'Junction' }).Count
if ($codexJ -ge $skills.Count) { Report('PASS', "Codex per-skill junctions: $codexJ") } else { Report('FAIL', "Codex per-skill junctions: $codexJ < $($skills.Count)") }
if (Test-Path "$home_\.qwen\QWEN.md") { Report('PASS', 'Qwen pointer artifact') } else { Report('FAIL', 'Qwen pointer missing') }
if ((Test-Path "$home_\.claude\CLAUDE.md") -and (Select-String -LiteralPath "$home_\.claude\CLAUDE.md" -SimpleMatch 'shared-agents:rules:START' -Quiet)) { Report('PASS', 'Claude rules block') } else { Report('FAIL', 'Claude rules block missing (run sync-rules.ps1)') }
if ((Test-Path "$home_\.codex\AGENTS.md") -and (Select-String -LiteralPath "$home_\.codex\AGENTS.md" -SimpleMatch 'shared-agents:rules:START' -Quiet)) { Report('PASS', 'Codex rules block') } else { Report('FAIL', 'Codex rules block missing (run sync-rules.ps1)') }
if ((Test-Path "$home_\.config\opencode\AGENTS.md") -and (Select-String -LiteralPath "$home_\.config\opencode\AGENTS.md" -SimpleMatch 'shared-agents:rules:START' -Quiet)) { Report('PASS', 'OpenCode rules block') } else { Report('FAIL', 'OpenCode rules block missing (run sync-rules.ps1)') }
if ((Test-Path "$home_\.qwen\QWEN.md") -and (Select-String -LiteralPath "$home_\.qwen\QWEN.md" -SimpleMatch 'shared-agents:rules:START' -Quiet)) { Report('PASS', 'Qwen rules block') } else { Report('FAIL', 'Qwen rules block missing (run sync-rules.ps1)') }
Section('Generated-layer drift (deployed blocks vs source)')
# Compare each deployed generated rules block against the block the current
# source rules produce (same construction as sync-rules.ps1 Build-Block).
# Detection only - the remedy is running sync-rules.ps1.
$driftStart = '<!-- shared-agents:rules:START (generated by sync-rules.ps1 - do not edit inside) -->'
$driftEnd   = '<!-- shared-agents:rules:END -->'
$driftParts = foreach ($rf in (Get-ChildItem (Join-Path $root 'rules') -Filter '*.md' -File | Sort-Object Name)) {
    "## $($rf.BaseName)`n"
    (Get-Content $rf.FullName -Raw).TrimEnd()
    ""
}
$driftBody = ($driftParts -join "`n").TrimEnd()
$driftBlock = "$driftStart`n$driftBody`n$driftEnd"
foreach ($dt in @(
    @{ n = 'Cline';    p = Join-Path $root 'AGENTS.md' },
    @{ n = 'Claude';   p = "$home_\.claude\CLAUDE.md" },
    @{ n = 'Codex';    p = "$home_\.codex\AGENTS.md" },
    @{ n = 'OpenCode'; p = "$home_\.config\opencode\AGENTS.md" },
    @{ n = 'Qwen';     p = "$home_\.qwen\QWEN.md" }
)) {
    $dep = $null
    if (Test-Path $dt.p) {
        $depRaw = Get-Content $dt.p -Raw
        $bi = $depRaw.IndexOf($driftStart); $ei = $depRaw.IndexOf($driftEnd)
        if ($bi -ge 0 -and $ei -ge 0) { $dep = $depRaw.Substring($bi, $ei + $driftEnd.Length - $bi) }
    }
    if ($null -eq $dep) { Report('FAIL', "$($dt.n): rules block missing (run sync-rules.ps1)") }
    elseif ($dep -ne $driftBlock) { Report('FAIL', "$($dt.n): rules block DRIFTED from source (run sync-rules.ps1)") }
    else { Report('PASS', "$($dt.n): rules block matches source") }
}

Section('Junctions')
foreach ($j in "$home_\.config\opencode\skills", "$home_\.claude\skills") {
    $item = Get-Item $j -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq 'Junction' -and (Test-Path $item.Target[0])) { Report('PASS', "junction resolves: $j") }
    else { Report('FAIL', "broken/wrong junction: $j") }
}
$stale = @(Get-ChildItem "$home_\.codex\skills" -Force -ErrorAction SilentlyContinue |
    Where-Object { $i = Get-Item $_.FullName -Force; $i.LinkType -eq 'Junction' -and $i.Target[0] -like "$root\skills\*" -and -not (Test-Path (Join-Path $root "skills\$($_.Name)\SKILL.md")) })
if ($stale.Count -eq 0) { Report('PASS', 'no stale Codex junctions') }
else { Report('WARN', "stale Codex junctions (run sync-adapters.ps1): $(@($stale | % Name) -join ', ')") }

Section('Safety (secret scan)')
$secretHits = @()
foreach ($f in (Get-ChildItem $root -Recurse -File |
        Where-Object { $_.FullName -notmatch '\\.git\\' -and $_.Extension -ne '.ps1' })) {
    $t = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($t -match '(?i)(api[_-]?key|secret|password|token)\s*[:=]\s*["'']?[A-Za-z0-9_\-]{16,}') {
        $secretHits += $f.FullName.Substring($root.Length + 1)
    }
}
if ($secretHits.Count -eq 0) { Report('PASS', 'no plaintext secrets detected') }
else { Report('FAIL', "possible secrets: $($secretHits -join ', ')") }

Section('Idempotency (sandbox: sync twice, second run must be a no-op)')
$sbx = Join-Path ([IO.Path]::GetTempPath()) ("agents-doctor-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $sbx -Force | Out-Null
$ops2 = ''
$opsFail = ''
try {
    foreach ($s in 'sync-adapters.ps1', 'sync-rules.ps1', 'sync-agents.ps1') {
        $rc1 = 1; $rc2 = 1
        powershell -NoProfile -File (Join-Path $root $s) -TargetHome $sbx | Out-Null
        $rc1 = $LASTEXITCODE
        $out2 = (powershell -NoProfile -File (Join-Path $root $s) -TargetHome $sbx) | Out-String
        $rc2 = $LASTEXITCODE
        # A crashed sync must fail the check too - idempotency of a script
        # that exits non-zero is meaningless.
        if ($rc1 -ne 0 -or $rc2 -ne 0) { $opsFail += "$s " }
        elseif ($out2 -match '^(created|written|appended|updated)\s') { $ops2 += "$s " }
    }
} finally { Remove-Item $sbx -Recurse -Force -ErrorAction SilentlyContinue }
if ($opsFail) { Report('FAIL', "sync failed in sandbox (non-zero exit): $opsFail") }
if ($ops2) { Report('FAIL', "not idempotent: $ops2") }
if (-not $opsFail -and -not $ops2) { Report('PASS', 'all syncs idempotent (sandbox)') }

Write-Host ''
if ($fail -gt 0) { Write-Host "RESULT: FAIL ($fail failure(s), $warn warning(s))"; exit 1 }
if ($warn -gt 0) { Write-Host "RESULT: WARNING ($warn warning(s), no failures)"; exit 0 }
Write-Host 'RESULT: HEALTHY'

