#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE="$1"
DESTINATION="$2"

# Check if source directory exists
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$DESTINATION" ]; then
    echo "Error: Destination directory does not exist."
    exit 1
fi

# Confirm before deleting (optional, remove for silent execution)
read -p "Are you sure you want to delete all contents of '$DESTINATION' and replace them with '$SOURCE'? (y/N) " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Delete contents of the destination directory
rm -rf "$DESTINATION"/* "$DESTINATION"/.[!.]* "$DESTINATION"/..?* 2>/dev/null

# Copy contents from source to destination
cp -R "$SOURCE"/* "$SOURCE"/.[!.]* "$SOURCE"/..?* "$DESTINATION" 2>/dev/null

echo "Sync complete: '$SOURCE' → '$DESTINATION'"
