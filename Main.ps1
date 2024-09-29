Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Set the path to the ToolBox directory in the TEMP folder
$toolboxPath = Join-Path -Path $env:TEMP -ChildPath "ToolBox"

# Construct full file paths from the toolboxPath
$softwareCategoriesPath = Join-Path -Path $toolboxPath -ChildPath "SoftwareCategories.ps1"
$functionsPath = Join-Path -Path $toolboxPath -ChildPath "Functions.ps1"
$stylesPath = Join-Path -Path $toolboxPath -ChildPath "Styles.ps1"
$colorsPath = Join-Path -Path $toolboxPath -ChildPath "Colors.ps1"
$uiPath = Join-Path -Path $toolboxPath -ChildPath "UI.ps1"
$settingsPath = Join-Path -Path $toolboxPath -ChildPath "Settings.ps1"

# Load the scripts with error handling
$scriptFiles = @(
    $softwareCategoriesPath,
    $functionsPath,
    $stylesPath,
    $colorsPath,
    $uiPath,
    $settingsPath
)

foreach ($script in $scriptFiles) {
    if (Test-Path $script) {
        try {
            . $script
        } catch {
            Write-Host "Error loading script_"
        }
    } else {
        Write-Host "File not found: $script"
    }
}

# Your UI code continues here


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
