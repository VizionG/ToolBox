# Parse the Style from XAML
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$inputTab = New-Object -TypeName System.Windows.Controls.TabItem
$inputTab.Header = "Utilities"
$inputTab.Style = $tabStyle

# Create a StackPanel for the Settings tab content
$inputPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$inputPanel.Orientation = 'Vertical'
$inputPanel.Margin = '5'
$inputPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Add a simple text label to the Settings page
$updateText = New-Object -TypeName System.Windows.Controls.TextBlock
$updateText.Text = "Update:"
$updateText.FontSize = 16
$updateText.Margin = '5'
$updateText.Foreground = [System.Windows.Media.Brushes]::White

# Create a Grid for the sidebar section (on the right)
$sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
$sidebarGrid.HorizontalAlignment = 'Stretch'
$sidebarGrid.VerticalAlignment = 'Stretch'

# Define rows for the sidebar (status and buttons)
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Status row
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Buttons row

# Create a small StackPanel for the logos
$logoPanel = New-Object System.Windows.Controls.StackPanel
$logoPanel.Orientation = 'Vertical'
$logoPanel.HorizontalAlignment = 'Center'
$logoPanel.VerticalAlignment = 'Top'
$logoPanel.Margin = '5'

# Create a new vizionLogo Image
$vizionLogo1 = New-Object -TypeName System.Windows.Controls.Image
$vizionLogo1.HorizontalAlignment = 'Center'
$vizionLogo1.VerticalAlignment = 'Top'
$vizionLogo1.Margin = '5'
$vizionLogo1.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new("https://viziong.github.io/ToolBox/Resources/images/v_logo.png"))


# Create Windows logo
$windowsLogo = New-Object System.Windows.Controls.Image
$windowsLogo.HorizontalAlignment = 'Center'
$windowsLogo.VerticalAlignment = 'Top'
$windowsLogo.Margin = '5, 10, 5, 5'

# Add logos into the panel
$logoPanel.Children.Add($vizionLogo1)
$logoPanel.Children.Add($windowsLogo)

# Finally add the logo panel into the sidebar grid
$sidebarGrid.Children.Insert(0, $logoPanel)

# Now set Windows logo based on version
$windowsVersion = Get-WindowsVersion

if ($windowsVersion -like "*11*") {
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new("https://viziong.github.io/ToolBox/Resources/images/Windows_11_logo.png"))
} elseif ($windowsVersion -like "*10*") {
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new("https://viziong.github.io/ToolBox/Resources/images/Windows_10_logo.png"))
}


# Add the Image control to the sidebar grid above the status box
$sidebarGrid.Children.Insert(0, $windowsLogo)  # Insert at index 0 to place it at the top

# Create and configure the status TextBox (for the sidebar)
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
$statusBox.TextWrapping = 'Wrap'  # Allow text to wrap when it hits the border
$statusBox.AcceptsReturn = $true  # Enable multiline text input/display
[System.Windows.Controls.Grid]::SetRow($statusBox, 0)  # Place in the first row
$sidebarGrid.Children.Add($statusBox)

# Get Windows version and update the status box text
$windowsVersion = Get-WindowsVersion
$statusBox.Text = "Detect: $windowsVersion"

# Create a StackPanel for buttons (second row)
$buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Right'
$buttonPanel.VerticalAlignment = 'Center'
$buttonPanel.Margin = '5, 60, 26, 5'


# Add button panel to sidebar grid (second row)
[System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
$sidebarGrid.Children.Add($buttonPanel)

# Add both grids to the main Grid
$mainGrid.Children.Add($categoriesGrid)
$mainGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 1)  # Set sidebarGrid to second column

# Install-SpotX function
function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}


# SpotX Button
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

$inputPanel.Children.Add($spotxButton)

# Assign settings panel to the settings tab content
$inputTab.Content = $inputPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($inputTab)


