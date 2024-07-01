# Get the script directory
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the relative path to your .txt file
$urlsFile = Join-Path -Path $scriptDirectory -ChildPath "datasets\datasets.txt"

# Define the relative output directory
$outputDirectory = Join-Path -Path $scriptDirectory -ChildPath "datasets"

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

# Read the URLs from the .txt file
$urls = Get-Content -Path $urlsFile

# Create a WebClient instance
$webClient = New-Object System.Net.WebClient

# Initialize the counters
$totalFiles = $urls.Count
$processedFiles = 0

# Download each file if it does not already exist
foreach ($url in $urls) {
    try {
        # Get the filename from the URL
        $filename = [System.IO.Path]::GetFileName($url)
        
        # Define the output path
        $outputPath = Join-Path -Path $outputDirectory -ChildPath $filename
        
        # Increment the processed files counter
        $processedFiles++
        
        # Check if the file already exists
        if (-Not (Test-Path -Path $outputPath)) {
            # Download the file if it doesn't exist
            Write-Host "[$processedFiles/$totalFiles] Downloading: $url"
            $webClient.DownloadFile($url, $outputPath)
            Write-Host "Downloaded to: $outputPath"
        } else {
            Write-Host "[$processedFiles/$totalFiles] Skipping (already exists): $outputPath"
        }
    } catch {
        $errorMsg = $_.Exception.Message
        Write-Host "[$processedFiles/$totalFiles] Failed to download: $url - Error: $errorMsg"
    }
}

# Dispose of the WebClient object
$webClient.Dispose()
