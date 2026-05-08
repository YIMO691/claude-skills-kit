param(
    [ValidateSet("auto", "core", "unity", "kit")]
    [string]$Profile = "auto",

    [switch]$FixManifest
)

$ErrorActionPreference = "Stop"

$scriptRoot = $PSScriptRoot
$repoRoot = Resolve-Path (Join-Path $scriptRoot "..")

$allPassed = $true

if ($Profile -eq "auto") {
    if (Test-Path -LiteralPath (Join-Path $repoRoot "docs\reference\install-manifest.md")) {
        $Profile = "kit"
    } elseif (
        (Test-Path -LiteralPath (Join-Path $repoRoot ".claude\rules\unity-csharp.md")) -or
        (Test-Path -LiteralPath (Join-Path $repoRoot ".claude\skills\unity6-project"))
    ) {
        $Profile = "unity"
    } else {
        $Profile = "core"
    }
}

Write-Host "Validation profile: $Profile"

function Write-Pass {
    param([string]$Message)
    Write-Host "PASS: $Message"
}

function Write-Fail {
    param([string]$Message)
    Write-Host "FAIL: $Message"
    $script:allPassed = $false
}

function Write-Warn {
    param([string]$Message)
    Write-Host "WARN: $Message"
}

# ============================================================
# Check 1: YAML frontmatter
# ============================================================
Write-Host "=== Validate: YAML frontmatter ==="

$skillsDir = Join-Path $repoRoot ".claude\skills"
$skillDirs = Get-ChildItem -LiteralPath $skillsDir -Directory -ErrorAction SilentlyContinue

if (-not $skillDirs -or $skillDirs.Count -eq 0) {
    Write-Warn "No skill directories found under .claude/skills/"
} else {
    foreach ($dir in $skillDirs) {
        $skillName = $dir.Name
        $skillFile = Join-Path $dir.FullName "SKILL.md"
        $relPath = "$skillName/SKILL.md"

        if (-not (Test-Path -LiteralPath $skillFile)) {
            Write-Fail "$relPath - SKILL.md not found"
            continue
        }

        $content = Get-Content -LiteralPath $skillFile -Raw -ErrorAction SilentlyContinue
        if (-not $content) {
            Write-Fail "$relPath - empty or unreadable"
            continue
        }

        if (-not ($content -match '(?s)^---\s*\r?\n(.+?)\r?\n---\s*\r?\n')) {
            Write-Fail "$relPath - missing or malformed YAML frontmatter"
            continue
        }

        $frontmatter = $matches[1]
        $hasName = ($frontmatter -match '(?m)^name:\s*\S')
        $hasDescription = ($frontmatter -match '(?m)^description:\s*\S')

        if (-not $hasName -and -not $hasDescription) {
            Write-Fail "$relPath - missing name and description fields"
        } elseif (-not $hasName) {
            Write-Fail "$relPath - missing name field"
        } elseif (-not $hasDescription) {
            Write-Fail "$relPath - missing description field"
        } else {
            Write-Pass $relPath
        }
    }
}

Write-Host ""

# ============================================================
# Check 2: Manifest consistency
# ============================================================
Write-Host "=== Validate: Manifest consistency ==="

$manifestPath = Join-Path $repoRoot "docs\reference\skills-manifest.md"

$manifestSkills = @()
$hasManifestFile = Test-Path -LiteralPath $manifestPath
if ($hasManifestFile) {
    $manifestContent = Get-Content -LiteralPath $manifestPath -Raw
    $tableMatches = [regex]::Matches($manifestContent, '(?m)^\|\s*`([^`]+)`\s*\|')
    foreach ($m in $tableMatches) {
        $manifestSkills += $m.Groups[1].Value
    }
} else {
    Write-Warn "Manifest file not found; skipping manifest consistency check"
}

$diskSkills = @()
if (Test-Path -LiteralPath $skillsDir) {
    $diskSkills = Get-ChildItem -LiteralPath $skillsDir -Directory | ForEach-Object { $_.Name }
}

