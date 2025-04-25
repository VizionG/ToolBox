Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Function to download script from URL
function Download-ScriptFromUrl {
    param (
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$subDir
    )

    $scriptName = [System.IO.Path]::GetFileName($url)
    $scriptFolder = Join-Path -Path $PSScriptRoot -ChildPath $subDir

    if (-not (Test-Path $scriptFolder)) {
        New-Item -ItemType Directory -Path $scriptFolder -Force | Out-Null
    }

    $destinationPath = Join-Path -Path $scriptFolder -ChildPath $scriptName

    try {
        Invoke-WebRequest -Uri $url -OutFile $destinationPath -ErrorAction Stop
        Write-Host "Downloaded: $scriptName"
        return $destinationPath
    } catch {
        Write-Error "Failed to download script from:`n$url"
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

# Relaunch as administrator if not already elevated
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Create the main window
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "ToolBox"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'

# Set the background color of the window
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Fallback if $dockPanel is not defined
if (-not $dockPanel) {
    Write-Warning "`$dockPanel is null. Creating a default DockPanel."
    $dockPanel = New-Object System.Windows.Controls.DockPanel
    $textBlock = New-Object System.Windows.Controls.TextBlock
    $textBlock.Text = "Failed to load UI components."
    $textBlock.Foreground = [System.Windows.Media.Brushes]::White
    $textBlock.Margin = '20'
    $dockPanel.Children.Add($textBlock)
}

# Define the DockPanel (assuming the dockPanel comes from one of the loaded scripts)
$mainWindow.Content = $dockPanel

# Add Closed event to delete the Scripts folder
$mainWindow.Add_Closed({
    $scriptsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
    if (Test-Path $scriptsFolder) {
        try {
            Remove-Item -Path $scriptsFolder -Recurse -Force
            Write-Host "Temporary scripts folder deleted: $scriptsFolder"
        }
        catch {
            Write-Warning "Failed to delete temporary scripts folder: $_"
        }
    }
})

# Show the main window
$mainWindow.ShowDialog()
