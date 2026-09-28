# Doctor — harness 漂移巡检清单

对已装本套 harness 的项目跑以下**只读**检查。逐项执行 → 汇总报告（漂移 / 位置 / 建议修复）→ 征询用户确认后再修。项目未启用某文件（如无 issues-archive.md）则跳过对应项。

> 设计原则：每项检查都是确定性的 grep / ls / 对比，不依赖主观判断；能一条命令说清就不读全文。

## D1 — issues.md 完整性

- **重复 ID**：`grep -oE '^## ISS-[0-9]+' docs/issues.md docs/issues-archive.md 2>/dev/null | sort | uniq -d` → 应为空。命中则建议：较新条目重编号为最大编号+1，并同步其在 plan.md / 其他 ISS 内的交叉引用。
- **排序**：正文前两个 `## ISS-` 编号应递减（newest-first）。混序则建议一次性重排。
- **索引对齐**：索引表的 ID 集合与正文 + archive 的 `## ISS-` 标题集合应双向一致（无索引缺行、无幽灵行）。
- **归档阈值**：正文 > 200 行或 resolved 条目 > 15 条 → 建议将最旧 resolved 迁 `issues-archive.md`。

## D2 — 跨文件状态一致

- 提取 plan.md 中出现的每个 `ISS-XXX`，与 issues.md 索引/标题中的 `[open|resolved|superseded]` 标签比对。plan.md 若复述了与权威不符的状态（违反 HM6）→ 以事实核实后统一，plan.md 改为只留 ID 链接。

## D3 — AGENTS.md 新鲜度

- **导航漂移**：`ls docs/`（含一层子目录）→ 每个 md 文件/子目录在快速导航表应有对应行；反向：导航表中的路径应真实存在。
- **目录树漂移**：AGENTS.md「项目目录」代码块 vs 实际两层目录（`find . -maxdepth 2 -type d -not -path '*/.*'` 或 `ls` 递归一层）→ 报告缺失/多余。
- **简介时效**：项目简介与 plan.md 当前活跃工作是否矛盾（如简介说"不做 X"而 plan 全是 X）→ 人工判断项，列出证据。
- **frontmatter staleness**：AGENTS.md `last_updated` 早于 issues.md 最新条目日期或 plan.md 最新里程碑日期 → 标记。

## D4 — 文档卫生

- **仓外引用**：`grep -nE '~/\.claude|~/\.codex|/Users/|/home/' AGENTS.md docs/*.md` → 命中即违反 HM5，建议把内容摘要进仓或删除引用（排除 HM5 规则行自身的示例文本这一固定误报）。
- **相对时间词**：`grep -nE '今晚|今早|明早|明天|后天|下周|T\+1 后' docs/plan.md` → 命中即违反 HM4（人工排除"下周期"类误报），建议改绝对日期或清理过期项。
- **plan.md 长度**：`wc -l docs/plan.md` > 100 → 建议完成章节迁 plan-archive.md。
- **常读层预算**：`wc -l AGENTS.md docs/plan.md` → AGENTS.md > 150 行，或两者合计 > 250 行 → 违反 HM7，建议规则细则下沉 `conventions.md`、完成项迁 `plan-archive.md`；顺带检查是否有单个规则组 > 6 条。
- **frontmatter 缺失**：docs 下每个 md 应有 `last_updated` frontmatter。

## D5 — 可选项

- `.claude/settings.local.json` 的 `permissions.allow` 条目 > ~50（尤其含具体 PID 的 `kill`、一次性 URL、转义 one-liner）→ 建议用 fewer-permission-prompts 类工具清理。本 skill 不代改 settings。
- 残留 `.claude/worktrees/` 下早已合并的旧 worktree → 提示用户确认后清理。

## D6 — 代码健康（CH 规则组的落地情况）

非 git 仓库则跳过本节。以下只给趋势信号，不做价值判断；结论交给用户。

- **超限文件**：`git ls-files | grep -vE '(\.lock|-lock\.|\.md|\.json|\.svg)$' | xargs wc -l 2>/dev/null | sort -rn | awk '$2!="total" && $1>400'` → 列出超 conventions 阈值的文件，建议拆分或记 `🔧 技术债`。
- **重构占比**：`git log --oneline -50 | grep -c ' refactor:'` → 为 0 且提交数 ≥ 30 时警告"近 50 次提交无结构整理"（违背 CH3 / CH4 的信号）。
- **净增长趋势**：`git log --since=30.days --numstat --format= | awk '{a+=$1; d+=$2} END {print a+0, d+0}'` → 删除 / 新增 < 0.1 且新增 > 2000 时提示"只增不减"，建议安排精简 pass。
- **技术债积压**：`grep -c '^| 🔧' docs/plan.md` > 5 → 建议开一个整洁里程碑集中偿还。
- **里程碑精简 pass**：plan-archive.md 最近归档的里程碑是否有已勾选的 CH4 验收行 → 缺失则标记。
- **可选工具**：项目已配置 `knip` / `vulture` / `jscpd` 等（见 conventions.md 对应语言块）则运行并附摘要；未配置则跳过，不安装依赖。

## 报告格式

```
## Harness Doctor 报告 — <项目名> (<日期>)

| # | 检查 | 结果 | 位置 | 建议 |
|---|---|---|---|---|
| D1 | ISS 重复 ID | ❌ ISS-027 ×2 | issues.md:65,436 | 后者重编号 ISS-032 |
| D3 | 导航漂移 | ⚠️ docs/design/ 未收录 | AGENTS.md 导航表 | 补行 |
| D6 | 超限文件 | ⚠️ src/engine.ts 812 行 | — | 按领域拆分或记 🔧 技术债 |
| ... | | ✅ | | |
```

只报告不修复；用户确认后逐项修，每修一项同步受影响的交叉引用与 `last_updated`。
