#!/bin/bash

# Find all Markdown files
find . -name "*.md" | while read -r readme; do
    echo "Checking: $readme"
    
    # Extract image paths like ![alt](path/to/img.png)
    grep -oP '!\[.*?\]\(\K.*?(?=\))' "$readme" | while read -r img_path; do
        
        # Check if the path is absolute (starts with /Users or C:)
        if [[ "$img_path" == /* ]]; then
            echo "  [✖] ABSOLUTE PATH FOUND: $img_path"
            echo "      Suggestion: Change this to a relative path."
        else
            # Check if the file actually exists relative to the README
            dir=$(dirname "$readme")
            if [ -f "$dir/$img_path" ]; then
                echo "  [✔] Valid relative path: $img_path"
            else
                echo "  [!] FILE MISSING: $img_path (Not found at $dir/$img_path)"
            fi
        fi
    done
done
