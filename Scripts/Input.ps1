# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create the TabControl
$tabControl = New-Object System.Windows.Controls.TabControl

# Create Utilities Tab
$utilitiesTab = New-Object -TypeName System.Windows.Controls.TabItem
$utilitiesTab.Header = "Utilities"
$utilitiesTab.Style = $tabStyle

# Create Utilities Panel
$utilitiesPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$utilitiesPanel.Orientation = 'Vertical'
$utilitiesPanel.Margin = '5'
$utilitiesPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Add "Utilities:" TextBlock
$utilitiesText = New-Object -TypeName System.Windows.Controls.TextBlock
$utilitiesText.Text = "Utilities:"
$utilitiesText.FontSize = 16
$utilitiesText.Margin = '5'
$utilitiesText.Foreground = [System.Windows.Media.Brushes]::White
$utilitiesPanel.Children.Add($utilitiesText)

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

# Add Utilities Panel to Tab
$utilitiesTab.Content = $utilitiesPanel

# Add Tab to TabControl
$tabControl.Items.Add($utilitiesTab)
