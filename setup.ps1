# Dependencies: none

[CmdletBinding()]
param(
    [switch]$InstallTools
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-Command {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    return $null -ne (
        Get-Command $Name -ErrorAction SilentlyContinue
    )
}

Write-Host "Windows development environment setup"
Write-Host "Computer: $env:COMPUTERNAME"
Write-Host "PowerShell: $($PSVersionTable.PSVersion)"

$tools = @(
    "git",
    "python",
    "node",
    "npm",
    "code"
)

foreach ($tool in $tools) {
    $present = Test-Command -Name $tool

    if ($present) {
        Write-Host "[OK] $tool available"
    }
    else {
        Write-Host "[MISSING] $tool"
    }
}

if (-not $InstallTools) {
    Write-Host ""
    Write-Host "No software was installed."
    Write-Host "Use -InstallTools to attempt installation."
    exit 0
}

if (-not (Test-Command -Name "winget")) {
    throw "winget is not available."
}

$packages = @(
    "Git.Git",
    "Python.Python.3.12",
    "OpenJS.NodeJS.LTS"
)

foreach ($package in $packages) {

    Write-Host "Installing $package..."

    & winget install `
        --id $package `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Installation failed: $package"
    }
}

Write-Host "Setup attempt complete."
Write-Host "Open a new terminal and run verify.ps1."