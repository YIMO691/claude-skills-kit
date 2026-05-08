param(
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [ValidateSet("core", "unity")]
    [string]$Profile = "core",

    [switch]$Force,

    [switch]$IncludeDocs
)

$ErrorActionPreference = "Stop"

$sourceRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$targetRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)

if (-not (Test-Path -LiteralPath $targetRoot)) {
    New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
}

function Copy-KitItem {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$DestinationRelativePath
    )

    $src = Join-Path $sourceRoot $RelativePath
    $dst = Join-Path $targetRoot $DestinationRelativePath

    if (-not (Test-Path -LiteralPath $src)) {
        throw "Missing source item: $src"
    }

    if ((Test-Path -LiteralPath $dst) -and -not $Force) {
        Write-Host "skip existing: $DestinationRelativePath"
        return
    }

    $parent = Split-Path -Parent $dst
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
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
        [string[]]$ExcludeNames = @()
    )

    $root = Join-Path $sourceRoot $RelativeRoot
    if (-not (Test-Path -LiteralPath $root)) {
        return @()
    }

    Get-ChildItem -LiteralPath $root -File |
        Where-Object { $ExcludeNames -notcontains $_.Name } |
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
}

$items += Add-FileItems -RelativeRoot ".claude\rules" -ExcludeNames $ruleExclusions
$items += Add-DirectoryItems -RelativeRoot ".claude\skills" -ExcludeNames $skillExclusions

if ($IncludeDocs) {
    $items += @{ Source = "docs\templates"; Dest = "docs\templates" }
    $items += @{ Source = "docs\reference"; Dest = "docs\reference" }
}

foreach ($item in $items) {
    Copy-KitItem -RelativePath $item.Source -DestinationRelativePath $item.Dest
}

Write-Host "Done. Target: $targetRoot Profile: $Profile"
