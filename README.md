# cooking-harness-skill

Claude Code / Codex compatible skill for bootstrapping a project harness (`AGENTS.md` + `docs/` scaffold).

## Skills

### `init-harness`

一键为新项目落地工程规范骨架：`AGENTS.md` + `CLAUDE.md` + `docs/{plan, plan-archive, conventions, issues, issues-archive}.md`（`architecture.md` 可选生成）。设计原则：**最小常载**——只写模型从代码里看不出、不写就会犯错的东西。

触发方式：
- Claude Code：在项目目录下输入 `/init-harness`；已有 harness 的项目说"巡检 / 体检 harness"跑 Doctor
- Codex：在项目目录下请求使用 `$init-harness`，或用自然语言说明"初始化项目 harness / 创建 AGENTS.md / 整理 docs"

**特性：**
- 检测冲突文件，询问覆盖 / 跳过 / 合并
- 收集项目名 / 技术栈 / owner 后替换模板 placeholder；按技术栈裁剪 `conventions.md` 可选块；从项目配置填入真实常用命令（含验证命令）
- 编号化硬规（WF1 / SEC2 等），内置三组共 12 条：**WF 工作流**（plan 门槛、**完成门**——验证并附证据 / 精简 diff / 记 ISS / 问 memory、worktree）、**HM 自维护**（docs 变动同步导航、绝对日期、禁仓外引用、issues 为状态唯一权威、AGENTS.md ≤150 行常载预算）
- **CH 代码健康规则组**——防止长期 agent 迭代堆成屎山：先搜后写 + Rule of Three、Tidy First（重构单独提交，范围外重构记 `🔧 技术债`）、里程碑精简 pass；`conventions.md` 附量化阈值与各语言精简工具
- `plan.md` ≤ 100 行 + `plan-archive.md` 历史归档模式
- `issues.md` 头部索引表 + newest-first + ISS-XXX 五段式踩坑模板；超阈值迁 `issues-archive.md`；**经验升级规则**——同类坑二次命中即提炼为 conventions / 硬规
- AGENTS.md 快速导航带加载分层（常读 / 按需 / 默认不读），控制常载上下文成本
- **Doctor 模式**：`scripts/doctor.sh` 一次跑完确定性只读检查（重复 ISS 编号、索引/正文错位、导航表与 docs/ 不符、frontmatter 缺失、仓外引用、相对时间词、跨文件状态矛盾、常读层预算、代码健康趋势），`references/doctor.md` 补人工判断项

版本历史见 [CHANGELOG.md](./CHANGELOG.md)。

## 安装

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.claude/skills
```

Codex：

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.codex/skills
```

换设备时按对应工具 clone 到本地 skills 目录即可。
