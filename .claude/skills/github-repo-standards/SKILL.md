---
name: github-repo-standards
description: 检查和补齐 GitHub 仓库社区标准文件。Use when the user asks to standardize a repository, prepare it for GitHub, add SECURITY.md, CONTRIBUTING.md, CODEOWNERS, issue/PR templates, .gitignore, .gitattributes, README, or CI-related repository hygiene.
---

# GitHub Repo Standards

## Workflow

1. Scan for existing files before creating anything.
2. Report missing or empty community files by priority.
3. Fill only the files the user wants, using project facts from the repo.
4. Never include secrets, personal tokens, private keys, or machine-local credentials.
5. Update `CLAUDE.md` or `README.md` only when a new important workflow needs to be discoverable.

## Checklist

- `README.md`
- `CLAUDE.md` or `AGENTS.md`
- `.gitignore`
- `.gitattributes`
- `.editorconfig`
- `SECURITY.md`
- `CONTRIBUTING.md`
- `.github/CODEOWNERS`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/`
- `.github/workflows/*.yml` when CI is in scope

## Templates

- 若 `docs/templates/github/` 存在，先读 README.md 了解模板与源文件关系，优先参照最新源文件生成。
- 若模板目录不存在（未安装 docs），直接根据项目上下文和通用最佳实践生成所需文件，不报错。
- 模板文件头部有 `source of truth` 声明，复制到下游项目时移除该声明行。
