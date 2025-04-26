# Global variable for status box
$statusBox = $null

function Get-InstalledApps {
    $statusBox.Text = "Checking..."
    Update-UI
    $installedApps = winget list
    $appsList = @()
    $installedApps | Select-Object -Skip 1 | ForEach-Object {
        $fields = $_.Trim() -split '\s{2,}' # Split by multiple spaces
        if ($fields.Length -ge 2) {
            $appsList += [PSCustomObject]@{
                Name = $fields[0]
                ID   = $fields[1]
            }
        }
    }
    $statusBox.Text = "Checking Complete"
    Update-UI
    return $appsList
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
        $command = "winget uninstall --id ${app_id} --disable-interactivity --silent"
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

function New-Sidebar {
    param (
        [System.Collections.Hashtable]$checkboxControls,
        [System.Windows.Media.Brush]$whitebrush,
        [System.Windows.Media.Brush]$brushbackground,
        [System.Windows.Style]$buttonStyle,
        [System.Collections.Hashtable]$software_categories
        # Remove [ref]$statusBoxRef if not used
    )

    # Create a Grid for the sidebar section
    $sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
    $sidebarGrid.HorizontalAlignment = 'Stretch'
    $sidebarGrid.VerticalAlignment = 'Stretch'

    # Define rows for the sidebar
    $sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Status
    $sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Buttons

    # Create and configure the status TextBox
    $statusBox = New-Object -TypeName System.Windows.Controls.TextBox
    $statusBox.Height = 60
    $statusBox.Width = 170
    $statusBox.Margin = '5, 5, 5, 5'
    $statusBox.IsReadOnly = $true
    $statusBox.Text = "Waiting for actions..."
    $statusBox.FontWeight = '600'
    $statusBox.TextAlignment = 'Center'
    $statusBox.Foreground = $whitebrush
    $statusBox.Background = $brushbackground
    $statusBox.Padding = '10,10,10,10'
    $statusBox.BorderThickness = '2'
    $statusBox.TextWrapping = 'Wrap'
    $statusBox.AcceptsReturn = $true

    [System.Windows.Controls.Grid]::SetRow($statusBox, 0)
    $sidebarGrid.Children.Add($statusBox)

    # StackPanel for buttons
    $buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
    $buttonPanel.Orientation = 'Vertical'
    $buttonPanel.HorizontalAlignment = 'Right'
    $buttonPanel.VerticalAlignment = 'Center'
    $buttonPanel.Margin = '5, 5, 5, 5'

    # Check Installed button
    $checkAppsButton = New-Object -TypeName System.Windows.Controls.Button
    $checkAppsButton.Content = "Check Installed"
    $checkAppsButton.Margin = '5'
    $checkAppsButton.Height = 30
    $checkAppsButton.Style = $buttonStyle
    $checkAppsButton.Add_Click({
        Get-InstalledApps | Out-Null
    })

    # Uninstall button (example hardcoded - update to dynamic later)
    $uninstallButton = New-Object -TypeName System.Windows.Controls.Button
    $uninstallButton.Content = "Uninstall"
    $uninstallButton.Margin = '5'
    $uninstallButton.Height = 30
    $uninstallButton.Style = $buttonStyle
    $uninstallButton.Add_Click({
        Uninstall-Software -app_id "Microsoft.Edge" -app_name "Microsoft Edge"
    })

    # Install button (example hardcoded - update to dynamic later)
    $installButton = New-Object -TypeName System.Windows.Controls.Button
    $installButton.Content = "Install"
    $installButton.Margin = '5'
    $installButton.Height = 30
    $installButton.Style = $buttonStyle
    $installButton.Add_Click({
        Install-Software -app_id "Mozilla.Firefox" -app_name "Mozilla Firefox"
    })

    # Add buttons to panel
    $buttonPanel.Children.Add($checkAppsButton)
    $buttonPanel.Children.Add($uninstallButton)
    $buttonPanel.Children.Add($installButton)

    # Add panel to sidebar grid
    [System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
    $sidebarGrid.Children.Add($buttonPanel)

    return $sidebarGrid
}

# Alias
Set-Alias -Name Create-Sidebar -Value New-Sidebar

# Example usage
$checkboxControls = @{}
$software_categories = @{}
$whitebrush = [System.Windows.Media.Brushes]::White
$brushbackground = [System.Windows.Media.Brushes]::DarkSlateGray
$buttonStyle = $null # or your custom style if needed

$statusBoxRef = [ref]$null
$sidebar = New-Sidebar -checkboxControls $checkboxControls -whitebrush $whitebrush -brushbackground $brushbackground -buttonStyle $buttonStyle -software_categories $software_categories -statusBoxRef $statusBoxRef

$statusBox = $statusBoxRef.Value
