Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Function to check and set execution policy
function Ensure-ExecutionPolicy {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser

    if ($currentPolicy -ne 'RemoteSigned') {
        Write-Host "Current execution policy is '$currentPolicy'. Changing it to 'RemoteSigned' to allow script execution."
        
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "Execution policy successfully changed to 'RemoteSigned'."
        }
        catch {
            Write-Error "Failed to change execution policy. Error: $_"
            throw "Script execution cannot proceed without appropriate policy settings."
        }
    }
    else {
        Write-Host "Execution policy is already set to 'RemoteSigned'. No changes needed."
    }
}

# Ensure script execution policy is set correctly
Ensure-ExecutionPolicy

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
        }
        else {
            $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        }

        # Ensure the directory exists
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue

        # Get the file name from the URL
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        # Download the script from the URL
        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        # Check if the file is downloaded and has content
        if ((Test-Path $tempScriptPath) -and ((Get-Item $tempScriptPath).Length -gt 0)) {
            Write-Host "Successfully downloaded script to: $tempScriptPath"
            return $tempScriptPath
        }
        else {
            throw "Downloaded script is empty or not found at: $tempScriptPath"
        }
    }
    catch {
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
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Recommended.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"
    )

    $tempScriptPaths = @()
    # Download all scripts into ToolBox\Scripts folder
    foreach ($url in $scriptUrls) {
        $tempScriptPath = Download-ScriptFromUrl -url $url -subDir "Scripts"
        if ($tempScriptPath) {
            Write-Host "Downloaded script: $tempScriptPath"
            $tempScriptPaths += $tempScriptPath
        }
        else {
            Write-Error "Failed to download script from: $url"
        }
    }

    # Return the paths of downloaded scripts
    return $tempScriptPaths
}

# Download all scripts
$tempScriptPaths = DownloadScripts

# Load the downloaded scripts into the current session
foreach ($scriptPath in $tempScriptPaths) {
    try {
        Write-Host "Loading script: $scriptPath"
        . $scriptPath
    }
    catch {
        Write-Error ("Failed to load script " + $scriptPath + ": " + $_)
    }
}

# Create the main window
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "ToolBox"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$iconPath = "https://viziong.github.io/ToolBox/Resources/images/v_logo.ico"  # Replace with the actual path to your icon file
$mainWindow.Icon = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($iconPath))

# Set the background color of the window
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Define the DockPanel (assuming the dockPanel comes from one of the loaded scripts)
$mainWindow.Content = $dockPanel

# Show the main window
$mainWindow.ShowDialog()
