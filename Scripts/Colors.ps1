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

$backgroundColor = [System.Windows.Media.Color]::FromRgb(38, 38, 38)
$brushbackground = New-Object System.Windows.Media.SolidColorBrush($backgroundColor)

# Create a SolidColorBrush from RGB values
$whiteBrush = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(255, 255, 255))

$titleBrush = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(101, 61, 201))
