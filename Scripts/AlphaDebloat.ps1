# Function to remove the 3D folder
function Remove-3DFolder {
    $folderPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\3D Objects"
    if (Test-Path -Path $folderPath) {
        Write-Host "Removing 3D Objects folder..."
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Host "3D Objects folder removed."
    } else {
        Write-Host "3D Objects folder not found."
    }
}

# Function to set Dark theme
function Set-DarkTheme {
    Write-Host "Setting Dark theme..."
    # Set registry value to enable dark theme for Windows
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
    Write-Host "Dark theme applied."
}

# Function to apply Ultimate Performance power plan
function Apply-UltimatePerformance {
    Write-Host "Applying Ultimate Performance power plan..."
    # Check if Ultimate Performance is available
    $powerPlan = "Ultimate Performance"
    $powerPlans = powercfg /L

    if ($powerPlans -contains $powerPlan) {
        powercfg /S $powerPlan
        Write-Host "Ultimate Performance power plan applied."
    } else {
        Write-Host "Ultimate Performance power plan is not available. Enabling it..."
        powercfg /duplicatescheme a1841308-3541-4fab-bc81-7e2b4c6fbbf4
        powercfg /S a1841308-3541-4fab-bc81-7e2b4c6fbbf4
        Write-Host "Ultimate Performance power plan applied."
    }
}

# Function to remove bloatware
function Remove-Bloatware {
    Write-Host "Removing bloatware..."

    # List of common bloatware apps to uninstall (add more apps to the list as needed)
    $BloatwareApps = @(
    "Microsoft.Microsoft3DViewer",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.GetHelp",
    "Microsoft.FeedbackHub",
    "Microsoft.FilmAndTV",
    "Microsoft.gethelp",
    "Microsoft.BingMaps",
    "Microsoft.Cortana",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.MSPaint",
    "Microsoft.Office.OneNote",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.Whiteboard",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)


foreach ($app in $bloatwareApps) {
    try {
        # Remove for all current users
        $packages = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$app*" }
        foreach ($pkg in $packages) {
            Remove-AppxPackage -Package $pkg.PackageFullName -ErrorAction SilentlyContinue
            Write-Host "$($pkg.Name) removed for user: $($pkg.PackageUserInformation.UserSecurityId)"
        }

        # Remove the provisioned version so it doesn’t reinstall for new users
        $provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$app*" }
        foreach ($prov in $provisioned) {
            Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction SilentlyContinue
            Write-Host "$($prov.DisplayName) removed from provisioned packages."
        }
    }
    catch {
        Write-Warning "Failed to remove $app. Error: $_"
    }
}


    Write-Host "Bloatware removal complete."
}

function Remove-MailAndTaskView {
    # Unpin Mail app from Start Menu (if pinned)
    $MailApp = Get-AppxPackage -Name "Microsoft.OutlookForWindows" 
    if ($MailApp) {
        $MailApp | Remove-AppxPackage
        Write-Host "Mail app unpinned from Start Menu."
    } else {
        Write-Host "Mail app is not installed or already removed."
    }

    # Disable Task View from Taskbar (Registry Method)
    $taskViewRegistryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $taskViewRegistryValue = "ShowTaskViewButton"

    # Set the registry key to disable Task View
    Set-ItemProperty -Path $taskViewRegistryKey -Name $taskViewRegistryValue -Value 0

    # Restart explorer to apply changes
    Stop-Process -Name explorer -Force
    Start-Process explorer
    Write-Host "Task View removed from Taskbar."
}

function Unpin-AllStartMenuItems {
    # Load the Shell.Application COM object
    $shell = New-Object -ComObject Shell.Application

    # Get the Start Menu folder
    $startMenu = $shell.Namespace('shell:::{5D6E6A7A-6B07-4C87-A0BF-B6B657C6E0D0}')

    # Check if the Start Menu folder was retrieved successfully
    if ($startMenu -eq $null) {
        Write-Error "Failed to access Start Menu folder."
        return
    }

    # Loop through all items in the Start Menu
    foreach ($item in $startMenu.Items()) {
        Write-Host "Item found: $($item.Name)"
        try {
            # Unpin each item
            $item.InvokeVerb('unpin from start')
            Write-Host "Unpinned: $($item.Name)"
        }
        catch {
            Write-Warning "Failed to unpin $($item.Name): $_"
        }
    }

    # Clean up the COM object
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
}


# Execute all functions
Remove-3DFolder
Set-DarkTheme
Apply-UltimatePerformance
Remove-Bloatware
Remove-MailAndTaskView
Unpin-AllStartMenuItems

Write-Host "Script execution completed successfully."
