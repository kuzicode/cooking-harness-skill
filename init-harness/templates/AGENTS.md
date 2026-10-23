---
last_updated: {{TODAY}}
status: active
owner: {{OWNER}}
harness_version: 6
---

# {{PROJECT_NAME}} — Agent Guidelines

{{TAGLINE}}

技术栈：{{STACK}}

## 快速导航

| 你想做什么 | 去哪里看 | 加载 |
|---|---|---|
| 当前迭代 / 活跃待办 | `docs/plan.md` | 常读 |
| 历史已完成 / 已废弃方案 | `docs/plan-archive.md` | 默认不读 |
| 详细架构 | `docs/architecture.md` | 按需 |
| 编码约定 / 代码健康阈值 | `docs/conventions.md` | 按需 |
| 踩坑记录（ISS-XXX） | `docs/issues.md` | 按需 |
| 已归档的历史 ISS | `docs/issues-archive.md` | 默认不读 |

> 查 `issues.md` 先读头部索引表，再按 `## ISS-XXX` 定位单条，不整文件读。

## 硬性规则

### WF — 工作流

- **WF1** 跨文件、或无法一句话说清 diff 的改动 → 先更新 `docs/plan.md`（问题 / 方案 / 影响文件 / 验收）再动手。阈值针对的正是"看起来很小"的误判
- **WF2** 完成门——宣称完成前依次做完：
  1. 跑能证明它的命令（见「常用命令」），回复里附命令与关键输出；没跑过就不算完成
  2. 精简本次 diff：重复块、死代码、无用参数/分支、可复用却新写的实现——没有"以后再优化"
  3. 解决了非平凡 bug → 追加 `docs/issues.md` 一条 ISS（无法预知哪个坑会被踩第二次）
  4. 本次改动 > 500 行 → 问用户有无经验值得记入 memory
- **WF3** 破坏性改动用 worktree 隔离，review 后再合并
- **WF4** [项目专属，如"不主动运行 deploy.sh，提示用户手动执行"]

### HM — Harness 维护

- **HM1** `docs/` 增删移文件，或项目定位变化 → 同一次改动内更新本文件的导航表 / 简介
- **HM2** 实质修改 docs 文件 → 更新其 frontmatter `last_updated`（`docs/` 可能被 gitignore，不能靠 git 历史）
- **HM3** 文档只写绝对日期 `YYYY-MM-DD`；不以仓库外路径（如 `~/.claude/plans/`）作为权威内容，需要就摘要进仓
- **HM4** 问题状态的唯一权威是 `docs/issues.md`；`plan.md` 只链接 `ISS-XXX`，不复述状态
- **HM5** 本文件是唯一常载文件，≤ 150 行；领域规则组超过 6 条时细则下沉 `docs/conventions.md`，此处只留摘要 + 链接

### CH — 代码健康

- **CH1** 先搜后写：新增函数 / 工具 / 组件前先 grep 现有实现，能扩展就不复制。同一逻辑第三次出现才抽取（Rule of Three），不做投机抽象
- **CH2** 结构与行为分离（Tidy First）：重构单独提交 `refactor:`，不改行为、测试保持绿；超出本次范围的重构不顺手做，记入 `plan.md` 的 `🔧 技术债` 行
- **CH3** 里程碑收尾做一次精简 pass（删死代码 / 合并重复 / 拆超限文件），作为验收 checkbox；阈值见 `docs/conventions.md`「代码健康」

<!-- ▼ 可选：项目有 UI（Web / App / 桌面 / TUI）时保留，否则删除 ▼ -->
### UI — 界面

- **UI1** Avoid unnecessary secondary labels and descriptions. Let the layout do the explaining. ——不加 slogan、副标题、说明性小字；靠层级、分组、留白、对齐表达信息，需要解释时先改设计
<!-- ▲ 可选块结束 ▲ -->

<!-- 按项目领域追加规则组（如 SEC / DATA / API），编号 <前缀><数字> -->

## 提交规范

前缀 `feat / fix / docs / refactor / chore` + 冒号 + 中文描述。

## 常用命令

<!-- 必须包含验证命令（test / lint / typecheck / build）——WF2 完成门依赖它 -->

```bash
[dev / test / lint / build / deploy 等命令]
```
