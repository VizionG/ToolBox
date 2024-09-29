# Correct raw URLs of the scripts hosted on GitHub
$SoftwareCategories = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1"
$Functions = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1"
$Styles = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1"
$Colors = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1"
$UI = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1"
$Settings = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"

# Function to load and run a script from a URL
function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        # Fetch the script content
        $scriptContent = Invoke-RestMethod -Uri $url -ErrorAction Stop
        Invoke-Expression $scriptContent
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
    }
}

# Load each script explicitly
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

# Assuming $dockPanel is defined in one of the scripts
$mainWindow.Content = $dockPanel

# Show the main window
$mainWindow.ShowDialog()
