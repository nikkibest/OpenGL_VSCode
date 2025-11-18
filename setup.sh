#!/bin/bash

# Setup script for OpenGL project on Linux
# This script initializes git submodules and installs system dependencies

set -e

echo "Setting up OpenGL project for Linux..."

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

# Initialize and update git submodules
echo "Initializing git submodules..."
git submodule update --init --recursive

# Check for required packages
echo "Checking for required packages..."

# Check for CMake
if ! command -v cmake &> /dev/null; then
    echo "Error: CMake is not installed."
    echo "Please install CMake: sudo pacman -S cmake (Arch) or sudo apt-get install cmake (Debian/Ubuntu)"
    exit 1
fi

# Check for OpenGL development libraries
if [ ! -f "/usr/include/GL/gl.h" ] && [ ! -f "/usr/include/GLES3/gl3.h" ]; then
    echo "Warning: OpenGL development headers not found."
    echo "Please install: sudo pacman -S mesa (Arch) or sudo apt-get install libgl1-mesa-dev (Debian/Ubuntu)"
fi

# Check for GLFW
if ! pkg-config --exists glfw3 2>/dev/null; then
    echo "Warning: GLFW3 not found via pkg-config."
    echo "Please install: sudo pacman -S glfw (Arch) or sudo apt-get install libglfw3-dev (Debian/Ubuntu)"
    echo "Or build from source if vendor/glfw is empty"
fi

# Check for build tools
if ! command -v make &> /dev/null; then
    echo "Warning: make is not installed."
    echo "Please install build-essential or base-devel"
fi

echo ""
echo "Setup complete!"
echo ""
echo "To build the project:"
echo "  1. mkdir -p build"
echo "  2. cd build"
echo "  3. cmake .."
echo "  4. make"
echo ""
echo "Or use the VS Code tasks:"
echo "  - Press Ctrl+Shift+P and run 'Tasks: Run Build Task'"
echo "  - Or use the CMake extension"
