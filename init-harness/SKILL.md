---
name: init-harness
description: Bootstrap project harness (AGENTS.md + docs/ scaffold) for a new or unstructured project. Use when user asks to "初始化项目 harness / 搭建工程规范 / 项目骨架 / new project setup / set up project guidelines / 整理 docs / 初始化文档结构". Copies opinionated templates and fills in project-specific placeholders so future AI sessions have low-context, high-clarity rules.
---

# init-harness

## When to invoke
- 新项目目录，无 `AGENTS.md` / `docs/plan.md`
- 现有项目想换装这套 harness（先列出冲突文件，询问用户覆盖 / 跳过 / 合并）
- 用户明确说"搭骨架 / init harness / 整理工程文档 / 初始化规范"

## Workflow

### Step 1 — 冲突检查
检查当前目录是否已有：`AGENTS.md`, `CLAUDE.md`, `docs/plan.md`, `docs/conventions.md`, `docs/issues.md`, `docs/architecture.md`, `docs/pm-overview.md`。
- 若任一存在 → 列出冲突文件，询问：覆盖 / 跳过已存在文件 / 逐文件确认？
- 若全部不存在 → 直接进入 Step 2

### Step 2 — 收集基本信息（AskUserQuestion）
问以下信息（可一次多问）：
1. 项目名（`{{PROJECT_NAME}}`，如 `KBOT` / `a-share`）
2. 一句话定位（`{{TAGLINE}}`，如"浏览器端多链钱包管理工具"）
3. 技术栈关键字（`{{STACK}}`，如"Next.js 15 · TypeScript · pnpm · viem"）
4. owner（`{{OWNER}}`，如 `kumata`）
5. 今天日期（`{{TODAY}}`，如 `2026-05-09`，可用 `date` 命令自动填）

### Step 3 — 写入文件
从 `~/.claude/skills/init-harness/templates/` 复制并替换 placeholder，落地到当前工作目录：

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

Placeholder 替换：`{{PROJECT_NAME}}` `{{TAGLINE}}` `{{STACK}}` `{{OWNER}}` `{{TODAY}}`

### Step 4 — 落地后提示
告知用户下一步应手动补充的内容：
1. `AGENTS.md` → 编辑"硬性规则"：WF 组是通用占位，按项目领域追加专属分组（SEC / TX / DATA / UI 等），每条规则用 `前缀+数字` 格式（WF1 / SEC2 / TX3）
2. `docs/plan.md` → 填入首个里程碑（M1 目标 / 验收条件）
3. `docs/conventions.md` → 删除不适用的占位条目，补充项目特有约定
4. `docs/architecture.md` → 按实际技术选型填充各章节
5. 询问用户 `docs/` 是否需要加入 `.gitignore`

### Step 5 — 禁止事项
- 不跑任何构建 / git 命令
- 不替用户写业务代码
- 不安装依赖

## Harness 约定（供 AI 执行时遵循）

- **编号硬规**：每条规则 `<前缀><数字>`（WF1 / SEC2 / TX3），便于 review 时精确引用
- **frontmatter**：每个 docs/ 文件必带 `last_updated / status / owner`
- **plan.md ≤ 100 行**：超过时将已完成里程碑迁入 `plan-archive.md`
- **issues.md ISS-XXX**：五段式（日期 / 现象 / 根因 / 方案 / 经验），状态 `open / resolved / superseded`
- **AGENTS.md ≤ 140 行**：快速导航表 + 硬规 + 技术栈 + 目录树 + 命令，不写大段叙述
