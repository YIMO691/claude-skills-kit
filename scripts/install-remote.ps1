<#
.SYNOPSIS
  One-liner remote installer for Claude Skills Kit.
  Downloads the kit from GitHub and installs to a target project.

.DESCRIPTION
  Usage: irm https://raw.githubusercontent.com/YIMO691/claude-skills-kit/main/scripts/install-remote.ps1 | iex
  Or:    .\install-remote.ps1 -Target "F:\MyProject"

  Downloads the latest kit from GitHub main branch, runs the installer, and cleans up.
#>

param(
    [string]$Target = (Get-Location).Path,
    [ValidateSet("core", "unity", "auto")]
    [string]$Profile = "auto",
    [switch]$Force,
    [switch]$IncludeDocs,
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$repoUrl = "https://github.com/YIMO691/claude-skills-kit/archive/refs/heads/$Branch.zip"
$tempDir = Join-Path $env:TEMP "claude-skills-kit-$([Guid]::NewGuid().ToString('N').Substring(0,8))"

try {
    Write-Host "Downloading Claude Skills Kit ($Branch)..."
    $zipPath = Join-Path $env:TEMP "claude-skills-kit.zip"

    # Use Invoke-WebRequest as primary; fall back to curl
    try {
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath -ErrorAction Stop
    } catch {
        Write-Host "WebRequest failed, trying curl..."
        curl -L -o $zipPath $repoUrl
    }

    Write-Host "Extracting..."
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force

    # The zip contains a folder like "claude-skills-kit-main"
    $extracted = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
    $installScript = Join-Path $extracted.FullName "scripts\install-claude-kit.ps1"

    $profileArg = if ($Profile -eq "auto") { "-AutoProfile" } else { "-Profile $Profile" }
    $forceArg = if ($Force) { "-Force" } else { "" }
    $docsArg = if ($IncludeDocs) { "-IncludeDocs" } else { "" }

    $cmd = "powershell -ExecutionPolicy Bypass -File `"$installScript`" -Target `"$Target`" $profileArg $forceArg $docsArg"
    Write-Host "Running: $cmd"
    Invoke-Expression $cmd

    Write-Host "Install complete."
} finally {
    if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue }
    if (Test-Path (Join-Path $env:TEMP "claude-skills-kit.zip")) { Remove-Item -Force (Join-Path $env:TEMP "claude-skills-kit.zip") -ErrorAction SilentlyContinue }
}
