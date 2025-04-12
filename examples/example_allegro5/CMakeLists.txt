cmake_minimum_required(VERSION 3.21)
project(example_allegro5)


find_package(Allegro REQUIRED)

add_library(imgui_alegro STATIC)
add_library(imgui::imgui_alegro ALIAS imgui_alegro)

target_sources(imgui_alegro
PUBLIC
    FILE_SET imgui_headers TYPE HEADERS
        FILES
        ../../imconfig.h
        ../../imgui.h
        ../../imgui_internal.h
        ../../imstb_rectpack.h
        ../../imstb_textedit.h
        ../../imstb_truetype.h
        BASE_DIRS ../..
    FILE_SET config_headers TYPE HEADERS
        FILES imconfig_allegro5.h
        BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
PRIVATE
        ../../imgui.cpp
        ../../imgui_demo.cpp
        ../../imgui_draw.cpp
        ../../imgui_tables.cpp
        ../../imgui_widgets.cpp
)
target_compile_features(imgui_alegro PRIVATE cxx_std_11)
target_compile_options(imgui_alegro PRIVATE -Wall -Wformat)
target_compile_definitions(imgui_alegro PUBLIC "IMGUI_USER_CONFIG=<imconfig_allegro5.h>")

target_include_directories(imgui_alegro PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../..>
    $<INSTALL_INTERFACE:include>
)

install(TARGETS imgui_alegro
        EXPORT imguiTargets
        ARCHIVE DESTINATION lib
        FILE_SET imgui_headers DESTINATION include
        FILE_SET config_headers DESTINATION include
)

add_library(imgui_backend_allegro5 STATIC)
add_library(imgui::backend_allegro5 ALIAS imgui_backend_allegro5)

target_sources(imgui_backend_allegro5
PUBLIC FILE_SET imgui_backend_allegro5_headers TYPE HEADERS FILES ../../backends/imgui_impl_allegro5.h BASE_DIRS ../../backends
PRIVATE ../../backends/imgui_impl_allegro5.cpp
)
target_compile_features(imgui_backend_allegro5 PRIVATE cxx_std_11)
target_compile_options(imgui_backend_allegro5 PRIVATE -Wall -Wformat)

target_include_directories(imgui_backend_allegro5 PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../backends>
    $<INSTALL_INTERFACE:include>
)

target_link_libraries(imgui_backend_allegro5 PUBLIC imgui::imgui_alegro)
target_link_libraries(imgui_backend_allegro5 PUBLIC allegro allegro_main allegro_primitives)

install(TARGETS imgui_backend_allegro5
        EXPORT imguiTargets
        ARCHIVE DESTINATION lib
        FILE_SET imgui_backend_allegro5_headers DESTINATION include
)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE imgui::imgui_alegro imgui::backend_allegro5)
