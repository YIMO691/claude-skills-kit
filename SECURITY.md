# Security Policy

This repository is a reusable Claude/Codex configuration kit. Treat prompts, rules, scripts, and templates as executable-adjacent configuration: a malicious change can alter future agent behavior even when it is not application code.

## Reporting A Vulnerability

Report security issues privately to the repository owner. Do not open a public issue containing secrets, exploit details, or private infrastructure information.

Include:

- affected file or workflow
- impact on downstream projects
- reproduction steps when safe to share
- suggested mitigation, if known

## Secret Handling

Do not commit API keys, tokens, passwords, private keys, cookies, local credential files, or machine-specific settings.

Before publishing, scan for:

- real API keys, tokens, passwords, private keys, cookies, and session values
- private URLs, account IDs, internal hostnames, and personal machine paths
- logs that may contain credentials or prompts with sensitive data
- generated caches, local settings, and temporary outputs

## Permission Boundaries

`.claude/settings.json` is a safety baseline, not a sandbox. Deny rules reduce accidental high-risk commands, but they do not replace human review, least-privilege credentials, repository protections, or careful CI configuration.

## Safe Defaults

- Do not push, deploy, publish, or delete remote resources unless the user explicitly asks.
- Keep model routing overrides local unless the target runner is documented.
- Prefer non-destructive install and update scripts; require explicit `-Force` for overwrites.
