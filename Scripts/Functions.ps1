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