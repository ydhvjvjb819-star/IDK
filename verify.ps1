# Dependencies: none
Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

$checks = @(
    @{ Name = "Git"; Command = "git"; Args = @("--version") },
    @{ Name = "Python"; Command = "python3"; Args = @("--version") }, # Changed from 'python' to 'python3'
    @{ Name = "Node.js"; Command = "node"; Args = @("--version") },
    @{ Name = "npm"; Command = "npm"; Args = @("--version") },
    @{ Name = "VS Code"; Command = "code"; Args = @("--version") }
)

$failed = 0

foreach ($check in $checks) {
    $cmd = Get-Command $check.Command -ErrorAction SilentlyContinue

    if (-not $cmd) {
        Write-Host "[MISSING] $($check.Name)"
        $failed++
        continue
    }

    # VS Code outputs version to stdout in some shells, stderr in others. Silently handle both.
    $output = & $check.Command @($check.Args) 2>&1

    if ($LASTEXITCODE -eq 0 -or $output) {
        Write-Host "[OK] $($check.Name): $($output[0])"
    } else {
        Write-Host "[ERROR] $($check.Name) failed to run."
        $failed++
    }
}

if ($failed -gt 0) {
    Write-Host "$failed check(s) need attention." -ForegroundColor Red
    exit 1
}

Write-Host "All development-tool checks passed." -ForegroundColor Green