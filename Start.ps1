Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

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

    $tempScriptPaths = @()
    # Download all scripts into ToolBox\Scripts folder
    foreach ($url in $scriptUrls) {
        $tempScriptPath = Load-ScriptFromUrl -url $url -subDir "Scripts"
        if ($tempScriptPath) {
            $tempScriptPaths += $tempScriptPath
        }
    }

    # Download Main.ps1 into the root ToolBox folder
    $mainUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Main.ps1"
    $mainScriptPath = Load-ScriptFromUrl -url $mainUrl -subDir $null  # No subdirectory for Main.ps1

    if ($mainScriptPath) {
        $tempScriptPaths += $mainScriptPath
    }

    return $tempScriptPaths
}

# Run the DownloadAndLoadScripts function to download all scripts
$tempScriptPaths = DownloadAndLoadScripts

# Log the path of Main.ps1 before loading
Write-Host "Main.ps1 path: $mainScriptPath"

# Check if Main.ps1 exists and load it
if ($mainScriptPath -and (Test-Path $mainScriptPath)) {
    Write-Host "Running Main.ps1"
    Write-Host "Script location: $PSScriptRoot"
    Write-Host "Loading script from: $mainScriptPath"
    try {
        . $mainScriptPath  # Dot-sourcing Main.ps1
    } catch {
        Write-Error ("Error loading script: {0}" -f $_)
    }
} else {
    Write-Error "Script not found or failed to download: $mainScriptPath"
}
