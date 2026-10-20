# Changelog

版本号对应模板 `AGENTS.md` frontmatter 中的 `harness_version`。

## v6.1 — 精简工具落地（2026-10-20）

源于 hyperflow 巡检：conventions 语言块只列了工具名、doctor 对「未配置」直接跳过，老项目升级后 CH 阈值表除文件行数外长期无任何检查。

- conventions 模板：TS / Python「精简工具」改为可执行建议——包成只报告、不拦提交的 `health` 脚本（不混进 lint），首次结果记技术债基线；TS 补 `max-depth` / `max-params` 与阈值表对齐；CH3 检查项注明以 `health` 输出为准、只处理新增命中
- doctor.md：精简工具人工项改为「有 health 就跑并对比基线，没有就建议落地（征得同意再装依赖）」，并提示老项目语言块缺工具行
- 规则条数与 `harness_version` 不变

## v6 — 精简（2026-09-28）

依据 Anthropic Claude Code 官方最佳实践与 ETH 2026《Evaluating AGENTS.md》：常载文件越短越好，只写模型从代码里看不出、不写就会犯错的内容。

- **规则 17 → 12 条**：WF2 / WF3 / WF5 与 v5 的"收尾三问"合并为 **WF2 完成门**（验证并附证据 → 精简 diff → 记 ISS → 问 memory）；HM 7 → 5 条；CH 4 → 3 条
- **WF1 门槛**：从"> 5 个文件或非一行改动"改为"跨文件、或无法一句话说清 diff"
- **删除**：AGENTS.md 项目目录树；conventions 中的命名表、import 顺序、React / 样式块；`pm-overview.md` 模板；plan.md「文档同步 TODO」
- **语气**：去掉"不可协商"类激进措辞，每条规则最多一句理由
- **新增 `scripts/doctor.sh`**：一次跑完 D1–D6 确定性只读检查（兼容 macOS bash 3.2）；`references/doctor.md` 只保留人工判断项
- SKILL.md「Harness Conventions」改为只写设计原则，不再复述模板细节
- AGENTS.md 模板 105 → 66 行

## v5 — 代码健康（2026-09-28）

应对长期 agent 迭代"只增不减"（GitClear：AI 普及后重复代码块 +81%，重构类代码移动大幅下降）。

- 新增 **CH 代码健康规则组**：先搜后写 + Rule of Three、Tidy First（重构单独提交，范围外重构记 `🔧 技术债`）、里程碑精简 pass
- conventions.md 新增「代码健康」：量化阈值、精简优先级、防过度重构、各语言精简工具
- Doctor 新增 D6：超限文件、重构提交占比、净增长趋势、技术债积压

## v4 — 常载预算治理

AGENTS.md ≤ 150 行（HM7）、issues 先查索引再读单条、归档阈值 300 → 200、Doctor 检查常读层预算。

## v3 — 吸收 superpowers 理念

WF5 完成前验证门、WF1 / WF2 反合理化措辞、issues 经验升级规则。

## v2 — 自维护 harness

HM 规则组、issues 索引 / 归档、Doctor 巡检模式。

## v1 — 初版

`init-harness` skill：AGENTS.md + CLAUDE.md pointer + docs/ 模板；适配 Codex。
