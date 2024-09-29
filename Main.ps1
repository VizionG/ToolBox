function Load-ScriptFromUrl {
    param (
        [string]$url
    )
    try {
        Write-Host "Attempting to download script from: $url"
        
        $tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Scripts"
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction SilentlyContinue
        
        $scriptName = [System.IO.Path]::GetFileName($url)
        $tempScriptPath = Join-Path -Path $tempDir -ChildPath $scriptName

        Invoke-WebRequest -Uri $url -OutFile $tempScriptPath -ErrorAction Stop
        
        Write-Host "Successfully downloaded script to: $tempScriptPath"
        return $tempScriptPath
    } catch {
        Write-Error "Failed to load script from $url. Error: $_"
        return $null
    }
}

# Define script URLs
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
    $tempScriptPath = Load-ScriptFromUrl $url
    if ($tempScriptPath) {
        $tempScriptPaths += $tempScriptPath
    }
}

$tempDir = Join-Path -Path $env:TEMP -ChildPath "ToolBox\Scripts"
Write-Host "Scripts in temp directory: "
Get-ChildItem -Path $tempDir | ForEach-Object { Write-Host $_.Name }

$scriptOrder = @(
    "SoftwareCategories.ps1",
    "Functions.ps1",
    "Styles.ps1",
    "Colors.ps1",
    "UI.ps1",
    "Settings.ps1"
)

foreach ($scriptName in $scriptOrder) {
    $scriptPath = Join-Path -Path $env:TEMP\ToolBox\Scripts -ChildPath $scriptName
    if (Test-Path $scriptPath) {
        Write-Host "Loading script from: $scriptPath"
        try {
            . $scriptPath
            
            if ($scriptName -eq "UI.ps1" -and (Get-Command -Name "InitializeUI" -ErrorAction SilentlyContinue)) {
                Write-Host "InitializeUI function found."
            }
        } catch {
            Write-Error ("Error loading script from {0}: {1}" -f $scriptPath, $_)
        }
    } else {
        Write-Error "Script not found: $scriptPath"
    }
}

$dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel

$mainWindow = New-Object -TypeName System.Windows.Window
$mainWindow.Title = "Software Manager"
$mainWindow.Width = 1100  
$mainWindow.Height = 625  
$mainWindow.ResizeMode = 'CanResize'
$mainWindow.WindowStartupLocation = 'CenterScreen'
$mainWindow.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

$mainWindow.Content = $dockPanel

$mainWindow.ShowDialog()
