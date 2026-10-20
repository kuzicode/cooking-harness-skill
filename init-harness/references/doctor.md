# Doctor — harness 漂移巡检

对已装本套 harness 的项目做**只读**巡检 → 汇总报告 → 征询用户确认后再修。

## 1. 跑脚本（确定性检查）

```bash
bash <skill 目录>/scripts/doctor.sh [项目根目录]
```

脚本输出 markdown 表格行，项目缺少的文件自动跳过。覆盖：

| 组 | 检查 |
|---|---|
| D1 issues | 重复 ID、newest-first 排序、索引 ↔ 正文对齐、归档阈值（>200 行或 >15 条 resolved） |
| D2 跨文件 | plan.md 复述 ISS 状态（HM4） |
| D3 导航 | docs/ 文件 / 子目录 ↔ AGENTS.md 导航表双向对齐（HM1） |
| D4 卫生 | 仓库外路径、相对时间词（HM3）；常读层预算、规则组 > 6 条（HM5）；frontmatter `last_updated` 缺失 |
| D5 可选 | `.claude/settings.local.json` allow 条目 > 50、残留 `.claude/worktrees/` |
| D6 代码健康 | 超 400 行文件、近 50 次提交无 `refactor:`、30 天只增不减、`🔧 技术债` 积压 > 5、最近归档里程碑缺 CH3 精简 pass |

## 2. 人工判断项（脚本做不了）

- **简介时效**：AGENTS.md 开头定位 / 技术栈与 plan.md 当前活跃工作是否矛盾（如简介说"不做 X"而 plan 全是 X）→ 列出证据。
- **状态分歧取证**：D2 命中时，先按代码 / 测试事实核实 ISS 真实状态，再统一到 issues.md，plan.md 只留 ID。
- **重复 ID 修复**：较新条目重编号为最大编号 + 1，同步 plan.md / 其他 ISS 内的交叉引用。
- **精简工具**：项目有 `health` 脚本（或已配置 `knip` / `vulture` / `jscpd` 等）→ 运行并附摘要，对比 plan.md 技术债基线看是否恶化；没有 → 报告「CH 阈值除文件行数外无工具覆盖」，建议按 conventions.md 语言块「精简工具」落地，**征得同意再装依赖**。老项目的 conventions 语言块缺这一行时一并提示（模板升级未合并）。
- **规则仍被需要吗**：AGENTS.md 中是否有模型不写也会遵守的规则、或从代码可直接读出的内容 → 建议删除（每行都是所有会话的常载成本）。

## 报告格式

```
## Harness Doctor 报告 — <项目名> (<日期>)

| # | 检查 | 结果 | 详情 |
|---|---|---|---|
（脚本输出）
| 人工 | 简介时效 | ⚠️ | 简介写"研究阶段"，plan 已进入实盘 |
```

只报告不修复；用户确认后逐项修，每修一项同步受影响的交叉引用与 `last_updated`。
