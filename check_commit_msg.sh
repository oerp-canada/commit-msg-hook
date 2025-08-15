#!/bin/bash

# Commit message file passed by Git
COMMIT_MSG_FILE="$1"

if [[ -z "$COMMIT_MSG_FILE" ]]; then
    echo "Usage: commit-msg <commit-msg-file>"
    exit 1
fi

if [[ ! -f "$COMMIT_MSG_FILE" ]]; then
    echo "ERROR: Commit message file '$COMMIT_MSG_FILE' does not exist."
    exit 1
fi

# Read commit message lines
mapfile -t LINES < "$COMMIT_MSG_FILE"

if [[ ${#LINES[@]} -eq 0 ]]; then
    echo "ERROR: Commit message is empty."
    exit 1
fi

SUBJECT="${LINES[0]}"

# Regex:
# ^T?[0-9]+       - Task ID (optional T prefix)
# \s+\[[^]]+\]    - Tags in [ ]
# \s+[a-zA-Z0-9_]+(?:,\s*[a-zA-Z0-9_]+)* - Modules (comma-separated)
# :\s.+$          - Short description after colon
PATTERN='^T?[0-9]+[[:space:]]+\[[^]]+\][[:space:]]+[a-zA-Z0-9_]+(,[[:space:]]*[a-zA-Z0-9_]+)*:[[:space:]].+$'

if ! [[ "$SUBJECT" =~ $PATTERN ]]; then
    echo "ERROR: Commit message subject does not match required format."
    echo "Format:"
    echo "  {T?}{Task/Ticket ID} [TAGs] module1, module2: short description"
    echo "Examples:"
    echo "  12345 [IMP] module_name: Improved sale order selection"
    echo "  T1234 [FIX, IMP] module1, module2: Fixed bug and improved performance"
    exit 1
fi

# Require at least 2 lines
if [[ ${#LINES[@]} -lt 2 ]]; then
    echo "ERROR: Commit description (body) is required after the subject line."
    exit 1
fi

# Check for at least one non-empty line after subject
FOUND_DESCRIPTION=false
for ((i=1; i<${#LINES[@]}; i++)); do
    if [[ -n "${LINES[$i]// }" ]]; then
        FOUND_DESCRIPTION=true
        break
    fi
done

if [[ "$FOUND_DESCRIPTION" = false ]]; then
    echo "ERROR: Commit description (body) must have at least one non-empty line."
    exit 1
fi

exit 0
