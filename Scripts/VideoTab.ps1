# Create a new TabItem for the video
$videoTab = New-Object System.Windows.Controls.TabItem
$videoTab.Header = "Live TV"
$videoTab.Style = $tabItemStyle

# Create a grid with two columns: left for player, right for channel list
$videoGrid = New-Object System.Windows.Controls.Grid
$videoGrid.HorizontalAlignment = 'Stretch'
$videoGrid.VerticalAlignment = 'Stretch'
$videoGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))    # Player column
$videoGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='220'}))  # Sidebar column

# --- Left: Video Player ---
$mediaElement = New-Object System.Windows.Controls.MediaElement
$mediaElement.Width = 640
$mediaElement.Height = 360
$mediaElement.LoadedBehavior = 'Manual'
$mediaElement.UnloadedBehavior = 'Stop'
$mediaElement.Margin = 10
# Default to first channel (will be set below)

# --- Right: Channel Sidebar ---
$sidebarPanel = New-Object System.Windows.Controls.StackPanel
$sidebarPanel.Margin = 10
$sidebarPanel.Background = [System.Windows.Media.Brushes]::LightGray

$sidebarLabel = New-Object System.Windows.Controls.TextBlock
$sidebarLabel.Text = "Live Channels"
$sidebarLabel.FontWeight = 'Bold'
$sidebarLabel.FontSize = 16
$sidebarLabel.Margin = '0,0,0,10'
$sidebarPanel.Children.Add($sidebarLabel)

# Define your channels (Name and Stream URL)
$channels = @(
    @{ Name = "Big Buck Bunny"; Url = "https://www.w3schools.com/html/mov_bbb.mp4" }
    @{ Name = "SIC"; Url = "https://d1zx6l1dn8vaj5.cloudfront.net/out/v1/b89cc37caa6d418eb423cf092a2ef970/index.m3u8" }
    @{ Name = "Sample Channel"; Url = "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8" }
)

# Add a button for each channel
foreach ($channel in $channels) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $channel.Name
    $btn.Margin = '0,0,0,5'
    $btn.Width = 180
    $btn.Style = $buttonStyle
    $btn.Add_Click({
        $mediaElement.Source = [Uri]::new($channel.Url)
        $mediaElement.Stop()
        $mediaElement.Play()
    })
    $sidebarPanel.Children.Add($btn)
}

# Create a Grid for the player area
$playerGrid = New-Object System.Windows.Controls.Grid

# Add the MediaElement
$playerGrid.Children.Add($mediaElement)

# Create a controls panel (overlay)
$controlsPanel = New-Object System.Windows.Controls.StackPanel
$controlsPanel.Orientation = 'Horizontal'
$controlsPanel.HorizontalAlignment = 'Center'
$controlsPanel.VerticalAlignment = 'Bottom'
$controlsPanel.Margin = '0,0,0,20'
$controlsPanel.Background = [System.Windows.Media.Brushes]::Transparent

$playButton = New-Object System.Windows.Controls.Button
$playButton.Content = "Play"
$playButton.Margin = 5
$playButton.Width = 80
$playButton.Add_Click({ $mediaElement.Play() })

$pauseButton = New-Object System.Windows.Controls.Button
$pauseButton.Content = "Pause"
$pauseButton.Margin = 5
$pauseButton.Width = 80
$pauseButton.Add_Click({ $mediaElement.Pause() })

$controlsPanel.Children.Add($playButton)
$controlsPanel.Children.Add($pauseButton)

# Add controls panel as overlay
$playerGrid.Children.Add($controlsPanel)

# Add the playerGrid to the left column of your main videoGrid
$videoGrid.Children.Add($playerGrid)
[System.Windows.Controls.Grid]::SetColumn($playerGrid, 0)

$videoGrid.Children.Add($sidebarPanel)
[System.Windows.Controls.Grid]::SetColumn($sidebarPanel, 1)

# Set grid as tab content
$videoTab.Content = $videoGrid

# Add the tab to the TabControl
$tabControl.Items.Add($videoTab)