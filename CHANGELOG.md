# Changelog

版本号对应模板 `AGENTS.md` frontmatter 中的 `harness_version`。

## v7.1 — D7 修准（2026-10-28）

源于 v7 复查 review（5 条均复现属实）。

- **D7 检查 git 内容而非工作区**：暂存区（下次提交）+ HEAD + 待推送提交新增的行（无上游则全部历史）；位置标注为 `path:行` / `HEAD:path:行` / `<提交>:path`。此前提交 token 后只清工作区即可绕过
- **修 HM6 中文解析**：`perl -CSD` 下源码中文字面量未按 UTF-8 解码，「本地专用…。」从不匹配、退回整行，第二句里的路径也被当成本地专用；改为按字节匹配
- **修 token 模式被当成 git 选项**：以 `-----BEGIN` 开头的模式改用 `-e` 传入
- **IP 口径统一**：文件与提交说明共用一个过滤（各段 ≤ 255，排除 0/8 · 10/8 · 127/8 · 169.254/16 · 172.16/12 · 192.168/16），私有声明对两者同样生效
- **处置分级**：凭据（❌）先轮换；地址类（⚠️）先人工确认，地址暴露 ≠ 凭据泄露，不默认改写历史 / 删库
- **默认入仓策略**：从「公开 / 个人项目整体本地化 docs、AGENTS.md、部署脚本」改为按内容敏感性隔离——harness 与部署逻辑入仓，凭据与服务器清单本地专用；HM6 模板随之改写，不再需要「私有入仓」特殊变体
- **UI1 中文释义放宽**：只删重复、无信息量的文案，保留表单提示、单位、错误原因等完成任务所需的说明
- 规则条数与 `harness_version` 不变

## v7 — 仓库安全（2026-10-28）

源于 hyperflow：文档持续积累部署 / 服务器细节，入不入仓要在脚手架期定；巡检又发现私有仓库「运维配置有意入仓」没有写法，doctor 把 HM6 里任意反引号都当本地专用路径误报 ❌、已接受的服务器 IP 每次重报。

- **新增 HM6 仓库安全**：句式固定为「仓库安全（可见性）：本地专用 <清单>。…」；新增 placeholder `{{REPO_VISIBILITY}}`、`{{PRIVATE_PATHS}}`（无则写 `无`）；「私有入仓」变体允许 docs 与运维配置入仓，密钥 / token / .env 仍不入仓，改公开前清理并改写历史
- **SKILL.md**：Step 2 询问可见性与本地专用路径；Step 3 追加 `.gitignore`、HM6 句式两条裁剪；Guardrails 不把运维细节写进入仓文件
- **doctor.sh 新增 D7**：本地专用路径仍被跟踪（只解析「本地专用」到第一个「。」）；声明私有但 `gh` 查得 PUBLIC 报 ❌；入仓密钥 / token、`.env` 被跟踪；入仓文件与提交说明含公网 IP（声明私有时只备注）；缺 HM6
- **doctor.sh D6**：30 天净增长不计 lock 文件
- **doctor.md**：D7 命中后的处置（改写历史 / 删库重建 / 联系 GitHub Support，凭据一律轮换）、HM6 句式升级
- 核心规则 12 → 13 条（HM6），`harness_version` 6 → 7

## v6.2 — UI 反 AI slop（2026-10-23）

源于社区经验（@luinlee）：模型（尤其 Opus）生成 UI 时爱堆 slogan 和说明性文字，界面像说明书；一句 "Avoid unnecessary secondary labels and descriptions. Let the layout do the explaining." 即可明显改善，让模型把精力放在 UI/UX 设计上。

- AGENTS.md 模板：新增**可选 UI 规则组**（`UI1`，保留英文原句 + 一句中文理由），无界面项目在脚手架期删除，不占常载预算
- SKILL.md Step 3：新增按技术栈保留 / 删除 UI 块的裁剪步骤
- doctor.md：人工项新增「有 UI 但无 `UI1`」→ 建议补上
- 核心 12 条与 `harness_version` 不变

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
