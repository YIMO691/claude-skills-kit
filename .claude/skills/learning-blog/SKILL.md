---
name: learning-blog
description: 根据一次开发、排错或学习过程生成结构化学习笔记。Use when the user asks to write a learning blog, record what was learned, summarize a tool setup, create a troubleshooting note, or preserve a reusable explanation from the conversation.
---

# Learning Blog

## Workflow

1. Identify the topic, date, and intended depth.
2. Extract only useful material from the current conversation and local artifacts:
   - commands used
   - errors and fixes
   - concepts learned
   - final verification state
3. Write a markdown note under `LearningBlog/YYYY-MM-DD-{slug}.md` when the project uses that folder; otherwise ask or place it under `docs/notes/`.
4. Update the nearest index file if one exists.

## Style

- Prefer concise Chinese explanations.
- Use `powershell`, `bash`, `csharp`, `json`, or other accurate code fence languages.
- Use troubleshooting tables with columns: 现象 / 原因 / 解决。
- Do not store API keys, tokens, passwords, private URLs, or raw secrets.

## Template

Use `docs/templates/learning-blog-template.md` when available.
