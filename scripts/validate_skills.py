#!/usr/bin/env python3
"""Validate the Agent Skills in this repo.

Usage:
    python3 scripts/validate_skills.py [--quiet]

Checks skill frontmatter against the Agent Skills specification, keeps the
generated indexes in sync with what is on disk, and runs the Ralph shell
suites. Exits 0 when everything passes, 1 otherwise.

Invoke with `python3 scripts/validate_skills.py` rather than relying on the
executable bit — a lost +x should not be able to take CI down.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"

# Spec limits: https://agentskills.io/specification
NAME_MAX = 64
DESC_MAX = 1024
NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")

SHELL_GLOBS = ("hooks/lib/*.sh", "hooks/*/*.sh", "scripts/*.sh")
EXECUTABLE_REQUIRED = (
    "hooks/claude/stop-hook.sh",
    "hooks/cursor/ralph-stop.sh",
    "hooks/cursor/ralph-capture.sh",
    "scripts/seed-ralph-loop.sh",
)
STRUCTURAL_PLACEHOLDERS = (
    "PRESET_BODY",
    "COMPLETION_BLOCK",
    "STATE_BLOCK",
    "STUCK_BLOCK",
    "TASK_PROMPT",
    "CUSTOM_STEPS",
)
MANIFESTS = (".claude-plugin/plugin.json", ".cursor-plugin/plugin.json")


class Report:
    """Collects results so the summary reflects the whole run, not the first failure."""

    def __init__(self, quiet: bool = False) -> None:
        self.failed = False
        self.quiet = quiet

    def ok(self, message: str) -> None:
        if not self.quiet:
            print(f"ok: {message}")

    def skip(self, message: str) -> None:
        if not self.quiet:
            print(f"skip: {message}")

    def fail(self, message: str, detail: str | list[str] | None = None) -> None:
        self.failed = True
        print(f"FAIL: {message}")
        if detail:
            lines = detail.splitlines() if isinstance(detail, str) else detail
            for line in lines[:20]:
                print(f"  {line}")


def read_json(path: Path):
    """Return parsed JSON, or None when the file is missing or malformed."""
    try:
        return json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return None


def parse_frontmatter(text: str) -> dict[str, str] | None:
    """Extract top-level scalar keys from YAML frontmatter.

    Deliberately not a YAML parser: this only needs top-level `key: value`
    pairs, with block scalars (`>`, `|`) folded into one string. Nested keys
    under `metadata:` are ignored.
    """
    match = re.match(r"^---\n(.*?)\n---", text, re.S)
    if not match:
        return None

    fields: dict[str, str] = {}
    key: str | None = None
    block: list[str] = []

    def flush() -> None:
        if key is not None:
            fields[key] = " ".join(block).strip()

    for line in match.group(1).split("\n"):
        header = re.match(r"^([A-Za-z][A-Za-z0-9_-]*):(.*)$", line)
        if header:
            flush()
            key = header.group(1)
            rest = header.group(2).strip()
            block = [] if rest in (">", "|", ">-", "|-", "") else [rest]
        elif key is not None and line.startswith((" ", "\t")):
            block.append(line.strip())
        else:
            flush()
            key, block = None, []
    flush()
    return fields


def skill_dirs() -> list[Path]:
    if not SKILLS.is_dir():
        return []
    return sorted(d for d in SKILLS.iterdir() if (d / "SKILL.md").is_file())


def check_skills(report: Report) -> None:
    """Frontmatter must satisfy the spec, and `name` must match the directory."""
    for skill in skill_dirs():
        name_on_disk = skill.name
        fields = parse_frontmatter((skill / "SKILL.md").read_text())

        if fields is None:
            report.fail(f"{name_on_disk}: no YAML frontmatter")
            continue

        declared = fields.get("name", "").strip("\"'")
        if not declared:
            report.fail(f"{name_on_disk}: missing name")
            continue
        if declared != name_on_disk:
            report.fail(f"{name_on_disk}: name '{declared}' must match directory")
            continue
        if len(declared) > NAME_MAX:
            report.fail(f"{name_on_disk}: name is {len(declared)} chars (max {NAME_MAX})")
            continue
        if not NAME_RE.match(declared):
            report.fail(
                f"{name_on_disk}: name must be lowercase alphanumeric and single hyphens"
            )
            continue

        description = fields.get("description", "")
        if not description:
            report.fail(f"{name_on_disk}: missing description")
            continue
        if len(description) > DESC_MAX:
            report.fail(
                f"{name_on_disk}: description is {len(description)} chars (max {DESC_MAX})"
            )
            continue

        report.ok(name_on_disk)


def check_epic_paths(report: Report) -> None:
    script = SKILLS / "tasks/scripts/check-epic-paths.sh"
    example = SKILLS / "tasks/examples/backlog.md"
    if not (script.is_file() and example.is_file()):
        return
    result = subprocess.run(
        ["bash", str(script), str(example)], cwd=ROOT, capture_output=True, text=True
    )
    if result.returncode != 0:
        report.fail("epic work paths", result.stdout + result.stderr)
    else:
        report.ok(f"epic work paths in {example.relative_to(ROOT)}")


def check_skills_index(report: Report) -> None:
    """Every skill on disk must be grouped, and every grouped skill must exist.

    A rename that misses one leaves a broken index that nothing else catches.
    """
    path = ROOT / "skills.sh.json"
    if not path.is_file():
        return

    data = read_json(path)
    if data is None:
        report.fail("skills.sh.json invalid JSON")
        return

    grouped = {s for g in data.get("groupings", []) for s in g.get("skills", [])}
    on_disk = {d.name for d in skill_dirs()}

    problems = [f"grouped but missing on disk: {n}" for n in sorted(grouped - on_disk)]
    problems += [f"on disk but not grouped: {n}" for n in sorted(on_disk - grouped)]

    if problems:
        report.fail("skills.sh.json out of sync", problems)
    else:
        report.ok("skills.sh.json in sync with skills/")


def check_evals(report: Report) -> None:
    """A stale skill_name after a rename is otherwise silent."""
    for skill in skill_dirs():
        evals = skill / "evals/evals.json"
        if evals.is_file():
            data = read_json(evals)
            if data is None:
                report.fail(f"{skill.name}: evals.json invalid JSON")
            elif data.get("skill_name") != skill.name:
                report.fail(
                    f"{skill.name}: evals.json declares skill_name "
                    f"'{data.get('skill_name', '')}'"
                )

        queries = skill / "evals/trigger-queries.json"
        if queries.is_file() and read_json(queries) is None:
            report.fail(f"{skill.name}: trigger-queries.json invalid JSON")


def shell_scripts() -> list[Path]:
    found: list[Path] = []
    for pattern in SHELL_GLOBS:
        found.extend(sorted(ROOT.glob(pattern)))
    return [p for p in found if p.is_file()]


def check_shell_syntax(report: Report) -> None:
    for script in shell_scripts():
        result = subprocess.run(
            ["bash", "-n", str(script)], capture_output=True, text=True
        )
        if result.returncode != 0:
            report.fail(
                f"{script.relative_to(ROOT)} has a syntax error", result.stderr
            )


def check_shellcheck(report: Report) -> None:
    """Advisory: shellcheck is not a hard dependency, so CI without it still validates."""
    if not shutil.which("shellcheck"):
        report.skip("shellcheck not installed")
        return
    scripts = [str(p) for p in shell_scripts()]
    if not scripts:
        return
    result = subprocess.run(
        ["shellcheck", "-x", "-S", "warning", *scripts],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        report.fail("shellcheck reported issues", result.stdout + result.stderr)
    else:
        report.ok("shellcheck clean")


def check_executable_bits(report: Report) -> None:
    """A hook without +x fails silently and the loop dies with no diagnostic."""
    for rel in EXECUTABLE_REQUIRED:
        path = ROOT / rel
        if path.is_file() and not os.access(path, os.X_OK):
            report.fail(f"{rel} is not executable (chmod +x)")


def check_template_placeholders(report: Report) -> None:
    """Templates must only use placeholders the seed script can resolve."""
    assets = SKILLS / "ralph-loop/assets"
    seed = ROOT / "scripts/seed-ralph-loop.sh"
    if not (assets.is_dir() and seed.is_file()):
        return

    seed_text = seed.read_text()
    for placeholder in STRUCTURAL_PLACEHOLDERS:
        if placeholder not in seed_text:
            report.fail(
                f"template placeholder {{{{{placeholder}}}}} is never set by "
                "seed-ralph-loop.sh"
            )

    used: set[str] = set()
    for path in assets.rglob("*"):
        if path.is_file():
            try:
                used |= set(re.findall(r"\{\{([A-Z_][A-Z0-9_]*)\}\}", path.read_text()))
            except (OSError, UnicodeDecodeError):
                continue

    # Keys supplied by the caller via --set are legitimate and cannot be
    # verified here, so they are reported rather than failed.
    unresolved = sorted(
        key
        for key in used
        if not re.search(rf"(add_default|add_kv) {key}\b|\"{key}\"", seed_text)
    )
    suffix = f" (caller-supplied: {' '.join(unresolved)})" if unresolved else ""
    report.ok(f"template placeholders resolvable{suffix}")


def run_suite(report: Report, rel: str, label: str) -> None:
    """Run a Ralph shell suite via bash, so a missing +x does not skip it."""
    script = ROOT / rel
    if not script.is_file():
        return

    with tempfile.TemporaryDirectory() as tmp:
        log = Path(tmp) / "suite.log"
        with log.open("w") as handle:
            result = subprocess.run(
                ["bash", str(script)],
                cwd=ROOT,
                stdout=handle,
                stderr=subprocess.STDOUT,
            )
        output = log.read_text()

    if result.returncode == 0:
        passed = re.search(r"^passed:\s*(\d+)", output, re.M)
        count = f" ({passed.group(1)} assertions)" if passed else ""
        report.ok(f"{label}{count}")
    else:
        detail = [
            line for line in output.splitlines() if line.startswith(("  - ", "failed:"))
        ]
        report.fail(label, detail or output.splitlines()[-20:])


def check_manifests(report: Report) -> None:
    for rel in MANIFESTS:
        path = ROOT / rel
        if path.is_file() and read_json(path) is None:
            report.fail(f"{rel} invalid JSON")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--quiet", action="store_true", help="only print failures"
    )
    args = parser.parse_args()

    report = Report(quiet=args.quiet)

    check_skills(report)
    check_epic_paths(report)
    check_skills_index(report)
    check_evals(report)
    check_shell_syntax(report)
    check_shellcheck(report)
    check_executable_bits(report)
    check_template_placeholders(report)
    run_suite(report, "scripts/test-ralph-hooks.sh", "ralph hook tests")
    run_suite(report, "scripts/test-seed-ralph-loop.sh", "ralph seed tests")
    check_manifests(report)

    return 1 if report.failed else 0


if __name__ == "__main__":
    sys.exit(main())
