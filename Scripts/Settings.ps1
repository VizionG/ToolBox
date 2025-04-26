# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$settingsTab = New-Object -TypeName System.Windows.Controls.TabItem
$settingsTab.Header = "Update"
$settingsTab.Style = $tabStyle

# Create a grid for the layout
$settingsGrid = New-Object System.Windows.Controls.Grid
$settingsGrid.HorizontalAlignment = 'Stretch'
$settingsGrid.VerticalAlignment = 'Stretch'
$settingsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))    # Content column
$settingsGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='180'}))  # Sidebar column

# --- Left: Content Panel ---
$settingsPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$settingsPanel.Orientation = 'Vertical'
$settingsPanel.Margin = '5'
$settingsPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Function to download and run the latest Visual C++ Redistributable installer
function DownloadAndRunVCRedist {
    try {
        $apiUrl = "https://api.github.com/repos/abbodi1406/vcredist/releases/latest"
        $releaseData = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ "User-Agent" = "PowerShell" }

        Write-Host "Available assets:"
        $releaseData.assets | ForEach-Object { Write-Host $_.name }

        $installerAsset = $releaseData.assets | Where-Object { $_.name -like "*VisualCppRedist_AIO_x86_x64*.exe" } | Select-Object -First 1

        if (-not $installerAsset) {
            Write-Error "Installer not found."
            return
        }

        $downloadUrl = $installerAsset.browser_download_url
        $downloadPath = Join-Path -Path $env:TEMP -ChildPath $installerAsset.name

        Write-Host "Downloading from: $downloadUrl"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -ErrorAction Stop

        if (Test-Path $downloadPath) {
            Write-Host "Installer downloaded to: $downloadPath"
        } else {
            Write-Error "Download failed."
            return
        }

        Write-Host "Running installer..."
        Start-Process -FilePath $downloadPath -ArgumentList "/install /quiet /norestart" -Wait -NoNewWindow

        Write-Host "Installation complete."
        Remove-Item -Path $downloadPath -Force
    }
    catch {
        Write-Error "Error: $_"
    }
}

# Add a simple text label to the Settings page
$updateText = New-Object -TypeName System.Windows.Controls.TextBlock
$updateText.Text = "Update:"
$updateText.FontSize = 16
$updateText.Margin = '5'
$updateText.Foreground = [System.Windows.Media.Brushes]::White

$settingsPanel.Children.Add($updateText)

# Ensure this block is before the Add_Click method
$vcredisButton = New-Object -TypeName System.Windows.Controls.Button
$vcredisButton.Content = "Microsoft Visual C++"
$vcredisButton.Style = $buttonStyle  # Apply the button style if needed
$vcredisButton.Margin = '5'           # Add margin for spacing
$vcredisButton.Width = 200             # Set a fixed width for the button
$vcredisButton.HorizontalAlignment ='Left'
$vcredisButton.VerticalAlignment ='center'

$vcredisButton.Add_Click({
    DownloadAndRunVCRedist
})

# Add the button to the settings panel
$settingsPanel.Children.Add($vcredisButton)

# Add a button for installing DirectX
$installDirectXButton = New-Object -TypeName System.Windows.Controls.Button
$installDirectXButton.Content = "Install DirectX"
$installDirectXButton.Style = $buttonStyle  # Apply the button style if needed
$installDirectXButton.Margin = '5'           # Add margin for spacing
$installDirectXButton.Width = 200             # Set a fixed width for the button
$installDirectXButton.HorizontalAlignment = 'Left'  # Center horizontally
$installDirectXButton.VerticalAlignment = 'Center'        # Align to the top vertically

# Set the button click event
$installDirectXButton.Add_Click({
    try {
        # Command to install DirectX
        $command = 'winget install -e --id Microsoft.DirectX'
        # Start the process to execute the command
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command $command" -Wait -NoNewWindow
        Write-Host "DirectX installation initiated."
    }
    catch {
        Write-Error "Failed to install DirectX. Error: $_"
    }
})

# Add the install DirectX button to the settings panel
$settingsPanel.Children.Add($installDirectXButton)

# Add Alpha Debloat
$alphaDebloatButton = New-Object -TypeName System.Windows.Controls.Button
$alphaDebloatButton.Content = "Alpha Debloat"
$alphaDebloatButton.Style = $buttonStyle  # Apply the button style if needed
$alphaDebloatButton.Margin = '5'           # Add margin for spacing
$alphaDebloatButton.Width = 200             # Set a fixed width for the button
$alphaDebloatButton.HorizontalAlignment = 'Left'  # Center horizontally
$alphaDebloatButton.VerticalAlignment = 'Center'        # Align to the top vertically

