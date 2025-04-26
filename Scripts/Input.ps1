# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$settingsTab = New-Object -TypeName System.Windows.Controls.TabItem
$settingsTab.Header = "Update"
$settingsTab.Style = $tabStyle

# Create a StackPanel for the Settings tab content
$inputPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$inputPanel.Orientation = 'Vertical'
$inputPanel.Margin = '5'
$inputPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))


# Install-SpotX function
function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing -UseB 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
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

$utilitiesPanel.Children.Add($spotxButton)



$inputPanel.Children.Add($updateText)

# Assign settings panel to the settings tab content
$settingsTab.Content = $inputPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($settingsTab)


