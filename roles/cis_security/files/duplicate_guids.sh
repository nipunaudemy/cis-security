#!/bin/bash
cut -f3 -d":" /etc/group | sort | uniq -d | while read gid ; do
    groups=$(awk -F: -v n="$gid" '($3 == n) { print $1 }' /etc/group | xargs)
    echo "Duplicate GID ($gid): $groups"
done
