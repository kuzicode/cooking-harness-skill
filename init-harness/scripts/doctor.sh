#!/usr/bin/env bash
# init-harness doctor — 确定性只读巡检。用法：bash doctor.sh [项目根目录]
# 输出 markdown 表格行；人工判断项见 references/doctor.md。兼容 macOS bash 3.2 / BSD 工具。
set -u
cd "${1:-.}" || exit 2

if [ ! -f AGENTS.md ]; then
  echo "未发现 AGENTS.md：不是本套 harness 项目，跳过巡检。"
  exit 0
fi

N_WARN=0; N_FAIL=0
row()  { printf '| %s | %s | %s | %s |\n' "$1" "$2" "$3" "${4:-}"; }
ok()   { row "$1" "$2" "✅" "${3:-}"; }
warn() { row "$1" "$2" "⚠️" "$3"; N_WARN=$((N_WARN + 1)); }
fail() { row "$1" "$2" "❌" "$3"; N_FAIL=$((N_FAIL + 1)); }
oneline() { tr '\n' ' ' | sed 's/ *$//'; }
# 去掉 <!-- --> 注释块（模板里的示例条目不算正文）
nocomment() { [ -f "$1" ] && awk '/<!--/{c=1} !c{print} /-->/{c=0}' "$1"; }

ISS=docs/issues.md; ISS_AR=docs/issues-archive.md; PLAN=docs/plan.md; PLAN_AR=docs/plan-archive.md

echo "| # | 检查 | 结果 | 详情 |"
echo "|---|---|---|---|"

