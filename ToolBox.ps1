# Adiciona tipos WPF apenas se ainda não estiverem carregados
if (-not ("System.Windows.Window" -as [type])) {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
}

# Verifica e define política de execução
function Set-ExecutionPolicyCustom {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -ne 'RemoteSigned') {
        Write-Host "Current execution policy is '$currentPolicy'. Changing to 'RemoteSigned'."
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "Execution policy changed to 'RemoteSigned'."
        } catch {
            Write-Error "Erro ao mudar política de execução: $_"
            throw "Script requires 'RemoteSigned' policy to proceed."
        }
    } else {
        Write-Host "Execution policy already set to 'RemoteSigned'."
    }
}

# Garante que o winget está instalado
function Test-Winget {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
        throw "Este script deve ser executado com privilégios de administrador."
    }

    try {
        $wingetVersion = winget --version
        if ($wingetVersion) {
            Write-Host "winget já está instalado. Versão: $wingetVersion"
            return
        }
    } catch {
        Write-Host "winget não está instalado. A instalar..."
        try {
            $wingetInstallerUrl = "https://aka.ms/getwinget"
            $wingetInstallerPath = Join-Path $env:TEMP "Microsoft.DesktopAppInstaller.msixbundle"
            Invoke-WebRequest -Uri $wingetInstallerUrl -OutFile $wingetInstallerPath -ErrorAction Stop
            Add-AppxPackage -Path $wingetInstallerPath
            Start-Sleep -Seconds 5
            $wingetVersion = winget --version
            if ($wingetVersion) {
                Write-Host "winget instalado com sucesso. Versão: $wingetVersion"
            } else {
                throw "Instalação concluída mas winget não está acessível."
            }
        } catch {
            Write-Error "Erro ao instalar winget: $_"
            throw "Tenta instalar manualmente via Microsoft Store."
        }
    }
}

# Faz download de um script de um URL
function Get-ScriptFromUrl {
    param (
        [string]$url,
        [string]$subDir = "Scripts"
    )
    try {
        Write-Host "A descarregar: $url"
        $tempDir = Join-Path $env:TEMP "ToolBox\$subDir"
        $null = New-Item -ItemType Directory -Path $tempDir -Force -ErrorAction SilentlyContinue
        $scriptName = [System.IO.Path]::GetFileName($url)
        $scriptPath = Join-Path $tempDir $scriptName
        Invoke-WebRequest -Uri $url -OutFile $scriptPath -ErrorAction Stop
        if ((Test-Path $scriptPath) -and ((Get-Item $scriptPath).Length -gt 0)) {
            return $scriptPath
        } else {
            throw "Ficheiro vazio ou inexistente: $scriptPath"
        }
    } catch {
        Write-Error "Erro ao carregar ${url}: $_"
        return $null
    }
}

# Faz download de todos os scripts necessários
function DownloadScripts {
    $scriptUrls = @(
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/SoftwareCategories.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Functions.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Styles.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Colors.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Recommended.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/UI.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/Settings.ps1",
        "https://raw.githubusercontent.com/VizionG/ToolBox/main/Scripts/AlphaDebloat.ps1"
    )
    $paths = @()
    foreach ($url in $scriptUrls) {
        $path = Get-ScriptFromUrl -url $url -subDir "Scripts"
        if ($path) { $paths += $path }
    }

    if ($paths.Count -ne $scriptUrls.Count) {
        throw "Nem todos os scripts foram descarregados com sucesso. Verifica a ligação à internet."
    }

    return $paths
}

# Carrega scripts descarregados
function Import-Scripts {
    param ([string[]]$paths)
    foreach ($scriptPath in $paths) {
        try {
            Write-Host "A carregar: $scriptPath"
            . $scriptPath
        } catch {
            Write-Error "Erro ao carregar ${scriptPath}: $_"
        }
    }
}


# Mostra a interface gráfica principal
function Show-ToolBoxUI {
    if (-not $dockPanel) {
        Write-Error "UI não foi carregada corretamente. dockPanel não está definido."
        return
    }

    $mainWindow = New-Object -TypeName System.Windows.Window
    $mainWindow.Title = "ToolBox"
    $mainWindow.Width = 1100
    $mainWindow.Height = 625
    $mainWindow.ResizeMode = 'CanResize'
    $mainWindow.WindowStartupLocation = 'CenterScreen'
    $mainWindow.Icon = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new("https://viziong.github.io/ToolBox/Resources/images/v_logo.ico"))
    $mainWindow.Background = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromArgb(255, 38, 37, 38))
    $mainWindow.Content = $dockPanel

    $mainWindow.Add_Closing({
        try {
            $toolBoxFolder = Join-Path $env:TEMP "ToolBox"
            if (Test-Path $toolBoxFolder) {
                Write-Host "A apagar pasta temporária: $toolBoxFolder"
                Remove-Item -Path $toolBoxFolder -Recurse -Force
                Write-Host "Pasta temporária apagada."
            }
        } catch {
            Write-Error "Erro ao apagar pasta ToolBox: $_"
        }
    })

    $mainWindow.ShowDialog()
}

# ==== EXECUÇÃO ====

Set-ExecutionPolicyCustom
Test-Winget
$tempScriptPaths = DownloadScripts
Import-Scripts -paths $tempScriptPaths
Show-ToolBoxUI
