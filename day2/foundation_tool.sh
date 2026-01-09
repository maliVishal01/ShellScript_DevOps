#!/bin/bash

###################################################
# Project : Shell Script Foundation Project
# Purpose : Master core shell scripting concepts
###################################################

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/foundation.log"

mkdir -p "$LOG_DIR"

############################################
# ARGUMENT CHECK
############################################
if [ $# -ne 1 ]; then
    echo "Usage: $0 <admin_name>"
    exit 1
fi

ADMIN="$1"

############################################
# LOG FUNCTION
############################################
log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

############################################
# WELCOME FUNCTION
############################################
welcome() {
    echo "======================================"
    echo " Welcome $ADMIN"
    echo " Shell Foundation Mastery Project"
    echo "======================================"
    log_msg "User logged in: $ADMIN"
}

############################################
# CREATE FILES (for loop)
############################################
create_files() {
    read -p "Enter number of files to create: " NUM

    if ! [[ "$NUM" =~ ^[0-9]+$ ]]; then
        echo "❌ Enter a valid number"
        return
    fi

    for (( i=1; i<=NUM; i++ ))
    do
        FILE="file_$i.txt"
        echo "This is file number $i" > "$FILE"
        echo "Created $FILE"
        log_msg "Created file: $FILE"
    done
}

############################################
# READ FILE (while loop)
############################################
read_file() {
    read -p "Enter file name to read: " FILE

    if [ ! -f "$FILE" ]; then
        echo "❌ File not found"
        log_msg "File not found: $FILE"
        return
    fi

    echo "------ File Content ------"
    while read line
    do
        echo "$line"
    done < "$FILE"

    log_msg "Read file: $FILE"
}

############################################
# RENAME FILES (if + for)
############################################
rename_files() {
    read -p "Enter extension to rename (txt/log): " EXT

    if [ -z "$EXT" ]; then
        echo "❌ Extension cannot be empty"
        return
    fi

    for file in *.$EXT
    do
        if [ -f "$file" ]; then
            mv "$file" "renamed_$file"
            echo "Renamed $file"
            log_msg "Renamed file: $file"
        fi
    done
}

############################################
# DELETE FILES SAFELY
############################################
delete_files() {
    read -p "Enter extension to delete: " EXT
    read -p "Type YES to confirm deletion: " CONFIRM

    if [ "$CONFIRM" != "YES" ]; then
        echo "❌ Deletion cancelled"
        log_msg "Deletion cancelled"
        return
    fi

    for file in *.$EXT
    do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "Deleted $file"
            log_msg "Deleted file: $file"
        fi
    done
}

############################################
# MENU LOOP (while + case)
############################################
while true
do
    welcome
    echo "1. Create files"
    echo "2. Read file"
    echo "3. Rename files"
    echo "4. Delete files"
    echo "5. Exit"

    read -p "Enter your choice: " CHOICE

    case $CHOICE in
        1) create_files ;;
        2) read_file ;;
        3) rename_files ;;
        4) delete_files ;;
        5)
            echo "👋 Exiting..."
            log_msg "User exited"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice"
            ;;
    esac

    echo ""
done

