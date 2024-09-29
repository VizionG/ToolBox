Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$toolboxPath = Join-Path -Path $env:TEMP -ChildPath "ToolBox"

# Load other scripts
. .\SoftwareCategories.ps1
. .\Functions.ps1
. .\Styles.ps1
. .\Colors.ps1
. .\UI.ps1
. .\Settings.ps1

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
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
