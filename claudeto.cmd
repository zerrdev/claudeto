@echo off
setlocal

if "%1"=="" (
    if not exist ".claude\.agent-todos" (
        mkdir ".claude\.agent-todos"
        echo Created .claude\.agent-todos directory
    ) else (
        echo .claude\.agent-todos already exists
    )
    exit /b 0
)

if "%1"=="plan" (
    claude-yolo -p "Use feature planner to plan the development of @project.md"
    exit /b %errorlevel%
)

if "%1"=="dev" (
    claude-yolo -p "Use feature developer to develop the next feature"
    exit /b %errorlevel%
)

if "%1"=="loop" (
    :loop
    for /f %%i in ('dir /b ".claude\.agent-todos" 2^>nul ^| findstr /v /i "\[done\]"') do (
        claude-yolo -p "Use feature developer to develop the next feature"
        timeout /t 1 /nobreak >nul
        goto loop
    )
    echo All tasks completed
    exit /b 0
)

echo Unknown command: %1
echo Usage: claudeto [plan^|dev^|loop]
exit /b 1
