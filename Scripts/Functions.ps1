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
        $command = "winget uninstall --id ${app_id} --disable-interactivity --silent --accept-source-agreements --accept-package-agreements"
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
        [string]$app_name,
        [string]$installer = "custom", # Default installer is custom for direct download
        [string]$installerUrl = $null,
        [string]$installerFileName = $null,
        [string]$installerLocation = $null
    )
    
    try {
        $statusBox.Text = "Installing: $app_name"
        Update-UI

        if ($installerUrl -ne $null -and $installerFileName -ne $null -and $installerLocation -ne $null) {
            Write-Output "Downloading $app_name from $installerUrl..."
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerLocation
        }

        if ($installerLocation -match "\.exe$") {
            Write-Output "Installing $app_name silently..."
            Start-Process -FilePath $installerLocation -ArgumentList "/S" -NoNewWindow -Wait
        } elseif ($installer -eq "choco") {
            Start-Process -NoNewWindow -FilePath "choco" -ArgumentList "install $app_id -y --no-progress --accept-license" -Wait
        } else {
            Start-Process -NoNewWindow -FilePath "winget" -ArgumentList "install --id $app_id --silent --accept-source-agreements --accept-package-agreements" -Wait
        }

        $statusBox.Text = "Successfully installed: $app_name"
        Update-UI
    } catch {
        $statusBox.Text = "Failed to install: $app_name"
        Write-Output "Error: $_"
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