if ($hasManifestFile) {
    $notOnDisk = $manifestSkills | Where-Object { $_ -notin $diskSkills }
    $notInManifest = $diskSkills | Where-Object { $_ -notin $manifestSkills }

    if ($notOnDisk.Count -eq 0 -and $notInManifest.Count -eq 0) {
        Write-Pass "all skills match"
    } else {
        if ($notOnDisk.Count -gt 0) {
            $missingDisk = $notOnDisk -join ", "
            Write-Fail "in manifest but not on disk: $missingDisk"
        }
        if ($notInManifest.Count -gt 0) {
            foreach ($skill in $notInManifest) {
                Write-Fail "$skill is on disk but missing from manifest"
            }
        }
    }
} else {
    $notInManifest = @()
}

if ($FixManifest -and $notInManifest.Count -gt 0 -and $hasManifestFile) {
    $lines = Get-Content -LiteralPath $manifestPath
    $lastDataIndex = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\|.+\|.+\|.+\|$' -and $lines[$i] -notmatch '^\|\s*-+\s*\|\s*-+\s*\|\s*-+\s*\|$') {
            $lastDataIndex = $i
        }
    }

    if ($lastDataIndex -ge 0) {
        $newRows = @()
        foreach ($skill in $notInManifest) {
            $desc = "TBD"
            $skillFile = Join-Path $skillsDir $skill "SKILL.md"
            if (Test-Path -LiteralPath $skillFile) {
                $content = Get-Content -LiteralPath $skillFile -Raw -ErrorAction SilentlyContinue
                if ($content -match '(?s)^---\s*\r?\n(.+?)\r?\n---') {
                    $fm = $matches[1]
                    if ($fm -match '(?m)^description:\s*(.+)') {
                        $fullDesc = $matches[1].Trim()
                        # Take first 60 chars as summary
                        $desc = $fullDesc.Substring(0, [Math]::Min(60, $fullDesc.Length))
                    }
                }
            }
            $newRows += "| ``$skill`` | $desc | TBD |"
        }

        $newContent = @()
        for ($i = 0; $i -le $lastDataIndex; $i++) {
            $newContent += $lines[$i]
        }
        $newContent += $newRows
        for ($i = $lastDataIndex + 1; $i -lt $lines.Count; $i++) {
            $newContent += $lines[$i]
        }

        Set-Content -LiteralPath $manifestPath -Value $newContent
        $addedList = $notInManifest -join ", "
        Write-Host "Updated manifest: $addedList"
    } else {
        Write-Warn "Could not find table data rows to append to"
    }
}

Write-Host ""

# ============================================================
# Check 3: Installed file policy
# ============================================================
Write-Host "=== Validate: Installed file policy ==="

function Test-RelativePath {
    param([string]$RelativePath)
    Test-Path -LiteralPath (Join-Path $repoRoot $RelativePath)
}

function Test-RelativeGlob {
    param([string]$RelativePattern)
    $parent = Split-Path -Parent $RelativePattern
    $leaf = Split-Path -Leaf $RelativePattern
    $root = if ($parent) { Join-Path $repoRoot $parent } else { $repoRoot }
    if (-not (Test-Path -LiteralPath $root)) { return $false }
    $matches = Get-ChildItem -LiteralPath $root -Filter $leaf -ErrorAction SilentlyContinue
    return ($matches.Count -gt 0)
}

$coreMustExist = @(
    "CLAUDE.md",
    "AGENTS.md",
    "VERSION",
    ".claude-kit-version",
    "scripts\install-claude-kit.ps1",
    "scripts\validate-kit.ps1",
    ".claude\settings.json",
    ".claude\agents\coder.json",
    ".claude\agents\engineer.json",
    ".claude\commands\progress.md",
    ".claude\rules\core-development.md",
    ".claude\rules\safe-remote-commands.md",
    ".claude\rules\token-efficiency.md",
    ".claude\skills\coder\SKILL.md",
    ".claude\skills\engineer\SKILL.md",
    ".claude\skills\engineer-coder-orchestrator\SKILL.md",
    ".claude\skills\github-repo-standards\SKILL.md",
    ".claude\skills\learning-blog\SKILL.md"
)

