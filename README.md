# Ghostty Installation Script for Debian 12

This script automates the installation of **Ghostty** on Debian 12 using source files. It installs necessary dependencies, downloads and installs **Zig 0.13.0**, and builds **Ghostty** from source. It also ensures a clean installation by removing temporary files after the process.

## Prerequisites

- Debian 12 (or a similar Debian-based distribution)
- A user with `sudo` privileges

## Installation Steps

### 1. Clone the repository

Clone the repository containing this script to your local machine:

```bash
git clone https://github.com/your-repository/ghostty-install-script.git
cd ghostty-install-script
```

### 2. Make the script executable

Change the permissions to make the script executable:

```bash
chmod +x install-ghostty.sh
```

### 3. Run the script

Execute the script to install **Ghostty** and its dependencies:

```bash
./install-ghostty.sh
```

The script will:

1. Install the necessary dependencies (`libgtk-4-dev`, `libadwaita-1-dev`, `git`).
2. Download and install **Zig 0.13.0**.
3. Clone the **Ghostty** repository from GitHub.
4. Build and install **Ghostty** with optimization for performance.
5. Clean up temporary files after the installation is complete.

### 4. Verify the installation

To verify that **Zig** has been installed successfully:

```bash
zig version
```

To verify **Ghostty** has been installed correctly, you can check if it is executable or check the installation paths based on your build setup.

## Cleaning Up

The script automatically removes all temporary files used during the installation process to keep your system clean.

## Troubleshooting

If you encounter any issues:

- Make sure your system has access to the required repositories and internet access for downloading dependencies and source files.
- Check if `zig` is available in your PATH with `which zig` or `zig version`.
- Review the logs printed during the script execution for any error messages.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Notes:
1. **GitHub Repo**: You may want to replace `https://github.com/your-repository/ghostty-install-script.git` with the actual URL if you are hosting this on GitHub or elsewhere.
2. **Verifying Ghostty**: The readme suggests checking if **Ghostty** is installed by verifying the executable or checking installation paths; you can customize that section based on specific verification steps for Ghostty, if needed.
