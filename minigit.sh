#!/bin/bash
# MiniGit - Shell-based Version Control System
# Author: Student
# Version: 1.0

REPO=".minigit"
OBJECTS="$REPO/objects"
LOGS="$REPO/logs"
INDEX="$REPO/index"
HEAD="$REPO/HEAD"

# ------------------------------
# Initialize repository
# ------------------------------
init_repo() {
    if [ -d "$REPO" ]; then
        echo "Repository already exists."
        exit 1
    fi
    mkdir -p "$OBJECTS"
    mkdir -p "$LOGS"
    touch "$INDEX"
    echo "HEAD" > "$HEAD"
    echo "Repository initialized successfully."
}

# ------------------------------
# Add files to index
# ------------------------------
add_files() {
    if [ ! -d "$REPO" ]; then
        echo "Repository not initialized. Run ./minigit.sh init"
        exit 1
    fi
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "File $file does not exist."
            continue
        fi
        if ! grep -qx "$file" "$INDEX"; then
            echo "$file" >> "$INDEX"
            echo "Added $file to index."
        else
            echo "$file already added."
        fi
    done
}

# ------------------------------
# Commit changes
# ------------------------------
commit_changes() {
    if [ ! -s "$INDEX" ]; then
        echo "No files to commit."
        exit 1
    fi
    if [ -z "$1" ]; then
        echo "Commit message required: ./minigit.sh commit \"message\""
        exit 1
    fi
    MESSAGE="$1"
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    COMMIT_ID="$TIMESTAMP"

    mkdir -p "$OBJECTS/$COMMIT_ID"
    while read -r file; do
        if [ -f "$file" ]; then
            cp "$file" "$OBJECTS/$COMMIT_ID/"
            gzip "$OBJECTS/$COMMIT_ID/$file"
        fi
    done < "$INDEX"

    echo "$COMMIT_ID|$MESSAGE|$(date)" > "$LOGS/$COMMIT_ID.log"
    echo "$COMMIT_ID" > "$HEAD"
    echo "Committed as $COMMIT_ID"
}

# ------------------------------
# View logs
# ------------------------------
view_logs() {
    for log in $(ls -r $LOGS); do
        awk -F'|' '{print "Commit ID: "$1"\nMessage: "$2"\nDate: "$3"\n----------------"}' "$LOGS/$log"
    done
}

# ------------------------------
# Checkout commit
# ------------------------------
checkout_commit() {
    if [ -z "$1" ]; then
        echo "Usage: ./minigit.sh checkout <commit_id>"
        exit 1
    fi
    COMMIT_ID="$1"
    if [ ! -d "$OBJECTS/$COMMIT_ID" ]; then
        echo "Commit $COMMIT_ID does not exist."
        exit 1
    fi
    bash restore.sh "$COMMIT_ID"
    echo "Checked out commit $COMMIT_ID"
}

# ------------------------------
# Show differences
# ------------------------------
show_diff() {
    if [ -z "$1" ]; then
        echo "Usage: ./minigit.sh diff <file>"
        exit 1
    fi
    FILE="$1"
    bash diff_viewer.sh "$FILE"
}

# ------------------------------
# Main
# ------------------------------
case "$1" in
    init) init_repo ;;
    add) shift; add_files "$@" ;;
    commit) shift; commit_changes "$*" ;;
    log) view_logs ;;
    checkout) shift; checkout_commit "$1" ;;
    diff) shift; show_diff "$1" ;;
    *) echo "Usage: ./minigit.sh {init|add|commit|log|checkout|diff}" ;;
esac
