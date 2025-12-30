#!/bin/bash

# claudeto - CLI tool for managing Claude agent todos

TODOS_DIR=".claude/.agent-todos"

# Ensure the todos directory exists
ensure_todos_dir() {
    if [ ! -d "$TODOS_DIR" ]; then
        mkdir -p "$TODOS_DIR"
        echo "Created $TODOS_DIR directory"
    fi
}

# Show usage information
show_usage() {
    echo "Usage: claudeto [command]"
    echo ""
    echo "Commands:"
    echo "  (none)    Create .claude/.agent-todos directory if not exists"
    echo "  plan      Run feature planner to plan development of @project.md"
    echo "  dev       Run feature developer to develop the next feature"
    echo "  loop      Continuously develop features until all todos are done"
    echo ""
}

# Main logic
case "${1:-}" in
    "")
        # No argument: just ensure directory exists
        ensure_todos_dir
        ;;
    "plan")
        ensure_todos_dir
        claude-yolo -p "Use feature planner to plan the development of @project.md"
        ;;
    "dev")
        ensure_todos_dir
        claude-yolo -p "Use feature developer to develop the next feature"
        ;;
    "loop")
        ensure_todos_dir
        until [ -z "$(find "$TODOS_DIR" -maxdepth 1 -type f ! -name '*\[done\]*' -print -quit)" ]; do
            claude-yolo -p "Use feature developer to develop the next feature"
            sleep 1
        done
        echo "All todos completed!"
        ;;
    "help"|"--help"|"-h")
        show_usage
        ;;
    *)
        echo "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac
