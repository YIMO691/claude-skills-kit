<#
.SYNOPSIS
  One-liner remote installer for Claude Skills Kit.
  Downloads the kit from GitHub and installs to a target project.

.DESCRIPTION
  Usage: irm https://raw.githubusercontent.com/YIMO691/claude-skills-kit/main/scripts/install-remote.ps1 | iex
  Or:    irm .../install-remote.ps1 | iex -Ref v0.2.0
  Or:    .\install-remote.ps1 -Target "F:\MyProject" -Ref v0.2.0

  Downloads the latest kit from GitHub main branch, runs the installer, and cleans up.
#>

param(
    [string]$Target = (Get-Location).Path,
    [ValidateSet("core", "unity", "auto")]
    [string]$Profile = "auto",
    [switch]$Force,
    [switch]$IncludeDocs,
    [string]$Branch = "main",
    [string]$Ref = ""
)

$ErrorActionPreference = "Stop"
if ($Ref) {
    if ($Ref.StartsWith("v")) {
        $repoUrl = "https://github.com/YIMO691/claude-skills-kit/archive/refs/tags/$Ref.zip"
    } else {
        $repoUrl = "https://github.com/YIMO691/claude-skills-kit/archive/refs/heads/$Ref.zip"
    }
} else {
    $repoUrl = "https://github.com/YIMO691/claude-skills-kit/archive/refs/heads/$Branch.zip"
}
$tempDir = Join-Path $env:TEMP "claude-skills-kit-$([Guid]::NewGuid().ToString('N').Substring(0,8))"

try {
    $label = if ($Ref) { $Ref } else { $Branch }
    Write-Host "Downloading Claude Skills Kit ($label)..."
    $zipPath = Join-Path $env:TEMP "claude-skills-kit.zip"

    # Use Invoke-WebRequest as primary; fall back to curl
    try {
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath -ErrorAction Stop
    } catch {
        Write-Host "WebRequest failed, trying curl..."
        curl.exe -L -o $zipPath $repoUrl
    }

    Write-Host "Extracting..."
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force

    # The zip contains a folder like "claude-skills-kit-main"
    $extracted = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
    $installScript = Join-Path $extracted.FullName "scripts\install-claude-kit.ps1"

    $powershellCommand = Get-Command pwsh -ErrorAction SilentlyContinue
    if (-not $powershellCommand) {
        $powershellCommand = Get-Command powershell.exe -ErrorAction Stop
    }

    $installerArgs = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $installScript,
        "-Target", $Target
    )

    if ($Profile -eq "auto") {
        $installerArgs += "-AutoProfile"
    } else {
        $installerArgs += @("-Profile", $Profile)
    }

    if ($Force) { $installerArgs += "-Force" }
    if ($IncludeDocs) { $installerArgs += "-IncludeDocs" }

    Write-Host "Running: $($powershellCommand.Source) $($installerArgs -join ' ')"
    & $powershellCommand.Source @installerArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Installer failed with exit code $LASTEXITCODE"
    }

    Write-Host "Install complete."
} finally {
    if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue }
    if (Test-Path (Join-Path $env:TEMP "claude-skills-kit.zip")) { Remove-Item -Force (Join-Path $env:TEMP "claude-skills-kit.zip") -ErrorAction SilentlyContinue }
}
