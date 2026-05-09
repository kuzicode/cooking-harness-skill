# cooking-harness-skill

Claude Code skills for bootstrapping project harness (AGENTS.md + docs/ scaffold).

## Skills

### `init-harness`

一键为新项目落地工程规范骨架：`AGENTS.md` + `CLAUDE.md` + `docs/{plan, plan-archive, architecture, conventions, issues, pm-overview}.md`。

触发方式：在项目目录下输入 `/init-harness`

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

换设备时同上，之后 `/init-harness` 即可用。
