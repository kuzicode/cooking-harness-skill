# 项目类型：solo 和 open-source

`CLAUDE.md`、`AGENTS.md` 是加载机制；harness 是用它们组织规则、状态和巡检的体系。两者不冲突。

## 分层方式

```
<brand>/                 私有仓库，维护者层（profile: maintainer）
├─ AGENTS.md             路线、部署权、审核权
├─ CLAUDE.md -> AGENTS.md
├─ docs/  ops/  review/
└─ <project>/            公开仓库（profile: open-source），上级 .gitignore 忽略
```

- 贡献者 clone 后没有上级目录，只看到公开层规则。
- 私有内容不在公开工作区里，不会一次 `git add -f` 就泄露。这是不用 `CLAUDE.local.md` 放路线和运维资料的原因；个人偏好仍可以放它。

## 实测的加载行为（Claude Code 2.1.318、Codex CLI 0.166.0，2026-11-06）

| 启动位置 | Claude Code | Codex |
|---|---|---|
| 公开项目目录，有上级维护者层 | 能读到上级 `CLAUDE.md` | 读不到，要从上级目录启动 |
| 独立 clone | 读不到 | 读不到 |

**上级 `CLAUDE.md` 用软链，不用 `@AGENTS.md`：** 从子目录启动的 `claude -p` 没有加载这个导入，软链直接生效。

## 分工

| | 公开层 | 维护者层 |
|---|---|---|
| 路线 | `ROADMAP.md`（方向和可认领事项） | `docs/plan.md`（真实计划、优先级） |
| 问题记录 | `docs/issues.md`（脱敏） | 未脱敏原文 |
| 规则 | 目录、命令、代码约定、红线 | 隔离、部署权、审核权 |
| 部署 | 不放 | `ops/` |
| 审核 | CI、PR 模板、红线 | `review/pr-gate.md`、敏感词表、pre-push |

## 迁移 solo 项目

1. 导出到新目录，用全新 git 历史和 noreply 邮箱；旧仓库保持私有。不要公开旧历史。
2. 把部署和路线移到维护者层。部署脚本如果用 `rsync --delete`，确认不会删掉服务器上 cron 调用的脚本。
3. 服务器目录不要跟着改名：Compose 项目名可能取自目录名，改了会挂上空卷。
4. 建敏感词表：把脱敏时替换掉的真实词也放进去，再扫全树。
5. 分支保护只有一位维护者时批准数设 0：GitHub 不允许批准自己的 PR，外部 fork 本来也合并不了。
