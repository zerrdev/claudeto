#!/bin/bash

# claudeto installer for Unix-based systems
# Usage: curl -fsSL https://raw.githubusercontent.com/zerrdev/claudeto/main/install.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/zerrdev/claudeto/main"
INSTALL_DIR="$HOME/.claudeto"

echo "Installing claudeto..."

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Download the claudeto script
curl -fsSL "$REPO_URL/claudeto" -o "$INSTALL_DIR/claudeto"

# Make executable
chmod +x "$INSTALL_DIR/claudeto"

# Add to PATH in shell profile if not already there
add_to_path() {
    local profile="$1"
    if [ -f "$profile" ]; then
        if ! grep -q "\.claudeto" "$profile"; then
            echo 'export PATH="$HOME/.claudeto:$PATH"' >> "$profile"
            echo "Added to $profile"
        fi
    fi
}

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    add_to_path "$HOME/.bashrc"
    add_to_path "$HOME/.zshrc"
    echo ""
    echo "Restart your terminal or run: export PATH=\"\$HOME/.claudeto:\$PATH\""
fi

echo "claudeto installed successfully!"
echo "Run 'claudeto' to get started."
