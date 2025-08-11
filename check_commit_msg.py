#!/usr/bin/env python3
import re
import sys
from pathlib import Path


def main():
    if len(sys.argv) < 2:
        print("Usage: commit-msg <commit-msg-file>")
        sys.exit(1)

    commit_msg_file = Path(sys.argv[1])

    if not commit_msg_file.exists():
        print(f"ERROR: Commit message file {commit_msg_file} does not exist.")
        sys.exit(1)

    # Read commit message lines
    lines = commit_msg_file.read_text(encoding="utf-8").splitlines()

    if not lines:
        print("ERROR: Commit message is empty.")
        sys.exit(1)

    subject = lines[0]

    # subject must have the task/ticket ID, tags, modules, and short description
    pattern = r'^T?[0-9]+\s+\[[^\]]+\]\s+[a-zA-Z0-9_]+(?:,\s*[a-zA-Z0-9_]+)*:\s.+$'

    if not re.match(pattern, subject):
        print("ERROR: Commit message subject does not match required format.")
        print("Format:")
        print("  {T?}{Task/Ticket ID} [TAGs] module1, module2: short description")
        print("Examples:")
        print("  12345 [IMP] module_name: Improved sale order selection")
        print("  T1234 [FIX, IMP] module1, module2: Fixed bug and improved performance")
        sys.exit(1)

    if len(lines) < 2:
        print("ERROR: Commit description (body) is required after the subject line.")
        sys.exit(1)

    # Check if body has at least one non-empty line
    found_description = any(line.strip() for line in lines[1:])
    if not found_description:
        print("ERROR: Commit description (body) must have at least one non-empty line.")
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
