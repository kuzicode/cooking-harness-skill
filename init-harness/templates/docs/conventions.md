---
last_updated: {{TODAY}}
status: active
---

# 编码约定

<!-- 语言无关核心（保留）+ 可选块（脚手架时按 {{STACK}} 裁剪，不适用的块整段删除） -->

## 注释纪律

- **默认不写注释**
- 只在 WHY 不显然时加一行（隐藏约束、绕过特定 bug、违反直觉的写法）
- 不解释 WHAT（命名已说明）；不引用 task / PR / issue 编号（放 commit message）；不写多行注释块

## 命名规范

| 对象 | 规范 |
|---|---|
| 类 / 组件 / 类型 | PascalCase（接口无 `I` 前缀） |
| 函数 / 方法 | 按语言惯例（JS `camelCase` / Python `snake_case`） |
| 常量（模块顶层）| SCREAMING_SNAKE_CASE |
| 模块文件 | 按语言惯例（JS `kebab-case` / Python `snake_case`） |

## 代码健康

<!-- AGENTS.md CH 规则组的细则。目标：长期迭代后代码量与复杂度可控，不堆成屎山 -->

**阈值**（超出即"考虑拆分 / 精简"，不是硬拦）：

| 指标 | 阈值 |
|---|---|
| 单文件行数 | > 400 → 按领域拆分（不按文件类型） |
| 单函数行数 | > 50 |
| 嵌套层级 | > 3 → 提前 return / 抽函数 |
| 圈复杂度 | > 10 |
| 参数个数 | > 4 → 收成对象 / 数据类 |

**精简优先级**：删除 > 复用 > 合并 > 新写。删掉的行也是产出；能删的功能开关、兼容分支、注释掉的代码直接删（历史在 git 里）。

**结构**：入口层只负责编排；业务逻辑下沉到 `lib/` / 专属模块。

**防过度重构**（精简不是炫技）：
- 无测试覆盖的代码，先补特征测试（锁住现有行为）再重构
- Rule of Three 之前宁可重复——"重复远比错误的抽象便宜"
- 不为"将来可能"加配置项、flag、抽象层、插件点

**童子军规则的边界**：只清理本次改动触及的文件；跨模块大改不顺手做，走 CH3 → `🔧 技术债` 行 → 单独里程碑。

**里程碑精简 pass（CH4）检查项**：本里程碑新增的死代码 / 未用导出、重复块、超阈值文件与函数、临时调试代码与 TODO。

## 测试

- 单元测试：`tests/unit/`；fixtures 放 `tests/fixtures/`
- 集成 / E2E：`tests/e2e/`（或 `tests/integration/`）
- 覆盖优先级：核心计算逻辑 > 数据转换 > UI 交互

---

<!-- ▼ 可选块开始：以下按项目技术栈保留/删除 ▼ -->

## TypeScript（如适用）

- `strict: true`，禁裸 `any` / `object`
- 优先 `interface` 描述数据形状
- 导入顺序：标准库 → 第三方 → 本项目（按 lint 规则）
- 精简工具：`knip`（死代码 / 未用导出与依赖）、`jscpd`（重复块）、eslint `complexity` / `max-lines-per-function`

## Python（如适用）

- 类型注解全覆盖（或 mypy strict）
- 优先 `dataclass` / `TypedDict` 描述数据形状
- 导入顺序：标准库 → 第三方 → 本项目
- 精简工具：`vulture`（死代码）、`radon cc`（圈复杂度）、`ruff`（含 `C901` 复杂度规则）、`jscpd`（重复块）

## React / Next.js（如适用）

- `'use client'` 仅在需要 hook / 浏览器 API / 事件的组件里加；能用 Server Component 就用
- 跨页面共享状态 → Zustand；单页面局部状态 → `useState`；不超过 2 层 props drilling
- 异步数据：Server Component 直接 `await fetch`；Client Component 用 `useEffect` + loading state

## 样式（如适用）

- 使用语义色板变量，禁裸 hex 颜色值
- 断点：默认 mobile-first

<!-- ▲ 可选块结束 ▲ -->
