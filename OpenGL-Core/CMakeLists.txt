# GLAD
add_library(Glad STATIC
    vendor/Glad/src/glad.c
)

target_include_directories(Glad PUBLIC
    vendor/Glad/include
)

# ImGui - Only include core files, exclude examples
file(GLOB IMGUI_CORE_SOURCES
    vendor/imgui/*.cpp
    vendor/imgui/*.h
)

# Exclude example directories and files (CMake 3.6+)
if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.6")
    list(FILTER IMGUI_CORE_SOURCES EXCLUDE REGEX ".*examples.*")
    list(FILTER IMGUI_CORE_SOURCES EXCLUDE REGEX ".*misc.*")
else()
    # Manual exclusion for older CMake versions
    set(IMGUI_FILTERED_SOURCES "")
    foreach(SRC ${IMGUI_CORE_SOURCES})
        if(NOT SRC MATCHES ".*examples.*" AND NOT SRC MATCHES ".*misc.*")
            list(APPEND IMGUI_FILTERED_SOURCES ${SRC})
        endif()
    endforeach()
    set(IMGUI_CORE_SOURCES ${IMGUI_FILTERED_SOURCES})
endif()

# Try both backends and examples directories (different ImGui versions)
set(IMGUI_BACKENDS_DIR "")
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui/backends")
    list(APPEND IMGUI_CORE_SOURCES
        vendor/imgui/backends/imgui_impl_glfw.cpp
        vendor/imgui/backends/imgui_impl_opengl3.cpp
    )
    set(IMGUI_BACKENDS_DIR "backends")
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui/examples")
    # Only include the implementation files, not the example main files
    list(APPEND IMGUI_CORE_SOURCES
        vendor/imgui/examples/imgui_impl_glfw.cpp
        vendor/imgui/examples/imgui_impl_opengl3.cpp
    )
    set(IMGUI_BACKENDS_DIR "examples")
endif()

add_library(ImGui STATIC ${IMGUI_CORE_SOURCES})

target_include_directories(ImGui PUBLIC
    vendor/imgui
    vendor/Glad/include
)

if(IMGUI_BACKENDS_DIR)
    target_include_directories(ImGui PUBLIC
        vendor/imgui/${IMGUI_BACKENDS_DIR}
    )
endif()

# Define GLAD as the OpenGL loader for ImGui
target_compile_definitions(ImGui PRIVATE
    IMGUI_IMPL_OPENGL_LOADER_GLAD
)

target_link_libraries(ImGui PUBLIC
    ${OPENGL_LIBRARIES}
    Glad
)

# Link GLFW to ImGui if available
if(GLFW_LIBRARIES)
    target_link_libraries(ImGui PUBLIC ${GLFW_LIBRARIES})
endif()

# OpenGL-Core Library
file(GLOB_RECURSE GLCORE_SOURCES
    src/*.cpp
    src/*.h
    vendor/stb_image/*.cpp
    vendor/stb_image/*.h
)

# Filter platform-specific files
if(GLCORE_PLATFORM_LINUX)
    list(APPEND GLCORE_SOURCES
        src/Platform/Linux/LinuxWindow.cpp
        src/Platform/Linux/LinuxInput.cpp
    )
    list(REMOVE_ITEM GLCORE_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Platform/Windows/WindowsWindow.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Platform/Windows/WindowsInput.cpp
    )
elseif(GLCORE_PLATFORM_WINDOWS)
    list(APPEND GLCORE_SOURCES
        src/Platform/Windows/WindowsWindow.cpp
        src/Platform/Windows/WindowsInput.cpp
    )
    list(REMOVE_ITEM GLCORE_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Platform/Linux/LinuxWindow.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/Platform/Linux/LinuxInput.cpp
    )
endif()

add_library(OpenGL-Core STATIC ${GLCORE_SOURCES})

target_include_directories(OpenGL-Core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/spdlog/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/glm
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/Glad/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor/stb_image
)

target_link_libraries(OpenGL-Core PUBLIC
    Glad
    ImGui
    ${OPENGL_LIBRARIES}
)

# Link GLFW to OpenGL-Core if available
if(GLFW_LIBRARIES)
    target_link_libraries(OpenGL-Core PUBLIC ${GLFW_LIBRARIES})
endif()

# Precompiled header
target_precompile_headers(OpenGL-Core PRIVATE src/glpch.h)

# Definitions
target_compile_definitions(OpenGL-Core PRIVATE
    GLFW_INCLUDE_NONE
    _CRT_SECURE_NO_WARNINGS
)

if(GLCORE_PLATFORM_LINUX)
    target_compile_definitions(OpenGL-Core PRIVATE
        GLCORE_PLATFORM_LINUX
    )
elseif(GLCORE_PLATFORM_WINDOWS)
    target_compile_definitions(OpenGL-Core PRIVATE
        GLCORE_PLATFORM_WINDOWS
    )
endif()
