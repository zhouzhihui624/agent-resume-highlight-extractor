---
name: agent-resume-highlight-extractor
description: Use when the user wants to extract or strengthen AI Agent/LLM engineering experience from repositories, docs, PRDs, commits, tests, prompts, traces, or project notes for a resume, internship application, project summary, STAR story, interview deep dive, or job-description tailoring, especially requests mentioning 简历亮点, 项目包装, 含金量, AI Harness, Agent evaluation, 评测, 底层原理, 面试话术, or ownership boundaries.
---

# Agent Resume Highlight Extractor

## Purpose

Turn real project evidence into resume claims the user can defend in an interview. Treat the task as technical due diligence followed by communication, not as copywriting. Technical correctness is insufficient if the intended reader cannot follow the explanation.

Default to Chinese unless the user requests another language. For beginner-facing Chinese output, introduce a necessary term as `中文解释（English Term）` on first use, then prefer the Chinese wording. Keep source identifiers, APIs, and model/provider names unchanged in the evidence section.

## Non-Negotiable Contract

1. Inspect available evidence before drafting claims.
2. Separate **project capability** from **the user's contribution**. Repository presence proves the former, not the latter.
3. Never invent ownership, implementation depth, metrics, scale, launch status, or business impact.
4. Do not upgrade a simple LLM API integration into an Agent platform without orchestration, tools, state, evaluation, or comparable evidence.
5. Honor explicit scope. If the user asks for only two bullets, return only two bullets after doing the necessary analysis internally.
6. For resume packaging plus interview preparation, make each selected highlight defensible at three depths:
   - **Resume**: concise contribution and value.
   - **Plain-language workflow**: what happens end to end.
   - **Implementation principle**: data/state/control flow, boundaries, failure handling, and trade-offs.
7. Teach before naming. Do not lead with unexplained terms, acronym stacks, source identifiers, or architecture labels when the user is an intern, beginner, or explicitly asks for plain language.
8. Plain language must preserve technical depth. Simplify the order and vocabulary, not the state flow, decision logic, recovery behavior, limitations, or trade-offs.

## Route the Request

Choose one primary mode before researching:

| Observable request | Default deliverable | Load on demand |
| --- | --- | --- |
| "only bullets", strict count/length | Exact requested bullets | `references/output-recipes.md` |
| old docs, unclear ownership, weak evidence | Safe draft + evidence gaps + at most 3 decisive questions | `references/evidence-and-theme-guide.md` |
| project analysis, 包装, 含金量, 4-5 亮点 | Ranked full analysis; use 2-5 themes based on evidence | Both references |
| 面试, STAR, 底层原理, deep dive | Interview defense pack for the strongest themes | Both references |
| save/revise a document package | Summary plus one file per strong theme | Both references |
| "看不懂", "太多英文", "很懵", "循序渐进" | Rewrite with a beginner-readable teaching sequence; preserve evidence and depth | `references/output-recipes.md` |
| tailor to a JD or role | Requirement-to-evidence mapping plus tailored bullets | `references/output-recipes.md` |

An explicit user format overrides this table. Do not append unrequested sections "for completeness."

## Workflow

### 1. Establish Scope

Identify:

- available artifacts and repository roots
- target role and seniority
- requested count, length, language, and output location
- whether the user wants bullets, understanding, interview defense, or all three
- ownership context already supplied by the user

Do not block when a safe partial answer is possible. If essential ownership or result information is missing, draft conservatively and ask only the questions that would materially change the wording.

### 2. Inspect Evidence

Start with orientation material, then verify important claims against stronger artifacts:

1. project instructions, `README`, architecture docs, PRDs, and existing project-understanding docs
2. source entry points, interfaces, prompts, schemas, configs, and migrations
3. tests, evals, fixtures, traces, replay artifacts, CI, and benchmark reports
4. commit history, PR/MR evidence, logs, and explicit user statements

Inspect Chinese-named documentation directories early when present, but treat them as orientation unless corroborated. When docs and implementation disagree, use the narrower confirmed claim and state the uncertainty.

For large projects, split independent evidence families across subagents only when delegation is available and authorized. Give each agent a distinct read scope, collect raw evidence, and perform theme selection and final wording in one unifying pass.

Read `references/evidence-and-theme-guide.md` when the project has multiple Agent/LLM subsystems, when evaluation terminology is ambiguous, or when deciding whether a mechanism is strong enough to headline.

### 3. Build a Claim Ledger

Build this internally for every candidate highlight:

| Claim component | Required question |
| --- | --- |
| Project fact | What observable artifact proves this exists? |
| Mechanism | How does data, state, or control move through it? |
| Contribution | What did the user personally design, implement, evaluate, debug, or document? |
| Engineering value | Which reliability, quality, safety, cost, or product problem does it address? |
| Result | What measured outcome or safely stated capability followed? |
| Boundary | What nearby stronger claim is not proven? |

Classify wording readiness:

