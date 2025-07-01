#!/bin/bash

# Set up error handling
set -e

# Dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y libgtk-4-dev libadwaita-1-dev git blueprint-compiler

# Create a temporary directory for the build
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Check if Zig is installed and at least version 0.14.0
ZIG_REQUIRED_VERSION="0.14.0"
check_zig_version() {
    local installed_version
    installed_version=$(zig version 2>/dev/null || echo "0.0.0")
    if [ "$(printf '%s\n' "$ZIG_REQUIRED_VERSION" "$installed_version" | sort -V | head -n1)" = "$ZIG_REQUIRED_VERSION" ]; then
        return 0
    else
        return 1
    fi
}

if command -v zig &> /dev/null && check_zig_version; then
    echo "Zig $ZIG_REQUIRED_VERSION or higher is already installed."
else
    echo "Downloading and installing Zig $ZIG_REQUIRED_VERSION..."
    cd "$TMP_DIR"
    ZIG_URL="https://ziglang.org/download/$ZIG_REQUIRED_VERSION/zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz"
    wget "$ZIG_URL"
    tar -xf "zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz"
    sudo mv "zig-linux-x86_64-$ZIG_REQUIRED_VERSION" /usr/local/zig
    sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig
    echo "Zig $ZIG_REQUIRED_VERSION installed successfully."
fi

# Verify Zig installation
zig version || { echo "Zig installation failed!"; exit 1; }

# Clone and build Ghostty from the latest main branch
echo "Cloning and building Ghostty from latest main branch..."
cd "$TMP_DIR"
git clone https://github.com/ghostty-org/ghostty.git
cd ghostty

sudo zig build -p /usr -Doptimize=ReleaseFast
echo "Ghostty installed successfully."

# Cleanup
echo "Cleaning up temporary files..."
sudo rm -rf "$TMP_DIR"

# Ensure ~/.config/ghostty directory exists
mkdir -p "$HOME/.config/ghostty"

# Desired ghostty configuration
CONFIG_FILE="$HOME/.config/ghostty/config"
DESIRED_CONFIG="
font-family = SauceCodePro Nerd Font Mono
font-size = 16
background-opacity = 0.90
theme = nightfox
"

# Create or update the config file
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Creating ghostty config with default settings at $CONFIG_FILE..."
    echo "$DESIRED_CONFIG" > "$CONFIG_FILE"
else
    echo "Updating ghostty config at $CONFIG_FILE to ensure desired settings are present..."

    for setting in "font-family" "font-size" "background-opacity" "theme"; do
        value=$(echo "$DESIRED_CONFIG" | grep "^$setting" | cut -d'=' -f2-)
        if grep -q "^$setting" "$CONFIG_FILE"; then
            sed -i "s|^$setting.*|$setting = $value|" "$CONFIG_FILE"
        else
            echo "$setting = $value" >> "$CONFIG_FILE"
        fi
    done
fi

echo "Ghostty installation and configuration complete."
