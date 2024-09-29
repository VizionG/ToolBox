# Correct raw URLs of the scripts hosted on GitHub
$SoftwareCategories = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1"
$Functions = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1"
$Styles = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1"
$Colors = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1"
$UI = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1"
$Settings = "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"

# Load scripts directly from GitHub using Invoke-RestMethod
Invoke-RestMethod -Uri $SoftwareCategories | Invoke-Expression
Invoke-RestMethod -Uri $Functions | Invoke-Expression
Invoke-RestMethod -Uri $Styles | Invoke-Expression
Invoke-RestMethod -Uri $Colors | Invoke-Expression
Invoke-RestMethod -Uri $UI | Invoke-Expression
Invoke-RestMethod -Uri $Settings | Invoke-Expression

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
