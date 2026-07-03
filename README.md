# cooking-harness-skill

Claude Code / Codex compatible skill for bootstrapping a project harness (`AGENTS.md` + `docs/` scaffold).

## Skills

### `init-harness`

一键为新项目落地工程规范骨架：`AGENTS.md` + `CLAUDE.md` + `docs/{plan, plan-archive, conventions, issues, issues-archive}.md`（`architecture.md` / `pm-overview.md` 可选生成）。

触发方式：
- Claude Code：在项目目录下输入 `/init-harness`；已有 harness 的项目说"巡检 / 体检 harness"跑 Doctor
- Codex：在项目目录下请求使用 `$init-harness`，或用自然语言说明"初始化项目 harness / 创建 AGENTS.md / 整理 docs"

**特性：**
- 检测冲突文件，询问覆盖 / 跳过 / 合并
- 收集项目名 / 技术栈 / owner 后替换模板 placeholder；按技术栈自动裁剪 `conventions.md` 可选块
- 编号化硬规（WF1 / SEC2 / TX3 等），便于 review 引用；内置 **HM 自维护规则组**（docs 变动同步导航、绝对日期、禁仓外引用、issues 为状态唯一权威、AGENTS.md ≤150 行常载预算）；WF 组含**完成前验证门**（宣称完成必须先跑证明命令）与关键规则反合理化措辞
- `plan.md` ≤ 100 行 + `plan-archive.md` 历史归档模式
- `issues.md` 头部索引表 + newest-first + ISS-XXX 五段式踩坑模板；超阈值迁 `issues-archive.md`；**经验升级规则**——同类坑二次命中即提炼为 conventions / 硬规
- AGENTS.md 快速导航带加载分层（常读 / 按需 / 默认不读），控制常载上下文成本
- **Doctor 模式**（`references/doctor.md`）：确定性只读检查已有 harness 的漂移——重复 ISS 编号、索引/正文错位、导航表与实际 docs/ 不符、frontmatter 过期、仓外引用、相对时间词、跨文件状态矛盾、常读层 token 预算超标

## 安装

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.claude/skills
```

Codex：

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.codex/skills
```

换设备时按对应工具 clone 到本地 skills 目录即可。
