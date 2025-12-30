# claudeto - CLI tool for managing Claude agent todos

param(
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

$TodosDir = ".claude\.agent-todos"
$ConfigFile = Join-Path $env:USERPROFILE ".claudeto\config"

# Load config from ~/.claudeto/config if it exists
if (Test-Path $ConfigFile) {
    Get-Content $ConfigFile | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            Set-Variable -Name $matches[1] -Value $matches[2] -Scope Script
        }
    }
}

# Set defaults if not configured
if (-not $CLAUDETO_PLANNER) { $CLAUDETO_PLANNER = "claudeto planner" }
if (-not $CLAUDETO_DEV) { $CLAUDETO_DEV = "claudeto developer" }

# Ensure the todos directory exists
function Ensure-TodosDir {
    if (-not (Test-Path $TodosDir)) {
        New-Item -ItemType Directory -Path $TodosDir -Force | Out-Null
        Write-Host "Created $TodosDir directory"
    }
}

# Show usage information
function Show-Usage {
    Write-Host "Usage: claudeto [command]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  (none)    Create .claude\.agent-todos directory if not exists"
    Write-Host "  plan      Run claudeto planner with a custom task (e.g., claudeto plan `"improve auth`")"
    Write-Host "  project-plan  Run claudeto planner to plan development of @project.md"
    Write-Host "  dev       Run claudeto developer to develop the next feature"
    Write-Host "  loop      Continuously develop features until all todos are done"
    Write-Host ""
}

# Check if there are pending todos (files without [done] in the name)
function Has-PendingTodos {
    if (-not (Test-Path $TodosDir)) {
        return $false
    }
    $pendingFiles = Get-ChildItem -Path $TodosDir -File | Where-Object { $_.Name -notlike '*`[done`]*' }
    return ($null -ne $pendingFiles -and $pendingFiles.Count -gt 0)
}

# Main logic
switch ($Command) {
    "" {
        # No argument: just ensure directory exists
        Ensure-TodosDir
    }
    "plan" {
        if (-not $Args -or $Args.Count -eq 0) {
            Write-Host "Error: plan command requires a task description"
            Write-Host "Usage: claudeto plan `"your task description`""
            exit 1
        }
        $task = $Args -join " "
        Ensure-TodosDir
        claude-yolo -p "Use $CLAUDETO_PLANNER to $task"
    }
    "project-plan" {
        Ensure-TodosDir
        claude-yolo -p "Use $CLAUDETO_PLANNER to plan the development of @project.md"
    }
    "dev" {
        Ensure-TodosDir
        claude-yolo -p "Use $CLAUDETO_DEV to develop the next feature"
    }
    "loop" {
        Ensure-TodosDir
        while (Has-PendingTodos) {
            claude-yolo -p "Use $CLAUDETO_DEV to develop the next feature"
            Start-Sleep -Seconds 1
        }
        Write-Host "All todos completed!"
    }
    { $_ -in "help", "--help", "-h" } {
        Show-Usage
    }
    default {
        Write-Host "Unknown command: $Command"
        Show-Usage
        exit 1
    }
}
