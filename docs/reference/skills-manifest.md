# Skills Manifest

Use this file before adding or renaming a skill.

| Skill | Purpose | Use when |
| --- | --- | --- |
| `engineer` | 架构设计与任务规划 | 需求模糊、需要方案、接口、取舍或任务拆解 |
| `coder` | 代码实现 | 已有清晰需求或设计，需要实现、测试、修 bug |
| `engineer-coder-orchestrator` | 双角色编排 | 需要先设计再实现，或需要 engineer 到 coder 的明确交接 |
| `github-repo-standards` | GitHub 仓库规范 | 准备发布 GitHub、补齐社区健康文件 |
| `learning-blog` | 学习笔记 | 记录一次工具学习、排错、环境配置或开发复盘 |
| `project-progress-reporter` | 进度摘要 | 汇报项目当前状态、Git 状态、日志或阻塞 |
| `unity6-project` | Unity 6 开发 | Unity 6、C#、NavMesh、Behavior、ML-Agents、Sentis 相关任务 |
| `claude-config-maintainer` | 配置仓库维护 | 更新本仓库规则、skills、commands、安装脚本 |

## Add A New Skill

1. Confirm the workflow is reusable across projects.
2. Create `.claude/skills/<skill-name>/SKILL.md`.
3. Use lowercase letters, digits, and hyphens for the folder name.
4. Keep frontmatter to `name` and `description`.
5. Put detailed examples or templates in `docs/` or a `references/` folder.
6. Update this manifest.
7. Run validation or at least inspect YAML frontmatter and install script behavior. The installer auto-discovers skills, but profile exclusions may still need updates.