$unityMustExist = @(
    ".claude\rules\unity-csharp.md",
    ".claude\skills\unity6-project\SKILL.md"
)

$downstreamMustNotExist = @(
    ".claude\skills\claude-config-maintainer",
    "docs",
    ".github",
    ".gitleaks.toml",
    "MAINTAINERS.md",
    "CHANGELOG.md",
    "LICENSE",
    "SECURITY.md",
    "CONTRIBUTING.md"
)

$downstreamForbiddenGlobs = @(
    ".claude\agents\*.local.json.example"
)

if ($Profile -eq "kit") {
    Write-Pass "installed file policy skipped for kit repository"
} else {
    $mustExist = @()
    $mustExist += $coreMustExist
    if ($Profile -eq "unity") {
        $mustExist += $unityMustExist
    }

    foreach ($path in $mustExist) {
        if (Test-RelativePath $path) {
            Write-Pass "exists: $path"
        } else {
            Write-Fail "missing required install item: $path"
        }
    }

    if ($Profile -eq "core") {
        foreach ($path in $unityMustExist) {
            if (Test-RelativePath $path) {
                Write-Fail "core profile should not include: $path"
            }
        }
    }

    foreach ($path in $downstreamMustNotExist) {
        if (Test-RelativePath $path) {
            Write-Fail "downstream install should not include: $path"
        }
    }

    foreach ($pattern in $downstreamForbiddenGlobs) {
        if (Test-RelativeGlob $pattern) {
            Write-Fail "downstream install should not include files matching: $pattern"
        }
    }
}

Write-Host ""

# ============================================================
# Check 4: Install script test (core profile)
# ============================================================
Write-Host "=== Validate: Install script (core) ==="

$installScript = Join-Path $scriptRoot "install-claude-kit.ps1"
$testTarget = Join-Path $env:TEMP "validate-kit-test-$([Guid]::NewGuid().ToString('N').Substring(0,8))"

try {
    if (-not (Test-Path -LiteralPath $installScript)) {
        Write-Fail "install-claude-kit.ps1 not found"
    } else {
        if (Test-Path -LiteralPath $testTarget) {
            Remove-Item -Recurse -Force -LiteralPath $testTarget -ErrorAction SilentlyContinue
        }

        $psExe = Get-Command pwsh -ErrorAction SilentlyContinue
        if (-not $psExe) { $psExe = Get-Command powershell.exe -ErrorAction Stop }
        & $psExe.Source -ExecutionPolicy Bypass -File $installScript -Target $testTarget -Profile core -Force *>&1 | Out-Null

        $requiredFiles = @("CLAUDE.md", "AGENTS.md", ".claude-kit-version")
        $missingFiles = @()
        foreach ($file in $requiredFiles) {
            $filePath = Join-Path $testTarget $file
            if (-not (Test-Path -LiteralPath $filePath)) {
                $missingFiles += $file
            }
        }

        if ($missingFiles.Count -gt 0) {
            $missingList = $missingFiles -join ", "
        Write-Fail "install test failed - missing: $missingList"
        } else {
            Write-Pass "install test passed"
        }
    }
} catch {
    Write-Fail "install test threw: $_"
} finally {
    if (Test-Path -LiteralPath $testTarget) {
        Remove-Item -Recurse -Force -LiteralPath $testTarget -ErrorAction SilentlyContinue
    }
}

Write-Host ""

# ============================================================
# Summary
# ============================================================
if ($allPassed) {
    Write-Host "All checks passed."
    exit 0
} else {
    Write-Host "Some checks failed."
    exit 1
}
