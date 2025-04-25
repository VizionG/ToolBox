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

# Function to remove bloatware
function Remove-Bloatware {
    Write-Host "Removing bloatware..."

    # List of common bloatware apps to uninstall (add more apps to the list as needed)
    $BloatwareApps = @(
    "Microsoft.3DViewer",
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
    "Microsoft.ZuneVideo",
    "Microsoft.Copilot"
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

function Remove-Cortana {
    Write-Host "Attempting to remove Cortana..." -ForegroundColor Yellow

    try {
        # Remove Cortana for all users
        $cortanaPackages = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*Cortana*" }
        foreach ($pkg in $cortanaPackages) {
            Write-Host "Removing Cortana for user: $($pkg.PackageUserInformation.UserSecurityId)"
            Remove-AppxPackage -Package $pkg.PackageFullName -ErrorAction SilentlyContinue
        }

        # Remove Cortana from provisioned packages (so it doesn't reinstall)
        $provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*Cortana*" }
        foreach ($prov in $provisioned) {
            Write-Host "Removing provisioned Cortana package: $($prov.DisplayName)"
            Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction SilentlyContinue
        }

        Write-Host "Cortana removal attempt completed." -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to remove Cortana. Error: $_"
    }
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

function Clear-StartMenuPins {
    param (
        [string]$LayoutPath = "$env:TEMP\BlankStartLayout.xml"
    )

    Write-Host "Creating blank Start Menu layout XML..."
    @"
<LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" Version="1">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" />
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@ | Set-Content -Path $LayoutPath -Encoding UTF8

    Write-Host "Importing layout for new users..."
    try {
        Import-StartLayout -LayoutPath $LayoutPath -MountPath $env:SystemDrive\
        Write-Host "Blank layout applied for new users."
    }
    catch {
        Write-Warning "Failed to import layout for new users: $_"
    }

    Write-Host "Resetting Start Menu for current user..."
    try {
        Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue

        Remove-Item "$env:LocalAppData\Microsoft\Windows\Shell\LayoutModification.xml" -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\Shell\DefaultLayouts.xml" -ErrorAction SilentlyContinue
        Remove-Item "$env:LocalAppData\Microsoft\Windows\Shell\CloudStore" -Recurse -Force -ErrorAction SilentlyContinue

        Write-Host "Start Menu layout reset. Please sign out and sign back in to apply changes."
    }
    catch {
        Write-Warning "Error resetting Start Menu: $_"
    }
}



# Execute all functions
Remove-3DFolder
Set-DarkTheme
Remove-Bloatware
Remove-Cortana
Remove-MailAndTaskView
Clear-StartMenuPins

Write-Host "Script execution completed successfully."
