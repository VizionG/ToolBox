# Parse the Style from XAML
$buttonStyle = [System.Windows.Markup.XamlReader]::Parse($buttonStyleXml)
$tabStyle = [System.Windows.Markup.XamlReader]::Parse($tabStyleXml)
$checkBoxStyle = [System.Windows.Markup.XamlReader]::Parse($checkBoxStyleXml)

# Create a Grid to organize the InputPanel and SidebarGrid
$utilitiesGrid = New-Object -TypeName System.Windows.Controls.Grid
$utilitiesGrid.HorizontalAlignment = 'Stretch'
$utilitiesGrid.VerticalAlignment = 'Stretch'

# ... build your UI and add children to $utilitiesGrid ...

# Now create the TabItem and assign the grid as content
$inputTab = New-Object System.Windows.Controls.TabItem
$inputTab.Header = "Utilities"
$inputTab.Style = $tabStyle
$inputTab.Content = $utilitiesGrid

$tabControl.Items.Add($inputTab)

# Install-SpotX function
function Install-SpotX {
    Invoke-Expression "& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
}

# InstallApp function (just a placeholder)
function InstallApp {
    Write-Host "App installation started..."
    # Add your installation logic here
}
