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

# Install agent files to ~/.claude/agents
$AgentsDir = "$env:USERPROFILE\.claude\agents"
if (!(Test-Path $AgentsDir)) {
    New-Item -ItemType Directory -Path $AgentsDir -Force | Out-Null
}

Write-Host "Installing agents..." -ForegroundColor Cyan

$Agents = @("claudeto-developer.md", "claudeto-planner.md")
foreach ($Agent in $Agents) {
    $AgentUrl = "$RepoUrl/agents/$Agent"
    $AgentPath = Join-Path $AgentsDir $Agent
    Invoke-WebRequest -Uri $AgentUrl -OutFile $AgentPath
    Write-Host "  Installed $Agent" -ForegroundColor Gray
}

# Add to PATH if not already there
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    Write-Host "Added $InstallDir to PATH" -ForegroundColor Yellow
    Write-Host "Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
}

Write-Host "claudeto installed successfully!" -ForegroundColor Green
Write-Host "Run 'claudeto' to get started." -ForegroundColor Yellow
