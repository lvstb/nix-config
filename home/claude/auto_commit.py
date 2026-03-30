#!/usr/bin/env python3
"""Claude Code hook: create standardized commit on TaskCompleted event."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from dataclasses import dataclass
from typing import Any


@dataclass
class CommitResult:
    attempted: bool
    success: bool
    exit_code: int | None
    message: str
    commit_message: str | None


def _load_payload() -> Any:
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {}


def _is_task_completed_event(payload: Any) -> bool:
    if not isinstance(payload, dict):
        return False
    return str(payload.get("hook_event_name", "")).strip().lower() == "taskcompleted"


def _extract_task_title(payload: Any) -> str:
    if not isinstance(payload, dict):
        return "completed task"
    value = payload.get("task_subject")
    if isinstance(value, str) and value.strip():
        return value.strip()
    return "completed task"


def _normalize_summary(raw_title: str, max_len: int = 72) -> str:
    compact = " ".join(raw_title.split())
    compact = re.sub(r"[^\w\s\-:/]", "", compact).strip().lower()
    if not compact:
        compact = "completed task"
    if len(compact) > max_len:
        compact = compact[: max_len - 3].rstrip() + "..."
    return compact


_COMMIT_TYPE_PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    ("fix",      re.compile(r"\b(fix(e[sd])?|bug|patch|repair|resolv(e[sd]?|ing)|hotfix|defect)\b", re.IGNORECASE)),
    ("feat",     re.compile(r"\b(add(ed|ing)?|implement(ed|ing)?|creat(e[sd]?|ing)|introduc(e[sd]?|ing)|new|feature|support)\b", re.IGNORECASE)),
    ("refactor", re.compile(r"\b(refactor(ed|ing)?|rewrite|rewrote|restructur(e[sd]?|ing)|reorgani[sz](e[sd]?|ing)|clean(ed|ing)?\s*up|extract(ed|ing)?|simplif(y|ied|ing))\b", re.IGNORECASE)),
    ("test",     re.compile(r"\b(test(ed|ing|s)?|spec(s)?|unit\s*test|coverage|assert)\b", re.IGNORECASE)),
    ("docs",     re.compile(r"\b(doc(s|ument(ed|ation|ing)?)?|readme|comment(ed|ing)?|changelog|docstring)\b", re.IGNORECASE)),
    ("perf",     re.compile(r"\b(optimi[sz](e[sd]?|ing)|perf(ormance)?|speed(\s*up)?|faster|cach(e[sd]?|ing)|latency)\b", re.IGNORECASE)),
    ("style",    re.compile(r"\b(format(ted|ting)?|lint(ed|ing)?|style|whitespace|indent(ation)?|prettier)\b", re.IGNORECASE)),
]


def _infer_commit_type(title: str) -> str:
    for commit_type, pattern in _COMMIT_TYPE_PATTERNS:
        if pattern.search(title):
            return commit_type
    return "chore"


def _extract_task_description(payload: Any) -> str:
    if not isinstance(payload, dict):
        return ""
    value = payload.get("task_description")
    if isinstance(value, str):
        return value.strip()
    return ""


def _build_commit_message(payload: Any) -> str:
    title = _extract_task_title(payload)
    commit_type = _infer_commit_type(title)
    if commit_type == "chore":
        description = _extract_task_description(payload)
        if description:
            commit_type = _infer_commit_type(description)
    summary = _normalize_summary(title)
    return f"{commit_type}(task): complete {summary}"


def _run_git(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, text=True, capture_output=True, check=False)


def create_standard_commit(payload: Any) -> CommitResult:
    if _run_git(["git", "rev-parse", "--is-inside-work-tree"]).returncode != 0:
        return CommitResult(
            attempted=False,
            success=True,
            exit_code=None,
            message="Not a git repository; skipping commit.",
            commit_message=None,
        )

    add_result = _run_git(["git", "add", "-A"])
    if add_result.returncode != 0:
        return CommitResult(
            attempted=True,
            success=False,
            exit_code=add_result.returncode,
            message=f"git add failed: {add_result.stderr.strip()}",
            commit_message=None,
        )

    staged_check = _run_git(["git", "diff", "--cached", "--quiet"])
    if staged_check.returncode == 0:
        return CommitResult(
            attempted=True,
            success=True,
            exit_code=0,
            message="No staged changes; skipping commit.",
            commit_message=None,
        )
    if staged_check.returncode not in (0, 1):
        return CommitResult(
            attempted=True,
            success=False,
            exit_code=staged_check.returncode,
            message=f"git diff --cached failed: {staged_check.stderr.strip()}",
            commit_message=None,
        )

    commit_message = _build_commit_message(payload)
    commit_result = _run_git(["git", "commit", "-m", commit_message])
    if commit_result.returncode == 0:
        return CommitResult(
            attempted=True,
            success=True,
            exit_code=0,
            message="Created standardized commit.",
            commit_message=commit_message,
        )

    return CommitResult(
        attempted=True,
        success=False,
        exit_code=commit_result.returncode,
        message=f"git commit failed: {commit_result.stderr.strip()}",
        commit_message=commit_message,
    )


def main() -> int:
    payload = _load_payload()

    if not _is_task_completed_event(payload):
        return 0

    commit = create_standard_commit(payload)
    if commit.attempted and commit.success and commit.commit_message:
        print(json.dumps({"systemMessage": f"Committed: {commit.commit_message}"}))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
