---
name: init-harness
description: Bootstrap a project harness with AGENTS.md, optional CLAUDE.md pointer, and docs/ scaffold; or run doctor mode on an existing harness to detect drift (stale nav, duplicate ISS IDs, cross-file contradictions). Use when the user asks to initialize project guidelines, set up an agent harness, create AGENTS.md, organize project docs, add Research → Plan → Build workflow files, or audit/巡检/体检 an existing harness — for Codex / Claude Code / Cursor / Copilot.
---

# init-harness

Create a small, vendor-neutral project harness so future AI sessions can start from `AGENTS.md` and `docs/plan.md` instead of rediscovering project rules.

## When to Invoke

- 新项目目录没有 `AGENTS.md` / `docs/plan.md`。
- 现有项目想换装这套 harness。
- 用户明确说"初始化 harness / 搭建工程规范 / 项目骨架 / 整理 docs / create AGENTS.md / project guidelines"。
- **Doctor**：项目已有这套 harness，用户说"巡检 / 体检 / doctor / 检查 harness 漂移" → 跳过脚手架流程，按 `references/doctor.md` 清单执行只读检查，报告发现并征询后再修。

## Workflow

### Step 1 — Conflict Check

检查当前目录是否已有这些文件：

- `AGENTS.md`
- `CLAUDE.md`
- `docs/plan.md`
- `docs/plan-archive.md`
- `docs/conventions.md`
- `docs/issues.md`
- `docs/issues-archive.md`
- `docs/architecture.md`（opt-in，见 Step 2）
- `docs/pm-overview.md`（opt-in，见 Step 2）

若任一存在，列出冲突文件并询问用户选择：覆盖、跳过已存在文件、或逐文件确认。未得到确认前不要覆盖。若已存在的是本套 harness（AGENTS.md 带 `harness_version` frontmatter），建议改走 Doctor 模式。

### Step 2 — Collect Project Facts

一次性询问缺失信息；能从仓库确定的不要重复问：

- 项目名：`{{PROJECT_NAME}}`
- 一句话定位：`{{TAGLINE}}`
- 技术栈关键字：`{{STACK}}`
- owner：`{{OWNER}}`
- 日期：`{{TODAY}}`，可用本地日期
- 是否需要 PM 视图 / 独立架构文档？（`pm-overview.md` / `architecture.md`；单人项目通常不需要，架构知识可先落在 AGENTS.md 规则组里，长大后再拆）

Codex 下如果没有专用提问工具，直接用一段简短文字向用户提问。

### Step 3 — Write Files

从 skill 目录的 `templates/` 复制并替换 placeholder：

| 模板文件 | 落地路径 | 条件 |
|---|---|---|
| `templates/AGENTS.md` | `./AGENTS.md` | 必选 |
| `templates/CLAUDE.md` | `./CLAUDE.md` | 必选 |
| `templates/docs/plan.md` | `./docs/plan.md` | 必选 |
| `templates/docs/plan-archive.md` | `./docs/plan-archive.md` | 必选 |
| `templates/docs/conventions.md` | `./docs/conventions.md` | 必选 |
| `templates/docs/issues.md` | `./docs/issues.md` | 必选 |
| `templates/docs/issues-archive.md` | `./docs/issues-archive.md` | 必选 |
| `templates/docs/architecture.md` | `./docs/architecture.md` | Step 2 用户选了才生成 |
| `templates/docs/pm-overview.md` | `./docs/pm-overview.md` | Step 2 用户选了才生成 |

Placeholder：`{{PROJECT_NAME}}`、`{{TAGLINE}}`、`{{STACK}}`、`{{OWNER}}`、`{{TODAY}}`。

写盘前的裁剪（模板噪音由 agent 在脚手架期消化，不留给用户）：

1. `conventions.md`：按 `{{STACK}}` **删除不适用的可选块**（如 Python 项目删 TS/React/样式块），只留语言无关核心 + 命中的语言块。
2. `AGENTS.md`：未选 opt-in 文档时，从快速导航表删除对应行。
3. `AGENTS.md`：根据仓库现状推断 1–2 个领域规则组（如 DATA / SEC / API），在注释示例处给出具体建议供用户确认，而不是只留空壳注释。

### Step 4 — Post-Setup Guidance

落地后提示用户补充：

1. `AGENTS.md`：把通用 WF 规则扩展成项目专属编号规则，例如 `SEC1`、`DATA2`、`TX3`。
2. `docs/plan.md`：填入首个活跃里程碑和验收条件。
3. `docs/conventions.md`：确认 Step 3 裁剪结果，补充项目技术约定。
4. （如生成）`docs/architecture.md`：按实际架构补齐模块边界。
5. 询问 `docs/` 是否入仓；私有个人 harness 可 ignore，协作项目或设计权威建议入仓。
6. 提示用户：日后可随时说"巡检 harness"跑 Doctor 检查漂移。

### Step 5 — Guardrails

- 不跑构建、测试、部署或 git 命令，除非用户明确要求。
- 不安装依赖。
- 不写业务代码。
- 不覆盖已有文件，除非用户已确认。

## Doctor — 巡检已有 harness

触发：项目已有本套 harness，且用户说"巡检 / 体检 / doctor / 检查漂移"，或 Step 1 发现 `harness_version` 后用户同意改走巡检。

执行：按 `references/doctor.md` 的清单逐项跑**只读**检查（grep / ls / 对比），汇总报告：命中的漂移、位置、建议修复。**先报告、征询确认后再修**，与 Guardrails 一致。

## Harness Conventions

- **编号硬规**：每条硬规则使用 `<前缀><数字>`，例如 `WF1` / `SEC2` / `TX3`。内置两组：WF（工作流）+ HM（harness 自维护：docs 变动同步导航、frontmatter 刷新、绝对日期、禁仓外引用、issues.md 为状态唯一权威）。
- **frontmatter**：docs 文件带 `last_updated / status`；AGENTS.md 另带 `owner / harness_version`。
- **plan.md**：只放活跃迭代和待办（≤100 行）；完成历史迁入 `plan-archive.md`；引用问题只写 `ISS-XXX` 链接，不复述状态。
- **issues.md**：头部索引表（ID / 状态 / 一句话 / 位置）；正文 newest-first；新 ID = 索引最大编号 + 1；正文 >300 行或 resolved >15 条时最旧 resolved 迁 `issues-archive.md`；条目五段式（日期 / 现象 / 根因 / 方案 / 经验），状态 `open / resolved / superseded`。
- **AGENTS.md**：保持短、可扫读，包含快速导航（含加载分层：常读 / 按需 / 默认不读）、硬规、技术栈、目录、常用命令。这是唯一常载文件，任何新增内容先问"值得每个会话都付这份 token 吗"。
