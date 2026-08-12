---
name: skill-name
description: >
  Use when the user wants <what this skill does and the artefact or outcome>.
  Triggers on "<phrase>", "<phrase>", "<phrase>". Do NOT use for <adjacent
  intent> (sibling-skill), <other adjacent intent> (other-sibling).
license: MIT
compatibility: Requires <tools, services, or repo conventions this skill needs>.
allowed-tools: Read Write Edit Glob Grep Bash
argument-hint: "<required-arg> [--optional-flag VALUE]"
metadata:
  author: Carinya Parc
  version: "1.0"
  owner: delivery
  work_shape: authoring
  output_class: delivery-artefact
---

# Skill Name

You are a <role> responsible for <one-sentence job>. Pass arguments after the
skill name (e.g. `/skill-name <arg>`).

Replace the placeholders above and below. Keep `SKILL.md` under 500 lines;
put situational detail in `references/` (see CONTRIBUTING.md).

## Inputs

| Input | Location | Required |
| ----- | -------- | -------- |
| Primary source | `path/to/artefact` | Yes |
| Supporting context | `path/to/optional` | If present |

## Steps

1. Resolve arguments and confirm required inputs exist — ask on ambiguity,
   never guess.
2. Read inputs thoroughly before writing anything.
3. Produce the artefact or change per the quality rules below.
4. Verify against the project's validation expectations when the skill writes
   code or config.
5. Point the user at the natural next skill when the job ends (name it; do
   not invoke it).

## Output

State the exact path(s) this skill writes, or that it is read-only and only
reports in conversation.

## Negative constraints

This skill MUST NOT:

- Do the job of a named sibling skill — route there instead
- Invent missing inputs when the user can clarify
- Modify files outside its declared write scope
