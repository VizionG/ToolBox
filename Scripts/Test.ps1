# --- Sidebar + Content in a New Tab ---

# Assumes $tabControl, $tabItemStyle, $buttonStyle, $whitebrush, $brushbackground, etc. are already available

# Create a new TabItem for the sidebar/content demo
$sidebarTab = New-Object System.Windows.Controls.TabItem
$sidebarTab.Header = "Utilities"
$sidebarTab.Style = $tabItemStyle

# Create a new grid for the tab layout
$sidebarTabGrid = New-Object System.Windows.Controls.Grid
$sidebarTabGrid.HorizontalAlignment = 'Stretch'
$sidebarTabGrid.VerticalAlignment = 'Stretch'
$sidebarTabGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))    # Content column
$sidebarTabGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='180'}))  # Sidebar column

# --- Content for the left side (SpotX button and label) ---
$leftPanel = New-Object System.Windows.Controls.StackPanel
$leftPanel.Orientation = 'Vertical'
$leftPanel.Margin = 20

$updateText = New-Object -TypeName System.Windows.Controls.TextBlock
$updateText.Text = "Update:"
$updateText.FontSize = 16
$updateText.Margin = '5'
$updateText.Foreground = [System.Windows.Media.Brushes]::White

function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}

$spotxButton = New-Object -TypeName System.Windows.Controls.Button
$spotxButton.Content = "SpotX"
$spotxButton.Style = $buttonStyle
$spotxButton.Margin = '5'
$spotxButton.Width = 200
$spotxButton.HorizontalAlignment = 'Left'
$spotxButton.VerticalAlignment = 'Center'

$spotxButton.Add_Click({
    Install-SpotX
})

$leftPanel.Children.Add($updateText)
$leftPanel.Children.Add($spotxButton)

$sidebarTabGrid.Children.Add($leftPanel)
[System.Windows.Controls.Grid]::SetColumn($leftPanel, 0)

# --- Sidebar for the right side (copied from UI.ps1) ---
$sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
$sidebarGrid.HorizontalAlignment = 'Stretch'
$sidebarGrid.VerticalAlignment = 'Stretch'

# Define rows for the sidebar (status and buttons)
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Status row
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Buttons row

$vizionLogo = New-Object -TypeName System.Windows.Controls.Image
$vizionLogo.HorizontalAlignment = 'Center'
$vizionLogo.VerticalAlignment = 'Top'
$vizionLogo.Margin = '5, 5, 5, 5'
$imageSource = "https://viziong.github.io/ToolBox/Resources/images/v_logo.png"
$vizionLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
$sidebarGrid.Children.Insert(0, $vizionLogo)

$windowsLogo = New-Object -TypeName System.Windows.Controls.Image
$windowsLogo.HorizontalAlignment = 'Center'
$windowsLogo.VerticalAlignment = 'Top'
$windowsLogo.Margin = '5, 150, 5, 5'
$windowsVersion = Get-WindowsVersion
if ($windowsVersion -like "*11*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_11_logo.png"
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
} elseif ($windowsVersion -like "*10*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_10_logo.png"
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
}
$sidebarGrid.Children.Insert(0, $windowsLogo)

$statusBox = New-Object -TypeName System.Windows.Controls.TextBox
$statusBox.Height = 60
$statusBox.Width = 170
$statusBox.Margin = '5, 190, 5, 5'
$statusBox.IsReadOnly = $true
$statusBox.Text = "Waiting for actions..."
$statusBox.FontWeight = '600'
$statusBox.TextAlignment = 'Center'
$statusBox.Foreground = $whitebrush
$statusBox.Background = $brushbackground
$statusBox.Padding = '10,10,10,10'
$statusBox.BorderThickness = '2'
$statusBox.TextWrapping = 'Wrap'
$statusBox.AcceptsReturn = $true
[System.Windows.Controls.Grid]::SetRow($statusBox, 0)
$sidebarGrid.Children.Add($statusBox)

$statusBox.Text = "Detect: $windowsVersion"

$buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Right'
$buttonPanel.VerticalAlignment = 'Center'
$buttonPanel.Margin = '5, 60, 26, 5'


[System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
$sidebarGrid.Children.Add($buttonPanel)

# Add the sidebar to the right column of the grid
$sidebarTabGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 1)

# Set the grid as the content of the new tab
$sidebarTab.Content = $sidebarTabGrid

# Add the new tab to the TabControl
$tabControl.Items.Add($sidebarTab)