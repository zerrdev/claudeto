# claudeto installer for Windows
# Usage: irm https://raw.githubusercontent.com/zerrdev/claudeto/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoUrl = "https://raw.githubusercontent.com/zerrdev/claudeto/main"
$InstallDir = "$env:USERPROFILE\.claudeto"

Write-Host "Installing claudeto..." -ForegroundColor Cyan

# Create installation directory
if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Download the claudeto script
$ScriptUrl = "$RepoUrl/claudeto.cmd"
$ScriptPath = Join-Path $InstallDir "claudeto.cmd"

Invoke-WebRequest -Uri $ScriptUrl -OutFile $ScriptPath

# Add to PATH if not already there
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    Write-Host "Added $InstallDir to PATH" -ForegroundColor Yellow
    Write-Host "Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
}

Write-Host "claudeto installed successfully!" -ForegroundColor Green
Write-Host "Run 'claudeto' to get started." -ForegroundColor Yellow
