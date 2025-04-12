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

set(FOUND_BACKENDS "")
if (glfw3_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_opengl2" "glfw_opengl3")
endif ()
if (glfw3_FOUND AND Vulkan_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_vulkan")
endif ()
if (SDL2_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "sdl2_opengl2" "sdl2_opengl3" "sdl2_sdlrenderer2")
endif ()
if (SDL2_FOUND AND Vulkan_FOUND)
    list(APPEND FOUND_BACKENDS "sdl2_vulkan")
endif ()
if (SDL3_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "sdl3_opengl3")
endif ()
if (SDL3_FOUND)
    list(APPEND FOUND_BACKENDS "sdl3_sdlgpu3" "sdl3_sdlrenderer3")
endif ()
if (SDL3_FOUND AND Vulkan_FOUND)
    list(APPEND FOUND_BACKENDS "sdl3_vulkan")
endif ()
if (EMSCRIPTEN AND glfw3_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_wgpu")
endif ()
if (EMSCRIPTEN AND glfw3_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_web_opengl3")
endif ()

set(SUPPORTED_BACKENDS ${FOUND_BACKENDS})
set(SUPPORTED_BACKENDS ${FOUND_BACKENDS} PARENT_SCOPE)
message(STATUS "Supported backends ${SUPPORTED_BACKENDS}")

function (add_backend NAME HEADER_FILES CPP_FILES TARGET_LIBS)
    add_library(imgui_backend_${NAME} STATIC)
    add_library(imgui::backend_${NAME} ALIAS imgui_backend_${NAME})

    target_sources(imgui_backend_${NAME}
    PUBLIC FILE_SET HEADERS FILES ${HEADER_FILES}
    PRIVATE ${CPP_FILES}
    )
    target_compile_features(imgui_backend_${NAME} PRIVATE cxx_std_11)
    target_compile_options(imgui_backend_${NAME} PRIVATE -Wall -Wformat)

    target_include_directories(imgui_backend_${NAME} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
    )

    target_link_libraries(imgui_backend_${NAME} PUBLIC imgui::imgui)
    target_link_libraries(imgui_backend_${NAME} PUBLIC ${TARGET_LIBS})

    install(TARGETS imgui_backend_${NAME}
            EXPORT imguiTargets
            ARCHIVE DESTINATION lib
            FILE_SET HEADERS DESTINATION include
    )
endfunction ()

if ("glfw_opengl2" IN_LIST SUPPORTED_BACKENDS)
    find_package(glfw3 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_opengl2.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_opengl2.cpp)
    set(TARGET_LIBS glfw OpenGL)

    add_backend("glfw_opengl2" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("glfw_opengl3" IN_LIST SUPPORTED_BACKENDS)
    find_package(glfw3 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS glfw OpenGL)

    add_backend("glfw_opengl3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("glfw_vulkan" IN_LIST SUPPORTED_BACKENDS)
    find_package(glfw3 REQUIRED)
    find_package(Vulkan REQUIRED)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_vulkan.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_vulkan.cpp)
    set(TARGET_LIBS glfw Vulkan::Vulkan)

    add_backend("glfw_vulkan" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl2_opengl2" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL2 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_opengl2.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_opengl2.cpp)
    set(TARGET_LIBS SDL2::SDL2 OpenGL)

    add_backend("sdl2_opengl2" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl2_opengl3" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL2 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_opengl2.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS SDL2::SDL2 OpenGL)

    add_backend("sdl2_opengl3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

install(EXPORT imguiTargets
        NAMESPACE imgui::
        DESTINATION share/cmake/imgui
)
