#!/usr/bin/env python3
"""Patch Amethyst Tools.hasOnlineProfile() so offline/local accounts can use profile tools."""
from __future__ import annotations

import re
import sys
from pathlib import Path


def patch_tools_java(tools_path: Path) -> None:
    if not tools_path.is_file():
        raise SystemExit(f"Tools.java not found: {tools_path}")

    text = tools_path.read_text(encoding="utf-8", errors="ignore")

    pattern = re.compile(
        r"public\s+static\s+boolean\s+hasOnlineProfile\s*\(\s*\)\s*\{",
        re.MULTILINE,
    )

    match = pattern.search(text)
    if not match:
        raise SystemExit(f"Could not find Tools.hasOnlineProfile() method in {tools_path}")

    brace = text.find("{", match.end() - 1)
    depth = 0
    end = None

    for index in range(brace, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                end = index + 1
                break

    if end is None:
        raise SystemExit("Could not parse Tools.hasOnlineProfile() method body")

    replacement = """public static boolean hasOnlineProfile() {
        // DURBIN: allow launcher utility screens for offline/local accounts.
        // This does not bypass Microsoft authentication for official online servers.
        return true;
    }"""

    tools_path.write_text(
        text[: match.start()] + replacement + text[end:],
        encoding="utf-8"
    )

    print(f"Patched: {tools_path}")


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("Amethyst-Android")

    if not root.exists():
        raise SystemExit(f"Project folder not found: {root}")

    candidates = list(root.rglob("Tools.java"))

    if not candidates:
        raise SystemExit("No Tools.java file found anywhere inside the project")

    for tools_path in candidates:
        text = tools_path.read_text(encoding="utf-8", errors="ignore")
        if "hasOnlineProfile" in text:
            patch_tools_java(tools_path)
            return 0

    raise SystemExit("Tools.java found, but none contain hasOnlineProfile()")


if __name__ == "__main__":
    raise SystemExit(main())