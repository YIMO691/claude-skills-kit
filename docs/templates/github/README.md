# GitHub Templates

此目录存放供下游项目复制使用的 GitHub 社区文件模板。每个模板都是最小化、项目无关的起点。

## 模板 vs 源文件

| 模板 (本目录) | 本仓库源文件 | 说明 |
|---------------|-------------|------|
| `CONTRIBUTING.md` | 根目录 `CONTRIBUTING.md` | 模板是通用贡献指南；源文件含 kit 维护专属流程 |
| `SECURITY.md` | 根目录 `SECURITY.md` | 模板是通用安全策略；源文件含 kit 配置特有安全说明 |
| `PULL_REQUEST_TEMPLATE.md` | `.github/PULL_REQUEST_TEMPLATE.md` | 内容相同 |
| `CODEOWNERS` | `.github/CODEOWNERS` | 模板含占位符 `@OWNER`；源文件已替换 |

## 维护规则

- 修改本仓库自身的社区文件时，只改根目录/`.github/` 中的源文件。
- 如果改动是**跨项目通用**的（如 PR 模板结构变化），同步更新本目录对应模板。
- 如果改动是**kit 专属**的（如 CONTRIBUTING.md 中的 kit 流程），不需要同步模板。
- 每个模板文件头部已有免责声明指向源文件，修改时保留该声明。
