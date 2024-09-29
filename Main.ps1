# URLs of the scripts hosted on GitHub (raw version)
$SoftwareCategories = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/SoftwareCategories.ps1"
$Functions = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Functions.ps1"
$Styles = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Styles.ps1"
$Colors = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Colors.ps1"
$UI = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/UI.ps1"
$Settings = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Settings.ps1"

# Function to load a script from a URL
function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    Invoke-RestMethod -Uri $url | Invoke-Expression
}

# Load other scripts from GitHub
Load-ScriptFromUrl $SoftwareCategories
Load-ScriptFromUrl $Functions
Load-ScriptFromUrl $Styles
Load-ScriptFromUrl $Colors
Load-ScriptFromUrl $UI
Load-ScriptFromUrl $Settings

# Create the main window
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "Software Manager"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Assign dockPanel as the window's content (Make sure $dockPanel is defined in the loaded scripts)
$mainWindow.Content = $dockPanel

# Show the main window
$mainWindow.ShowDialog()
