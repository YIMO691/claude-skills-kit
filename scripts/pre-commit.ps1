<#
.SYNOPSIS
    Pre-commit hook for Claude Skills Kit.
    Validates staged .md files under .claude/skills/ have correct YAML frontmatter
    and checks for obvious secret patterns in all staged files.
.DESCRIPTION
    Designed to be invoked by a Git pre-commit hook. Exits with code 1 if any
    violations are found, 0 otherwise.
#>

$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
$exitCode = 0

function Write-ErrorMsg {
    param([string]$Path, [string]$Message)
    Write-Host "FAIL  $Path : $Message" -ForegroundColor Red
    $script:exitCode = 1
}

function Write-Pass {
    param([string]$Path, [string]$Message)
    Write-Host "PASS  $Path : $Message" -ForegroundColor Green
}

function Write-Summary {
    param([string]$Category)
    Write-Host ""
    Write-Host "--- $Category ---" -ForegroundColor Cyan
}

# ---------------------------------------------------------------------------
# 1. YAML frontmatter check on staged SKILL.md files
# ---------------------------------------------------------------------------
Write-Summary "YAML frontmatter check (.claude/skills/**/SKILL.md)"

$stagedSkillFiles = git diff --cached --name-only --diff-filter=ACMR |
    Where-Object { $_ -match '^\.claude/skills/.+/SKILL\.md$' } |
    ForEach-Object { Join-Path (Get-Location) $_ -Resolve -ErrorAction SilentlyContinue } |
    Where-Object { $_ -and (Test-Path -LiteralPath $_) }

if ($stagedSkillFiles.Count -eq 0) {
    Write-Host "No staged SKILL.md files to check." -ForegroundColor Yellow
} else {
    foreach ($file in $stagedSkillFiles) {
        $content = Get-Content -Path $file -Raw
        $basename = [System.IO.Path]::GetRelativePath((Get-Location), $file)

        # Check opening `---` and closing `---`
        if (-not ($content -match '(?s)^---\s*\n.*?\n---\s*$')) {
            Write-ErrorMsg -Path $basename -Message "Missing or malformed YAML frontmatter (requires opening `---` and closing `---` on their own lines)"
            continue
        }

        $frontmatter = $matches[0]

        # Remove delimiters to extract inner content
        $inner = $frontmatter -replace '(?s)^---\s*\n', '' -replace '(?s)\n---\s*$', ''

        # Check for name field
        if ($inner -notmatch '(?m)^name:\s*\S') {
            Write-ErrorMsg -Path $basename -Message "Missing required 'name' field in frontmatter"
            continue
        }

        # Check for description field
        if ($inner -notmatch '(?m)^description:\s*\S') {
            Write-ErrorMsg -Path $basename -Message "Missing required 'description' field in frontmatter"
            continue
        }

        Write-Pass -Path $basename -Message "Valid YAML frontmatter with name and description"
    }
}

# ---------------------------------------------------------------------------
# 2. Secret pattern scan on all staged files
# ---------------------------------------------------------------------------
Write-Summary "Secret pattern scan (all staged files)"

$stagedFiles = git diff --cached --name-only --diff-filter=ACMR |
    Where-Object { $_ } |
    ForEach-Object { Join-Path (Get-Location) $_ -Resolve -ErrorAction SilentlyContinue } |
    Where-Object { $_ -and (Test-Path -LiteralPath $_) }

if ($stagedFiles.Count -eq 0) {
    Write-Host "No staged files to scan for secrets." -ForegroundColor Yellow
} else {
    $secretPatterns = @(
        @{ Pattern = 'api_key\s*[:=]\s*["''][^"'']+["'']'; Description = 'Potential API key (api_key = "...")' }
        @{ Pattern = 'sk-\S+'; Description = 'Potential OpenAI/Auth token (sk-...)' }
        @{ Pattern = 'token.*=.*[a-zA-Z0-9]{20,}'; Description = 'Potential token value (20+ alphanumeric chars)' }
        @{ Pattern = 'password.*=.*[^\s]{8,}'; Description = 'Potential password value (8+ non-whitespace chars)' }
    )

    foreach ($file in $stagedFiles) {
        if ($file -match '\.ps1$|\.sh$|\.yml$|\.yaml$|\.json$|\.md$|\.env$|\.ini$|\.cfg$|\.conf$|\.config$|\.py$|\.js$|\.ts$|\.rb$|\.go$|\.java$|\.cs$') {
            $basename = [System.IO.Path]::GetRelativePath((Get-Location), $file)
            $content = Get-Content -Path $file -Raw

            foreach ($sp in $secretPatterns) {
                if ($content -match $sp.Pattern) {
                    $matchLine = $null
                    $lines = $content -split "`n"
                    for ($i = 0; $i -lt $lines.Count; $i++) {
                        if ($lines[$i] -match $sp.Pattern) {
                            $matchLine = $i + 1
                            break
                        }
                    }
                    Write-ErrorMsg -Path $basename -Message "$($sp.Description) (matches '$($matches[0])') at line $matchLine"
                }
            }
        }
    }

    if ($exitCode -eq 1) {
        Write-Host ""
        Write-Host "Potential secrets found in staged files. Commit blocked." -ForegroundColor Red
        Write-Host "If these are false positives, add a .gitattributes or comment to override." -ForegroundColor Yellow
    } else {
        Write-Host "No secret patterns detected in staged files." -ForegroundColor Green
    }
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
Write-Host ""
if ($exitCode -eq 0) {
    Write-Host "All pre-commit checks passed." -ForegroundColor Green
} else {
    Write-Host "Pre-commit checks FAILED." -ForegroundColor Red
}

exit $exitCode
