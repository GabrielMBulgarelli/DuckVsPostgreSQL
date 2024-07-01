#!/bin/bash

# Get the script directory
scriptDirectory=$(dirname "$(readlink -f "$0")")

# Define the relative path to your .txt file
urlsFile="$scriptDirectory/datasets/datasets.txt"

# Define the relative output directory
outputDirectory="$scriptDirectory/datasets"

# Create the output directory if it doesn't exist
if [ ! -d "$outputDirectory" ]; then
    mkdir -p "$outputDirectory"
fi

# Read the URLs from the .txt file
mapfile -t urls < "$urlsFile"

# Initialize the counters
totalFiles=${#urls[@]}
processedFiles=0

# Download each file if it does not already exist
for url in "${urls[@]}"; do
    ((processedFiles++))
    # Get the filename from the URL
    filename=$(basename "$url")
    # Define the output path
    outputPath="$outputDirectory/$filename"
    # Define the temporary file path
    tempOutputPath="$outputPath.part"
    # Check if the file is already downloaded completely
    if [ -f "$outputPath" ]; then
        echo "[$processedFiles/$totalFiles] Skipping (already exists): $outputPath"
    else
        echo "[$processedFiles/$totalFiles] Downloading: $url"
        # Use wget with the -c option to continue downloading if interrupted
        if wget -c -O "$tempOutputPath" "$url"; then
            mv "$tempOutputPath" "$outputPath"
            echo "Downloaded to: $outputPath"
        else
            echo "[$processedFiles/$totalFiles] Failed to download: $url"
        fi
    fi
done

