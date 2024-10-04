Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

. .\Scripts\Colors.ps1
. .\Scripts\Functions.ps1
. .\Scripts\SoftwareCategories.ps1
. .\Scripts\Styles.ps1
. .\Scripts\Recommended.ps1
. .\Scripts\Ui.ps1
. .\Scripts\Settings.ps1

# Create the main window
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "ToolBox"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$iconPath = "https://viziong.github.io/ToolBox/Resources/images/v_logo.ico"  # Replace with the actual path to your icon file
$mainWindow.Icon = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($iconPath))


# Set the background color of the window
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Define the DockPanel (assuming the dockPanel comes from one of the loaded scripts)
$mainWindow.Content = $dockPanel

# Show the main window
$mainWindow.ShowDialog()
