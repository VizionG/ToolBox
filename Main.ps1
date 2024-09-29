# Define the path to the temporary script folder
$tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Scripts"

# Define the order of the scripts to load
$scriptOrder = @(
    "SoftwareCategories.ps1",
    "Functions.ps1",
    "Styles.ps1",
    "Colors.ps1",
    "UI.ps1",
    "Settings.ps1"
)

# Load each script in the defined order
foreach ($scriptName in $scriptOrder) {
    $scriptPath = Join-Path -Path $tempDir -ChildPath $scriptName
    if (Test-Path $scriptPath) {
        Write-Host "Loading script from: $scriptPath"
        try {
            . $scriptPath  # Dot-sourcing the script
        } catch {
            Write-Error ("Error loading script from {0}: {1}" -f $scriptPath, $_)
        }
    } else {
        Write-Error "Script not found: $scriptPath"
    }
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
