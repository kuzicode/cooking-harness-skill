---
name: init-harness
description: Bootstrap a project harness with AGENTS.md, optional CLAUDE.md pointer, and docs/ scaffold; or run doctor mode on an existing harness to detect drift (stale nav, duplicate ISS IDs, cross-file contradictions, code bloat). Use when the user asks to initialize project guidelines, set up an agent harness, create AGENTS.md, organize project docs, add Research → Plan → Build workflow files, or audit/巡检/体检 an existing harness — for Codex / Claude Code / Cursor / Copilot.
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

若任一存在，列出冲突文件并询问用户选择：覆盖、跳过已存在文件、或逐文件确认。未得到确认前不要覆盖。若已存在的是本套 harness（AGENTS.md 带 `harness_version` frontmatter），建议改走 Doctor 模式。

### Step 2 — Collect Project Facts

一次性询问缺失信息；能从仓库确定的不要重复问：

- 项目名：`{{PROJECT_NAME}}`
- 一句话定位：`{{TAGLINE}}`
- 技术栈关键字：`{{STACK}}`
- owner：`{{OWNER}}`
- 日期：`{{TODAY}}`，可用本地日期
- 是否需要独立架构文档 `architecture.md`？（单人项目通常不需要，架构知识可先落在 AGENTS.md 规则组里，长大后再拆）
- 仓库可见性 `{{REPO_VISIBILITY}}`（公开 / 私有）与本地专用路径 `{{PRIVATE_PATHS}}`：**按内容敏感性隔离，不按目录整体隔离**。harness（`AGENTS.md` / `CLAUDE.md` / `docs/`）与部署逻辑默认入仓，换设备 clone 即可用；凭据、`.env*`、服务器清单（IP / SSH 账号 / 内部域名）放本地专用文件（如 `.env*`、`deploy/hosts.local`），由入仓脚本读取。公开仓库的文档与提交说明不写服务器地址；私有仓库可写，但改公开前先清理

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

Placeholder：`{{PROJECT_NAME}}`、`{{TAGLINE}}`、`{{STACK}}`、`{{OWNER}}`、`{{TODAY}}`、`{{REPO_VISIBILITY}}`（`公开` / `私有`）、`{{PRIVATE_PATHS}}`（反引号包裹、顿号分隔的路径列表；没有则写 `无`）。

写盘前的裁剪（模板噪音由 agent 在脚手架期消化，不留给用户）：

1. `conventions.md`：按 `{{STACK}}` **删除不适用的可选块**（如 Python 项目删 TS 块），只留语言无关核心 + 命中的语言块。
2. `AGENTS.md`：未选 architecture.md 时，从快速导航表删除对应行。
3. `AGENTS.md`：按 `{{STACK}}` / 仓库现状判断有无 UI——无则删除 UI 可选块，有则保留并删掉其注释标记。
4. `AGENTS.md`：根据仓库现状推断 1–2 个领域规则组（如 DATA / SEC / API），替换规则区末尾的注释占位，给出具体建议供用户确认。
5. `AGENTS.md`「常用命令」：从 package.json / Makefile / pyproject 等填入真实命令，**至少包含验证命令**（test / lint / typecheck / build）——WF2 完成门依赖它。填完删掉注释。
6. `.gitignore`：把 `{{PRIVATE_PATHS}}` 逐行追加（文件不存在则创建，已有条目不重复），附一行注释说明「本地专用：凭据 / 服务器清单」。已被 git 跟踪的路径只提示用户 `git rm --cached`，不擅自执行。
7. `AGENTS.md` HM6 句式固定为「仓库安全（可见性）：本地专用 <清单>。…」——Doctor D7 只解析「本地专用」到第一个「。」之间的反引号路径；后文提到的路径（如允许入仓的目录）不加反引号也不会被检查。

### Step 4 — Post-Setup Guidance

落地后提示用户补充：

1. `AGENTS.md`：补充项目专属编号规则（`WF4` 占位、`SEC1`、`DATA2` 等）。只写模型从代码里看不出、不写就会犯错的规则。
2. `docs/plan.md`：填入首个活跃里程碑和验收条件。
3. `docs/conventions.md`：确认 Step 3 裁剪结果，补充项目技术约定。
4. （如生成）`docs/architecture.md`：按实际架构补齐模块边界。
5. 复述 HM6 的可见性、本地专用清单与 `.gitignore` 结果；提醒：已推送到公开仓库的敏感内容删文件不够，提交历史仍可见（处理方式见 `references/doctor.md` D7）。
6. 提示用户：日后可随时说"巡检 harness"跑 Doctor 检查漂移。

### Step 5 — Guardrails

- 不跑构建、测试、部署或 git 命令，除非用户明确要求。
- 不安装依赖。
- 不写业务代码。
- 不覆盖已有文件，除非用户已确认。
- 不把服务器地址、账号、密钥等运维细节写进会入仓的文件（HM6）。

## Doctor — 巡检已有 harness

触发：项目已有本套 harness，且用户说"巡检 / 体检 / doctor / 检查漂移"，或 Step 1 发现 `harness_version` 后用户同意改走巡检。

执行：在项目根运行 `bash <本 skill 目录>/scripts/doctor.sh`（确定性只读检查），再按 `references/doctor.md` 补人工判断项，汇总报告。**先报告、征询确认后再修**，与 Guardrails 一致。

## Harness Conventions

模板本身就是规范的权威，这里只列设计原则，细节不在此复述（避免与模板漂移）：

- **最小常载**：AGENTS.md 是唯一常载文件（≤150 行，HM5）。每行都要回答"删了它模型会犯错吗"——模型已知的通用惯例、能从代码读出的内容（目录树、技术栈细节）不写。
- **编号硬规**：`<前缀><数字>`，便于 review 引用。内置三组：WF（plan 门槛、完成门、worktree）/ HM（harness 自维护）/ CH（代码健康），外加可选 UI 组（有界面才保留）；项目按领域追加。
- **规则带理由、不喊口号**：一条规则最多一句 why，不用"不可协商 / MUST"类激进措辞。
- **跨会话状态进 docs/**：`plan.md`（活跃，≤100 行）↔ `plan-archive.md`；`issues.md`（索引 + newest-first + 五段式 + 经验升级为规则）↔ `issues-archive.md`。规则见各模板头部。
- **确定性的交给脚本**：能 grep 判定的漂移由 `scripts/doctor.sh` 检查，不占 agent 的推理。
- **仓库安全前置**：文档是运维细节最容易泄露的地方，入不入仓在脚手架期定（Step 2），由 HM6 + Doctor D7 守住，而不是等推送后再补救。
