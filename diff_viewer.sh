#!/bin/bash
# diff_viewer.sh - Compare file in current vs latest commit

REPO=".minigit"
OBJECTS="$REPO/objects"
HEAD="$REPO/HEAD"

if [ -z "$1" ]; then
    echo "Usage: ./diff_viewer.sh <file>"
    exit 1
fi

FILE="$1"
CURRENT_FILE="$FILE"
LATEST_COMMIT=$(cat "$HEAD")
COMMIT_FILE="$OBJECTS/$LATEST_COMMIT/$FILE.gz"

if [ ! -f "$COMMIT_FILE" ]; then
    echo "File $FILE not found in latest commit."
    exit 1
fi

gzip -dc "$COMMIT_FILE" > /tmp/$FILE.commit

echo "Showing diff for $FILE (working vs last commit):"
diff -u /tmp/$FILE.commit "$CURRENT_FILE" | awk '
    /^+/ && !/^+++/{print "\033[32m" $0 "\033[0m"}
    /^-/ && !/^---/{print "\033[31m" $0 "\033[0m"}
    /^ /{print $0}
'

rm /tmp/$FILE.commit
