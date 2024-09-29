# Initialize the hashtable to store checkbox controls
$checkboxControls = @{}

# Create a DockPanel as the main layout container
$dockPanel = New-Object -TypeName System.Windows.Controls.DockPanel
$dockPanel.HorizontalAlignment = 'Stretch'
$dockPanel.VerticalAlignment = 'Stretch'
$dockPanel.LastChildFill = $true  # Ensure the last child fills the remaining space

# Create and configure the TabControl
$tabControl = New-Object -TypeName System.Windows.Controls.TabControl
$tabControl.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))
$tabControl.HorizontalAlignment = 'Stretch'
$tabControl.VerticalAlignment = 'Stretch'

# Create the Main Tab
$mainTab = New-Object -TypeName System.Windows.Controls.TabItem
$mainTab.Header = "Home"

# Create a StackPanel for the main layout
$mainPanelStack = New-Object -TypeName System.Windows.Controls.StackPanel
$mainPanelStack.HorizontalAlignment = 'Stretch'
$mainPanelStack.VerticalAlignment = 'Stretch'

# Create a WrapPanel for categories
$categoriesPanel = New-Object -TypeName System.Windows.Controls.WrapPanel
$categoriesPanel.Margin = '5'
$categoriesPanel.Background = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))
$categoriesPanel.HorizontalAlignment = 'Stretch'
$categoriesPanel.VerticalAlignment = 'Stretch'

# Parse the CheckBox style from XAML
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)

# Parse the Button style from XAML
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)

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

# Loop through the sorted categories and create panels for each one
foreach ($category in $sorted_software_categories) {
    # Create a StackPanel for each category group
    $categoryPanel = New-Object -TypeName System.Windows.Controls.StackPanel
    $categoryPanel.Orientation = 'Vertical'
    $categoryPanel.Margin = '25,25,25,25'  # Add some spacing between categories

    # Add category header
    $header = New-Object -TypeName System.Windows.Controls.TextBlock
    $header.Text = $category.Category
    $header.FontWeight = 'Bold'
    $header.Margin = '0,0,0,0'
    $header.FontSize = '16'
    $header.TextAlignment = 'Center'

    # Set the text color with custom ARGB value (dark gray in this case)
    $header.Foreground = New-Object -TypeName System.Windows.Media.SolidColorBrush -ArgumentList ([System.Windows.Media.Color]::FromArgb(255, 90, 51, 203))

    # Apply underline text decoration
    $header.TextDecorations = [System.Windows.TextDecorations]::Underline

    # Add the unique header to the category panel
    $categoryPanel.Children.Add($header)

    # Add checkboxes for each software in the category
    foreach ($item in $category.Items) {
        $app_name = $item.Name
        $app_info = $item.Details

        # Add checkbox for each app
        $checkbox = New-Object -TypeName System.Windows.Controls.CheckBox
        $checkbox.Content = $app_name
        $checkbox.Style = $checkBoxStyle  # Apply custom checkbox style
        $checkbox.IsChecked = $false  # Default to unchecked
        $categoryPanel.Children.Add($checkbox)

        # Create a ToolTip for each checkbox
        $toolTip = New-Object -TypeName System.Windows.Controls.ToolTip
        $toolTip.Content = $app_info.info
        $toolTip.Background = [System.Windows.Media.Brushes]::LightGray
        $toolTip.Foreground = [System.Windows.Media.Brushes]::Black
        $checkbox.ToolTip = $toolTip

        # Store checkbox in dictionary
        $checkboxControls[$app_name] = $checkbox
    }

    # Add category panel to the WrapPanel (categories in a row)
    $categoriesPanel.Children.Add($categoryPanel)
}

# Add categoriesPanel to the main layout stack
$mainPanelStack.Children.Add($categoriesPanel)

# Create the actionsPanel using a StackPanel for layout
$actionsPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$actionsPanel.Orientation = 'Vertical'
$actionsPanel.Margin = '0'
$actionsPanel.HorizontalAlignment = 'Stretch'
$actionsPanel.VerticalAlignment = 'Stretch'

