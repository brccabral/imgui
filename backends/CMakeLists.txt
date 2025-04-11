find_package(glfw3 QUIET)
if (glfw3_FOUND)
    message(STATUS "Found glfw3")
else ()
    message(WARNING "glfw3 not found")
endif ()

find_package(OpenGL QUIET)
if (OpenGL_FOUND)
    message(STATUS "Found OpenGL")
else ()
    message(WARNING "OpenGL not found")
endif ()

find_package(SDL2 QUIET)
if (SDL2_FOUND)
    message(STATUS "Found SDL2")
else ()
    message(WARNING "SDL2 not found")
endif ()

find_package(SDL3 QUIET)
if (SDL3_FOUND)
    message(STATUS "Found SDL3")
else ()
    message(WARNING "SDL3 not found")
endif ()

find_package(Vulkan QUIET)
if (Vulkan_FOUND)
    message(STATUS "Found Vulkan")
else ()
    message(WARNING "Vulkan not found")
endif ()

if (EMSCRIPTEN)
    message(STATUS "Found emscripten")
else ()
    message(WARNING "emscripten not found")
endif ()

set(SUPPORTED_BACKENDS "")
if (glfw3_FOUND AND OpenGL_FOUND)
    list(APPEND SUPPORTED_BACKENDS "glfw_opengl2" "glfw_opengl3")
endif ()
if (glfw3_FOUND AND Vulkan_FOUND)
    list(APPEND SUPPORTED_BACKENDS "glfw_vulkan")
endif ()
if (SDL2_FOUND AND OpenGL_FOUND)
    list(APPEND SUPPORTED_BACKENDS "sdl2_opengl2" "sdl2_opengl3" "sdl2_sdlrenderer2")
endif ()
if (SDL2_FOUND AND Vulkan_FOUND)
    list(APPEND SUPPORTED_BACKENDS "sdl2_vulkan")
endif ()
if (SDL3_FOUND AND OpenGL_FOUND)
    list(APPEND SUPPORTED_BACKENDS "sdl3_opengl3")
endif ()
if (SDL3_FOUND)
    list(APPEND SUPPORTED_BACKENDS "sdl3_sdlgpu3" "sdl3_sdlrenderer3")
endif ()
if (SDL3_FOUND AND Vulkan_FOUND)
    list(APPEND SUPPORTED_BACKENDS "sdl3_vulkan")
endif ()
if (EMSCRIPTEN AND glfw3_FOUND)
    list(APPEND SUPPORTED_BACKENDS "glfw_wgpu")
endif ()

list(GET SUPPORTED_BACKENDS 0 FIRST_BACKEND)

set(BACKEND ${FIRST_BACKEND} CACHE STRING "Choose one of: ${SUPPORTED_BACKENDS}")
set_property(CACHE BACKEND PROPERTY STRINGS ${SUPPORTED_BACKENDS})
if (NOT BACKEND IN_LIST SUPPORTED_BACKENDS)
    message(FATAL_ERROR "Invalid backend ${BACKEND}. Supported values ${SUPPORTED_BACKENDS}")
endif ()
message(STATUS "Supported backends ${SUPPORTED_BACKENDS}")
message(STATUS "Backend ${BACKEND}")

if (BACKEND STREQUAL "glfw_opengl2")
    find_package(glfw3 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_opengl2.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_opengl2.cpp)
    set(TARGET_LIBS glfw OpenGL)
endif ()

add_library(imgui STATIC)
add_library(imgui::imgui ALIAS imgui)

target_sources(imgui
PUBLIC FILE_SET HEADERS FILES ${HEADER_FILES}
PRIVATE ${CPP_FILES}
)
target_compile_features(imgui PRIVATE cxx_std_11)
target_compile_options(imgui PRIVATE -Wall -Wformat)

target_include_directories(imgui PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

target_link_libraries(imgui PUBLIC imgui::main)
target_link_libraries(imgui PUBLIC ${TARGET_LIBS})

install(TARGETS imgui
        EXPORT imguiTargets
        ARCHIVE DESTINATION lib
        FILE_SET HEADERS DESTINATION include
)

install(EXPORT imguiTargets
        NAMESPACE imgui::
        DESTINATION share/cmake/imgui
)
