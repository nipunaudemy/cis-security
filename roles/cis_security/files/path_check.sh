#!/bin/bash
# Find issues in user's PATH variable

# Check for empty directories in PATH
if [[ "$PATH" == *::* ]]; then
    echo "Empty directory in PATH (::)"
fi

# Check for trailing colon in PATH
if [[ "$PATH" == *: ]]; then
    echo "Trailing colon in PATH"
fi

# Iterate over each directory in PATH
while IFS=: read -r dir; do
    # Check for invalid directory
    if [[ ! -d "$dir" ]]; then
        echo "$dir is not a directory"
        continue
    fi

    # Check for group or other write permissions
    dirperm="$(stat -c %A "$dir")"
    if [[ "$dirperm" != ???*???? ]]; then
        if [[ "$dirperm" == ?*?w* ]]; then
            echo "Group or other write permission set on directory $dir"
        fi
    fi

    # Check for non-root ownership
    dirown="$(stat -c %U "$dir")"
    if [[ "$dirown" != "root" ]]; then
        echo "$dir is not owned by root"
    fi
done <<< "$PATH:"
