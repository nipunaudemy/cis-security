#!/bin/bash
cut -f1 -d":" /etc/group | sort | uniq -d | while read group_name ; do
    gids=$(awk -F: -v n="$group_name" '($1 == n) { print $3 }' /etc/group | xargs)
    echo "Duplicate Group Name ($group_name): $gids"
done