# ---------- D1 issues.md 完整性 ----------
if [ -f "$ISS" ]; then
  heads=$({ nocomment "$ISS"; nocomment "$ISS_AR"; } | grep -oE '^## ISS-[0-9]+' | sed 's/^## //')
  dup=$(printf '%s\n' "$heads" | grep . | sort | uniq -d | oneline)
  [ -n "$dup" ] && fail D1 "ISS 重复 ID" "$dup" || ok D1 "ISS 重复 ID"

  first_two=$(nocomment "$ISS" | grep -oE '^## ISS-[0-9]+' | head -2 | sed 's/^## //' | oneline)
  set -- $first_two
  if [ $# -eq 2 ] && [ "$(echo "$1" | awk -F- '{print $2 + 0}')" -lt "$(echo "$2" | awk -F- '{print $2 + 0}')" ]; then
    warn D1 "newest-first 排序" "前两条为 $1, $2（应递减）"
  else
    ok D1 "newest-first 排序"
  fi

  idx=$(grep -E '^\| *\[?ISS-[0-9]+' "$ISS" | sed -E 's/^\| *\[?(ISS-[0-9]+).*/\1/' | sort -u)
  body=$(printf '%s\n' "$heads" | grep . | sort -u)
  missing=$(comm -13 <(printf '%s\n' "$idx" | grep .) <(printf '%s\n' "$body") | oneline)
  ghost=$(comm -23 <(printf '%s\n' "$idx" | grep .) <(printf '%s\n' "$body") | oneline)
  if [ -n "$missing$ghost" ]; then
    warn D1 "索引对齐" "索引缺行: ${missing:-无}；幽灵行: ${ghost:-无}"
  else
    ok D1 "索引对齐"
  fi

  lines=$(wc -l < "$ISS" | tr -d ' ')
  resolved=$(nocomment "$ISS" | grep -cE '^## ISS-[0-9]+.*\[resolved\]')
  if [ "$lines" -gt 200 ] || [ "$resolved" -gt 15 ]; then
    warn D1 "归档阈值" "$lines 行 / $resolved 条 resolved → 最旧 resolved 迁 issues-archive.md"
  else
    ok D1 "归档阈值" "$lines 行 / $resolved 条 resolved"
  fi
fi

# ---------- D2 plan.md 不复述 ISS 状态（HM4） ----------
if [ -f "$PLAN" ]; then
  hits=$(grep -nE 'ISS-[0-9]+' "$PLAN" | grep -E 'open|resolved|superseded|已修复|已解决|已关闭|待修' | cut -d: -f1 | oneline)
  [ -n "$hits" ] && warn D2 "plan 复述 ISS 状态" "plan.md 行 $hits → 只留 ID 链接" || ok D2 "plan 复述 ISS 状态"
fi

# ---------- D3 导航表对齐（HM1） ----------
if [ -d docs ]; then
  unlisted=""
  for p in docs/*.md docs/*/; do
    [ -e "$p" ] || continue
    p=${p%/}
    grep -q "\`$p" AGENTS.md || unlisted="$unlisted $p"
  done
  dead=""
  for p in $(grep -oE '`docs/[^`]+`' AGENTS.md | tr -d '`' | sort -u); do
    [ -e "$p" ] || dead="$dead $p"
  done
  if [ -n "$unlisted$dead" ]; then
    warn D3 "导航表对齐" "未收录:${unlisted:- 无}；失效路径:${dead:- 无}"
  else
    ok D3 "导航表对齐"
  fi
fi

# ---------- D4 文档卫生 ----------
docs_md=$(ls AGENTS.md docs/*.md docs/*/*.md 2>/dev/null)

ext=$(grep -nE '~/\.claude|~/\.codex|/Users/|/home/' $docs_md 2>/dev/null | grep -v 'HM3' | cut -d: -f1,2 | oneline)
[ -n "$ext" ] && warn D4 "仓库外引用（HM3）" "$ext" || ok D4 "仓库外引用（HM3）"

if [ -f "$PLAN" ]; then
  rel=$(grep -nE '今晚|今早|明早|明天|后天|下周|T\+1 后' "$PLAN" | grep -v '下周期' | cut -d: -f1 | oneline)
  [ -n "$rel" ] && warn D4 "相对时间词（HM3）" "plan.md 行 $rel" || ok D4 "相对时间词（HM3）"
fi

a_lines=$(wc -l < AGENTS.md | tr -d ' ')
p_lines=0; [ -f "$PLAN" ] && p_lines=$(wc -l < "$PLAN" | tr -d ' ')
budget="AGENTS $a_lines / plan $p_lines 行"
if [ "$a_lines" -gt 150 ] || [ "$p_lines" -gt 100 ] || [ $((a_lines + p_lines)) -gt 250 ]; then
  warn D4 "常读层预算（HM5）" "${budget}（上限 150 / 100 / 合计 250）"
else
  ok D4 "常读层预算（HM5）" "$budget"
fi

big=$(awk '/^### /{g=$2} /^- \*\*[A-Z]+[0-9]+\*\*/{c[g]++} END{for(k in c) if(c[k]>6) printf "%s=%d ", k, c[k]}' AGENTS.md)
[ -n "$big" ] && warn D4 "规则组条数（HM5）" "${big}→ 细则下沉 conventions.md" || ok D4 "规则组条数（HM5）"

nofm=""
for f in $docs_md; do
  head -6 "$f" | grep -q '^last_updated:' || nofm="$nofm $f"
done
[ -n "$nofm" ] && warn D4 "frontmatter last_updated" "缺失:$nofm" || ok D4 "frontmatter last_updated"

# ---------- D5 可选项 ----------
S=.claude/settings.local.json
if [ -f "$S" ]; then
  n=$(awk '/"allow"[[:space:]]*:/{f=1; sub(/.*"allow"[[:space:]]*:[[:space:]]*\[/, "")} f{c+=gsub(/"[^"]*"/, "&"); if (/\]/) f=0} END{print c+0}' "$S")
  [ "$n" -gt 50 ] && warn D5 "permissions.allow 条目" "$n 条 → 建议清理一次性条目" || ok D5 "permissions.allow 条目" "$n 条"
fi
if [ -d .claude/worktrees ]; then
  wt=$(ls .claude/worktrees | wc -l | tr -d ' ')
  [ "$wt" -gt 0 ] && warn D5 "残留 worktree" "$wt 个 → 确认已合并后清理"
fi

# ---------- D6 代码健康（CH） ----------
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  over=$(git ls-files | grep -vE '(\.lock|-lock\.[a-z]+|\.md|\.json|\.svg|\.csv)$' | tr '\n' '\0' \
    | xargs -0 wc -l 2>/dev/null | awk '$2!="total" && $1>400 {printf "%s(%d) ", $2, $1}')
  [ -n "$over" ] && warn D6 "超 400 行文件" "${over}→ 拆分或记 🔧 技术债" || ok D6 "超 400 行文件"

  total=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  refac=$(git log --format=%s -50 2>/dev/null | grep -cE '^refactor(\(|:)')
  if [ "$total" -ge 30 ] && [ "$refac" -eq 0 ]; then
    warn D6 "重构提交占比" "近 50 次提交无 refactor:"
  else
    ok D6 "重构提交占比" "近 50 次中 $refac 次 refactor:"
  fi

  # 依赖锁定文件随装包自动生成，不计入代码增长
  lockre='(^|/)(package-lock\.json|npm-shrinkwrap\.json|pnpm-lock\.yaml|go\.sum|[^/]*\.lockb?|[^/]*-lock\.(json|ya?ml))$'
  set -- $(git log --since=30.days --numstat --format= 2>/dev/null \
    | awk -v lr="$lockre" '$1 ~ /^[0-9]+$/ && $3 !~ lr {a+=$1; d+=$2} END{print a+0, d+0}')
  if [ "$1" -gt 2000 ] && [ $(($2 * 10)) -lt "$1" ]; then
    warn D6 "30 天净增长" "+$1 / -$2 → 只增不减，安排精简 pass"
  else
    ok D6 "30 天净增长" "+$1 / -$2"
  fi
fi

if [ -f "$PLAN" ]; then
  debt=$(grep '^| 🔧' "$PLAN" | grep -vc '\[待重构模块\]')
  [ "$debt" -gt 5 ] && warn D6 "技术债积压" "$debt 行 → 安排整洁里程碑" || ok D6 "技术债积压" "$debt 行"
fi

if [ -f "$PLAN_AR" ]; then
  last=$(nocomment "$PLAN_AR" | awk '/^## /{s=""} {s=s $0 "\n"} END{printf "%s", s}')
  if printf '%s' "$last" | grep -q '^## '; then
    printf '%s' "$last" | grep -qE '^- \[x\] 精简 pass' \
      && ok D6 "最近归档里程碑精简 pass" \
      || warn D6 "最近归档里程碑精简 pass" "$(printf '%s' "$last" | head -1) 缺已勾选的 CH3 行"
  fi
fi

# ---------- D7 仓库安全（HM6） ----------
# 检查对象是 git 里的内容，不读工作区：暂存区（下次提交）· HEAD（已提交、暂存区已删的）· 待推送提交新增的行（无上游则为全部历史）
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  EXCL=(':!*-lock.*' ':!*.lock' ':!*.lockb' ':!go.sum')
  # git_scan <ERE>：输出「位置<TAB>内容」；位置为 path:行（暂存区）/ HEAD:path:行 / <提交>:path（待推送）
  git_scan() {
    { git grep -z -nIE --cached -e "$1" -- . "${EXCL[@]}"
      git rev-parse -q --verify HEAD >/dev/null && git grep -z -nIE -e "$1" HEAD -- . "${EXCL[@]}"
    } 2>/dev/null | perl -0777 -ne 'while (/([^\0\n]*)\0(\d+)\0([^\n]*)\n/g) {
        my ($f, $n, $c) = ($1, $2, $3); (my $k = $f) =~ s/^HEAD://;
        print "$f:$n\t$c\n" unless $seen{"$k:$n"}++ }'
    git rev-parse -q --verify HEAD >/dev/null || return 0
    up=$(git rev-parse -q --verify '@{u}' 2>/dev/null)
    git log -p --no-color --no-ext-diff --format='COMMIT %h' "${up:+$up..}HEAD" -- . "${EXCL[@]}" 2>/dev/null \
      | RE="$1" perl -ne 'if (/^COMMIT (\S+)/) { $h = $1 } elsif (m{^\+\+\+ b/(.*)}) { $f = $1 }
          elsif (/^\+(?!\+\+ )(.*)/) { my $c = $1; print "$h:$f\t$c\n" if $c =~ /$ENV{RE}/ && !$seen{"$h:$f"}++ }'
  }
  # 公网 IPv4（文件与提交说明同一口径）：输入「位置<TAB>内容」，输出位置。各段 ≤ 255，排除 0/8 · 10/8 · 127/8 · 169.254/16 · 172.16/12 · 192.168/16
  pubip() {
    perl -ne 'my ($loc, $c) = split /\t/, $_, 2;
      while ($c =~ /(?<![\d.])((\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}))(?![\d.])/g) {
        next if grep { $_ > 255 } ($2, $3, $4, $5);
        next if $1 =~ /^(?:0\.|10\.|127\.|169\.254\.|192\.168\.|172\.(?:1[6-9]|2\d|3[01])\.)/;
        print "$loc\n"; last }'
  }

  hm6=$(grep -E '^- \*\*HM6\*\*' AGENTS.md)
  if [ -z "$hm6" ]; then
    warn D7 "HM6 仓库安全规则" "AGENTS.md 缺 HM6 → 从模板补上并确认本地专用清单"
  else
    # 只解析「本地专用」到第一个「。」；按字节匹配（不开 -C：源码中文字面量与输入同为 UTF-8 字节）
    seg=$(printf '%s' "$hm6" | perl -ne 'print /本地专用(.*?)。/ ? $1 : (/^(.*?)。/ ? $1 : $_)')
    tracked=""
    for p in $(printf '%s' "$seg" | grep -oE '`[^` ]+`' | tr -d '`'); do
      [ -n "$(git ls-files -- "$p" 2>/dev/null | head -1)" ] && tracked="$tracked $p"
    done
    [ -n "$tracked" ] && fail D7 "本地专用路径未入仓" "仍被跟踪:$tracked → git rm --cached 并确认 .gitignore" || ok D7 "本地专用路径未入仓"
  fi
  # HM6 声明私有 → 服务器地址只备注；有 gh 时核对实际可见性
  private=""; printf '%s' "$hm6" | grep -q '私有' && private=1
  vis=$(command -v gh >/dev/null 2>&1 && gh repo view --json visibility -q .visibility 2>/dev/null)
  if [ -n "$private" ] && [ "$vis" = "PUBLIC" ]; then
    fail D7 "仓库可见性" "HM6 声明私有，实际 PUBLIC → 按 doctor.md D7 处置"; private=""
  elif [ -n "$vis" ]; then
    ok D7 "仓库可见性" "$vis"
  fi

  secret=$(git_scan '-----BEGIN [A-Z ]*PRIVATE KEY-----|(ghp|gho|ghs|github_pat)_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}' \
    | cut -f1 | head -10 | oneline)
  [ -n "$secret" ] && fail D7 "入仓内容含密钥 / token" "$secret → 凭据视为已泄露，先轮换，再按 doctor.md D7 移除" || ok D7 "入仓内容含密钥 / token"

  envf=$(git ls-files | grep -E '(^|/)\.env(\.|$)' | grep -vE '\.example$' | oneline)
  [ -n "$envf" ] && fail D7 ".env 被跟踪" "$envf → 凭据视为已泄露，先轮换" || ok D7 ".env 未入仓"

  # 地址类只需人工确认：私有仓库按 HM6 允许，只备注
  ip_row() {
    if [ -z "$2" ]; then ok D7 "$1"
    elif [ -n "$private" ]; then ok D7 "$1" "HM6 声明私有、允许：$2（改公开前清理）"
    else warn D7 "$1" "$2 → 人工确认是否服务器地址"; fi
  }
  ip_row "入仓内容含公网 IP" "$(git_scan '[0-9]{1,3}(\.[0-9]{1,3}){3}' | pubip | head -10 | oneline)"
  ip_row "提交说明含公网 IP" "$(git log -100 -z --format='%h%x09%s %b' 2>/dev/null | tr '\n\0' ' \n' | pubip | head -10 | oneline)"
fi

echo
echo "汇总：❌ ${N_FAIL} / ⚠️ ${N_WARN}。人工判断项见 references/doctor.md。"
