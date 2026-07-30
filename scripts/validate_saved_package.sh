#!/usr/bin/env bash

set -u

usage() {
  printf '用法: %s <文档目录> [--deep-zh] [--no-code] [--theme-glob <文件模式>]\n' "$0" >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 2
fi

doc_dir=$1
shift
deep_zh=false
no_code=false
theme_glob='0[1-9]-*.md'

while [[ $# -gt 0 ]]; do
  case "$1" in
    --deep-zh) deep_zh=true ;;
    --no-code) no_code=true ;;
    --theme-glob)
      shift
      if [[ $# -eq 0 ]]; then
        usage
        exit 2
      fi
      theme_glob=$1
      ;;
    *) usage; exit 2 ;;
  esac
  shift
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
  for file in "${files[@]}"; do
    source_tour_line=$(
      awk '
        /^(```|~~~)/ {
          in_fence = !in_fence
          next
        }
        /^#{1,6}[[:space:]]/ {
          match($0, /^#+/)
          level = RLENGTH
          if (in_evidence && level <= evidence_level) {
            in_evidence = 0
            evidence_level = 0
          }
          if ($0 ~ /(证据|验证|源码定位|代码定位|实现定位|Evidence)/) {
            in_evidence = 1
            evidence_level = level
          }
        }
        !in_fence && !in_evidence && ($0 ~ /\.(go|ts|tsx|js|py)(:[0-9]+)?([^A-Za-z0-9_]|$)/ || $0 ~ /\/internal\// || $0 ~ /(^|[[:space:]])func[[:space:]]/ || $0 ~ /[A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*\(/) {
          print NR
          exit
        }
      ' "$file"
    )
    if [[ -n "$source_tour_line" ]]; then
      fail "$(basename "$file"):$source_tour_line 在证据章节之外出现源码路径或实现标识"
    fi
  done
fi

if [[ "$deep_zh" == true ]]; then
  themes=()
  while IFS= read -r -d '' file; do
    themes+=("$file")
  done < <(find "$doc_dir" -maxdepth 1 -type f -name "$theme_glob" -print | sort | mapfile_compat)

  if [[ ${#themes[@]} -eq 0 ]]; then
    fail "没有找到匹配 $theme_glob 的正式主题文档"
  fi

  required_concepts=(
    '整体方法或完整流程|^#{2,3}[[:space:]].*(整体方法|整体流程|完整流程|方法总览|一次任务)'
    '具体实现步骤|^#{2,3}[[:space:]].*(怎样实现|如何实现|详细实现|拆解实现|实现步骤|三个实现|方法细节|关键设计)'
    '失败、取舍或事实边界|^#{2,3}[[:space:]].*(失败|异常|取舍|事实边界)'
    '验证或证据|^#{2,3}[[:space:]].*(验证|证明|证据)'
    '简历或面试表达|^#{2,3}[[:space:]].*(简历|面试|STAR|快速复习)'
    '深挖问题或追问|^#{2,3}[[:space:]].*(追问|深挖|高频问题)'
  )

  for file in "${themes[@]}"; do
    if ! sed -n '1,100p' "$file" | rg -q '(具体问题|工程问题|痛点|场景|目标|记忆句|一句话)'; then
      fail "$(basename "$file") 开头缺少具体问题或故事主张"
    fi

    mermaid_count=$(rg -c '^(```|~~~)mermaid[[:space:]]*$' "$file" || true)
    if [[ "$mermaid_count" -lt 1 ]]; then
      fail "$(basename "$file") 缺少整体方法图"
    fi

    for concept in "${required_concepts[@]}"; do
      label=${concept%%|*}
      pattern=${concept#*|}
      if ! rg -q "$pattern" "$file"; then
        fail "$(basename "$file") 缺少语义章节: $label"
      fi
    done

  done
fi

if [[ "$errors" -gt 0 ]]; then
  printf '校验失败: 共 %d 个问题\n' "$errors" >&2
  exit 1
fi

if [[ "$deep_zh" == true ]]; then
  printf '校验通过: %s 中共 %d 份 Markdown 文档，其中 %d 份正式主题匹配 %s\n' \
    "$doc_dir" "${#files[@]}" "${#themes[@]}" "$theme_glob"
else
  printf '校验通过: %s 中共 %d 份 Markdown 文档\n' "$doc_dir" "${#files[@]}"
fi
