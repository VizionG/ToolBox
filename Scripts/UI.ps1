# Initialize the hashtable to store checkbox controls
$checkboxControls = @{}

# Parse the Style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)

# Create a DockPanel as the main layout container
$dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel
$dockPanel.HorizontalAlignment = 'Stretch'
$dockPanel.VerticalAlignment = 'Stretch'
$dockPanel.LastChildFill = $true  # Ensure the last child fills the remaining space

# Create a Style for TabControl
$tabControlStyle = New-Object -TypeName System.Windows.Style -ArgumentList ([System.Windows.Controls.TabControl])
$tabControlSetterThickness = New-Object -TypeName System.Windows.Setter
$tabControlSetterThickness.Property = [System.Windows.Controls.TabControl]::BorderThicknessProperty
$tabControlSetterThickness.Value = [System.Windows.Thickness]::new(0)
$tabControlStyle.Setters.Add($tabControlSetterThickness)

# Create a Setter for Background
$tabControlSetterBackground = New-Object -TypeName System.Windows.Setter
$tabControlSetterBackground.Property = [System.Windows.Controls.TabControl]::BackgroundProperty
$tabControlSetterBackground.Value = $brushbackground
$tabControlStyle.Setters.Add($tabControlSetterBackground)

# Create a Style for TabItem
$tabItemStyle = New-Object -TypeName System.Windows.Style -ArgumentList ([System.Windows.Controls.TabItem])
$tabItemSetterThickness = New-Object -TypeName System.Windows.Setter
$tabItemSetterThickness.Property = [System.Windows.Controls.TabItem]::BorderThicknessProperty
$tabItemSetterThickness.Value = [System.Windows.Thickness]::new(0)
$tabItemStyle.Setters.Add($tabItemSetterThickness)

# Create and configure the TabControl
$tabControl = New-Object -TypeName System.Windows.Controls.TabControl
$tabControl.HorizontalAlignment = 'Stretch'
$tabControl.VerticalAlignment = 'Stretch'
$tabControl.Style = $tabControlStyle  # Apply the style


# Create the Main Tab
$mainTab = New-Object -TypeName System.Windows.Controls.TabItem
$mainTab.Header = "Software"
$mainTab.Style = $tabItemStyle  # Apply the style
$mainTab.Style = $tabStyle

# Create a Grid for the main layout
$mainGrid = New-Object -TypeName System.Windows.Controls.Grid
$mainGrid.HorizontalAlignment = 'Stretch'
$mainGrid.VerticalAlignment = 'Stretch'

# Define ColumnDefinitions for the main Grid (one for categories on the left, one for sidebar on the right)
$mainGrid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))  # Categories column
$sidebarColumn = New-Object System.Windows.Controls.ColumnDefinition
$sidebarColumn.Width = '180'  # Set fixed width for sidebar
$mainGrid.ColumnDefinitions.Add($sidebarColumn)  # Sidebar column

# Create a Grid for categories (on the left)
$categoriesGrid = New-Object -TypeName System.Windows.Controls.Grid
$categoriesGrid.Margin = '5'
$categoriesGrid.HorizontalAlignment = 'Stretch'
$categoriesGrid.VerticalAlignment = 'Stretch'# Create a ScrollViewer to make categories scrollable
$scrollViewer = New-Object -TypeName System.Windows.Controls.ScrollViewer
$scrollViewer.VerticalScrollBarVisibility = 'Auto'  # Show scrollbar when needed
$scrollViewer.Style = $scrollStyle


# Create a UniformGrid to arrange categories side by sidex
$uniformGrid = New-Object -TypeName System.Windows.Controls.Primitives.UniformGrid
$uniformGrid.Columns = 3  # Adjust this to control the number of categories in each row
$uniformGrid.HorizontalAlignment = 'Stretch'
$uniformGrid.VerticalAlignment = 'Stretch'


# Define your sorted categories as before
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
    
