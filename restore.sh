#!/bin/bash
# restore.sh - Restore files from a commit

REPO=".minigit"
OBJECTS="$REPO/objects"
COMMIT="$1"

if [ -z "$COMMIT" ]; then
    echo "Usage: ./restore.sh <commit_id>"
    exit 1
fi

if [ ! -d "$OBJECTS/$COMMIT" ]; then
    echo "Commit $COMMIT does not exist."
    exit 1
fi

for f in "$OBJECTS/$COMMIT/"*.gz; do
    FILE_NAME=$(basename "$f" .gz)
    gzip -dc "$f" > "$FILE_NAME"
done
