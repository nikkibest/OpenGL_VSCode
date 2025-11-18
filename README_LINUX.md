# OpenGL Project - Linux Setup Guide

This project has been adapted to work on Linux with Cursor/VS Code. The original project was designed for Visual Studio on Windows.

## Prerequisites

### System Dependencies

Install the following packages on your Linux system:

**Arch Linux:**
```bash
sudo pacman -S cmake make gcc glfw mesa
```

**Debian/Ubuntu:**
```bash
sudo apt-get install cmake build-essential libglfw3-dev libgl1-mesa-dev
```

**Fedora:**
```bash
sudo dnf install cmake gcc-c++ glfw-devel mesa-libGL-devel
```

### Project Dependencies

The project uses git submodules for vendor dependencies. Initialize them:

```bash
./setup.sh
```

Or manually:
```bash
git submodule update --init --recursive
```

## Building the Project

### Using CMake (Command Line)

1. Create a build directory:
```bash
mkdir -p build
cd build
```

2. Configure and build:
```bash
cmake ..
make
```

3. Run the application:
```bash
./bin/OpenGL-Sandbox
```

### Using VS Code/Cursor

1. **Install Extensions:**
   - C/C++ (Microsoft)
   - CMake Tools (Microsoft)

2. **Build:**
   - Press `Ctrl+Shift+P` and run "Tasks: Run Build Task"
   - Or use the CMake extension to configure and build

3. **Debug:**
   - Press `F5` to start debugging
   - Or use the "Debug OpenGL-Sandbox" configuration from the Run menu

## Project Structure

- `OpenGL-Core/` - Core OpenGL library
- `OpenGL-Sandbox/` - Main application
- `OpenGL-Examples/` - Example applications
- `build/` - Build output directory (created during build)

## Platform-Specific Code

The project now supports both Windows and Linux:
- Windows: Uses `WindowsWindow.cpp` and `WindowsInput.cpp`
- Linux: Uses `LinuxWindow.cpp` and `LinuxInput.cpp`

The platform is automatically detected during CMake configuration.

## Troubleshooting

### GLFW not found
If CMake can't find GLFW:
1. Install system GLFW: `sudo pacman -S glfw` (Arch) or `sudo apt-get install libglfw3-dev` (Debian)
2. Or ensure git submodules are initialized: `git submodule update --init --recursive`

### OpenGL errors
Make sure you have:
- Mesa drivers installed
- Proper graphics drivers for your GPU

### ImGui include errors
The project supports both ImGui versions:
- Older versions use `examples/imgui_impl_*.h`
- Newer versions use `backends/imgui_impl_*.h`

CMake will automatically detect which version you have.

## Original Project

This is based on The Cherno's OpenGL tutorial series. The original project used Premake5 for Windows/Visual Studio. This adaptation uses CMake for cross-platform support.
