# claudeto

A CLI tool for automated feature planning and development using Claude AI agents.

## Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/zerrdev/claudeto/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/zerrdev/claudeto/main/install.ps1 | iex
```

The script will be installed to `~/.claudeto` and added to your PATH. Restart your terminal for PATH changes to take effect.

## Usage

```
claudeto [command]

Commands:
  (none)        Create .claude/.agent-todos directory if not exists
  plan          Run planner with a custom task (e.g., claudeto plan "improve auth")
  project-plan  Run planner to plan development of @project.md
  dev           Run developer to develop the next feature
  loop          Continuously develop features until all todos are done
  help          Show usage information
```

### Initialize Project

```bash
claudeto
```

Creates the `.claude/.agent-todos` directory if it doesn't exist. This directory is used to track pending features and tasks.

### Plan Custom Task

```bash
claudeto plan "your task description"
```

Runs the planner agent with a custom task. Examples:

```bash
claudeto plan "add user authentication"
claudeto plan "refactor the database layer"
claudeto plan "improve error handling"
```

### Plan from Project File

```bash
claudeto project-plan
```

Runs the planner agent to analyze `project.md` and break down the project into actionable development tasks.

### Develop Next Feature

```bash
claudeto dev
```

Runs the developer agent to implement the next pending feature from the `.agent-todos` directory.

### Continuous Development Loop

```bash
claudeto loop
```

Continuously develops features until all tasks are complete. The loop:

1. Checks for incomplete tasks in `.claude/.agent-todos`
2. Runs the developer on the next pending task
3. Repeats until no pending tasks remain

## Directory Structure

```
.claude/
└── .agent-todos/
    ├── feature-1.md
    ├── feature-2.md
    ├── feature-3[done].md
    └── ...
```

Tasks are marked as complete by adding `[done]` to the filename.

## Configuration

You can customize the planner and developer prompts by creating a config file at `~/.claudeto/config`:

```bash
# ~/.claudeto/config
CLAUDETO_PLANNER="claudeto planner"
CLAUDETO_DEV="claudeto developer"
```

These variables control the prompt prefixes used when invoking Claude agents.

## Requirements

- [claude-yolo](https://github.com/zerrdev/claude-yolo) - Claude CLI wrapper for running AI agents

### Installing claude-yolo

Before using claudeto, you need to install claude-yolo:

```bash
npm install -g claude-yolo
```
