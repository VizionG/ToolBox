# Parse the Style from XAML
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Utilities tab
$inputTab = New-Object -TypeName System.Windows.Controls.TabItem
$inputTab.Header = "Utilities"
$inputTab.Style = $tabStyle

# Create a grid for the layout
$inputGrid = New-Object System.Windows.Controls.Grid
$inputGrid.HorizontalAlignment = 'Stretch'
$inputGrid.VerticalAlignment = 'Stretch'
$inputGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))    # Content column
$inputGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='180'}))  # Sidebar column

# --- Left: Content Panel (SpotX) ---
$inputPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$inputPanel.Orientation = 'Vertical'
$inputPanel.Margin = '5'
$inputPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

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

$inputPanel.Children.Add($updateText)
$inputPanel.Children.Add($spotxButton)

$inputGrid.Children.Add($inputPanel)
[System.Windows.Controls.Grid]::SetColumn($inputPanel, 0)

# --- Right: Sidebar (copied from UI.ps1) ---
$sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
$sidebarGrid.HorizontalAlignment = 'Stretch'
$sidebarGrid.VerticalAlignment = 'Stretch'
$sidebarGrid.MinWidth = 180
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))

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

$checkAppsButton = New-Object -TypeName System.Windows.Controls.Button
$checkAppsButton.Content = "Check Installed"
$checkAppsButton.Margin = '5'
$checkAppsButton.Height = 30
$checkAppsButton.Style = $buttonStyle

$uninstallButton = New-Object -TypeName System.Windows.Controls.Button
$uninstallButton.Content = "Uninstall"
$uninstallButton.Margin = '5'
$uninstallButton.Height = 30
$uninstallButton.Style = $buttonStyle

$installButton = New-Object -TypeName System.Windows.Controls.Button
$installButton.Content = "Install"
$installButton.Margin = '5'
$installButton.Height = 30
$installButton.Style = $buttonStyle

$recommendedButton = New-Object -TypeName System.Windows.Controls.Button
$recommendedButton.Content = "Recommended"
$recommendedButton.Margin = '5'
$recommendedButton.Height = 30
$recommendedButton.Style = $buttonStyle

$buttonPanel.Children.Add($recommendedButton)
$buttonPanel.Children.Add($checkAppsButton)
$buttonPanel.Children.Add($uninstallButton)
$buttonPanel.Children.Add($installButton)

[System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
$sidebarGrid.Children.Add($buttonPanel)

$inputGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 1)

# Assign the grid to the tab content
$inputTab.Content = $inputGrid

# Add the Utilities tab to the TabControl
$tabControl.Items.Add($inputTab)


