# cooking-harness-skill

Claude Code / Codex compatible skill for bootstrapping a project harness (`AGENTS.md` + `docs/` scaffold).

## Skills

### `init-harness`

一键为新项目落地工程规范骨架：`AGENTS.md` + `CLAUDE.md` + `docs/{plan, plan-archive, architecture, conventions, issues, pm-overview}.md`。

触发方式：
- Claude Code：在项目目录下输入 `/init-harness`
- Codex：在项目目录下请求使用 `$init-harness`，或用自然语言说明"初始化项目 harness / 创建 AGENTS.md / 整理 docs"

**特性：**
- 检测冲突文件，询问覆盖 / 跳过 / 合并
- 收集项目名 / 技术栈 / owner 后替换模板 placeholder
- 编号化硬规（WF1 / SEC2 / TX3 等），便于 review 引用
- `plan.md` ≤ 100 行 + `plan-archive.md` 历史归档模式
- `issues.md` ISS-XXX 五段式踩坑模板

## 安装

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.claude/skills
```

Codex：

```bash
git clone https://github.com/kuzicode/cooking-harness-skill.git ~/.codex/skills
```

换设备时按对应工具 clone 到本地 skills 目录即可。
