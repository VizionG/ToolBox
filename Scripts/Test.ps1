# --- Sidebar + Content in a New Tab ---

# Assume $tabControl, $tabItemStyle, $buttonStyle, $whitebrush, $brushbackground, etc. are already available

# Create a new TabItem for the sidebar/content demo
$sidebarTab = New-Object System.Windows.Controls.TabItem
$sidebarTab.Header = "Sidebar Demo"
$sidebarTab.Style = $tabItemStyle

# Create a new grid for the tab layout
$sidebarTabGrid = New-Object System.Windows.Controls.Grid
$sidebarTabGrid.HorizontalAlignment = 'Stretch'
$sidebarTabGrid.VerticalAlignment = 'Stretch'
$sidebarTabGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))    # Content column
$sidebarTabGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='180'}))  # Sidebar column

# --- Content for the left side ---
$leftContent = New-Object System.Windows.Controls.TextBlock
$leftContent.Text = "This is the content area (left side)."
$leftContent.Margin = 20
$leftContent.VerticalAlignment = 'Center'
$leftContent.HorizontalAlignment = 'Center'
$sidebarTabGrid.Children.Add($leftContent)
[System.Windows.Controls.Grid]::SetColumn($leftContent, 0)

# --- Sidebar for the right side ---
$sidebarDemoGrid = New-Object System.Windows.Controls.StackPanel
$sidebarDemoGrid.Background = [System.Windows.Media.Brushes]::LightGray
$sidebarDemoGrid.Margin = 10

$sidebarLabel = New-Object System.Windows.Controls.TextBlock
$sidebarLabel.Text = "Sidebar (right side)"
$sidebarLabel.FontWeight = 'Bold'
$sidebarLabel.Margin = 5
$sidebarDemoGrid.Children.Add($sidebarLabel)

$sidebarTabGrid.Children.Add($sidebarDemoGrid)
[System.Windows.Controls.Grid]::SetColumn($sidebarDemoGrid, 1)

# Set the grid as the content of the new tab
$sidebarTab.Content = $sidebarTabGrid

# Add the new tab to the TabControl
$tabControl.Items.Add($sidebarTab)