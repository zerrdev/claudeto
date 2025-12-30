# claudeto - CLI tool for managing Claude agent todos

param(
    [Parameter(Position=0)]
    [string]$Command
)

$TodosDir = ".claude\.agent-todos"

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
    Write-Host "  plan      Run feature planner to plan development of @project.md"
    Write-Host "  dev       Run feature developer to develop the next feature"
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
        Ensure-TodosDir
        claude-yolo -p "Use feature planner to plan the development of @project.md"
    }
    "dev" {
        Ensure-TodosDir
        claude-yolo -p "Use feature developer to develop the next feature"
    }
    "loop" {
        Ensure-TodosDir
        while (Has-PendingTodos) {
            claude-yolo -p "Use feature developer to develop the next feature"
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
