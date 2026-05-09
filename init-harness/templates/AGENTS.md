---
last_updated: {{TODAY}}
status: active
owner: {{OWNER}}
---

# {{PROJECT_NAME}} — Agent Guidelines

## 项目简介

{{TAGLINE}}

## 快速导航

| 你想做什么 | 去哪里看 |
|---|---|
| 当前迭代 / 活跃待办 | `docs/plan.md` |
| 历史已完成 / 已废弃方案 | `docs/plan-archive.md` |
| 详细架构 | `docs/architecture.md` |
| 编码约定 | `docs/conventions.md` |
| 踩坑记录（ISS-XXX） | `docs/issues.md` |
| 产品视图（面向 PM） | `docs/pm-overview.md` |

---

## 硬性规则（编号化）

### WF — 工作流 (Workflow)

- **WF1** > 5 个文件或非一行改动，先更新 `docs/plan.md` 再动手（Research → Plan → Build）
- **WF2** 解决一个非平凡 bug 后追加 `docs/issues.md` 一条 ISS-XXX（踩过两次的坑必须记）
- **WF3** 改动 > 500 行后主动问用户："有什么值得记入 memory 的经验？"
- **WF4** 破坏性改动用 worktree 隔离，review 后再合并
- **WF5** [根据项目需要追加，如"不主动运行 deploy.sh，提示用户手动执行"]

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
