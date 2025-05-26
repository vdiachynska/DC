# Python Installation Guide

This guide covers installing or updating Python to the latest stable version (Python 3.12.x as of January 2025) on Mac and Windows.

## macOS Installation

### Method 1: Official Python Installer (Recommended)

1. Visit the official Python website: https://www.python.org/downloads/
2. Click "Download Python 3.13.x" (the latest version will be displayed)
3. Open the downloaded `.pkg` file
4. Follow the installation wizard
5. Make sure to check "Add Python to PATH" if prompted

### Method 2: Using Homebrew

If you have Homebrew installed:

```bash
# Install Python
brew install python@3.13

# Or update if already installed
brew upgrade python
```

### Verify Installation on Mac

Open Terminal and run:

```bash
python3 --version
# or
python --version
```
a
## Windows Installation

### Method 1: Official Python Installer (Recommended)

1. Visit the official Python website: https://www.python.org/downloads/
2. Click "Download Python 3.13.x" (the latest version will be displayed)
3. Open the downloaded `.exe` file
4. **Important**: Check "Add Python to PATH" at the bottom of the installer
5. Click "Install Now" or choose "Customize installation" for advanced options
6. Follow the installation wizard

### Method 2: Microsoft Store

1. Open Microsoft Store
2. Search for "Python 3.13"
3. Click "Get" or "Install"

### Method 3: Using Chocolatey

If you have Chocolatey installed:

```powershell
# Install Python
choco install python

# Or upgrade if already installed
choco upgrade python
```

### Verify Installation on Windows

Open Command Prompt or PowerShell and run:

```cmd
python --version
# or
py --version
```

## Updating Python

### macOS Update

- **Official installer**: Download and install the latest version from python.org
- **Homebrew**: Run `brew upgrade python`

### Windows Update

- **Official installer**: Download and install the latest version from python.org (it will update your existing installation)
- **Microsoft Store**: Updates automatically or manually through the store
- **Chocolatey**: Run `choco upgrade python`

## Post-Installation Setup

### Update pip (Python Package Manager)

After installation, update pip to the latest version:

```bash
# On macOS/Linux
python3 -m pip install --upgrade pip

# On Windows
python -m pip install --upgrade pip
```

### Create Virtual Environment (Recommended)

It's good practice to create virtual environments for your projects:

```bash
# Create a virtual environment
python -m venv myproject

# Activate it
# On macOS/Linux:
source myproject/bin/activate

# On Windows:
myproject\Scripts\activate
```

## Troubleshooting

### Python Not Found in PATH

If you get "python is not recognized" or "command not found":

**Windows:**
1. Search for "Environment Variables" in Start Menu
2. Click "Environment Variables"
3. Find "Path" in System Variables, click "Edit"
4. Add Python installation directory (usually `C:\Users\YourName\AppData\Local\Programs\Python\Python313\`)

**macOS:**
Add to your shell profile (`.bashrc`, `.zshrc`, etc.):
```bash
export PATH="/usr/local/bin/python3:$PATH"
```

### Multiple Python Versions

If you have multiple versions installed:
- Use `python3` command on macOS/Linux
- Use `py -3.13` on Windows to specify version
- Use `which python` (macOS/Linux) or `where python` (Windows) to see which version is being used

## Checking Your Installation

Verify everything is working:

```python
python -c "import sys; print(sys.version)"
```

This should display your Python version and build information.