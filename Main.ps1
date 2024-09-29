function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        # Fetch the script content using Invoke-RestMethod
        $scriptContent = Invoke-RestMethod -Uri $url -ErrorAction Stop
        Write-Output $scriptContent 
        Invoke-Expression $scriptContent
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
    }
}



# Define script URLs
$SoftwareCategoriesUrl = "https://viziong.github.io/ToolBox/main/Scripts/SoftwareCategories.ps1"
$FunctionsUrl = "https://viziong.github.io/ToolBox/main/Scripts/Functions.ps1"
$StylesUrl = "https://viziong.github.io/ToolBox/main/Scripts/Styles.ps1"
$ColorsUrl = "https://viziong.github.io/ToolBox/main/Scripts/Colors.ps1"
$UIUrl = "https://viziong.github.io/ToolBox/main/Scripts/UI.ps1"
$SettingsUrl = "https://viziong.github.io/ToolBox/main/Scripts/Settings.ps1"

# Load other scripts
Load-ScriptFromUrl $SoftwareCategoriesUrl
Load-ScriptFromUrl $FunctionsUrl
Load-ScriptFromUrl $StylesUrl
Load-ScriptFromUrl $ColorsUrl
Load-ScriptFromUrl $UIUrl
Load-ScriptFromUrl $SettingsUrl

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
