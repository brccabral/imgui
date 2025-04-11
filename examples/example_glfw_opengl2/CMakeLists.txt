cmake_minimum_required(VERSION 3.21)
project(example_glfw_opengl2)

# find_package(imgui REQUIRED)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE main.cpp)
target_compile_features(imgui PRIVATE cxx_std_11)
target_compile_options(imgui PRIVATE -Wall -Wformat)

target_link_libraries(${PROJECT_NAME} PRIVATE imgui::imgui)
