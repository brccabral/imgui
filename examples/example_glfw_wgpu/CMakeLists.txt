# Building for desktop (WebGPU-native) with Dawn:
#  1. git clone https://github.com/google/dawn dawn
#  2. cmake -B build -DIMGUI_DAWN_DIR=dawn
#  3. cmake --build build --target example_glfw_wgpu_dawn
# The resulting binary will be found at one of the following locations:
#   * build/Debug/example_glfw_wgpu_dawn[.exe]
#   * build/example_glfw_wgpu_dawn[.exe]

# Building for Emscripten:
#  1. Install Emscripten SDK following the instructions: https://emscripten.org/docs/getting_started/downloads.html
#  2. Install Ninja build system
#  3. emcmake cmake -G Ninja -B build
#  3. cmake --build build --target example_glfw_wgpu_emscripten
#  4. emrun build/index.html

cmake_minimum_required(VERSION 3.23)
project(example_glfw_wgpu)

# find_package(imgui REQUIRED)

if (IMGUI_DAWN_DIR AND 0) # example does not compile with latest Dawn
    add_executable(example_glfw_wgpu_dawn)

    target_sources(example_glfw_wgpu_dawn PRIVATE main.cpp)

    target_link_libraries(example_glfw_wgpu_dawn PRIVATE imgui::imgui imgui::backend_glfw_wgpu_dawn)
endif ()

if (EMSCRIPTEN)
    add_executable(example_glfw_wgpu_emscripten)

    target_sources(example_glfw_wgpu_emscripten PRIVATE main.cpp)

    target_link_libraries(example_glfw_wgpu_emscripten PRIVATE imgui::imgui imgui::backend_glfw_wgpu_emscripten)

    set_target_properties(example_glfw_wgpu_emscripten PROPERTIES OUTPUT_NAME "index")
    # copy our custom index.html to build directory
    add_custom_command(TARGET example_glfw_wgpu_emscripten POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_CURRENT_LIST_DIR}/web/index.html" $<TARGET_FILE_DIR:example_glfw_wgpu_emscripten>
    )
endif ()
