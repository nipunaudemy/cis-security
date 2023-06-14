#!/bin/bash
awk -F: '{print $3, $1}' /etc/passwd | sort -n | uniq -d | while read -r uid user; do
    echo "Duplicate UID ($uid): $(grep -oE "^$user( |:)" /etc/passwd | cut -d: -f1 | xargs)"
done
