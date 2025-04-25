Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Define log file path
$logFile = "$env:TEMP\ToolBox.log"

# Start logging everything
Start-Transcript -Path $logFile -Append -Force

try {
    $baseFolder = Join-Path -Path $env:TEMP -ChildPath "ToolBox"

    # Function to download script from URL
    function Download-ScriptFromUrl {
        param (
            [Parameter(Mandatory)]
            [string]$url,
            [Parameter(Mandatory)]
            [string]$subDir
        )

        $scriptName = [System.IO.Path]::GetFileName($url)
        $scriptFolder = Join-Path -Path $baseFolder -ChildPath $subDir

        if (-not (Test-Path $scriptFolder)) {
            New-Item -ItemType Directory -Path $scriptFolder -Force | Out-Null
        }

        $destinationPath = Join-Path -Path $scriptFolder -ChildPath $scriptName

        try {
            Invoke-WebRequest -Uri $url -OutFile $destinationPath -ErrorAction Stop
            Write-Host "Downloaded: $scriptName"
            return $destinationPath
        } catch {
            Write-Error "Failed to download script from:`n$url"
            return $null
        }
    }

    # Function to download all required scripts
    function DownloadScripts {
        $scriptUrls = @(
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
            "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1"
        )

        $tempScriptPaths = @()
        foreach ($url in $scriptUrls) {
            $tempScriptPath = Download-ScriptFromUrl -url $url -subDir "Scripts"
            if ($tempScriptPath) {
                Write-Host "Downloaded script: $tempScriptPath"
                $tempScriptPaths += $tempScriptPath
            } else {
                Write-Error "Failed to download script from: $url"
            }
        }

        return $tempScriptPaths
    }

    # Download all scripts
    $tempScriptPaths = DownloadScripts

    # Load the downloaded scripts into the current session
    foreach ($scriptPath in $tempScriptPaths) {
        try {
            Write-Host "Loading script: $scriptPath"
            . $scriptPath
        }
        catch {
            Write-Error ("Failed to load script ${scriptPath}: $_")
        }
    }

    # Relaunch as administrator if not already elevated
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }

    # Ensure dockPanel is defined before using it
    $dockPanel = Get-MainDockPanel

    # Create the main window
    $mainWindow = New-Object -TypeName System.Windows.Window
    $mainWindow.Title = "Software Manager"
    $mainWindow.Width = 1100
    $mainWindow.Height = 625
    $mainWindow.ResizeMode = 'CanResize'
    $mainWindow.WindowStartupLocation = 'CenterScreen'

    # Set the background color of the window
    $mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

    # Set content from loaded script (UI.ps1 should define $dockPanel)
    if (-not $dockPanel) {
        Write-Host "dockPanel is null or not defined!"
    } else {
        $mainWindow.Content = $dockPanel
    }

    $mainWindow.Add_Closed({
        if (Test-Path $baseFolder) {
            try {
                Remove-Item -Path $baseFolder -Recurse -Force
                Write-Host "Deleted temporary folder: $baseFolder"
            }
            catch {
                Write-Warning "Could not delete the temporary folder: $_"
            }
        }
    })

    try {
        $mainWindow.ShowDialog()
    } catch {
        Write-Error "Failed to show main window: $_"
    }

}
catch {
    Write-Error "An unexpected error occurred: $_"
}
finally {
    Stop-Transcript
    Read-Host "Press Enter to close the window"
}
