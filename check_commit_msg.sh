#!/bin/bash

commit_msg_file=$1

readarray -t lines < "$commit_msg_file"

subject="${lines[0]}"

pattern='^T?[0-9]+\s+\[[^\]]+\]\s+[a-zA-Z0-9_]+(,\s*[a-zA-Z0-9_]+)*:\s.+$'

if ! [[ $subject =~ $pattern ]]; then
    echo "ERROR: Commit message subject does not match required format."
    echo "Format:"
    echo "  {T?}{Task/Ticket ID} [TAGs] module1, module2: short description"
    echo "Examples:"
    echo "  12345 [IMP] module_name: Improved sale order selection"
    echo "  T1234 [FIX, IMP] module1, module2: Fixed bug and improved performance"
    exit 1
fi

if [ "${#lines[@]}" -lt 2 ]; then
    echo "ERROR: Commit description (body) is required after the subject line."
    exit 1
fi

found_description=0
for (( i=1; i<${#lines[@]}; i++ )); do
    if [[ -n "${lines[i]// /}" ]]; then
        found_description=1
        break
    fi
done

if [ "$found_description" -eq 0 ]; then
    echo "ERROR: Commit description (body) must have at least one non-empty line."
    exit 1
fi

exit 0
