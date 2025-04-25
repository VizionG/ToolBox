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

    # Function to create a DockPanel with actual controls
    function Get-MainDockPanel {
        $dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel

        # Create some controls to add to the DockPanel
        $button = New-Object -TypeName System.Windows.Controls.Button
        $button.Content = "Click Me"
        $button.Width = 200
        $button.Height = 50
        $button.SetValue([System.Windows.Controls.DockPanel]::DockProperty, [System.Windows.Controls.Dock]::Top)

        $textBlock = New-Object -TypeName System.Windows.Controls.TextBlock
        $textBlock.Text = "Hello, this is your application!"
        $textBlock.Foreground = [System.Windows.Media.Brushes]::White
        $textBlock.SetValue([System.Windows.Controls.DockPanel]::DockProperty, [System.Windows.Controls.Dock]::Top)

        # Add controls to the dock panel
        $dockPanel.Children.Add($button)
        $dockPanel.Children.Add($textBlock)

        return $dockPanel
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
    $mainWindow.Title = "ToolBox"
    $mainWindow.Width = 1100  
    $mainWindow.Height = 625  
    $mainWindow.ResizeMode = 'CanResize'
    $mainWindow.WindowStartupLocation = 'CenterScreen'

    # Set the icon for the window
    $iconPath = "https://viziong.github.io/ToolBox/Resources/images/v_logo.ico"  # Replace with the actual path to your icon file
    $mainWindow.Icon = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($iconPath))

    # Set the background color of the window
    $mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

    # Define the DockPanel (assuming the dockPanel comes from one of the loaded scripts)
    $mainWindow.Content = $dockPanel

    # Show the main window
    $mainWindow.ShowDialog()
}
catch {
    Write-Error "An unexpected error occurred: $_"
}
finally {
    Stop-Transcript
    Read-Host "Press Enter to close the window"
}
