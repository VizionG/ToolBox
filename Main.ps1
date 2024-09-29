function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        # Fetch the script content using Invoke-WebRequest
        $response = Invoke-WebRequest -Uri $url -ErrorAction Stop
        $scriptContent = $response.Content
        Write-Output $scriptContent 
        Invoke-Expression $scriptContent
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
    }
}

# Define script URLs
$SoftwareCategoriesUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1"
$FunctionsUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1"
$StylesUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1"
$ColorsUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1"
$UIUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1"
$SettingsUrl = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"

# Load other scripts
Load-ScriptFromUrl $SoftwareCategoriesUrl
Load-ScriptFromUrl $FunctionsUrl
Load-ScriptFromUrl $StylesUrl
Load-ScriptFromUrl $ColorsUrl
Load-ScriptFromUrl $UIUrl
Load-ScriptFromUrl $SettingsUrl

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
