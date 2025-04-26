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
    "Microsoft.Clipchamp",
    "Microsoft.todolist",
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

function Remove-AllApps {
    $apps = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
    
    if($apps){
        foreach ($app in $apps){
            $appaction = $app.Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start'}
            if ($appaction){
                $appaction | %{$_.DoIt(); write-host "App '$($app.Name)' unpinned from Start"}
            }
        }
    }else{
        write-error "No apps found to unpin."
    }
}




# Execute all functions
Remove-3DFolder
Set-DarkTheme
Remove-Bloatware
Remove-Cortana
Remove-MailAndTaskView
Remove-AllApps

Write-Host "Script execution completed successfully."
