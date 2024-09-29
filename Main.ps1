# URL of the script hosted on GitHub (raw version)
$SoftwareCategories = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/SoftwareCategories.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"
$Functions = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Functions.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"
$Styles = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Styles.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"
$Colors = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Colors.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"
$UI = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/UI.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"
$Settings = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Settings.ps1?token=GHSAT0AAAAAACYGXXYJ2F4N352AJ5R47GXSZXZTV2A"

# Load other scripts
. $SoftwareCategories
. $Functions
. $Styles
. $Colors
. $UI
. $Settings

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