# Set the click event for the Alpha Debloat button
$alphaDebloatButton.Add_Click({
    try {
        $url = "https://viziong.github.io/ToolBox/Scripts/AlphaDebloat.ps1"
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"iwr -useb '$url' | iex`"" -Wait -NoNewWindow
        Write-Host "Alpha Debloat script executed from GitHub."
    }
    catch {
        Write-Error "Failed to run Alpha Debloat script from GitHub. Error: $_"
    }
})

# Add the Alpha Debloat button to the settings panel
$settingsPanel.Children.Add($alphaDebloatButton)

# Add a button for installing .NET Framework
$installDotNetButton = New-Object -TypeName System.Windows.Controls.Button
$installDotNetButton.Content = ".NET Framework"
$installDotNetButton.Style = $buttonStyle  # Apply the button style if needed
$installDotNetButton.Margin = '5'           # Add margin for spacing
$installDotNetButton.Width = 200             # Set a fixed width for the button
$installDotNetButton.HorizontalAlignment = 'Left'  # Center horizontally
$installDotNetButton.VerticalAlignment = 'Center'        # Align to the top vertically

# Set the button click event
$installDotNetButton.Add_Click({
    try {
        # Command to install .NET Framework
        $command = 'winget install -e --id Microsoft.DotNet.Framework.DeveloperPack_4'
        # Start the process to execute the command
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command $command" -Wait -NoNewWindow
        Write-Host ".NET Framework installation initiated."
    }
    catch {
        Write-Error "Failed to install .NET Framework. Error: $_"
    }
})

# Add the install .NET Framework button to the settings panel
$settingsPanel.Children.Add($installDotNetButton)

# Add the left panel to the grid
$settingsGrid.Children.Add($settingsPanel)
[System.Windows.Controls.Grid]::SetColumn($settingsPanel, 0)

# --- Right: Sidebar (copied from UI.ps1) ---
$sidebarGrid = New-Object -TypeName System.Windows.Controls.Grid
$sidebarGrid.HorizontalAlignment = 'Stretch'
$sidebarGrid.VerticalAlignment = 'Stretch'
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
$sidebarGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))

$vizionLogo = New-Object -TypeName System.Windows.Controls.Image
$vizionLogo.HorizontalAlignment = 'Center'
$vizionLogo.VerticalAlignment = 'Top'
$vizionLogo.Margin = '5, 5, 5, 5'
$imageSource = "https://viziong.github.io/ToolBox/Resources/images/v_logo.png"
$vizionLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
$sidebarGrid.Children.Insert(0, $vizionLogo)

$windowsLogo = New-Object -TypeName System.Windows.Controls.Image
$windowsLogo.HorizontalAlignment = 'Center'
$windowsLogo.VerticalAlignment = 'Top'
$windowsLogo.Margin = '5, 150, 5, 5'
$windowsVersion = Get-WindowsVersion
if ($windowsVersion -like "*11*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_11_logo.png"
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
} elseif ($windowsVersion -like "*10*") {
    $imageSource = "https://viziong.github.io/ToolBox/Resources/images/Windows_10_logo.png"
    $windowsLogo.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($imageSource))
}
$sidebarGrid.Children.Insert(0, $windowsLogo)

$statusBox = New-Object -TypeName System.Windows.Controls.TextBox
$statusBox.Height = 60
$statusBox.Width = 170
$statusBox.Margin = '5, 190, 5, 5'
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

$statusBox.Text = "Detect: $windowsVersion"

$buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Vertical'
$buttonPanel.HorizontalAlignment = 'Right'
$buttonPanel.VerticalAlignment = 'Center'
$buttonPanel.Margin = '5, 60, 26, 5'


[System.Windows.Controls.Grid]::SetRow($buttonPanel, 1)
$sidebarGrid.Children.Add($buttonPanel)

# Add the sidebar to the right column of the grid
$settingsGrid.Children.Add($sidebarGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarGrid, 1)

# Assign the grid to the tab content
$settingsTab.Content = $settingsGrid

# Add the Settings tab to the TabControl
$tabControl.Items.Add($settingsTab)