# Create and configure the status TextBox
$statusBox = New-Object -TypeName System.Windows.Controls.TextBox
$statusBox.Height = 30
$statusBox.Width = 220
$statusBox.Margin = '5,5,5,5'
$statusBox.Background = [System.Windows.Media.Brushes]::Black
$statusBox.Foreground = [System.Windows.Media.Brushes]::White
$statusBox.IsReadOnly = $true
$statusBox.Text = "Status: Waiting for actions..."
$statusBox.TextAlignment = 'Center'

# Create and configure Check All checkbox
$checkAllBox = New-Object -TypeName System.Windows.Controls.CheckBox
$checkAllBox.Content = "Check All"
$checkAllBox.Margin = '0,0,0,0'
$checkAllBox.Style = $checkBoxStyle  # Apply custom checkbox style

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

# Create button panel and add buttons to it
$buttonPanel = New-Object -TypeName System.Windows.Controls.StackPanel
$buttonPanel.Orientation = 'Horizontal'
$buttonPanel.HorizontalAlignment = 'Right'
$buttonPanel.Margin = '0,5,0,15'

# Create Uninstall button
$uninstallButton = New-Object -TypeName System.Windows.Controls.Button
$uninstallButton.Content = "Uninstall"
$uninstallButton.Margin = '5'
$uninstallButton.Style = $buttonStyle  # Apply custom button style
$uninstallButton.Add_Click({
    foreach ($checkbox in $checkboxControls.Values) {
        if ($checkbox.IsChecked -eq $true) {
            $app_name = $checkbox.Content.ToString()
            $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
            if ($app_info) {
                $app_id = $app_info.winget_id
                Uninstall-Software -app_id $app_id -app_name $app_name
            }
        }
    }
})

# Create Install button
$installButton = New-Object -TypeName System.Windows.Controls.Button
$installButton.Content = "Install"
$installButton.Margin = '5'
$installButton.Style = $buttonStyle  # Apply custom button style
$installButton.Add_Click({
    foreach ($checkbox in $checkboxControls.Values) {
        if ($checkbox.IsChecked -eq $true) {
            $app_name = $checkbox.Content.ToString()
            $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
            if ($app_info) {
                $app_id = $app_info.winget_id
                Install-Software -app_id $app_id -app_name $app_name
            }
        }
    }
})

# Create Check Installed Apps button
$checkAppsButton = New-Object -TypeName System.Windows.Controls.Button
$checkAppsButton.Content = "Installed"
$checkAppsButton.Margin = '5'
$checkAppsButton.Style = $buttonStyle  # Apply custom button style
$checkAppsButton.Add_Click({
    $installedAppsList = Get-InstalledApps

    foreach ($checkbox in $checkboxControls.Values) {
        $app_name = $checkbox.Content.ToString()
        $app_info = $software_categories.Values | ForEach-Object { $_[$app_name] } | Where-Object { $_ }
        if ($app_info) {
            $winget_id = $app_info.winget_id
            $names = $app_info.names

            $isInstalled = $installedAppsList | Where-Object {
                ($_.ID -eq $winget_id) -or ($_.Name -in $names)
            }

            $checkbox.IsChecked = $isInstalled -ne $null
        }
    }
})

# Add buttons to button panel
$buttonPanel.Children.Add($uninstallButton)
$buttonPanel.Children.Add($installButton)
$buttonPanel.Children.Add($checkAppsButton)

# Add status box, check all box, and button panel to actionsPanel
$actionsPanel.Children.Add($statusBox)
$actionsPanel.Children.Add($checkAllBox)
$actionsPanel.Children.Add($buttonPanel)

# Add actionsPanel to the main layout stack
$mainPanelStack.Children.Add($actionsPanel)

# Set the content of the Main tab
$mainTab.Content = $mainPanelStack

# Add the Main Tab to the TabControl
$tabControl.Items.Add($mainTab)

# Add the TabControl to the DockPanel
$dockPanel.Children.Add($tabControl)

