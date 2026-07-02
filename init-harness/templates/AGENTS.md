---
last_updated: {{TODAY}}
status: active
owner: {{OWNER}}
harness_version: 2
---

# {{PROJECT_NAME}} — Agent Guidelines

## 项目简介

{{TAGLINE}}

## 快速导航

| 你想做什么 | 去哪里看 | 加载 |
|---|---|---|
| 当前迭代 / 活跃待办 | `docs/plan.md` | 常读 |
| 历史已完成 / 已废弃方案 | `docs/plan-archive.md` | 默认不读 |
| 详细架构 | `docs/architecture.md` | 按需 |
| 编码约定 | `docs/conventions.md` | 按需 |
| 踩坑记录（ISS-XXX） | `docs/issues.md` | 按需 |
| 已归档的历史 ISS | `docs/issues-archive.md` | 默认不读 |
| 产品视图（面向 PM） | `docs/pm-overview.md` | 按需 |

> `docs/` 允许按主题增设子目录（如 `design/`、`strategies/`、`reference/`）；新增即按 HM1 补导航行。

---

## 硬性规则（编号化）

### WF — 工作流 (Workflow)

- **WF1** > 5 个文件或非一行改动，先更新 `docs/plan.md` 再动手（Research → Plan → Build）
- **WF2** 解决一个非平凡 bug 后追加 `docs/issues.md` 一条 ISS-XXX（踩过两次的坑必须记）
- **WF3** 改动 > 500 行后主动问用户："有什么值得记入 memory 的经验？"
- **WF4** 破坏性改动用 worktree 隔离，review 后再合并
- **WF5** [根据项目需要追加，如"不主动运行 deploy.sh，提示用户手动执行"]

### HM — Harness 维护 (Harness Maintenance)

- **HM1** 新增/移动 `docs/` 下任何文件或子目录 → 同一次改动内更新本文件的快速导航表和项目目录树
- **HM2** 实质性修改任一 docs 文件 → 同步更新其 frontmatter `last_updated`
- **HM3** 项目定位/阶段发生变化（如"研究"→"实盘"）→ 立即更新本文件的项目简介
- **HM4** 文档只写绝对日期 `YYYY-MM-DD`，禁止"今晚 / 明天 / T+1 后"类相对时间
- **HM5** `docs/` 不得引用仓库外路径（如 `~/.claude/plans/...`）作为权威内容；需要就把内容摘要进仓
- **HM6** 问题状态的唯一权威是 `docs/issues.md`；`plan.md` 只链接 `ISS-XXX`，不复述其状态

<!-- 按项目领域在此添加专属规则分组，例如：

### SEC — 安全
- **SEC1** ...

### TX — 交易执行
- **TX1** ...

### DATA — 数据层
- **DATA1** ...
-->

---

## 提交规范

前缀 + 冒号 + 中文描述：

```
feat: 新增功能
fix: 修复 bug
docs: 文档变更
refactor: 重构（不改功能）
chore: 工具 / 配置变更
```

---

## 技术栈

{{STACK}}

---

## 项目目录

```
[在此粘贴 src/ 或项目根目录树，精简到 2 层]
```

---

## 常用命令

```bash
[在此填写 dev / build / lint / start / stop / deploy 等命令]
```
