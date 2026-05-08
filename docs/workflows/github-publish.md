# Publish This Kit To GitHub

## One-time Setup

```powershell
cd "F:\Claude skills"
git init
git add .
git commit -m "Initial Claude skills kit"
```

Create an empty GitHub repository, then connect it:

```powershell
git remote add origin https://github.com/<owner>/<repo>.git
git branch -M main
git push -u origin main
```

## Update Flow

```powershell
git status --short
git add .
git commit -m "Update reusable Claude rules and skills"
git push
```

## Before Push Checklist

- No API keys, tokens, private URLs, account IDs, or local secrets.
- No project-specific temporary logs or caches.
- `docs/reference/skills-manifest.md` matches `.claude/skills/`.
- `scripts/install-claude-kit.ps1` runs on a test target.
- `README.md` explains how to install the latest version into a new project.
- `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md`, `.github/CODEOWNERS`, and `.github/PULL_REQUEST_TEMPLATE.md` exist.
- Replace `@OWNER` in `.github/CODEOWNERS` with the real GitHub user or team before making the repository public.
- If root GitHub files change, update matching downstream templates in `docs/templates/github/` or add a note explaining why they intentionally differ.
- `CHANGELOG.md` and `VERSION` describe the release being published.
