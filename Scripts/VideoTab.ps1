# Create a new TabItem for the video
$videoTab = New-Object System.Windows.Controls.TabItem
$videoTab.Header = "Video"
$videoTab.Style = $tabItemStyle

# Create a grid for layout (optional)
$videoGrid = New-Object System.Windows.Controls.Grid
$videoGrid.HorizontalAlignment = 'Stretch'
$videoGrid.VerticalAlignment = 'Stretch'

# Create the MediaElement
$mediaElement = New-Object System.Windows.Controls.MediaElement
$mediaElement.Width = 800
$mediaElement.Height = 450
$mediaElement.LoadedBehavior = 'Manual'
$mediaElement.UnloadedBehavior = 'Stop'
$mediaElement.Source = [Uri]::new("https://www.w3schools.com/html/mov_bbb.mp4") # Replace with your video URL or local path

# Optionally, add Play button
$playButton = New-Object System.Windows.Controls.Button
$playButton.Content = "Play"
$playButton.Margin = 10
$playButton.Width = 80
$playButton.Add_Click({ $mediaElement.Play() })

# Optionally, add Pause button
$pauseButton = New-Object System.Windows.Controls.Button
$pauseButton.Content = "Pause"
$pauseButton.Margin = 10
$pauseButton.Width = 80
$pauseButton.Add_Click({ $mediaElement.Pause() })

# Layout: StackPanel for controls
$controlsPanel = New-Object System.Windows.Controls.StackPanel
$controlsPanel.Orientation = 'Horizontal'
$controlsPanel.HorizontalAlignment = 'Center'
$controlsPanel.Children.Add($playButton)
$controlsPanel.Children.Add($pauseButton)

# Add MediaElement and controls to grid
$videoGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height="*"}))
$videoGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height="Auto"}))
$videoGrid.Children.Add($mediaElement)
[System.Windows.Controls.Grid]::SetRow($mediaElement, 0)
$videoGrid.Children.Add($controlsPanel)
[System.Windows.Controls.Grid]::SetRow($controlsPanel, 1)

# Set grid as tab content
$videoTab.Content = $videoGrid

# Add the tab to the TabControl
$tabControl.Items.Add($videoTab)