---
name: init-harness
description: Bootstrap a project harness with AGENTS.md, optional CLAUDE.md pointer, and docs/ scaffold. Use when the user asks to initialize project guidelines, set up an agent harness, create AGENTS.md, organize project docs, or add Research → Plan → Build workflow files for Codex / Claude Code / Cursor / Copilot.
---

# init-harness

Create a small, vendor-neutral project harness so future AI sessions can start from `AGENTS.md` and `docs/plan.md` instead of rediscovering project rules.

## When to Invoke

- 新项目目录没有 `AGENTS.md` / `docs/plan.md`。
- 现有项目想换装这套 harness。
- 用户明确说"初始化 harness / 搭建工程规范 / 项目骨架 / 整理 docs / create AGENTS.md / project guidelines"。

## Workflow

### Step 1 — Conflict Check

检查当前目录是否已有这些文件：

- `AGENTS.md`
- `CLAUDE.md`
- `docs/plan.md`
- `docs/plan-archive.md`
- `docs/architecture.md`
- `docs/conventions.md`
- `docs/issues.md`
- `docs/pm-overview.md`

若任一存在，列出冲突文件并询问用户选择：覆盖、跳过已存在文件、或逐文件确认。未得到确认前不要覆盖。

### Step 2 — Collect Project Facts

一次性询问缺失信息；能从仓库确定的不要重复问：

- 项目名：`{{PROJECT_NAME}}`
- 一句话定位：`{{TAGLINE}}`
- 技术栈关键字：`{{STACK}}`
- owner：`{{OWNER}}`
- 日期：`{{TODAY}}`，可用本地日期

Codex 下如果没有专用提问工具，直接用一段简短文字向用户提问。

### Step 3 — Write Files

从 skill 目录的 `templates/` 复制并替换 placeholder：

| 模板文件 | 落地路径 |
|---|---|
| `templates/AGENTS.md` | `./AGENTS.md` |
| `templates/CLAUDE.md` | `./CLAUDE.md` |
| `templates/docs/plan.md` | `./docs/plan.md` |
| `templates/docs/plan-archive.md` | `./docs/plan-archive.md` |
| `templates/docs/architecture.md` | `./docs/architecture.md` |
| `templates/docs/conventions.md` | `./docs/conventions.md` |
| `templates/docs/issues.md` | `./docs/issues.md` |
| `templates/docs/pm-overview.md` | `./docs/pm-overview.md` |

Placeholder：`{{PROJECT_NAME}}`、`{{TAGLINE}}`、`{{STACK}}`、`{{OWNER}}`、`{{TODAY}}`。

### Step 4 — Post-Setup Guidance

落地后提示用户补充：

1. `AGENTS.md`：把通用 WF 规则扩展成项目专属编号规则，例如 `SEC1`、`DATA2`、`TX3`。
2. `docs/plan.md`：填入首个活跃里程碑和验收条件。
3. `docs/conventions.md`：删除不适用占位，补充项目技术约定。
4. `docs/architecture.md`：按实际架构补齐模块边界。
5. 询问 `docs/` 是否入仓；私有个人 harness 可 ignore，协作项目或设计权威建议入仓。

### Step 5 — Guardrails

- 不跑构建、测试、部署或 git 命令，除非用户明确要求。
- 不安装依赖。
- 不写业务代码。
- 不覆盖已有文件，除非用户已确认。

## Harness Conventions

- **编号硬规**：每条硬规则使用 `<前缀><数字>`，例如 `WF1` / `SEC2` / `TX3`。
- **frontmatter**：docs 文件带 `last_updated / status / owner`。
- **plan.md**：只放活跃迭代和待办；完成历史迁入 `plan-archive.md`。
- **issues.md**：使用 `ISS-XXX`，记录日期、现象、根因、方案、经验，状态为 `open / resolved / superseded`。
- **AGENTS.md**：保持短、可扫读，包含快速导航、硬规、技术栈、目录、常用命令。
