$checkBoxStyleXml = @"
<Style xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
       xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
       TargetType="{x:Type CheckBox}">
    <Setter Property="Background" Value="#262626"/>
    <Setter Property="Foreground" Value="#B8B8B8"/>
    <Setter Property="BorderBrush" Value="#B8B8B8"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="5"/>
    <Setter Property="FontSize" Value="12"/>
    <Setter Property="FontWeight" Value="Bold"/>
    <Setter Property="Height" Value="30"/>
    <Setter Property="Width" Value="90"/>
    <Setter Property="Margin" Value="0,5,5,5"/>
    <Setter Property="HorizontalAlignment" Value="Center"/>
    <Setter Property="VerticalAlignment" Value="Center"/>
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="{x:Type CheckBox}">
                <Grid>
                    <!-- Background Rectangle -->
                    <Rectangle x:Name="BackgroundRectangle"
                               Fill="{TemplateBinding Background}"
                               Stroke="{TemplateBinding BorderBrush}"
                               StrokeThickness="{TemplateBinding BorderThickness}"
                               RadiusX="3"
                               RadiusY="3"/>
                    
                    <!-- Content Presenter -->
                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Grid>
                <ControlTemplate.Triggers>
                    <!-- Trigger for Checked State -->
                    <Trigger Property="IsChecked" Value="True">
                        <Setter TargetName="BackgroundRectangle" Property="Stroke" Value="#5A33CB"/> <!-- Custom border color -->
                        <Setter Property="Foreground" Value="#00FF0C"/> <!-- Custom text color -->
                        <Setter Property="Background" Value="#5A33CB"/> <!-- Custom text color -->
                    </Trigger>
                    <!-- Trigger for MouseOver State -->
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter Property="Background" Value="#444"/> <!-- Custom background color when hovered -->
                    </Trigger>
                </ControlTemplate.Triggers>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
</Style>
"@

$buttonStyleXml = @"
<Style xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
       xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
       TargetType="{x:Type Button}">
    <Setter Property="Background" Value="#262626"/>
    <Setter Property="Foreground" Value="#FFFFFF"/>
    <Setter Property="BorderBrush" Value="#B8B8B8"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="5"/>
    <Setter Property="FontSize" Value="14"/>
    <Setter Property="FontWeight" Value="Bold"/>
    <Setter Property="Height" Value="30"/>
    <Setter Property="Width" Value="120"/>
    <Setter Property="Margin" Value="10"/>
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="{x:Type Button}">
                <Grid>
                    <Border x:Name="BorderElement"
                            Background="{TemplateBinding Background}"
                            BorderBrush="{TemplateBinding BorderBrush}"
                            BorderThickness="{TemplateBinding BorderThickness}"
                            CornerRadius="10"
                            Padding="{TemplateBinding Padding}">
                        <ContentPresenter HorizontalAlignment="Center"
                                          VerticalAlignment="Center"/>
                    </Border>
                </Grid>
                <ControlTemplate.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter TargetName="BorderElement" Property="Background" Value="#444"/>
                    </Trigger>
                    <Trigger Property="IsPressed" Value="True">
                        <Setter TargetName="BorderElement" Property="Background" Value="#FFFFFF"/>
                        <Setter Property="Foreground" Value="#262626"/>
                    </Trigger>
                </ControlTemplate.Triggers>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
</Style>
"@

$tabStyleXml = @"
<Style TargetType="TabItem" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
       xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <Setter Property="Background" Value="#262626"/>
    <Setter Property="Foreground" Value="#FFFFFF"/>
    <Setter Property="BorderBrush" Value="#B8B8B8"/>
    <Setter Property="BorderThickness" Value="1"/>
    <Setter Property="Padding" Value="16"/> <!-- Adjust padding as needed -->
    <Setter Property="FontSize" Value="14"/>
    <Setter Property="Height" Value="30"/>
    <Setter Property="Width" Value="Auto"/>
    <Setter Property="FontWeight" Value="Bold"/>
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="TabItem">
                <Grid>
                    <Border x:Name="BorderElement"
                            Background="{TemplateBinding Background}"
                            BorderBrush="{TemplateBinding BorderBrush}"
                            BorderThickness="{TemplateBinding BorderThickness}"
                            CornerRadius="3.5">
                        <ContentPresenter 
                            HorizontalAlignment="Center" 
                            VerticalAlignment="Center" 
                            ContentSource="Header"
                            Margin="10,5"/>
                    </Border>
                </Grid>
                <ControlTemplate.Triggers>
                    <Trigger Property="IsSelected" Value="True">
                        <Setter TargetName="BorderElement" Property="Background" Value="#5A33CB"/>
                        <Setter Property="Foreground" Value="#FFFFFF"/>
                    </Trigger>
                    <Trigger Property="IsEnabled" Value="False">
                        <Setter Property="Foreground" Value="#B8B8B8"/>
                        <Setter TargetName="BorderElement" Property="Background" Value="#3C3C3C"/>
                    </Trigger>
                </ControlTemplate.Triggers>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
</Style>
"@
