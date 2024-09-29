Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase

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

function Get-InstalledApps {
    $statusBox.Text = "Checking. . ."
    Update-UI
    $installedApps = winget list
    $installedApps | Select-Object -Skip 1 | ForEach-Object {
        $fields = $_.Trim() -split '\s{2,}' # Split by multiple spaces
        if ($fields.Length -ge 2) {
            [PSCustomObject]@{
                Name = $fields[0] # Assuming Name is in the first column
                ID = $fields[1]   # Assuming ID is in the second column
            }
        }
    }
    Update-UI
    $statusBox.Text = "Checking Complete"
}

function Update-UI {
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [action] { })
}

function Uninstall-Software {
    param (
        [string]$app_id,
        [string]$app_name
    )
    try {
        $statusBox.Text = "Uninstalling: $app_name"
        Update-UI
        $command = "winget uninstall --id ${app_id} --silent"
        Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c $command" -Wait
        $statusBox.Text = "Successfully uninstalled: $app_name"
        Update-UI
    } catch {
        $statusBox.Text = "Failed to uninstall: $app_name"
        Update-UI
    }
}

function Install-Software {
    param (
        [string]$app_id,
        [string]$app_name
    )
    try {
        $statusBox.Text = "Installing: $app_name"
        Update-UI
        $command = "winget install --id ${app_id} --silent"
        Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c $command" -Wait
        $statusBox.Text = "Successfully installed: $app_name"
        Update-UI
    } catch {
        $statusBox.Text = "Failed to install: $app_name"
        Update-UI
    }
}

function Get-WindowsVersion {
    $osInfo = Get-CimInstance Win32_OperatingSystem

    # Retrieve the major and minor version numbers
    $version = [System.Version]$osInfo.Version

    if ($version.Major -eq 10 -and $version.Build -ge 22000) {
        return "Windows 11 Build: $version"
    }
    elseif ($version.Major -eq 10) {
        return "Windows 10 Build: $version"
    }
    else {
        return "Unknown Version"
    }
}