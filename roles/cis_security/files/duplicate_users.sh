#!/bin/bash
cut -f1 -d":" /etc/passwd | sort | uniq -d | while read user ; do
    uids=$(awk -F: -v n="$user" '($1 == n) { print $3 }' /etc/passwd | xargs)
    echo "Duplicate User Name ($user): $uids"
done
