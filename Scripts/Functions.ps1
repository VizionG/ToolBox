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

function Create-Sidebar {
    param (
        [System.Collections.Hashtable]$checkboxControls,
        [System.Windows.Media.Brush]$whitebrush,
        [System.Windows.Media.Brush]$brushbackground,
        [System.Windows.Style]$buttonStyle,
        [System.Collections.Hashtable]$software_categories
    )

    # Create a Grid for the sidebar section
    $sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
    $sidebarGrid.HorizontalAlignment = 'Stretch'
    $sidebarGrid.VerticalAlignment = 'Stretch'

    # Define rows for the sidebar (status and buttons)
    $sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Status row
    $sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # Buttons row

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

    # Create a StackPanel for buttons
    $buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
    $buttonPanel.Orientation = 'Vertical'
    $buttonPanel.HorizontalAlignment = 'Right'
    $buttonPanel.VerticalAlignment = 'Center'
    $buttonPanel.Margin = '5, 5, 5, 5'

    # Create and configure buttons (Check Installed, Uninstall, Install)
    $checkAppsButton = New-Object -TypeName System.Windows.Controls.Button
    $checkAppsButton.Content = "Check Installed"
    $checkAppsButton.Margin = '5'
    $checkAppsButton.Height = 30
    $checkAppsButton.Style = $buttonStyle
    $checkAppsButton.Add_Click({
        # Logic for checking installed apps
    })

    $uninstallButton = New-Object -TypeName System.Windows.Controls.Button
    $uninstallButton.Content = "Uninstall"
    $uninstallButton.Margin = '5'
    $uninstallButton.Height = 30
    $uninstallButton.Style = $buttonStyle
    $uninstallButton.Add_Click({
        # Logic for uninstalling apps
    })

    $installButton = New-Object -TypeName System.Windows.Controls.Button
    $installButton.Content = "Install"
    $installButton.Margin = '5'
    $installButton.Height = 30
    $installButton.Style = $buttonStyle
    $installButton.Add_Click({
        # Logic for installing apps
    })

    # Add buttons to the button panel
    $buttonPanel.Children.Add($checkAppsButton)
    $buttonPanel.Children.Add($uninstallButton)
    $buttonPanel.Children.Add($installButton)

    # Add button panel to sidebar grid
    [System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
    $sidebarGrid.Children.Add($buttonPanel)

    return $sidebarGrid
}