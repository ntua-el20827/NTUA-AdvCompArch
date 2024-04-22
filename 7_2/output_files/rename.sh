#!/bin/bash

# Function to rename files in a directory
rename_files() {
    local dir="$1"
    cd "$dir"
    
    # Delete output_11.txt if it exists
    if [ -f "output_11.txt" ]; then
        rm "output_11.txt"
    fi

    # Rename files from 12 to 14
    for ((i = 12; i <= 14; i++)); do
        if [ -f "output_$i.txt" ]; then
            mv "output_$i.txt" "output_$((i-1)).txt"
        fi
    done
}

# Iterate through subfolders
for folder in */; do
    rename_files "$folder"
done

