#!/bin/bash

# Script to rename media files based on their metadata timestamps
# Usage: ./rename_media.sh [-r] [directory]
# Options:
#   -r: Process subdirectories recursively
# If no directory is provided, operates on the current directory

# Define the date format: YYYY-MM-DD_HH-MM-SS
# The '%%-c' adds an incremental copy number (e.g., -1, -2) for files with the same timestamp
DATE_FORMAT="%Y-%m-%d_%H-%M-%S.%%e%%-c"

# --- Argument Handling ---

RECURSIVE=""
TARGET_DIR="."

# Parse arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        -r|--recursive)
            RECURSIVE="-r"
            shift
            ;;
        -*)
            echo "Error: Unknown option: $1"
            echo "Usage: $0 [-r] [directory]"
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            if [ ! -d "$TARGET_DIR" ]; then
                echo "Error: Directory not found at $TARGET_DIR"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -n "$RECURSIVE" ]; then
    echo "Starting RECURSIVE renaming process in directory: $TARGET_DIR"
else
    echo "Starting renaming process in directory: $TARGET_DIR (current level only)"
fi
echo "Target Format: YYYY-MM-DD_HH-MM-SS.EXT (with -N postfix for conflicts)"

# Use exiftool to rename files based on metadata timestamps
# -m: ignore minor errors and warnings
# -r: process directories recursively (if flag is set)
# -overwrite_original: don't keep backup files
# -d: specify date format for output
# Filter out "Warning:" lines but keep the summary
# Priority order: DateTimeOriginal > CreateDate > MediaCreateDate > FileModifyDate
if [ -n "$RECURSIVE" ]; then
    exiftool -m -r -overwrite_original -d "$DATE_FORMAT" \
             '-FileName<DateTimeOriginal' \
             '-FileName<CreateDate' \
             '-FileName<MediaCreateDate' \
             '-FileName<FileModifyDate' \
             "$TARGET_DIR" 2>&1 | grep -v "^Warning:"
else
    exiftool -m -overwrite_original -d "$DATE_FORMAT" \
             '-FileName<DateTimeOriginal' \
             '-FileName<CreateDate' \
             '-FileName<MediaCreateDate' \
             '-FileName<FileModifyDate' \
             "$TARGET_DIR" 2>&1 | grep -v "^Warning:"
fi

echo "Renaming complete for files in $TARGET_DIR."

