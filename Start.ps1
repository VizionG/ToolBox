Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Function to download script from URL
function Load-ScriptFromUrl {
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
        Write-Error "Failed to load script from $url. Error: $_"
        return $null
    }
}

# Function to download and load all required scripts
function DownloadAndLoadScripts {
    # Define script URLs
    $scriptUrls = @(
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"
    )

    # Download all scripts into ToolBox\Scripts folder
    foreach ($url in $scriptUrls) {
        Load-ScriptFromUrl -url $url -subDir "Scripts"
    }

    # Download Main.ps1 into the root ToolBox folder
    $mainUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Main.ps1"
    $mainScriptPath = Load-ScriptFromUrl -url $mainUrl -subDir $null  # No subdirectory for Main.ps1

    return $mainScriptPath
}

# Run the DownloadAndLoadScripts function to download all scripts
$mainScriptPath = DownloadAndLoadScripts

# Set the path to the Main.ps1 script in the root ToolBox folder
if (Test-Path $mainScriptPath) {
    Write-Host "Loading Main script from: $mainScriptPath"
    try {
        . $mainScriptPath  # Dot-sourcing Main.ps1
    } catch {
        Write-Error ("Error loading Main script: {0}" -f $_)
    }
} else {
    Write-Error "Main script not found: $mainScriptPath"
}
