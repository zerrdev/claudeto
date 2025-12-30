@echo off
setlocal enabledelayedexpansion

rem Load config from ~/.claudeto/config if it exists
set "CONFIG_FILE=%USERPROFILE%\.claudeto\config"
if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
        set "%%a=%%b"
    )
)

rem Set defaults if not configured
if not defined CLAUDETO_PLANNER set "CLAUDETO_PLANNER=claudeto planner"
if not defined CLAUDETO_DEV set "CLAUDETO_DEV=claudeto developer"

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
    if "%~2"=="" (
        echo Error: plan command requires a task description
        echo Usage: claudeto plan "your task description"
        exit /b 1
    )
    set "task=%~2"
    for %%a in (%*) do (
        if not "%%~a"=="plan" if not "%%~a"=="%~2" set "task=!task! %%~a"
    )
    claude-yolo -p "Use %CLAUDETO_PLANNER% to %task%"
    exit /b %errorlevel%
)

if "%1"=="project-plan" (
    claude-yolo -p "Use %CLAUDETO_PLANNER% to plan the development of @project.md"
    exit /b %errorlevel%
)

if "%1"=="dev" (
    claude-yolo -p "Use %CLAUDETO_DEV% to develop the next feature"
    exit /b %errorlevel%
)

if "%1"=="loop" (
    :loop
    for /f %%i in ('dir /b ".claude\.agent-todos" 2^>nul ^| findstr /v /i "\[done\]"') do (
        claude-yolo -p "Use %CLAUDETO_DEV% to develop the next feature"
        timeout /t 1 /nobreak >nul
        goto loop
    )
    echo All tasks completed
    exit /b 0
)

echo Unknown command: %1
echo Usage: claudeto [plan^|project-plan^|dev^|loop]
exit /b 1
