# Function to download script from URL
# Function to download script from URL
function Load-ScriptFromUrl {
    param (
        [string]$url,
        [string]$subDir = $null  # Root directory (ToolBox) for Main.ps1
    )
    try {
        Write-Host "Attempting to download script from: $url"
        
        # Determine the directory (root directory for Main.ps1)
        if ($subDir) {
            $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\$subDir"
        } else {
            $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        }

        # Ensure the directory exists
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue

        # Get the file name from the URL
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        # Download the script from the URL
        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        Write-Host "Successfully downloaded script to: $tempScriptPath"
        return $tempScriptPath
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
        return $null
    }
}


# Download Main.ps1 into the root ToolBox folder
$mainUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Main.ps1"
$mainScriptPath = Load-ScriptFromUrl -url $mainUrl -subDir $null  # No subdirectory for Main.ps1

# Check if Main.ps1 exists and load it
if ($null -ne $mainScriptPath -and (Test-Path $mainScriptPath)) {
    Write-Host "Loading script from: $mainScriptPath"
    try {
        . $mainScriptPath  # Dot-sourcing Main.ps1
    } catch {
        Write-Error ("Error loading script: {0}" -f $_)
    }
} else {
    Write-Error "Script not found or failed to download: $mainScriptPath"
}

