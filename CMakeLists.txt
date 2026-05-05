cmake_minimum_required(VERSION 3.20)
project(HelloWorldVulkan LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Vulkan REQUIRED)
find_package(glfw3 REQUIRED)

# Shader compilation
set(SHADER_DIR ${CMAKE_SOURCE_DIR}/shaders)
file(MAKE_DIRECTORY ${SHADER_DIR})

# Compile combined vertex shader for background (with BACKGROUND define)
add_custom_command(
    OUTPUT ${SHADER_DIR}/background.vert.spv
    COMMAND glslangValidator -V -DBACKGROUND ${SHADER_DIR}/vert.vert -o ${SHADER_DIR}/background.vert.spv
    DEPENDS ${SHADER_DIR}/vert.vert
    COMMENT "Compiling background vertex shader from vert.vert"
)

# Compile combined vertex shader for torus (no define → torus branch)
add_custom_command(
    OUTPUT ${SHADER_DIR}/torus.vert.spv
    COMMAND glslangValidator -V ${SHADER_DIR}/vert.vert -o ${SHADER_DIR}/torus.vert.spv
    DEPENDS ${SHADER_DIR}/vert.vert
    COMMENT "Compiling torus vertex shader from vert.vert"
)

# Compile combined fragment shader for background
add_custom_command(
    OUTPUT ${SHADER_DIR}/background.frag.spv
    COMMAND glslangValidator -V -DBACKGROUND ${SHADER_DIR}/frag.frag -o ${SHADER_DIR}/background.frag.spv
    DEPENDS ${SHADER_DIR}/frag.frag
    COMMENT "Compiling background fragment shader from frag.frag"
)

# Compile combined fragment shader for torus
add_custom_command(
    OUTPUT ${SHADER_DIR}/torus.frag.spv
    COMMAND glslangValidator -V ${SHADER_DIR}/frag.frag -o ${SHADER_DIR}/torus.frag.spv
    DEPENDS ${SHADER_DIR}/frag.frag
    COMMENT "Compiling torus fragment shader from frag.frag"
)

add_custom_target(Shaders ALL DEPENDS
    ${SHADER_DIR}/background.vert.spv
    ${SHADER_DIR}/torus.vert.spv
    ${SHADER_DIR}/background.frag.spv
    ${SHADER_DIR}/torus.frag.spv
)

add_executable(HelloWorld WIN32
    Main.cpp
    Main.h
)
target_include_directories(HelloWorld PRIVATE ${Vulkan_INCLUDE_DIRS})
target_link_libraries(HelloWorld Vulkan::Vulkan glfw)
add_dependencies(HelloWorld Shaders)

# Copy shaders to build directory so the app can find them
add_custom_command(TARGET HelloWorld POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${SHADER_DIR}/background.vert.spv $<TARGET_FILE_DIR:HelloWorld>/shaders/background.vert.spv
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${SHADER_DIR}/torus.vert.spv $<TARGET_FILE_DIR:HelloWorld>/shaders/torus.vert.spv
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${SHADER_DIR}/background.frag.spv $<TARGET_FILE_DIR:HelloWorld>/shaders/background.frag.spv
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${SHADER_DIR}/torus.frag.spv $<TARGET_FILE_DIR:HelloWorld>/shaders/torus.frag.spv
)