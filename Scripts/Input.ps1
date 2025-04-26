# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a new TabItem for the Settings tab
$inputTab = New-Object -TypeName System.Windows.Controls.TabItem
$inputTab.Header = "Update"
$inputTab.Style = $tabStyle

# Create a StackPanel for the Settings tab content
$inputPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$inputPanel.Orientation = 'Vertical'
$inputPanel.Margin = '5'
$inputPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))

# Function to download and run the latest Visual C++ Redistributable installer
function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing -UseB 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}


# Add a simple text label to the Settings page
$updateText = New-Object -TypeName System.Windows.Controls.TextBlock
$updateText.Text = "Update:"
$updateText.FontSize = 16
$updateText.Margin = '5'
$updateText.Foreground = [System.Windows.Media.Brushes]::White

$inputPanel.Children.Add($updateText)

# Ensure this block is before the Add_Click method
$spotxButton = New-Object -TypeName System.Windows.Controls.Button
$spotxButton.Content = "Microsoft Visual C++"
$spotxButton.Style = $buttonStyle  # Apply the button style if needed
$spotxButton.Margin = '5'           # Add margin for spacing
$spotxButton.Width = 200             # Set a fixed width for the button
$spotxButton.HorizontalAlignment ='Left'
$spotxButton.VerticalAlignment ='center'

$spotxButton.Add_Click({
    Install-SpotX
})

# Add the button to the settings panel
$inputPanel.Children.Add($spotxButton)

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
$inputPanel.Children.Add($installDirectXButton)

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
$inputPanel.Children.Add($alphaDebloatButton)

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
$inputPanel.Children.Add($installDotNetButton)


# Assign settings panel to the settings tab content
$inputTab.Content = $inputPanel

# Add the Settings tab to the TabControl
$tabControl.Items.Add($inputTab)


