#!/bin/bash
# Check for groups referenced in /etc/passwd but not in /etc/group

# shellcheck disable=SC2034
while IFS=: read -r groupname grouppass gid members; do
    if ! grep -q -P "^$groupname:[^:]*:$gid:" /etc/group; then
        echo "Group $gid is referenced by /etc/passwd but does not exist in /etc/group"
    fi
done < /etc/passwd
