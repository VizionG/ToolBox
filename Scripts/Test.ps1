# Create a DockPanel as the main layout container
$dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel
$dockPanel.HorizontalAlignment = 'Stretch'
$dockPanel.VerticalAlignment = 'Stretch'
$dockPanel.LastChildFill = $true

# Create a Grid for the main layout (just one column for the sidebar)
$mainGrid = New-Object -TypeName System.Windows.Controls.Grid
$mainGrid.HorizontalAlignment = 'Stretch'
$mainGrid.VerticalAlignment = 'Stretch'

# Single column (sidebar only)
$sidebarColumn = New-Object System.Windows.Controls.ColumnDefinition
$sidebarColumn.Width = '180'
$mainGrid.ColumnDefinitions.Add($sidebarColumn)

# Create a Grid for the sidebar section (on the right)
$sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
$sidebarGrid.HorizontalAlignment = 'Stretch'
$sidebarGrid.VerticalAlignment = 'Stretch'

# Define rows for the sidebar (status and logos)
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Logos/status row

# Add Vizion logo
$vizionLogo = New-Object -TypeName System.Windows.Controls.Image
$vizionLogo.HorizontalAlignment = 'Center'
$vizionLogo.VerticalAlignment = 'Top'
$vizionLogo.Margin = '5, 5, 5, 5'
$imageSource = "https://viziong.github.io/ToolBox/Resources/images/v_logo.png"
$vizionLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
$sidebarGrid.Children.Add($vizionLogo)

# Add Windows logo
$windowsLogo = New-Object -TypeName System.Windows.Controls.Image
$windowsLogo.HorizontalAlignment = 'Center'
$windowsLogo.VerticalAlignment = 'Top'
$windowsLogo.Margin = '5, 150, 5, 5'
$windowsVersion = Get-WindowsVersion
if ($windowsVersion -like "*11*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_11_logo.png"
} elseif ($windowsVersion -like "*10*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_10_logo.png"
}
$windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
$sidebarGrid.Children.Add($windowsLogo)

# Add the status TextBox
$statusBox = New-Object -TypeName System.Windows.Controls.TextBox
$statusBox.Height = 60
$statusBox.Width = 170
$statusBox.Margin = '5, 190, 5, 5'
$statusBox.IsReadOnly = $true
$statusBox.Text = "Detect: $windowsVersion"
$statusBox.FontWeight = '600'
$statusBox.TextAlignment = 'Center'
$statusBox.Foreground = $whitebrush
$statusBox.Background = $brushbackground
$statusBox.Padding = '10,10,10,10'
$statusBox.BorderThickness = '2'
$statusBox.TextWrapping = 'Wrap'
$statusBox.AcceptsReturn = $true
$sidebarGrid.Children.Add($statusBox)

# Add sidebarGrid to mainGrid
$mainGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 0)

# Add mainGrid to dockPanel
$dockPanel.Children.Add($mainGrid)
