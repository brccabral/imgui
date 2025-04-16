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

function (add_emscripten_flags TARGET USE_RENDER_FLAG USE_FILESYSTEM)

    target_compile_options(${TARGET}
        PUBLIC
        -sDISABLE_EXCEPTION_CATCHING=1
        -Os
    )

    target_compile_options(${TARGET} PUBLIC ${USE_RENDER_FLAG})
    target_link_options(${TARGET} PUBLIC ${USE_RENDER_FLAG})

    target_link_options(${TARGET}
        PUBLIC
        "${IMGUI_EMSCRIPTEN_GLFW3}"
        "-sWASM=1"
        "-sALLOW_MEMORY_GROWTH=1"
        "-sNO_EXIT_RUNTIME=0"
        "-sASSERTIONS=1"
        "-sDISABLE_EXCEPTION_CATCHING=1"
    )

    if (USE_FILESYSTEM)
        target_link_options(${TARGET}
            PUBLIC
            "--no-heap-copy"
            "--preload-file"
            "${PROJECT_SOURCE_DIR}/misc/fonts@/fonts"
        )
    else ()
        target_compile_options(${TARGET}
            PUBLIC
            -DIMGUI_DISABLE_FILE_FUNCTIONS
        )
        target_link_options(${TARGET}
            PUBLIC
            "-sNO_FILESYSTEM=1"
        )
    endif ()