- `可直接写`: mechanism and contribution are supported.
- `需降级措辞`: project mechanism is supported, but ownership or impact is incomplete.
- `需本人确认`: a specific user answer could make the claim usable.
- `不使用`: the claim depends on guesswork or marketing language.

Do not expose the full ledger unless the user asks for an evidence audit.

### 4. Select Themes

Select **2-5 distinct themes**, not a quota. If the user asks for 4-5 but only three are defensible, return three and explain why.

Rank candidates by:

1. evidence strength
2. technical depth and interview discussability
3. ownership defensibility
4. relevance to the target role
5. distinctness from the other selected themes

Merge themes that tell the same engineering story. Prefer a smaller set of mechanisms the user can explain deeply over a broad feature inventory.

### 5. Explain the Mechanism

For full or interview-oriented output, explain each theme without narrating source line by line:

1. trigger/input
2. orchestration or decision path
3. state and persistence changes
4. output, assertion, score, or human decision
5. failure/recovery path
6. why this design differs from a single LLM call
7. one important trade-off or limitation

Name key modules, interfaces, stores, prompts, tests, or artifacts when they improve precision. If the user asks for a non-code explanation, keep identifiers in the evidence appendix rather than the main narrative.

For beginner-facing output, present that material in this teaching order:

1. state what problem exists in ordinary language
2. use one accurate familiar analogy or minimal example to build intuition
3. walk through the complete happy path before splitting it into components
4. explain the control flow, state changes, failure/recovery path, and one trade-off
5. compress the understanding into resume and interview language only after the mechanism is clear

Use the following readability rules:

- Start with `读完你应该能回答什么` and `先记住三句话` for long saved theme documents.
- Limit the glossary to roughly 8-12 terms that are necessary for the theme.
- Explain every term at first use; do not rely on a glossary at the end to repair unexplained jargon earlier.
- Make each glossary definition self-contained. Do not define one unfamiliar term with another undefined acronym or source identifier.
- Prefer Chinese headings and diagram labels. After every diagram, walk through it once in natural language.
- Avoid sentences built from several English labels such as `Host-neutral SDK contract + runtime-state + Resume`. Translate the relationship first, then add exact source names only where they help evidence or interview recall.
- Do not force an analogy when it distorts the mechanism. A small concrete scenario is better than an inaccurate metaphor.

### 6. Draft Conservatively

Use `contribution + mechanism + problem/value + supported result`.

For students and interns, default to `参与建设`, `参与设计`, `负责其中 X 模块`, or `围绕 X 完成实现/评测/文档沉淀`. Use `主导`, `独立负责全链路`, or equivalent only with explicit evidence.

When metrics are absent:

- state enabled capabilities such as `支持`, `打通`, `沉淀`, `可复现`, `可回归`, or `可恢复`
- suggest relevant metrics separately as `待补充指标`
- never insert placeholder numbers into a directly usable bullet

Existing tests prove that a behavior is covered, not that all tests currently pass. Claim a passing test run only when it was run and observed during the task.

Read `references/output-recipes.md` before producing structured bullets, STAR stories, JD-tailored variants, or a saved document package.

## Default Full-Theme Contract

When the user asks for comprehensive packaging or interview preparation, populate every required slot below for each selected theme. `待补充指标` is the only optional slot.

- `读完你应该能回答什么`: for long beginner-facing documents
- `先记住三句话`: three plain-language anchors
- `生活化直觉或最小例子`
- `术语小字典`: approximately 8-12 necessary terms, Chinese-first
- `适合简历的一句话`
- `通俗流程`
- `底层操作原理`
- `为什么有含金量`
- `STAR 面试话术`
- `面试追问怎么答`: at least one likely follow-up question with a compact answer
- `证据路径与表达边界`
- `待补充指标` only when useful

For evidence-poor requests, replace this contract with a safe draft, explicit unknowns, and at most three decisive questions. Do not manufacture a deep-dive section from generic Agent knowledge.

## Final Verification

Before answering or saving files, confirm:

- the response matches the exact requested scope and count
- every headline claim has evidence or is clearly marked as user-provided
- project capability and personal ownership are not conflated
- selected themes are distinct and strong enough to defend
- metrics, scale, production status, and business impact were not invented
- full/interview output covers workflow, implementation principles, STAR, and at least one follow-up Q&A per theme
- beginner-facing output follows problem -> intuition -> full flow -> mechanism -> failure/trade-off -> interview expression
- necessary terms are explained at first use, headings do not stack unexplained English labels, and source identifiers stay mainly in evidence sections
- glossary definitions do not introduce a second unexplained acronym or architecture label
- diagrams use reader-appropriate labels and are followed by a natural-language walkthrough
- mocked runtime tests are not mislabeled as model-quality evaluation
- evidence-poor cases ask no more than three high-value questions
- saved packages contain no `TODO`, `TBD`, stale duplicate themes, or unreachable evidence paths
