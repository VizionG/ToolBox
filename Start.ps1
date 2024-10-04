Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Function to download script from URL
function Download-ScriptFromUrl {
    param (
        [string]$url,
        [string]$subDir = "Scripts"  # Default subdirectory under ToolBox, unless specified
    )
    try {
        Write-Host "Attempting to download script from: $url"
        
        # Determine the directory based on whether a subdirectory is provided
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
        Write-Error "Failed to download script from $url. Error: $_"
        return $null
    }
}

# Function to download all required scripts
function DownloadScripts {
    # Define script URLs
    $scriptUrls = @(
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"
    )

    $tempScriptPaths = @()
    # Download all scripts into ToolBox\Scripts folder
    foreach ($url in $scriptUrls) {
        $tempScriptPath = Download-ScriptFromUrl -url $url -subDir "Scripts"
        if ($tempScriptPath) {
            $tempScriptPaths += $tempScriptPath
        }
    }

    # Return the paths of downloaded scripts
    return $tempScriptPaths
}

# Download all scripts
$tempScriptPaths = DownloadScripts

# Log the path of Main.ps1
$mainUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Main.ps1"
$mainScriptPath = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Main.ps1"

# Download Main.ps1 if not already downloaded
if (-not (Test-Path $mainScriptPath)) {
    $mainScriptPath = Download-ScriptFromUrl -url $mainUrl -subDir $null  # No subdirectory for Main.ps1
}

# Check if Main.ps1 exists and run it with administrator rights
if (Test-Path $mainScriptPath) {
    Write-Host "Running Main.ps1 with administrator rights"
    
    # Prepare to start Main.ps1 with elevated privileges without a console window
    try {
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = "powershell.exe"
        $processInfo.Arguments = "-ExecutionPolicy Bypass -File `"$mainScriptPath`""
        $processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden  # Hide the window
        
        # Start the process and wait for it to exit
        $process = [System.Diagnostics.Process]::Start($processInfo)
        $process.WaitForExit()  # Wait for the process to exit
    } catch {
        Write-Error "Failed to run Main.ps1. Error: $_"
    } finally {
        # Cleanup: Remove the temporary directory after the window is closed
        $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Cleaned up temporary directory: $tempDir"
    }
} else {
    Write-Error "Script not found or failed to download: $mainScriptPath"
}