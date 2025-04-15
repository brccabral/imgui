cmake_minimum_required(VERSION 3.23)
project(example_sdl3_opengl3)

# find_package(imgui REQUIRED)

if (NOT IMGUI_EMSCRIPTEN_FOUND)
    add_executable(${PROJECT_NAME})

    target_sources(${PROJECT_NAME} PRIVATE main.cpp)

    target_link_libraries(${PROJECT_NAME} PRIVATE imgui::imgui imgui::backend_sdl3_opengl3)
else ()
    add_executable(example_sdl3_opengl3_emscripten)

    target_sources(example_sdl3_opengl3_emscripten PRIVATE main.cpp)

    target_link_libraries(example_sdl3_opengl3_emscripten PRIVATE imgui::imgui imgui::backend_sdl3_opengl3_emscripten)

    target_link_options(example_sdl3_opengl3_emscripten
        PRIVATE
        "--shell-file=${CMAKE_CURRENT_SOURCE_DIR}/../libs/emscripten/shell_minimal.html"
        "-sMODULARIZE=0"
    )

    set_target_properties(example_sdl3_opengl3_emscripten PROPERTIES OUTPUT_NAME "index")
    set(CMAKE_EXECUTABLE_SUFFIX ".html")

    if (IMGUI_HTTP_PORT)
        set(HTTP_PORT ${IMGUI_HTTP_PORT})
    else ()
        set(HTTP_PORT 8080)
    endif ()
    add_custom_target(run_example_sdl3_opengl3_emscripten
        COMMAND python3 -m http.server -d $<TARGET_FILE_DIR:example_sdl3_opengl3_emscripten> ${HTTP_PORT}
        DEPENDS example_sdl3_opengl3_emscripten
        COMMAND "Run a python3 http.server in example_sdl3_opengl3_emscripten location http://127.0.0.1:${HTTP_PORT}/"
    )
endif ()
