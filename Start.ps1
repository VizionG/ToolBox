function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        Write-Host "Attempting to download script from: $url"
        
        $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue
        
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        Write-Host "Successfully downloaded script to: $tempScriptPath"
        return $tempScriptPath
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
        return $null
    }
}

function DownloadAndLoadScripts {
    # Define script URLs
    $scriptUrls = @(
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Main.ps1"
    )

    $tempScriptPaths = @()
    foreach ($url in $scriptUrls) {
        $tempScriptPath = Load-ScriptFromUrl $url
        if ($tempScriptPath) {
            $tempScriptPaths += $tempScriptPath
        }
    }
}

# Run the DownloadAndLoadScripts function to download all scripts
DownloadAndLoadScripts

# After downloading, run the Main.ps1 script
$mainScriptPath = Join-Path -Path $env:TEMP\ToolBox\Scripts -ChildPath "Main.ps1"
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
