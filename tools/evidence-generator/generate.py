#!/usr/bin/env python3

from __future__ import annotations

import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EVIDENCE_DIR = ROOT / "evidence"
COMPLIANCE_DIR = ROOT / "policies" / "compliance"
OUTPUT_DIR = EVIDENCE_DIR / "generated"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()

    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(65536), b""):
            digest.update(chunk)

    return digest.hexdigest()


def git_value(*args: str) -> str:
    try:
        result = subprocess.run(
            ["git", *args],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        )
        return result.stdout.strip()
    except Exception:
        return "unknown"


def evidence_files() -> list[Path]:
    return sorted(
        path
        for path in EVIDENCE_DIR.rglob("*")
        if path.is_file()
        and "generated" not in path.parts
        and path.name != ".gitkeep"
    )


def mapping_files() -> list[Path]:
    return sorted(COMPLIANCE_DIR.rglob("mapping.json"))


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    generated_at = datetime.now(timezone.utc).isoformat()
    commit = git_value("rev-parse", "HEAD")
    branch = git_value("rev-parse", "--abbrev-ref", "HEAD")

    files = []

    for path in evidence_files():
        relative = path.relative_to(ROOT)

        files.append(
            {
                "path": str(relative),
                "size_bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
        )

    frameworks = []

    for path in mapping_files():
        mapping = json.loads(path.read_text())

        frameworks.append(
            {
                "mapping_file": str(path.relative_to(ROOT)),
                "framework": mapping.get("framework", "unknown"),
                "mapping": mapping,
            }
        )

    manifest = {
        "project": "SENTINEL - Multi-Cloud Secure Landing Zone & Policy Platform",
        "generated_at_utc": generated_at,
        "git_branch": branch,
        "git_commit": commit,
        "evidence_count": len(files),
        "evidence": files,
        "frameworks": frameworks,
    }

    manifest_path = OUTPUT_DIR / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")

    report = [
        "# SENTINEL Automated Security Evidence Report",
        "",
        f"Generated: `{generated_at}`",
        f"Git branch: `{branch}`",
        f"Git commit: `{commit}`",
        "",
        "## Summary",
        "",
        f"- Evidence artifacts discovered: **{len(files)}**",
        f"- Compliance mapping files discovered: **{len(frameworks)}**",
        "- Evidence integrity: SHA-256 calculated for every artifact",
        "",
        "> These mappings demonstrate security engineering traceability.",
        "> They do not represent a formal compliance certification or assessment.",
        "",
        "## Evidence Inventory",
        "",
        "| Evidence artifact | SHA-256 |",
        "|---|---|",
    ]

    for item in files:
        report.append(
            f"| `{item['path']}` | `{item['sha256'][:16]}...` |"
        )

    report.extend(
        [
            "",
            "## Framework Traceability",
            "",
        ]
    )

    for framework in frameworks:
        report.append(f"### {framework['framework']}")
        report.append("")
        report.append(
            f"Source mapping: `{framework['mapping_file']}`"
        )
        report.append("")

        mapping = framework["mapping"]

        entries = (
            mapping.get("controls")
            or mapping.get("domains")
            or mapping.get("categories")
            or []
        )

        for entry in entries:
            identifier = (
                entry.get("control")
                or entry.get("domain")
                or entry.get("category")
                or "Unspecified"
            )

            title = entry.get("title")

            if title:
                report.append(f"#### {identifier} — {title}")
            else:
                report.append(f"#### {identifier}")

            report.append("")

            if entry.get("implementation"):
                report.append(entry["implementation"])
                report.append("")

            for evidence in entry.get("evidence", []):
                exists = (ROOT / evidence).exists()
                status = "PASS" if exists else "MISSING"

                report.append(f"- **{status}** `{evidence}`")

            report.append("")

    report_path = OUTPUT_DIR / "security-evidence-report.md"
    report_path.write_text("\n".join(report) + "\n")

    print("SENTINEL Evidence Generator")
    print("---------------------------")
    print(f"Evidence artifacts : {len(files)}")
    print(f"Framework mappings : {len(frameworks)}")
    print(f"Manifest           : {manifest_path.relative_to(ROOT)}")
    print(f"Report             : {report_path.relative_to(ROOT)}")
    print(f"Git commit         : {commit}")


if __name__ == "__main__":
    main()
