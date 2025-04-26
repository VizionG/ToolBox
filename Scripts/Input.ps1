# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Utilities tab
$utilitiesTab = New-Object -TypeName System.Windows.Controls.TabItem
$utilitiesTab.Header = "Utilities"
$utilitiesTab.Style = $tabStyle

# Create a StackPanel for the Utilities tab content
$utilitiesPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$utilitiesPanel.Orientation = 'Vertical'
$utilitiesPanel.Margin = '5'
$utilitiesPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Example: Add a TextBlock for the Utilities tab
$utilitiesText = New-Object -TypeName System.Windows.Controls.TextBlock
$utilitiesText.Text = "Utilities:"
$utilitiesText.FontSize = 16
$utilitiesText.Margin = '5'
$utilitiesText.Foreground = [System.Windows.Media.Brushes]::White

# Add the text to the utilities panel
$utilitiesPanel.Children.Add($utilitiesText)

function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing -UseB 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}

# Ensure this block is before the Add_Click method
$spotxButton = New-Object -TypeName System.Windows.Controls.Button
$spotxButton.Content = "SpotX"
$spotxButton.Style = $buttonStyle  # Apply the button style if needed
$spotxButton.Margin = '5'           # Add margin for spacing
$spotxButton.Width = 200             # Set a fixed width for the button
$spotxButton.HorizontalAlignment ='Left'
$spotxButton.VerticalAlignment ='center'

$spotxButton.Add_Click({
    Install-SpotX
})

# Add the button to the settings panel
$inputPanel.Children.Add($spotxButton)

# Add the button to the Utilities panel
$utilitiesPanel.Children.Add($exampleButton)

# Assign the panel to the tab
$utilitiesTab.Content = $utilitiesPanel

# Finally, add the Utilities tab to the TabControl
$tabControl.Items.Add($utilitiesTab)



