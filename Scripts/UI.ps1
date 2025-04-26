# UI.ps1
# Do NOT create a new $tabControl here!
# Use the existing $tabControl from ToolBox.ps1

$mainTab = New-Object System.Windows.Controls.TabItem
$mainTab.Header = "Software"
$mainTab.Style = $tabItemStyle
$mainTab.Content = $mainGrid

$tabControl.Items.Add($mainTab)

# Create Grid for the main layout (Categories on the left, Sidebar on the right)
$mainGrid = New-Object System.Windows.Controls.Grid
$mainGrid.HorizontalAlignment = 'Stretch'
$mainGrid.VerticalAlignment = 'Stretch'
$mainGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))  # Categories column
$mainGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='180'}))  # Sidebar column

# Create categories grid with scrollable content
$categoriesGrid = New-Object System.Windows.Controls.Grid
$categoriesGrid.Margin = '5'
$categoriesGrid.HorizontalAlignment = 'Stretch'
$categoriesGrid.VerticalAlignment = 'Stretch'

# ScrollViewer for categories
$scrollViewer = New-Object System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = 'Auto'  # Show scrollbar when needed
$scrollViewer.Style = $scrollStyle

# UniformGrid for arranging categories side by side
$uniformGrid = New-Object System.Windows.Controls.Primitives.UniformGrid
$uniformGrid.Columns = 3  # Adjust this to control the number of categories per row
$uniformGrid.HorizontalAlignment = 'Stretch'
$uniformGrid.VerticalAlignment = 'Stretch'

# Sort and loop through categories and items
$sorted_software_categories = $software_categories.GetEnumerator() | 
    Sort-Object Name | ForEach-Object {
        $category = $_.Name
        $category_content = $_.Value
        $sorted_content = $category_content.GetEnumerator() |
            Sort-Object Name | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    Details = $_.Value
                }
            }

        [PSCustomObject]@{
            Category = $category
            Items = $sorted_content
        }
    }

# Loop through categories and add category panels
foreach ($category in $sorted_software_categories) {
    # Create Grid for each category
    $categoryPanel = New-Object System.Windows.Controls.Grid
    $categoryPanel.Margin = '8'
    $categoryPanel.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height='Auto'}))  # Row for category title
    $categoryPanel.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height='Auto'}))  # Row for checkboxes

    # Category Header (Title)
    $header = New-Object System.Windows.Controls.TextBlock
    $header.Text = $category.Category
    $header.FontWeight = 'Bold'
    $header.FontSize = '26'
    $header.Foreground = $titleBrush
    $header.TextAlignment = 'Center'
    $categoryPanel.Children.Add($header)
    [System.Windows.Controls.Grid]::SetRow($header, 0)  # Set to first row

    # StackPanel for checkboxes
    $checkboxStackPanel = New-Object System.Windows.Controls.StackPanel
    $checkboxStackPanel.Orientation = 'Vertical'
    $checkboxStackPanel.Margin = '5 , 10, 5, 5'

    # Style for CheckBox with triggers
    $checkBoxStyle = New-Object System.Windows.Style -ArgumentList ([System.Windows.Controls.CheckBox])
    $checkBoxStyle.Setters.Add((New-Object System.Windows.Setter -ArgumentList ([System.Windows.Controls.CheckBox]::BackgroundProperty, [System.Windows.Media.Brushes]::Transparent)))
    $checkBoxTrigger = New-Object System.Windows.Trigger
    $checkBoxTrigger.Property = [System.Windows.Controls.CheckBox]::IsCheckedProperty
    $checkBoxTrigger.Value = $true
    $checkBoxTrigger.Setters.Add((New-Object System.Windows.Setter -ArgumentList ([System.Windows.Controls.CheckBox]::BackgroundProperty, $highlightBrush)))
    $checkBoxStyle.Triggers.Add($checkBoxTrigger)

    # Add checkboxes for each item in the category
    foreach ($item in $category.Items) {
        $app_name = $item.Name
        $app_info = $item.Details

        # Create and configure checkbox
        $checkbox = New-Object System.Windows.Controls.CheckBox
        $checkbox.Content = $app_name
        $checkbox.IsChecked = $false
        $checkbox.FontSize = '14'
        $checkbox.FontWeight = '380'
        $checkbox.Foreground = $whitebrush
        $checkbox.Margin = 4
        $checkbox.Style = $checkBoxStyle
        $checkbox.ToolTip = (New-Object System.Windows.Controls.ToolTip -Property @{Content = $app_info.info})

        # Add checkbox to checkbox stack panel
        $checkboxStackPanel.Children.Add($checkbox)
        $checkboxControls[$app_name] = $checkbox
    }

    # Add checkbox stack panel to the second row of the category panel
    $categoryPanel.Children.Add($checkboxStackPanel)
    [System.Windows.Controls.Grid]::SetRow($checkboxStackPanel, 1)

    # Add category panel to the UniformGrid
    $uniformGrid.Children.Add($categoryPanel)
}

# Add UniformGrid to ScrollViewer and ScrollViewer to categoriesGrid
$scrollViewer.Content = $uniformGrid
$categoriesGrid.Children.Add($scrollViewer)
[System.Windows.Controls.Grid]::SetRow($scrollViewer, 0)

# Create and configure Check All checkbox
$checkAllPanel = New-Object System.Windows.Controls.StackPanel
$checkAllPanel.HorizontalAlignment = 'Right'
$checkAllPanel.VerticalAlignment = 'Bottom'

$checkAllBox = New-Object System.Windows.Controls.CheckBox
$checkAllBox.Content = "Check All"
$checkAllBox.Margin = '22'
$checkAllBox.FontSize = 12
$checkAllBox.FontWeight = 'Bold'
$checkAllBox.Style = $checkBoxStyle
$checkAllBox.Foreground = 'Red'
$checkAllBox.Add_Checked({
    foreach ($checkbox in $checkboxControls.Values) {
        $checkbox.IsChecked = $true
    }
})
$checkAllBox.Add_Unchecked({
    foreach ($checkbox in $checkboxControls.Values) {
        $checkbox.IsChecked = $false
    }
})

# Add Check All checkbox to the panel
$checkAllPanel.Children.Add($checkAllBox)
$categoriesGrid.Children.Add($checkAllPanel)
[System.Windows.Controls.Grid]::SetRow($checkAllPanel, 1)

# Add categoriesGrid to the mainGrid (left side)
$mainGrid.Children.Add($categoriesGrid)
[System.Windows.Controls.Grid]::SetColumn($categoriesGrid, 0)

# Sidebar setup
$newSidebar = Create-Sidebar -checkboxControls $checkboxControls -whitebrush $whitebrush -brushbackground $brushbackground -buttonStyle $buttonStyle -software_categories $software_categories
$mainGrid.Children.Add($newSidebar)
[System.Windows.Controls.Grid]::SetColumn($newSidebar, 1)

