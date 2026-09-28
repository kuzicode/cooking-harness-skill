---
last_updated: {{TODAY}}
status: active
owner: {{OWNER}}
harness_version: 5
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
> 查 `issues.md` 先读头部索引表，再按 `## ISS-XXX` 定位读单条，不整文件读。

---

## 硬性规则（编号化）

### WF — 工作流 (Workflow)

- **WF1** > 5 个文件或非一行改动，先更新 `docs/plan.md` 再动手（Research → Plan → Build）。不可协商。"这次改动很小，不用更新 plan" 不成立——阈值就是为"很小"的误判设的
- **WF2** 解决一个非平凡 bug 后立即追加 `docs/issues.md` 一条 ISS-XXX。"这个坑太琐碎不值得记" 不成立——踩过两次的坑必须记，而你无法预知哪个坑会被踩第二次
- **WF3** 改动 > 500 行后主动问用户："有什么值得记入 memory 的经验？"
- **WF4** 破坏性改动用 worktree 隔离，review 后再合并
- **WF5** 宣称"完成 / 修好了 / 测试通过"之前，必须实际运行能证明它的命令（测试 / 构建 / 复现步骤）并核对输出。"应该没问题 / 逻辑上是对的" 不算完成；没跑过验证就宣称完成等于虚报
- **WF6** [根据项目需要追加，如"不主动运行 deploy.sh，提示用户手动执行"]

### HM — Harness 维护 (Harness Maintenance)

- **HM1** 新增/移动 `docs/` 下任何文件或子目录 → 同一次改动内更新本文件的快速导航表和项目目录树
- **HM2** 实质性修改任一 docs 文件 → 同步更新其 frontmatter `last_updated`
- **HM3** 项目定位/阶段发生变化（如"研究"→"实盘"）→ 立即更新本文件的项目简介
- **HM4** 文档只写绝对日期 `YYYY-MM-DD`，禁止"今晚 / 明天 / T+1 后"类相对时间
- **HM5** `docs/` 不得引用仓库外路径（如 `~/.claude/plans/...`）作为权威内容；需要就把内容摘要进仓
- **HM6** 问题状态的唯一权威是 `docs/issues.md`；`plan.md` 只链接 `ISS-XXX`，不复述其状态
- **HM7** 常载预算：本文件 ≤ 150 行；单个领域规则组超过 6 条时，细则下沉到 `docs/conventions.md` 或专属文档，此处只留组名 + 一行摘要 + 链接。本文件是唯一常载文件，每多一行所有会话都要付费

### CH — 代码健康 (Code Health)

- **CH1** 收尾三问：每完成一个 plan 步骤或非平凡改动，宣称完成前依次自问：① 要记 ISS 吗（WF2）② 本次 diff 能精简吗——重复块、死代码、无用参数/分支、可复用却新写的实现 ③ 验证跑过了吗（WF5）。"先跑通以后再优化" 不成立——没有"以后"，每轮迭代只会叠加
- **CH2** 先搜后写：新增函数 / 工具 / 组件前先 grep 现有实现，能扩展就不复制。同一逻辑第三次出现必须抽取（Rule of Three）；前两次允许重复，不做投机抽象（YAGNI）
- **CH3** 结构与行为分离（Tidy First）：重构单独提交 `refactor:`，期间不改行为、测试保持绿；超出本次任务范围的重构不顺手做，记入 `plan.md` 的 `🔧 技术债` 行
- **CH4** 里程碑收尾做一次精简 pass（删死代码 / 合并重复 / 拆超限文件），作为验收 checkbox；阈值与细则见 `docs/conventions.md` 的「代码健康」节

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
