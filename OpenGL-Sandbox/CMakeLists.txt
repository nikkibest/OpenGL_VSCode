file(GLOB_RECURSE SANDBOX_SOURCES
    src/*.cpp
    src/*.h
)

add_executable(OpenGL-Sandbox ${SANDBOX_SOURCES})

target_include_directories(OpenGL-Sandbox PRIVATE
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/src
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/spdlog/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/glm
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/Glad/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/imgui
)

target_link_libraries(OpenGL-Sandbox PRIVATE
    OpenGL-Core
)

if(GLCORE_PLATFORM_LINUX)
    target_compile_definitions(OpenGL-Sandbox PRIVATE
        GLCORE_PLATFORM_LINUX
    )
elseif(GLCORE_PLATFORM_WINDOWS)
    target_compile_definitions(OpenGL-Sandbox PRIVATE
        GLCORE_PLATFORM_WINDOWS
    )
endif()

# Set working directory for debugging/running from IDE
set_target_properties(OpenGL-Sandbox PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)
