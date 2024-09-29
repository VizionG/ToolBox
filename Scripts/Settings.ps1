$SoftwareCategories = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/SoftwareCategories.ps1"
$Functions = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Functions.ps1"
$Styles = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Styles.ps1"
$Colors = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Colors.ps1"
$UI = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/UI.ps1"
$Settings = "https://raw.githubusercontent.com/VizionG/ToolBox/refs/heads/main/Scripts/Settings.ps1"

# Function to load a script from a URL
function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    Invoke-RestMethod -Uri $url | Invoke-Expression
}

# Load other scripts from GitHub
Load-ScriptFromUrl $SoftwareCategories
Load-ScriptFromUrl $Functions
Load-ScriptFromUrl $Styles
Load-ScriptFromUrl $Colors
Load-ScriptFromUrl $UI
Load-ScriptFromUrl $Settings


# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$settingsTab = New-Object -TypeName System.Windows.Controls.TabItem
$settingsTab.Header = "Settings"
$settingsTab.Style = $tabStyle

# Create a StackPanel for the Settings tab content
$settingsPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$settingsPanel.Orientation = 'Vertical'
$settingsPanel.Margin = '5'
$settingsPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Add a simple text label to the Settings page
$settingsText = New-Object -TypeName System.Windows.Controls.TextBlock
$settingsText.Text = "Settings Page"
$settingsText.FontSize = 16
$settingsText.Margin = '5'
$settingsText.Foreground = [System.Windows.Media.Brushes]::White

$settingsPanel.Children.Add($settingsText)

# Set the content of the Settings tab
$settingsTab.Content = $settingsPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($settingsTab)