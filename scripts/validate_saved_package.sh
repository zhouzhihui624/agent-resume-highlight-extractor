#!/usr/bin/env bash

set -u

usage() {
  printf '用法: %s <文档目录> [--deep-zh] [--no-code]\n' "$0" >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

doc_dir=$1
shift
deep_zh=false
no_code=false

for arg in "$@"; do
  case "$arg" in
    --deep-zh) deep_zh=true ;;
    --no-code) no_code=true ;;
    *) usage; exit 2 ;;
  esac
done

if [[ ! -d "$doc_dir" ]]; then
  printf '错误: 文档目录不存在: %s\n' "$doc_dir" >&2
  exit 2
fi

if ! command -v rg >/dev/null 2>&1; then
  printf '错误: 需要安装 rg\n' >&2
  exit 2
fi

errors=0

fail() {
  printf '错误: %s\n' "$1" >&2
  errors=$((errors + 1))
}

mapfile_compat() {
  while IFS= read -r line; do
    printf '%s\0' "$line"
  done
}

files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(find "$doc_dir" -maxdepth 1 -type f -name '*.md' -print | sort | mapfile_compat)

if [[ ${#files[@]} -eq 0 ]]; then
  fail "没有找到 Markdown 文件"
fi

if [[ ! -f "$doc_dir/README.md" ]]; then
  fail "缺少 README.md"
fi

summary_count=$(find "$doc_dir" -maxdepth 1 -type f -name '00-*.md' | wc -l | tr -d ' ')
if [[ "$summary_count" -ne 1 ]]; then
  fail "应当只有一份 00-*.md 总览文档，实际找到 $summary_count 份"
fi

for file in "${files[@]}"; do
  fence_count=$(rg -c '^```' "$file" || true)
  if (( fence_count % 2 != 0 )); then
    fail "$(basename "$file") 的代码围栏没有成对闭合"
  fi

  if rg -q 'TODO|TBD| +$' "$file"; then
    fail "$(basename "$file") 中存在占位符或行尾空格"
  fi

  duplicate=$(awk 'length($0)>0 && $0==previous {print NR; exit} {previous=$0}' "$file")
  if [[ -n "$duplicate" ]]; then
    fail "$(basename "$file"):$duplicate 存在相邻重复行"
  fi
done

if [[ -f "$doc_dir/README.md" ]]; then
  while IFS= read -r link; do
    target=${link#./}
    if [[ ! -f "$doc_dir/$target" ]]; then
      fail "README 链接目标不存在: $target"
    fi
  done < <(rg -o '\]\(\./[^)]+\.md\)' "$doc_dir/README.md" | sed -E 's/^.*\]\((\.\/[^)]+)\)$/\1/')
fi

if [[ "$no_code" == true ]]; then
  if rg -n '\.(go|ts|tsx|js|py)\b|/internal/|func[[:space:]]' "${files[@]}" >/dev/null; then
    fail "要求不讲代码的文档包中仍存在源码路径或实现标识"
  fi
fi

if [[ "$deep_zh" == true ]]; then
  themes=()
  while IFS= read -r -d '' file; do
    themes+=("$file")
  done < <(find "$doc_dir" -maxdepth 1 -type f -name '0[1-9]-*.md' -print | sort | mapfile_compat)

  if [[ ${#themes[@]} -eq 0 ]]; then
    fail "没有找到编号主题文档"
  fi

  required_patterns=(
    '^## .*完整.*流程|^## 通俗流程'
    '^## .*底层操作原理'
    '^## .*失败|^## .*故障|^## .*异常'
    '^## 为什么这个亮点有含金量'
    '^## 简历表述|^## 适合简历的一句话'
    '^## 30 秒面试话术'
    '^## 2 分钟面试话术'
    '^## 10 分钟讲述顺序'
    '^## STAR 面试话术'
    '^## 面试追问怎么答'
    '^## .*表达边界|^## .*证据路径与表达边界'
  )

  for file in "${themes[@]}"; do
    for pattern in "${required_patterns[@]}"; do
      if ! rg -q "$pattern" "$file"; then
        fail "$(basename "$file") 缺少深挖文档章节: $pattern"
      fi
    done

    question_rows=$(awk '
      /^## 面试追问怎么答/ {inside=1; next}
      /^## / && inside {inside=0}
      inside && /^\|.*\|.*\|$/ {rows++}
      END {if (rows > 2) print rows - 2; else print 0}
    ' "$file")
    if [[ "$question_rows" -lt 8 ]]; then
      fail "$(basename "$file") 的面试追问少于 8 条"
    fi
  done
fi

if [[ "$errors" -gt 0 ]]; then
  printf '校验失败: 共 %d 个问题\n' "$errors" >&2
  exit 1
fi

printf '校验通过: %s 中共 %d 份 Markdown 文档\n' "$doc_dir" "${#files[@]}"
