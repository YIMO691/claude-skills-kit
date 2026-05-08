param(
    [string]$Target = (Get-Location).Path,

    [ValidateSet("core", "unity")]
    [string]$Profile = "core",

    [switch]$AutoProfile,

    [switch]$Force,

    [switch]$IncludeDocs,

    [switch]$DryRun,

    [switch]$Backup
)

$ErrorActionPreference = "Stop"

# Auto-detect profile: scan target for Unity project markers
$targetRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)

if ($Backup) {
    $backupTimestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupRoot = Join-Path $targetRoot ".claude-kit-backup\$backupTimestamp"
}

if ($AutoProfile) {
    $hasAssets = Test-Path (Join-Path $targetRoot "Assets") -PathType Container
    $hasManifest = Test-Path (Join-Path $targetRoot "Packages\manifest.json") -PathType Leaf
    if ($hasAssets -and $hasManifest) {
        $Profile = "unity"
        Write-Host "Auto-detected profile: unity"
    } else {
        $Profile = "core"
        Write-Host "Auto-detected profile: core"
    }
}

$sourceRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

if (-not (Test-Path -LiteralPath $targetRoot)) {
    New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
}

function Copy-KitItem {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$DestinationRelativePath,
        [switch]$DryRun
    )

    $src = Join-Path $sourceRoot $RelativePath
    $dst = Join-Path $targetRoot $DestinationRelativePath

    if (-not (Test-Path -LiteralPath $src)) {
        throw "Missing source item: $src"
    }

    # Dry-run: report without copying
    if ($DryRun) {
        if ((Test-Path -LiteralPath $dst) -and -not $Force) {
            Write-Host "[DryRun] would skip: $DestinationRelativePath"
            $script:dryRunWouldSkip++
        } else {
            Write-Host "[DryRun] would copy: $DestinationRelativePath"
            $script:dryRunWouldCopy++
        }
        return
    }

    if ((Test-Path -LiteralPath $dst) -and -not $Force) {
        Write-Host "skip existing: $DestinationRelativePath"
        return
    }

    $parent = Split-Path -Parent $dst
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    # Backup existing file before overwriting
    if ($Backup -and (Test-Path -LiteralPath $dst)) {
        $backupDstDir = Join-Path $backupRoot (Split-Path -Parent $DestinationRelativePath)
        if (-not (Test-Path -LiteralPath $backupDstDir)) {
            New-Item -ItemType Directory -Force -Path $backupDstDir | Out-Null
        }
        Copy-Item -LiteralPath $dst -Destination (Join-Path $backupRoot $DestinationRelativePath) -Force
        Write-Host "backed up: $DestinationRelativePath"
    }

    Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force:$Force
    Write-Host "copied: $DestinationRelativePath"
}

function Add-DirectoryItems {
    param(
        [Parameter(Mandatory = $true)][string]$RelativeRoot,
        [string[]]$ExcludeNames = @()
    )

    $root = Join-Path $sourceRoot $RelativeRoot
    if (-not (Test-Path -LiteralPath $root)) {
        return @()
    }

    Get-ChildItem -LiteralPath $root -Directory |
        Where-Object { $ExcludeNames -notcontains $_.Name } |
        ForEach-Object {
            $relative = Join-Path $RelativeRoot $_.Name
            @{ Source = $relative; Dest = $relative }
        }
}

function Add-FileItems {
    param(
        [Parameter(Mandatory = $true)][string]$RelativeRoot,
        [string[]]$ExcludeNames = @(),
        [string[]]$ExcludePatterns = @("*.local.json.example")
    )

    $root = Join-Path $sourceRoot $RelativeRoot
    if (-not (Test-Path -LiteralPath $root)) {
        return @()
    }

    Get-ChildItem -LiteralPath $root -File |
        Where-Object { $ExcludeNames -notcontains $_.Name } |
        Where-Object {
            $keep = $true
            foreach ($pat in $ExcludePatterns) {
                if ($_.Name -like $pat) { $keep = $false; break }
            }
            $keep
        } |
        ForEach-Object {
            $relative = Join-Path $RelativeRoot $_.Name
            @{ Source = $relative; Dest = $relative }
        }
}

$rootItems = @(
    @{ Source = "CLAUDE.md"; Dest = "CLAUDE.md" },
    @{ Source = "AGENTS.md"; Dest = "AGENTS.md" },
    @{ Source = "VERSION"; Dest = ".claude-kit-version" }
)

$items = @()
$items += $rootItems
$items += @{ Source = ".claude\settings.json"; Dest = ".claude\settings.json" }
$items += Add-FileItems -RelativeRoot ".claude\agents"
$items += Add-FileItems -RelativeRoot ".claude\commands"

$ruleExclusions = @()
$skillExclusions = @()
if ($Profile -eq "core") {
    $ruleExclusions += "unity-csharp.md"
    $skillExclusions += "unity6-project"
    $skillExclusions += "claude-config-maintainer"
}

$items += Add-FileItems -RelativeRoot ".claude\rules" -ExcludeNames $ruleExclusions
$items += Add-DirectoryItems -RelativeRoot ".claude\skills" -ExcludeNames $skillExclusions

if ($IncludeDocs) {
    $items += @{ Source = "docs\templates"; Dest = "docs\templates" }
    $items += @{ Source = "docs\reference"; Dest = "docs\reference" }
}

$script:dryRunWouldCopy = 0
$script:dryRunWouldSkip = 0

foreach ($item in $items) {
    Copy-KitItem -RelativePath $item.Source -DestinationRelativePath $item.Dest -DryRun:$DryRun
}

if ($DryRun) {
    Write-Host "[DryRun] Summary: $dryRunWouldCopy would copy, $dryRunWouldSkip would skip, $($items.Count) total items"
}

Write-Host "Done. Target: $targetRoot Profile: $Profile"