# Loop through the sorted categories and add panels for each
foreach ($category in $sorted_software_categories) {
    # Create a Grid for each category
    $categoryPanel = New-Object -TypeName System.Windows.Controls.Grid
    $categoryPanel.Margin = '8'

    # Define two rows: one for the title and one for the contents
    $categoryPanel.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height='Auto'}))  # Row for category title
    $categoryPanel.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{Height='Auto'}))  # Row for checkboxes

    # Add category header (title)
    $header = New-Object -TypeName System.Windows.Controls.TextBlock
    $header.Text = $category.Category
    $header.FontWeight = 'Bold'
    $header.FontSize = '26'
    $header.Foreground = $titleBrush
    $header.TextAlignment = 'Center'

    # Add header to category panel (first row)
    $categoryPanel.Children.Add($header)
    [System.Windows.Controls.Grid]::SetRow($header, 0)  # Set to first row

    # Create a StackPanel for the checkboxes in the second row
    $checkboxStackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
    $checkboxStackPanel.Orientation = 'Vertical'  # Stack checkboxes vertically
    $checkboxStackPanel.Margin = '5 , 10, 5, 5'

    # Define a highlight color for checked state
    $highlightBrush = $titleBrush

    # Create a style for CheckBox
    $checkBoxStyle = New-Object System.Windows.Style -ArgumentList ([System.Windows.Controls.CheckBox])

    # Create a setter for the default background
    $defaultSetter = New-Object System.Windows.Setter -ArgumentList ([System.Windows.Controls.CheckBox]::BackgroundProperty, [System.Windows.Media.Brushes]::Transparent)
    $checkBoxStyle.Setters.Add($defaultSetter)

    # Create a trigger for checked state
    $checkBoxTrigger = New-Object System.Windows.Trigger
    $checkBoxTrigger.Property = [System.Windows.Controls.CheckBox]::IsCheckedProperty
    $checkBoxTrigger.Value = $true

    # Create a setter for the background when checked
    $checkedSetter = New-Object System.Windows.Setter -ArgumentList ([System.Windows.Controls.CheckBox]::BackgroundProperty, $highlightBrush)
    $checkBoxTrigger.Setters.Add($checkedSetter)

    # Add the trigger to the style
    $checkBoxStyle.Triggers.Add($checkBoxTrigger)

    # Add checkboxes for each software in the category
    foreach ($item in $category.Items) {
        $app_name = $item.Name
        $app_info = $item.Details

        # Create and configure checkbox
        $checkbox = New-Object -TypeName System.Windows.Controls.CheckBox
        $checkbox.Content = $app_name
        $checkbox.IsChecked = $false
        $checkbox.FontSize = '14'
        $checkbox.FontWeight = '380'
        $checkbox.Foreground = $whitebrush
        $checkbox.Margin = 4
        $checkbox.Style = $checkBoxStyle 

        # Add tooltip to checkbox
        $toolTip = New-Object -TypeName System.Windows.Controls.ToolTip
        $toolTip.Content = $app_info.info
        $checkbox.ToolTip = $toolTip

        # Add checkbox to checkbox stack panel
        $checkboxStackPanel.Children.Add($checkbox)

        # Store checkbox in dictionary
        $checkboxControls[$app_name] = $checkbox
    }

    # Add the checkbox stack panel to the second row of the category panel
    $categoryPanel.Children.Add($checkboxStackPanel)
    [System.Windows.Controls.Grid]::SetRow($checkboxStackPanel, 1)  # Set to second row

    # Add the category panel to the UniformGrid
    $uniformGrid.Children.Add($categoryPanel)
}

# Add the UniformGrid to a ScrollViewer
$scrollViewer.Content = $uniformGrid

# Add ScrollViewer to categoriesGrid
$categoriesGrid.Children.Add($scrollViewer)
[System.Windows.Controls.Grid]::SetRow($scrollViewer, 0)

# Create a StackPanel for the Check All checkbox and place it in the second row
$checkAllPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$checkAllPanel.HorizontalAlignment = 'Right'  # Align to the right
$checkAllPanel.VerticalAlignment = 'Bottom'  # Align to the right

# Create and configure Check All checkbox
$checkAllBox = New-Object -TypeName System.Windows.Controls.CheckBox
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

# Add the Check All checkbox to the panel
$checkAllPanel.Children.Add($checkAllBox)

# Add CheckAllPanel to categoriesGrid
$categoriesGrid.Children.Add($checkAllPanel)
[System.Windows.Controls.Grid]::SetRow($checkAllPanel, 1)

# ADD the categoriesGrid to mainGrid (left side)
$mainGrid.Children.Add($categoriesGrid)
[System.Windows.Controls.Grid]::SetColumn($categoriesGrid, 0)

# Create the sidebar using the function
$newSidebar = Create-Sidebar -checkboxControls $checkboxControls -whitebrush $whitebrush -brushbackground $brushbackground -buttonStyle $buttonStyle -software_categories $software_categories

# Add the sidebar to the main grid
$mainGrid.Children.Add($newSidebar)
[System.Windows.Controls.Grid]::SetColumn($newSidebar, 1)

$dockPanel.Children.Add($mainGrid)
