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

$inputPanel.Children.Add($updateText)
$inputPanel.Children.Add($spotxButton)

# Assign settings panel to the settings tab content
$inputTab.Content = $inputPanel

# Add the Settings tab to the TabControl
$inputTab.Content = $inputPanel
$tabControl.Items.Add($inputTab)


