# Parse the Style from XAML
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Utilities tab
$inputTab = New-Object -TypeName System.Windows.Controls.TabItem
$inputTab.Header = "Utilities"
$inputTab.Style = $tabStyle

# Create a StackPanel for the Utilities tab content
$inputPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$inputPanel.Orientation = 'Vertical'
$inputPanel.Margin = '5'
$inputPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Create and configure the SpotX Button
$spotxButton = New-Object -TypeName System.Windows.Controls.Button
$spotxButton.Content = "SpotX"
$spotxButton.Style = $buttonStyle
$spotxButton.Margin = '5'
$spotxButton.Width = 200
$spotxButton.HorizontalAlignment = 'Left'
$spotxButton.VerticalAlignment = 'Center'

# Add Click event for SpotX button
$spotxButton.Add_Click({
    Install-SpotX
})

# Add SpotX button to the input panel
$inputPanel.Children.Add($spotxButton)

# Create another button, for example, Install button
$installButton = New-Object -TypeName System.Windows.Controls.Button
$installButton.Content = "Install"
$installButton.Style = $buttonStyle
$installButton.Margin = '5'
$installButton.Width = 200
$installButton.HorizontalAlignment = 'Left'
$installButton.VerticalAlignment = 'Center'

# Add Click event for Install button
$installButton.Add_Click({
    InstallApp
})

# Add Install button to the input panel
$inputPanel.Children.Add($installButton)

# Create a Grid to organize the InputPanel and SidebarGrid
$utilitiesGrid = New-Object -TypeName System.Windows.Controls.Grid
$utilitiesGrid.HorizontalAlignment = 'Stretch'
$utilitiesGrid.VerticalAlignment = 'Stretch'

# Define two columns (input panel and sidebar)
$col1 = New-Object System.Windows.Controls.ColumnDefinition
$col1.Width = '1*'   # Left side (for buttons)
$col2 = New-Object System.Windows.Controls.ColumnDefinition
$col2.Width = 'Auto'  # Right side (for sidebar)
$utilitiesGrid.ColumnDefinitions.Add($col1)
$utilitiesGrid.ColumnDefinitions.Add($col2)

# Create the sidebar using the function
$sidebarGrid = Create-Sidebar -checkboxControls $null -whitebrush $whitebrush -brushbackground $brushbackground -buttonStyle $buttonStyle -software_categories $null

# Add the sidebar to the utilities grid
$utilitiesGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 1)

# Add the input panel with buttons to the left side
$utilitiesGrid.Children.Add($inputPanel)
[System.Windows.Controls.Grid]::SetColumn($inputPanel, 0)

# Assign the utilities grid as the content of the input tab
$inputTab.Content = $utilitiesGrid

# Add the Settings tab to the TabControl
$tabControl.Items.Add($inputTab)

# Install-SpotX function
function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}

# InstallApp function (just a placeholder)
function InstallApp {
    Write-Host "App installation started..."
    # Add your installation logic here
}
