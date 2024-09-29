function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        # Create a temporary directory for the scripts
        $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Scripts"
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue
        
        # Define the path for the downloaded script
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        # Fetch the script content using Invoke-WebRequest and save it to a temp file
        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        # Return the path of the downloaded script
        return $tempScriptPath
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
        return $null
    }
}

# Define script URLs (corrected)
$scriptUrls = @(
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
    "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"
)

# Load each script and store their paths
$tempScriptPaths = @()
foreach ($url in $scriptUrls) {
    $tempScriptPath = Load-ScriptFromUrl $url
    if ($tempScriptPath) {
        $tempScriptPaths += $tempScriptPath
    }
}

# Load scripts from the temp folder using dot-sourcing
foreach ($scriptPath in $tempScriptPaths) {
    Write-Host "Loading script from: $scriptPath"
    . $scriptPath  # Dot-sourcing the script
}

# Create a DockPanel to use in the main window
$dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel

# Create the main window
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "Software Manager"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Assign dockPanel as the window's content
$mainWindow.Content = $dockPanel

# Show the main window
$mainWindow.ShowDialog()

# Cleanup: Remove the temporary directory after the window is closed
Remove-Item -Path (Join-Path -Path $env:TEMP -ChildPath "ToolBox") -Recurse -Force -ErrorAction SilentlyContinue
