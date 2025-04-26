Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Function to check and set execution policy
function Ensure-ExecutionPolicy {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser

    if ($currentPolicy -ne 'RemoteSigned') {
        Write-Host "Current execution policy is '$currentPolicy'. Changing it to 'RemoteSigned' to allow script execution."
        
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "Execution policy successfully changed to 'RemoteSigned'."
        }
        catch {
            Write-Error "Failed to change execution policy. Error: $_"
            throw "Script execution cannot proceed without appropriate policy settings."
        }
    }
    else {
        Write-Host "Execution policy is already set to 'RemoteSigned'. No changes needed."
    }
}

# Function to check if winget is installed
function Ensure-Winget {
    try {
        $wingetVersion = winget --version
        if ($wingetVersion) {
            Write-Host "winget is already installed. Version: $wingetVersion"
        }
    }
    catch {
        Write-Host "winget is not installed. Installing winget..."
        
        try {
            # Download the winget installer from GitHub
            $wingetInstallerUrl = "https://aka.ms/getwinget"
            $wingetInstallerPath = Join-Path -Path $env:TEMP -ChildPath "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

            Write-Host "Downloading winget installer..."
            Invoke-WebRequest -Uri $wingetInstallerUrl -OutFile $wingetInstallerPath -ErrorAction Stop

            # Install winget using Add-AppxPackage
            Write-Host "Installing winget..."
            Add-AppxPackage -Path $wingetInstallerPath

            Write-Host "winget installation complete."
        }
        catch {
            Write-Error "Failed to install winget. Error: $_"
            throw "Installation failed. Please try manually."
        }
    }
}

# Ensure script execution policy is set correctly
Ensure-ExecutionPolicy

# Ensure winget is installed
Ensure-Winget

# Function to download script from URL
function Download-ScriptFromUrl {
    param (
        [string]$url,
        [string]$subDir = "Scripts"  # Default subdirectory under ToolBox, unless specified
    )
    try {
        Write-Host "Attempting to download script from: $url"
        
        # Determine the directory based on whether a subdirectory is provided
        if ($subDir) {
            $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\$subDir"
        }
        else {
            $c = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        }

        # Ensure the directory exists
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue

        # Get the file name from the URL
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        # Download the script from the URL
        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        # Check if the file is downloaded and has content
        if ((Test-Path $tempScriptPath) -and ((Get-Item $tempScriptPath).Length -gt 0)) {
            Write-Host "Successfully downloaded script to: $tempScriptPath"
            return $tempScriptPath
        }
        else {
            throw "Downloaded script is empty or not found at: $tempScriptPath"
        }
    }
    catch {
        Write-Error "Failed to download script from $url. Error: $_"
        return $null
    }
}

# Function to download all required scripts
function DownloadScripts {
    # Define script URLs
    $baseUrl = "https://viziong.github.io/ToolBox/Scripts/"
    $scriptUrls = @(
        "${baseUrl}SoftwareCategories.ps1",
        "${baseUrl}Functions.ps1",
        "${baseUrl}Styles.ps1",
        "${baseUrl}Colors.ps1",
        "${baseUrl}Recommended.ps1",
        "${baseUrl}UI.ps1",
        "${baseUrl}Settings.ps1",
        "${baseUrl}Input.ps1"
    )

    $tempScriptPaths = @()
    # Download all scripts into ToolBox\Scripts folder
    foreach ($url in $scriptUrls) {
        $tempScriptPath = Download-ScriptFromUrl -url $url -subDir "Scripts"
        if ($tempScriptPath) {
            Write-Host "Downloaded script: $tempScriptPath"
            $tempScriptPaths += $tempScriptPath
        }
        else {
            Write-Error "Failed to download script from: $url"
        }
    }

    # Return the paths of downloaded scripts
    return $tempScriptPaths
}

# Create the main window and UI containers FIRST
$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "ToolBox"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$iconPath = "https://viziong.github.io/ToolBox/Resources/images/v_logo.ico"
$mainWindow.Icon = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($iconPath))
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

$dockPanel = New-Object System.Windows.Controls.DockPanel
$tabControl = New-Object System.Windows.Controls.TabControl
$dockPanel.Children.Add($tabControl)
$mainWindow.Content = $dockPanel

# Now download and load scripts
$tempScriptPaths = DownloadScripts

foreach ($scriptPath in $tempScriptPaths) {
    try {
        Write-Host "Loading script: $scriptPath"
        . $scriptPath > $null 2>&1
    }
    catch {
        Write-Error ("Failed to load script " + $scriptPath + ": " + $_)
    }
}

# Register the event handler for the Closing event
$mainWindow.Add_Closing({
    try {
        $toolBoxFolder = Join-Path -Path $env:TEMP -ChildPath "ToolBox"
        if (Test-Path $toolBoxFolder) {
            Write-Host "Deleting temporary ToolBox folder: $toolBoxFolder"
            Remove-Item -Path $toolBoxFolder -Recurse -Force
            Write-Host "Temporary ToolBox folder deleted."
        }
    }
    catch {
        Write-Error "Failed to delete ToolBox folder. Error: $_"
    }
})

# Show the main window
$mainWindow.ShowDialog()