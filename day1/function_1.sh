#!/bin/bash

LOG_FILE="./function_demo.log"

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

check_file() {
    local FILE="$1"
    if [ -f "$FILE" ]; then
        echo "File exists: $FILE"
        log "FILE found: $FILE"
    else
        echo "File not found: $FILE"
        log "File Missing: $FILE"
    fi
}

check_file "/etc/passwd"
check_file "/fake/file.txt"

