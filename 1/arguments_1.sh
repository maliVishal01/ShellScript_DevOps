#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <filename> <word>"
    exit 1
fi

FILE="$1"
WORD="$2"

if [ ! -f "$FILE" ]; then
    echo " File does not exist"
    exit 1
fi

echo "Searching for '$WORD' in $FILE"
grep -n "$WORD" "$FILE"

if [ $? -eq 0 ]; then
    echo "Word found"
else
    echo " Word not found"
fi

