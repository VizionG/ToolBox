# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
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
        # GitHub API URL to get the latest release information
        $apiUrl = "https://api.github.com/repos/abbodi1406/vcredist/releases/latest"

        # Get the latest release data
        $releaseData = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{ "User-Agent" = "PowerShell" }

        # Log the asset names for troubleshooting
        Write-Host "Available assets:"
        $releaseData.assets | ForEach-Object { Write-Host $_.name }

        # Extract the download URL for the installer (e.g., vcredist_x64.exe)
        $downloadUrl = $releaseData.assets | Where-Object { $_.name -like "*VisualCppRedist_AIO_x86_x64.exe"} | Select-Object -ExpandProperty browser_download_url

        if (-not $downloadUrl) {
            Write-Error "Download URL not found for the latest release."
            return
        }

        # Set the path for the downloaded file
        $downloadPath = Join-Path -Path $env:TEMP -ChildPath "vcredist_x64.exe"

        # Download the installer
        Write-Host "Downloading Visual C++ Redistributable from: $downloadUrl"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -ErrorAction Stop

        Write-Host "Download completed. Running installer..."
        
        # Execute the installer
        Start-Process -FilePath $downloadPath -ArgumentList "/install /quiet /norestart" -Wait -NoNewWindow

        Write-Host "Visual C++ Redistributable installed successfully."
        
        # Optionally, remove the installer after running
        Remove-Item -Path $downloadPath -Force
    }
    catch {
        Write-Error "Failed to download or install Visual C++ Redistributable. Error: $_"
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

if ($vcredisButton -ne $null) {
    $vcredisButton.Add_Click({
        DownloadAndRunVCRedist
    })
} else {
    Write-Error "Button not initialized."
}

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

# Set the content of the Settings tab
$settingsTab.Content = $settingsPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($settingsTab)