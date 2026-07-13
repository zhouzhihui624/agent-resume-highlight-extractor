# Output Recipes

Read this reference when producing resume bullets, STAR stories, role/JD tailoring, or saved documents. Use only the recipe matching the user's request.

## Contents

- [Bullets Only](#bullets-only)
- [Evidence Audit](#evidence-audit)
- [Full Theme](#full-theme)
- [Interview Defense Pack](#interview-defense-pack)
- [JD Tailoring](#jd-tailoring)
- [Saved Document Package](#saved-document-package)
- [Ownership Ladder](#ownership-ladder)
- [Result Language](#result-language)
- [Example Transformation](#example-transformation)

## Bullets Only

Return exactly the requested count and length. Do the evidence analysis internally.

Pattern:

```text
[ownership-safe verb] + [mechanism/contribution] + [problem addressed] + [supported result]
```

Prefer concrete nouns and verbs over stacks of technology names. If the length limit is tight, keep the distinguishing mechanism and remove generic value language first.

## Evidence Audit

Use when the user has old or incomplete material:

```markdown
## 现在能安全写什么
[one conservative draft or a clear statement that evidence is insufficient]

## 当前证据能证明什么
- ...

## 还不能写什么
- ...

## 最关键的确认问题
1. ...
2. ...
3. ...
```

Ask no more than three questions. Choose questions that can upgrade ownership, technical depth, or results; omit broad questionnaires.

## Full Theme

```markdown
## [主题]

### 读完你应该能回答什么
- ...

### 先记住三句话
1. ...
2. ...
3. ...

### 先用一个例子建立直觉
...

### 术语小字典
| 中文说法（英文原词） | 通俗解释 |
| --- | --- |
| ... | ... |

### 适合简历的一句话
...

### 跟着一次完整任务走流程
1. ...

### 再下钻到底层操作原理
1. 输入/触发: ...
2. 编排/决策: ...
3. 状态/持久化: ...
4. 输出/评测: ...
5. 异常/恢复: ...
6. 关键取舍: ...

### 为什么有含金量
...

### STAR 面试话术
- S: ...
- T: ...
- A: ...
- R: ...

### 面试追问怎么答
- Q: ...
  A: ...

### 证据路径与表达边界
- 证据: ...
- 可以说: ...
- 不要说: ...

### 待补充指标
- ...
```

Omit `待补充指标` when no meaningful measurement can be suggested.

For full-analysis and interview modes, include at least one concrete Q&A per theme. STAR does not replace this slot.

For a short response, omit the teaching scaffolding that would make the answer bloated. For a saved deep-dive document, keep it when the reader is an intern, beginner, or has asked for plain language.

### Beginner Readability Gate

- Lead with a problem and one concrete flow, not an architecture noun stack.
- Introduce necessary terminology as `中文解释（English Term）`; prefer the Chinese phrase afterward.
- Keep source identifiers and exact struct/function names in the evidence appendix unless they are essential to the explanation.
- Use roughly 8-12 glossary terms per theme rather than cataloging every identifier.
- Keep glossary definitions self-contained; do not explain `Host` as “the program using the SDK” unless `SDK` is already explained.
- Label diagrams in the reader's language and immediately explain the path below the diagram.
- Preserve who decides, what state changes, what survives interruption, what can fail, and what trade-off remains. “通俗” must not become generic product copy.

Bad opening:

> Host injects IO into a Host-neutral SDK contract, then Run/Resume restores runtime-state.

Better opening:

> 外层应用负责提供模型、文件和命令行能力；智能体运行底座负责按统一流程推进任务。任务暂停后，系统会读取已经保存的会话记录和运行快照，从原位置继续。源码中把这两个入口称为 `Run` 和 `Resume`。

## Interview Defense Pack

Lead with a 60-90 second STAR answer, then prepare concise answers for:

- 为什么不是一次普通大模型接口调用？
- 核心数据流和状态流是什么？
- 如何测试或评估？
- 最大的失败模式是什么？
- 为什么选择这个方案而不是更简单的替代方案？
- 哪部分是你本人负责的？
- 结果如何衡量，哪些指标还没有？

The `Action` section must contain technical decisions and work, not only coordination verbs. When no metric exists, make `Result` a verified capability such as reproducible regression, resumable approval, or consistent replay.

## JD Tailoring

First map requirements to evidence:

| JD requirement | Matching evidence | Strength | Resume angle |
| --- | --- | --- | --- |

Then write only the strongest tailored bullets. List material JD gaps separately; do not fill them with adjacent technologies.

Role emphasis:

- **AI Agent Engineer**: orchestration, tools, context, memory, evaluation, safety, tracing.
- **AI Application Engineer**: user workflow, business integration, reliability, evaluation, deployment.
- **Code Agent Engineer**: repository understanding, issue-to-patch loop, sandbox/tests, SWE-style evaluation.
- **Backend / AI Infra**: runtime boundaries, provider abstraction, state, recovery, permissions, cost and observability.

## Saved Document Package

Use a lean package:

```text
resume-highlight-docs/
  README.md
  00-summary-and-resume.md
  01-<strong-theme>.md
  02-<strong-theme>.md
  ...
```

`README.md` contains the index and reading order. The summary contains final bullets, project positioning, evidence status, and confirmation items. Each theme file follows the Full Theme recipe.

When revising an existing package, merge or remove weak duplicates. Do not preserve stale files merely because they already exist.

## Ownership Ladder

Choose the strongest evidence-supported level:

1. `主导 / 独立负责`: explicit ownership of the subsystem or workstream.
2. `负责 X 模块 / 设计并实现 X`: specific commits, MR/PRs, tasks, or user confirmation.
3. `参与建设 / 参与设计`: project capability is real, individual scope is partial or shared.
4. `协助实现 / 参与联调 / 完成调研与沉淀`: support contribution.

Do not use Git authorship alone to infer product ownership.

## Result Language

With verified metrics, state the metric and measurement context. Without metrics, prefer:

- 支持 / 打通 / 建立
- 沉淀为可复现、可回归的流程
- 形成可暂停、可恢复、可审计的执行语义
- 降低手工复现或排查成本
- 为后续模型对比或扩展提供统一基础

Avoid `显著提升`, `生产级`, `高并发`, `SOTA`, `完全自动化`, and invented percentages.

## Example Transformation

Evidence: the project uses a scripted model and in-memory IO to drive the real Agent `Run/Resume` path and assert tool calls, files, events, and session state.

Defensible bullet:

> 参与建设智能体场景化端到端测试体系，通过按剧本返回的模型替身与内存环境驱动真实任务启动和恢复流程，沉淀工具调用与中断恢复的可复现回归场景。

Why it works: it keeps the mechanism and ownership boundary, but does not require the reader to decode `E2E Harness`, `IO`, and `Run/Resume` before understanding the contribution. Exact source terms can still appear later in the evidence section.
