# Important: This is a "null backend" application, with no visible output or interaction!
# This is used for testing purpose and continuous integration, and has little use for end-user.
#

add_library(example_null STATIC)

target_sources(example_null
    PRIVATE
        ../../imgui.cpp
        ../../imgui_demo.cpp
        ../../imgui_draw.cpp
        ../../imgui_tables.cpp
        ../../imgui_widgets.cpp
)
target_compile_features(example_null PRIVATE cxx_std_11)
if (MSVC)
    target_compile_options(example_null PRIVATE /W3)
else ()
    target_compile_options(example_null PRIVATE -Wall -Wformat)
endif ()

target_include_directories(example_null PRIVATE ../..)

if (WITH_FREETYPE)
    find_package(Freetype REQUIRED)

    target_sources(example_null
        PRIVATE
            ../../misc/freetype/imgui_freetype.cpp
    )
    target_link_libraries(example_null PRIVATE Freetype::Freetype)
endif ()
