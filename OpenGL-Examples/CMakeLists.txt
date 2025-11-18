file(GLOB_RECURSE EXAMPLES_SOURCES
    src/*.cpp
    src/*.h
)

add_executable(OpenGL-Examples ${EXAMPLES_SOURCES})

target_include_directories(OpenGL-Examples PRIVATE
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/src
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/spdlog/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/glm
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/Glad/include
    ${CMAKE_SOURCE_DIR}/OpenGL-Core/vendor/imgui
)

target_link_libraries(OpenGL-Examples PRIVATE
    OpenGL-Core
)

if(GLCORE_PLATFORM_LINUX)
    target_compile_definitions(OpenGL-Examples PRIVATE
        GLCORE_PLATFORM_LINUX
    )
elseif(GLCORE_PLATFORM_WINDOWS)
    target_compile_definitions(OpenGL-Examples PRIVATE
        GLCORE_PLATFORM_WINDOWS
    )
endif()

# Copy shader assets to build directory (next to executable) after build
add_custom_command(TARGET OpenGL-Examples POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/assets
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/assets
    COMMENT "Copying shader assets to build directory"
)

# Set working directory for debugging/running from IDE
set_target_properties(OpenGL-Examples PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)
