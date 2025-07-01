# Ghostty Installation Script for Debian 12

This script automates the installation of **Ghostty** terminal emulator on Debian 12 (Bookworm) by building from source. It handles the dependency version conflicts between newer Ghostty releases and Debian 12's stable packages.

## Why This Script?

The latest Ghostty releases require:
- libadwaita 1.5.0+ (Debian 12 has 1.2.2)
- blueprint-compiler 0.16.0+ (Debian 12 has 0.6.0)

This script builds an older, compatible version (commit f1f11207) that works perfectly with Debian 12's packages.

## Prerequisites

- Debian 12 (Bookworm) or similar Debian-based distribution
- User with `sudo` privileges
- Internet connection for downloading dependencies

## System Dependencies

The script will automatically install:
- `libgtk-4-dev` - GTK4 development files
- `libadwaita-1-dev` - Adwaita (GNOME) development files
- `git` - Version control system
- `blueprint-compiler` - GTK blueprint compiler

## Installation Steps

### 1. Clone the repository

```bash
git clone https://github.com/drewgrif/myghostty
cd myghostty
```

### 2. Make the script executable

```bash
chmod +x install_ghostty.sh
```

### 3. Run the installation script

```bash
sudo ./install_ghostty.sh
```

The script will:

1. Install system dependencies via apt
2. Download Zig 0.13.0 to a temporary location (required for this Ghostty version)
3. Clone Ghostty repository and checkout commit f1f11207
4. Build Ghostty with optimizations
5. Install Ghostty to `/usr/bin/ghostty`
6. Set up default configuration in `~/.config/ghostty/config`
7. Clean up all temporary files

### 4. Verify the installation

After installation, verify Ghostty is working:

```bash
ghostty --version
```

You should see: `ghostty 1.1.3-HEAD+f1f11207`

## Cleaning Up

The script automatically removes all temporary files used during the installation process to keep your system clean.

## Troubleshooting

If you encounter any issues:

- Make sure your system has access to the required repositories and internet access for downloading dependencies and source files.
- Check if `zig` is available in your PATH with `which zig` or `zig version`.
- Review the logs printed during the script execution for any error messages.


> [!TIP]
> If you are getting an error using ```clear``` or ```CTRL+L``` command in SSH, look at SSH https://ghostty.org/docs/help/terminfo#ssh

![2025-01-22_18-55](https://github.com/user-attachments/assets/6879a35c-a609-4215-9c52-674c64b46683)

#### SOLUTION:   ```infocmp -x | ssh YOUR-SERVER -- tic -x -```
