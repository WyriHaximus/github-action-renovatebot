#!/bin/bash
# Script to ensure all text files end with a newline

find . -name "*.yaml" -o -name "*.yml" -o -name "*.md" -o -name "*.txt" -o -name "*.json" -o -name "LICENSE" | grep -v ".git" | while read file; do
    # Check if file ends with newline
    if [[ -s "$file" && $(tail -c1 "$file" | wc -l) -eq 0 ]]; then
        echo "Adding newline to: $file"
        echo "" >> "$file"
    fi
done

echo "All files now end with newlines"
