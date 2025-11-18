cmake_minimum_required(VERSION 3.15)
project(OpenGL-Sandbox)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Platform detection
if(UNIX AND NOT APPLE)
    set(GLCORE_PLATFORM_LINUX ON)
    add_definitions(-DGLCORE_PLATFORM_LINUX)
elseif(WIN32)
    set(GLCORE_PLATFORM_WINDOWS ON)
    add_definitions(-DGLCORE_PLATFORM_WINDOWS)
endif()

# Build configuration
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DGLCORE_DEBUG)
else()
    add_definitions(-DGLCORE_RELEASE)
endif()

# Find packages
find_package(OpenGL REQUIRED)
find_package(PkgConfig QUIET)

# Try to find GLFW via pkg-config or find_package
find_package(glfw3 QUIET)
if(NOT glfw3_FOUND)
    if(PkgConfig_FOUND)
        pkg_check_modules(GLFW3 QUIET glfw3)
        if(GLFW3_FOUND)
            set(GLFW_LIBRARIES ${GLFW3_LIBRARIES} CACHE STRING "GLFW libraries")
            set(GLFW_INCLUDE_DIRS ${GLFW3_INCLUDE_DIRS} CACHE STRING "GLFW include directories")
        endif()
    endif()
    if(NOT GLFW3_FOUND)
        # Check if GLFW is in vendor directory
        if(EXISTS "${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/glfw/CMakeLists.txt")
            add_subdirectory(OpenGL-Core/vendor/glfw)
            set(GLFW_LIBRARIES glfw CACHE STRING "GLFW libraries")
            set(GLFW_INCLUDE_DIRS "${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/glfw/include" CACHE STRING "GLFW include directories")
        else()
            message(FATAL_ERROR "GLFW not found. Please install libglfw3-dev or initialize git submodules.")
        endif()
    endif()
else()
    set(GLFW_LIBRARIES glfw CACHE STRING "GLFW libraries")
    get_target_property(GLFW_INCLUDE_DIRS glfw INTERFACE_INCLUDE_DIRECTORIES)
    if(NOT GLFW_INCLUDE_DIRS)
        set(GLFW_INCLUDE_DIRS "" CACHE STRING "GLFW include directories")
    endif()
endif()

# Include directories (for reference, actual includes are in subdirectories)
set(INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/src
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/spdlog/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/glm
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/Glad/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/imgui
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/stb_image
    ${GLFW_INCLUDE_DIRS}
)

# Add subdirectories
add_subdirectory(OpenGL-Core)
add_subdirectory(OpenGL-Sandbox)
add_subdirectory(OpenGL-Examples)