endfunction()

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

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS SDL2::SDL2 OpenGL)

    add_backend("sdl2_opengl3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl2_sdlrenderer2" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL2 REQUIRED)

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_sdlrenderer2.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_sdlrenderer2.cpp)
    set(TARGET_LIBS SDL2::SDL2)

    add_backend("sdl2_sdlrenderer2" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl2_vulkan" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL2 REQUIRED)
    find_package(Vulkan REQUIRED)

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_vulkan.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_vulkan.cpp)
    set(TARGET_LIBS SDL2::SDL2 Vulkan::Vulkan)

    add_backend("sdl2_vulkan" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl3_opengl3" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL3 REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS SDL3::SDL3 OpenGL)

    add_backend("sdl3_opengl3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl3_sdlrenderer3" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL3 REQUIRED)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_sdlrenderer3.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_sdlrenderer3.cpp)
    set(TARGET_LIBS SDL3::SDL3)

    add_backend("sdl3_sdlrenderer3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl3_sdlgpu3" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL3 REQUIRED)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_sdlgpu3.h imgui_impl_sdlgpu3_shaders.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_sdlgpu3.cpp)
    set(TARGET_LIBS SDL3::SDL3)

    add_backend("sdl3_sdlgpu3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("sdl3_vulkan" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL3 REQUIRED)
    find_package(Vulkan REQUIRED)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_vulkan.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_vulkan.cpp)
    set(TARGET_LIBS SDL3::SDL3 Vulkan::Vulkan)

    add_backend("sdl3_vulkan" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("glut_opengl2" IN_LIST SUPPORTED_BACKENDS)
    find_package(GLUT REQUIRED)
    find_package(OpenGL REQUIRED)

    set(HEADER_FILES imgui_impl_glut.h imgui_impl_opengl2.h)
    set(CPP_FILES imgui_impl_glut.cpp imgui_impl_opengl2.cpp)
    set(TARGET_LIBS glut OpenGL)

    add_backend("glut_opengl2" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
endif ()

if ("allegro5" IN_LIST SUPPORTED_BACKENDS)
#    Allegro needs a config.h file, which is not compiled in imgui::imgui
#    We add a new library in the `example_allegro5`
endif ()

if ("glfw_wgpu_emscripten" IN_LIST SUPPORTED_BACKENDS)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_wgpu.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_wgpu.cpp)
    set(TARGET_LIBS "")

    if(EMSCRIPTEN_VERSION VERSION_GREATER_EQUAL "3.1.57")
        set(USE_RENDER_FLAG "--use-port=contrib.glfw3")
    else()
        # cannot use contrib.glfw3 prior to 3.1.57
        set(USE_RENDER_FLAG -s USE_GLFW=3)
    endif()
    set(USE_RENDER_FLAG "${USE_RENDER_FLAG}" -sUSE_WEBGPU=1)

    add_backend("glfw_wgpu_emscripten" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
    add_emscripten_flags(imgui_backend_glfw_wgpu_emscripten "${USE_RENDER_FLAG}" 0)
endif ()

if ("glfw_opengl3_emscripten" IN_LIST SUPPORTED_BACKENDS)

    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS "")

    if(EMSCRIPTEN_VERSION VERSION_GREATER_EQUAL "3.1.57")
        set(USE_RENDER_FLAG "--use-port=contrib.glfw3")
    else()
        # cannot use contrib.glfw3 prior to 3.1.57
        set(USE_RENDER_FLAG "-sUSE_GLFW=3")
    endif()

    add_backend("glfw_opengl3_emscripten" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
    add_emscripten_flags(imgui_backend_glfw_opengl3_emscripten "${USE_RENDER_FLAG}" 0)
endif ()

if ("sdl2_opengl3_emscripten" IN_LIST SUPPORTED_BACKENDS)

    set(HEADER_FILES imgui_impl_sdl2.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_sdl2.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS "")

    set(USE_RENDER_FLAG "-sUSE_SDL=2")

    add_backend("sdl2_opengl3_emscripten" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
    add_emscripten_flags(imgui_backend_sdl2_opengl3_emscripten "${USE_RENDER_FLAG}" 1)
endif ()

if ("sdl3_opengl3_emscripten" IN_LIST SUPPORTED_BACKENDS)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS "")

    set(USE_RENDER_FLAG "-sUSE_SDL=3")

    add_backend("sdl3_opengl3_emscripten" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
    add_emscripten_flags(imgui_backend_sdl3_opengl3_emscripten "${USE_RENDER_FLAG}" 1)
endif ()

if ("glfw_wgpu_dawn" IN_LIST SUPPORTED_BACKENDS)
    set(HEADER_FILES imgui_impl_glfw.h imgui_impl_wgpu.h)
    set(CPP_FILES imgui_impl_glfw.cpp imgui_impl_wgpu.cpp)
    set(TARGET_LIBS webgpu_dawn webgpu_cpp webgpu_glfw glfw)

    add_backend("glfw_wgpu_dawn" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")

    target_compile_features(imgui_backend_glfw_wgpu_dawn PRIVATE cxx_std_17)
    target_compile_definitions(imgui_backend_glfw_wgpu_dawn PUBLIC "IMGUI_IMPL_WEBGPU_BACKEND_DAWN")
endif ()

if ("android_opengl3" IN_LIST SUPPORTED_BACKENDS)
    set(HEADER_FILES imgui_impl_android.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_android.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS android EGL GLESv3 log)

    # android_opengl3 is a SHARED lib, can't use `add_backend`
    add_library(imgui_backend_android_opengl3 SHARED)
    add_library(imgui::backend_android_opengl3 ALIAS imgui_backend_android_opengl3)

    target_link_options(imgui_backend_android_opengl3 PUBLIC "-uANativeActivity_onCreate")

    target_compile_features(imgui_backend_android_opengl3 PRIVATE cxx_std_11)

    # ImGui sources
    target_sources(imgui_backend_android_opengl3
    PUBLIC
            FILE_SET HEADERS FILES ${HEADER_FILES}
    PRIVATE ${CPP_FILES}
    )

    target_compile_definitions(imgui_backend_android_opengl3 PUBLIC IMGUI_IMPL_OPENGL_ES3)

    target_include_directories(imgui_backend_android_opengl3 PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
    )

    target_link_libraries(imgui_backend_android_opengl3 PUBLIC imgui::imgui)
    target_link_libraries(imgui_backend_android_opengl3 PUBLIC ${TARGET_LIBS})

    install(TARGETS imgui_backend_android_opengl3
            EXPORT imguiTargets
            ARCHIVE DESTINATION lib
            FILE_SET HEADERS DESTINATION include
    )
endif ()
