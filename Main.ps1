Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$toolbox = Join-Path -Path $env:TEMP -ChildPath "ToolBox"

# Set the path to the ToolBox directory in the TEMP folder
$toolboxPath = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Scripts"

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

# Cleanup: Remove the temporary directory after the window is closed
Remove-Item -Path $toolbox -Recurse -Force -ErrorAction SilentlyContinue

$mainWindow.Add_Closing({
    # Perform any necessary cleanup here
    Write-Host "Cleaning up before closing..."
    # Optionally, you can add any code to release resources or save settings
})

# Show the main window
$mainWindow.ShowDialog()