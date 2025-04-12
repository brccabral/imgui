cmake_minimum_required(VERSION 3.23)
project(ImGui)

option(BUILD_EXAMPLES "Build examples" ON)

add_library(imgui STATIC)
add_library(imgui::imgui ALIAS imgui)

target_sources(imgui
PUBLIC
    FILE_SET HEADERS
    FILES
        imconfig.h
        imgui.h
        imgui_internal.h
        imstb_rectpack.h
        imstb_textedit.h
        imstb_truetype.h
PRIVATE
        imgui.cpp
        imgui_demo.cpp
        imgui_draw.cpp
        imgui_tables.cpp
        imgui_widgets.cpp
)
target_compile_features(imgui PRIVATE cxx_std_11)
target_compile_options(imgui PRIVATE -Wall -Wformat)

target_include_directories(imgui PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

install(TARGETS imgui
        EXPORT imguiTargets
        ARCHIVE DESTINATION lib
        FILE_SET HEADERS DESTINATION include
)

add_subdirectory(backends)

if (BUILD_EXAMPLES)
    add_subdirectory(examples)
endif ()
