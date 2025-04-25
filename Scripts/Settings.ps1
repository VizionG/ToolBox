# Parse the Style from XAML
$tabControl = New-Object -TypeName System.Windows.Controls.TabControl
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$settingsTab = New-Object -TypeName System.Windows.Controls.TabItem
$settingsTab.Header = "Update"
$settingsTab.Style = $tabStyle

# Create a StackPanel for the Settings tab content
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
        $command = 'winget install -e --id Microsoft.DotNet.Framework'
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

# Add a button for installing .NET 6
$installDotNet6Button = New-Object -TypeName System.Windows.Controls.Button
$installDotNet6Button.Content = ".NET 6"
$installDotNet6Button.Style = $buttonStyle  # Apply the button style if needed
$installDotNet6Button.Margin = '5'           # Add margin for spacing
$installDotNet6Button.Width = 200             # Set a fixed width for the button
$installDotNet6Button.HorizontalAlignment = 'Left'  # Center horizontally
$installDotNet6Button.VerticalAlignment = 'Center'        # Align to the top vertically

# Set the button click event
$installDotNet6Button.Add_Click({
    try {
        # Command to install .NET 6
        $command = 'winget install -e --id Microsoft.DotNet.6'
        # Start the process to execute the command
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command $command" -Wait -NoNewWindow
        Write-Host ".NET 6 installation initiated."
    }
    catch {
        Write-Error "Failed to install .NET 6. Error: $_"
    }
})

# Add the install .NET 6 button to the settings panel
$settingsPanel.Children.Add($installDotNet6Button)

# Add a button for installing .NET 7
$installDotNet7Button = New-Object -TypeName System.Windows.Controls.Button
$installDotNet7Button.Content = ".NET 7"
$installDotNet7Button.Style = $buttonStyle  # Apply the button style if needed
$installDotNet7Button.Margin = '5'           # Add margin for spacing
$installDotNet7Button.Width = 200             # Set a fixed width for the button
$installDotNet7Button.HorizontalAlignment = 'Left'  # Center horizontally
$installDotNet7Button.VerticalAlignment = 'Center'        # Align to the top vertically

# Set the button click event
$installDotNet7Button.Add_Click({
    try {
        # Command to install .NET 7
        $command = 'winget install -e --id Microsoft.DotNet.7'
        # Start the process to execute the command
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command $command" -Wait -NoNewWindow
        Write-Host ".NET 7 installation initiated."
    }
    catch {
        Write-Error "Failed to install .NET 7. Error: $_"
    }
})

# Add the install .NET 7 button to the settings panel
$settingsPanel.Children.Add($installDotNet7Button)

# Set the content of the Settings tab
$settingsTab.Content = $settingsPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($settingsTab)
