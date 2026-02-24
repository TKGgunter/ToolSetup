#!/bin/bash

# Check if at least 2 arguments provided (mode + at least one word)
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <and|or> <word1> [word2] [word3] ..."
    exit 1
fi

# First argument is the search mode (and/or)
mode="$1"
# Remove first argument, leaving only the words
shift
# Store remaining arguments (the words) in an array
words=("$@")

echo "Searching for " ${words[@]}

if [ "$mode" = "or" ]; then
    # Join array elements with '|' separator for regex alternation
    # IFS is the field separator - temporarily set to '|'
    pattern=$(IFS='|'; echo "${words[*]}")
    # Search for lines starting with "tag:" containing any of the words
    rg "^tags:.*\b($pattern)\b"
    
elif [ "$mode" = "and" ]; then
    # Get all lines starting with "tag:"
    result=$(rg '^tags:')
    # Filter results through each word sequentially
    # Each iteration narrows down to lines containing that word
    for word in "${words[@]}"; do
        result=$(echo "$result" | rg "\b$word\b")
    done
    # Print final filtered results
    echo "$result"
    
else
    echo "Mode must be 'and' or 'or'"
    exit 1
fi
