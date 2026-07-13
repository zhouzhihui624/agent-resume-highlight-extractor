# Evidence and Theme Guide

Read this reference when a project contains several AI/Agent subsystems, when evaluation terminology is ambiguous, or when candidate highlights must be ranked.

## Contents

- [Evidence Strength](#evidence-strength)
- [Evaluation Taxonomy](#evaluation-taxonomy)
- [High-Value Theme Map](#high-value-theme-map)
- [Deep-Dive Checklist](#deep-dive-checklist)
- [Candidate Ranking](#candidate-ranking)
- [Metrics to Ask For, Not Invent](#metrics-to-ask-for-not-invent)

## Evidence Strength

Use evidence for the claim it can actually support:

| Evidence | Usually supports | Does not prove by itself |
| --- | --- | --- |
| source, interfaces, schemas, prompts | implemented mechanism | personal ownership or production use |
| focused tests and scenarios | intended and covered behavior | current pass status unless tests were run |
| traces, replay artifacts, eval reports | observed execution or evaluation process | broad business impact |
| architecture docs and PRDs | intended design and scope | completed implementation |
| commits and PR/MR history | contribution to specific changes | sole ownership of the whole subsystem |
| logs and dashboards | observed runtime behavior | causality without comparison |
| explicit user statement | personal scope or context | independent technical verification |

If one sentence mixes several claim types, verify each part separately.

## Evaluation Taxonomy

Do not collapse every test into "大模型评测."

| Evaluation layer | Main question | Typical controls and artifacts | Safe resume framing |
| --- | --- | --- | --- |
| Runtime contract | Does the Agent loop behave correctly? | scripted/fake LLM, in-memory IO, tool assertions, event/session checks | scenario E2E or regression harness |
| Model/task quality | Does a model complete the task well? | fixed task start, replay, golden set, graders, final artifacts, traces | offline eval, replay, benchmark |
| Safety/HITL | Are risky actions blocked, reviewed, and resumed correctly? | permission cases, interrupt state, approval/denial scenarios, audit events | safety/HITL evaluation harness |
| Multi-agent quality | Do role-separated agents improve review or execution? | isolated contexts, schemas, convergence rules, false-positive review | multi-agent review/eval workflow |
| Product/business outcome | Does the system help users or operations? | task success, human acceptance, latency, cost, retention, time saved | online/product impact, only with data |

A deterministic scripted LLM is valuable because it removes model variance and exposes runtime regressions. It does not measure the quality of a real model.

## High-Value Theme Map

Start with these themes when evidence exists. Use the mechanism questions to distinguish real engineering from labels.

### Agent Runtime or Harness

Look for:

- model/tool loop, `Run`/`Resume`, session and runtime state
- host-injected IO, provider, storage, permission, event, or background interfaces
- streaming events, interruption, recovery, background work

Explain:

- what the runtime owns versus what the host injects
- how one turn moves through model output, tool execution, persistence, and terminal state
- what is required to resume safely after an interrupt

Avoid claiming a distributed or production-scale platform from an embeddable runtime alone.

### Scenario E2E or Regression Harness

Look for:

- scenario declarations, scripted responses, fake/model fixtures
- in-memory filesystem, shell, session store, queues, clock, or event sinks
- assertions over requests, tool calls, files, events, messages, and resume behavior

Explain which nondeterministic boundaries are controlled and which real runtime path remains under test.

### Replay or Offline Evaluation

Look for:

- captured code/data starting point, conversation context, prompts, environment, model config
- deterministic reconstruction, context truncation, replay entry point
- final artifacts, traces, acceptance criteria, graders, or comparison reports

Explain how the system creates a fair same-start comparison. Do not claim automated scoring when the repository only captures or extracts evaluation inputs.

### Safety, Permission, and HITL

Look for:

- ordered permission rules, risk classification, allow/ask/deny decisions
- pending approval state, interrupt events, resolution APIs, resume logic
- duplicate-side-effect protection and approval/denial tests

Explain decision order, persistence, resumption, and the limits of any classifier. Do not claim complete prompt-injection prevention or exactly-once execution without proof.

### Multi-Agent Review or Collaboration

Look for:

- role definitions, context isolation, tool restrictions, structured output
- parallel dispatch, aggregation, priority rules, re-review, convergence limits
- false-positive handling or human arbitration

Explain why separate agents are used instead of repeated identical calls. Distinguish prompt/skill-driven orchestration from a standalone workflow engine.

### Tool Calling and External Actions

Look for registries, schemas, validation, permissions, timeout/retry behavior, result normalization, and audit events. A list of tools is weaker than a controlled execution contract.

### Context, Memory, and Retrieval

Look for prompt assembly, history selection, context budgets, compaction, cache behavior, retrieval indexes, reranking, citations, and memory lifecycle. Explain what is selected, when, and how it reaches the model.

### Model and Provider Infrastructure

Look for routing, capability registries, wire translation, streaming, reasoning/thinking filtering, fallback, token accounting, and cost attribution. Separate SDK-level portable concepts from provider-specific fields.

### Code Agent Automation

Look for issue understanding, repository retrieval, static analysis, patch generation, sandbox execution, test feedback, review, and issue-to-patch evaluation. Do not infer SWE-bench performance from a compatible workflow.

### Observability and Cost

Look for trace/span creation, request/tool timelines, token and cost records, model metadata, latency metrics, replay/debug links, and failure classification. Logs alone are not an observability system unless they support diagnosis or measurement.

## Deep-Dive Checklist

For interview preparation, be able to answer:

1. What triggers the mechanism?
2. Which data enters and what artifact leaves?
3. Where is state stored, and what survives a restart or resume?
4. Which component makes each decision?
5. How are nondeterministic dependencies controlled or observed?
6. What happens on timeout, rejection, partial failure, or malformed model output?
7. Which alternative was simpler, and why was it insufficient here?
8. What limitation remains?

## Candidate Ranking

Score internally from 0-2 on each dimension:

- `E`: evidence strength
- `D`: mechanism depth
- `O`: ownership defensibility
- `R`: target-role relevance

Prefer themes totaling at least 6 with `E > 0`. Treat this as a prioritization aid, not as proof. A lower-scoring but user-owned module can outrank a broad platform capability with unknown ownership.

## Metrics to Ask For, Not Invent

Suggest only metrics that match the mechanism:

| Theme | Useful metrics |
| --- | --- |
| scenario harness | scenario count, critical flows covered, flakes removed, regressions caught |
| replay/offline eval | replay success rate, task count, models compared, grader agreement |
| HITL | approval/denial counts, resume success, risky-call interception, classifier escalation |
| multi-agent review | findings accepted, false-positive rate, convergence rounds, review time |
| runtime/tooling | tool success rate, recovery success, timeout/error rate, task completion |
| model/provider | latency, token/cost per task, fallback rate, provider error rate |
| product workflow | human acceptance, completion time, task success, repeat usage |

Keep missing metrics outside directly usable bullets under `待补充指标`.
