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

$vizionLogo = New-Object -TypeName System.Windows.Controls.Image
$vizionLogo.HorizontalAlignment = 'Center'
$vizionLogo.VerticalAlignment = 'Top'
$vizionLogo.Margin = '5, 5, 5, 5'
# Set the source for the logo image
$imageSource = "https://viziong.github.io/ToolBox/Resources/images/v_logo.png"  # Replace with the actual path to your image
$vizionLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))

$sidebarGrid.Children.Insert(0, $vizionLogo)

# Create an Image control
$windowsLogo = New-Object -TypeName System.Windows.Controls.Image
$windowsLogo.HorizontalAlignment = 'Center'  # Center the image
$windowsLogo.VerticalAlignment = 'Top'  # Align to the top
$windowsLogo.Margin = '5, 150, 5, 5'  # Margin for some spacing

# Set the image source based on Windows version
$windowsVersion = Get-WindowsVersion

# Set image source based on Windows version
if ($windowsVersion -like "*11*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_11_logo.png"  # Replace with the actual path to your Windows 11 image
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
} elseif ($windowsVersion -like "*10*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_10_logo.png"  # Replace with the actual path to your Windows 10 image
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
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

# Create and configure Check Installed Apps button
$checkAppsButton = New-Object -TypeName System.Windows.Controls.Button
$checkAppsButton.Content = "Check Installed"
$checkAppsButton.Margin = '5'
$checkAppsButton.Height = 30  # Set button height

$checkAppsButton.Style = $buttonStyle
$checkAppsButton.Add_Click({
    $installedAppsList = Get-InstalledApps
    foreach ($checkbox in $checkboxControls.Values) {
        $app_name = $checkbox.Content.ToString()
        $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
        if ($app_info) {
            $winget_id = $app_info.winget_id
            $names = $app_info.names

            $isInstalled = $installedAppsList | Where-Object {
                ($_.ID -eq $winget_id) -or ($_.Name -in $names)
            }

            $checkbox.IsChecked = $isInstalled -ne $null
        }
    }
})

# Create and configure Uninstall button
$uninstallButton = New-Object -TypeName System.Windows.Controls.Button
$uninstallButton.Content = "Uninstall"
$uninstallButton.Margin = '5'
$uninstallButton.Height = 30  # Set button height

$uninstallButton.Style = $buttonStyle
$uninstallButton.Add_Click({
    foreach ($checkbox in $checkboxControls.Values) {
        if ($checkbox.IsChecked -eq $true) {
            $app_name = $checkbox.Content.ToString()
            $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
            if ($app_info) {
                $app_id = $app_info.winget_id
                Uninstall-Software -app_id $app_id -app_name $app_name
            }
        }
    }
})

# Create and configure Install button
$installButton = New-Object -TypeName System.Windows.Controls.Button
$installButton.Content = "Install"
$installButton.Margin = '5'
$installButton.Height = 30  # Set button height

$installButton.Style = $buttonStyle
$installButton.Add_Click({
    foreach ($checkbox in $checkboxControls.Values) {
        if ($checkbox.IsChecked -eq $true) {
            $app_name = $checkbox.Content.ToString()
            $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
            if ($app_info) {
                $app_id = $app_info.winget_id
                Install-Software -app_id $app_id -app_name $app_name
            }
        }
    }
})

# Create and configure Recommended button
$recommendedButton = New-Object -TypeName System.Windows.Controls.Button
$recommendedButton.Content = "Recommended"
$recommendedButton.Margin = '5'
$recommendedButton.Height = 30  # Set button height
$recommendedButton.Style = $buttonStyle

# Add click event for the Recommended button (You can define the action inside the script)
$recommendedButton.Add_Click({
    # Uncheck all checkboxes first (optional, if you want to clear previous selections)
    foreach ($checkbox in $checkboxControls.Values) {
        $checkbox.IsChecked = $false
    }
    
    # Check the specific recommended checkboxes
    foreach ($app in $recommendedSoftware) {
        if ($checkboxControls.ContainsKey($app)) {
            $checkboxControls[$app].IsChecked = $true
        }
    }

    # Update status (optional)
    $statusBox.Text = "Selected Recommended Apps" + ($specificRecommendedApps -join ', ')
})

# Add the Recommended button to the button panel (above Check Installed)
$buttonPanel.Children.Insert(0, $recommendedButton)  # Insert at index 0 to place it at the top

# Add buttons to button panel
$buttonPanel.Children.Add($checkAppsButton)
$buttonPanel.Children.Add($uninstallButton)
$buttonPanel.Children.Add($installButton)

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


