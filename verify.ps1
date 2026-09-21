# Verify the shared skills layer. Exit code 0 = healthy.
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = Join-Path $env:USERPROFILE '.agents'
$shared = Join-Path $root 'skills'
$fail = 0
function Assert-True([bool]$cond, [string]$msg) {
    if ($cond) { Write-Host "  OK   $msg" }
    else { Write-Host "  FAIL $msg"; $script:fail++ }
}

Write-Host "== 1. Skills load (valid frontmatter) =="
$skills = @(Get-ChildItem $shared -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })
Assert-True ($skills.Count -gt 0) "canonical skills discovered ($($skills.Count))"
$names = @()
foreach ($s in $skills) {
    $md = Get-Content (Join-Path $s.FullName 'SKILL.md') -Raw
    $okName = $md -match '(?m)^name:\s*(\S+)'
    $name = if ($okName) { $Matches[1] } else { '' }
    # description: single-line text OR YAML folded (> / |) with indented continuation
    $folded = $md -match '(?m)^description:\s*(>+|\|+)\s*[\r\n]+(\s+\S)'
    $inline = $md -match '(?m)^description:\s*[^\s>|][^\r\n]+\r?$'
    $okDesc = $folded -or $inline
    Assert-True ($s.Name -eq $name) "frontmatter name matches folder: $($s.Name)"
    Assert-True ($okDesc) "description present: $($s.Name)"
    Assert-True ($md -notmatch '(?i)(api[_-]?key|password)\s*[:=]\s*\S') "no secrets: $($s.Name)"
    $names += $name
}

Write-Host "== 2. No duplicate/conflicting skills =="
$dups = $names | Group-Object | Where-Object Count -gt 1
Assert-True (-not $dups) "no duplicate skill names"
Assert-True (-not (Test-Path (Join-Path $shared 'skills'))) "no nested 'skills/skills' duplicate"

Write-Host "== 3. Adapters resolve =="
$pairs = @(
    @{ p = Join-Path $env:USERPROFILE '.config\opencode\skills' },
    @{ p = Join-Path $env:USERPROFILE '.claude\skills' }
)
foreach ($pair in $pairs) {
    $dir = $pair.p
    $item = Get-Item $dir -Force -ErrorAction SilentlyContinue
    Assert-True ($item -and $item.LinkType -eq 'Junction' -and (Test-Path $dir)) "junction resolves: $dir"
}
$codex = Join-Path $env:USERPROFILE '.codex\skills'
$codexJ = @(Get-ChildItem $codex -Force -ErrorAction SilentlyContinue |
    Where-Object { (Get-Item $_.FullName -Force).LinkType -eq 'Junction' })
$codexMissing = @($skills | Where-Object {
    $p = Join-Path $codex $_.Name
    if (-not (Test-Path $p)) { return $true }
    $i = Get-Item $p -Force
    -not ($i.LinkType -eq 'Junction' -and $i.Target -and [IO.Path]::GetFullPath(@($i.Target)[0]).TrimEnd('\').ToLowerInvariant() -eq [IO.Path]::GetFullPath($_.FullName).TrimEnd('\').ToLowerInvariant())
})
Assert-True ($codexMissing.Count -eq 0) "Codex exposes every canonical skill via correct junctions"
Assert-True (Test-Path (Join-Path $env:USERPROFILE '.qwen\QWEN.md')) "Qwen pointer artifact exists"
Assert-True (Test-Path (Join-Path $env:USERPROFILE '.claude\agents\cold-reviewer.md')) "Claude cold-reviewer agent"
Assert-True (Test-Path (Join-Path $env:USERPROFILE '.config\opencode\agent\cold-reviewer.md')) "OpenCode cold-reviewer agent"

Write-Host "== 4. Discovery spot-check (Cline dir = shared dir) =="
$required = 'continue','plan','implement','audit','research','test','review','checkpoint','verify','cold-review','context-management','task-delegation'
$missing = $required | Where-Object { $names -notcontains $_ }
Assert-True (-not $missing) "all 12 required skills present ($($required -join ', '))"

Write-Host ''
if ($fail -eq 0) { Write-Host 'LAYER HEALTHY' ; exit 0 }
Write-Host "LAYER UNHEALTHY: $fail failure(s)"; exit 1
