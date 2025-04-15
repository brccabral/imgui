find_package(glfw3 QUIET)
if (glfw3_FOUND)
    message(STATUS "Found glfw3 ${glfw3_VERSION}")
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
    message(STATUS "Found SDL2 ${SDL2_VERSION}")
else ()
    message(WARNING "SDL2 not found")
endif ()

find_package(SDL3 QUIET)
if (SDL3_FOUND)
    message(STATUS "Found SDL3 ${SDL3_VERSION}")
else ()
    message(WARNING "SDL3 not found")
endif ()

find_package(Vulkan QUIET)
if (Vulkan_FOUND)
    message(STATUS "Found Vulkan ${Vulkan_VERSION}")
else ()
    message(WARNING "Vulkan not found")
endif ()

find_package(Allegro QUIET)
if (Allegro_FOUND)
    message(STATUS "Found Allegro ${Allegro_VERSION}")
else ()
    message(WARNING "Allegro not found")
endif ()

find_package(GLUT QUIET)
if (GLUT_FOUND)
    message(STATUS "Found GLUT ${PC_GLUT_VERSION}")
else ()
    message(WARNING "GLUT not found")
endif ()

if (EMSCRIPTEN)
    if (NOT EMSCRIPTEN_VERSION)
        message(FATAL_ERROR "EMSCRIPTEN_VERSION not found")
    endif ()
    if (EMSCRIPTEN_VERSION VERSION_LESS "3.1.43")
        message(FATAL_ERROR "ImGui requires Emscripten version >= 3.1.43, found ${EMSCRIPTEN_VERSION}")
    endif ()
    set(IMGUI_EMSCRIPTEN_FOUND ON)
    set(IMGUI_EMSCRIPTEN_FOUND ON PARENT_SCOPE)
    message(STATUS "Found emscripten ${EMSCRIPTEN_VERSION}")
else ()
    message(WARNING "emscripten not found. `cmake -DCMAKE_TOOLCHAIN_FILE=emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake`")
endif ()

if (IMGUI_DAWN_DIR)
    if (EXISTS ${IMGUI_DAWN_DIR}/CMakeLists.txt)
        find_package(VulkanUtilityLibraries QUIET)
        if (VulkanUtilityLibraries_FOUND)
            message(STATUS "Found VulkanUtilityLibraries_FOUND")
        else ()
            message(FATAL_ERROR "VulkanUtilityLibraries is a dependency of Dawn. The version fetched by Dawn is not compatible. `sudo apt install vulkan-utility-libraries-dev`")
        endif ()

        # Dawn wgpu desktop
        set(DAWN_FETCH_DEPENDENCIES ON)

        option(DAWN_FETCH_DEPENDENCIES "Use fetch_dawn_dependencies.py as an alternative to using depot_tools" ON)

        # Dawn builds many things by default - disable things we don't need
        option(DAWN_BUILD_SAMPLES "Enables building Dawn's samples" OFF)
        option(TINT_BUILD_CMD_TOOLS "Build the Tint command line tools" OFF)
        option(TINT_BUILD_DOCS "Build documentation" OFF)
        option(TINT_BUILD_TESTS "Build tests" OFF)
        if (NOT APPLE)
            option(TINT_BUILD_MSL_WRITER "Build the MSL output writer" OFF)
        endif()
        if(WIN32)
            option(TINT_BUILD_SPV_READER "Build the SPIR-V input reader" OFF)
            option(TINT_BUILD_WGSL_READER "Build the WGSL input reader" ON)
            option(TINT_BUILD_GLSL_WRITER "Build the GLSL output writer" OFF)
            option(TINT_BUILD_GLSL_VALIDATOR "Build the GLSL output validator" OFF)
            option(TINT_BUILD_SPV_WRITER "Build the SPIR-V output writer" OFF)
            option(TINT_BUILD_WGSL_WRITER "Build the WGSL output writer" ON)
        endif()

        add_subdirectory("${IMGUI_DAWN_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/dawn" EXCLUDE_FROM_ALL)

        set(IMGUI_DAWN_FOUND ON)
        set(IMGUI_DAWN_FOUND ON PARENT_SCOPE)
        message(STATUS "Found dawn")
    else ()
        message(FATAL_ERROR "IMGUI_DAWN_DIR defined but could not find CMakeLists.txt in ${IMGUI_DAWN_DIR}")
    endif ()
else ()
    message(WARNING "dawn not found.")
endif ()

if (ANDROID_NDK)
    message(STATUS "Found ANDROID_NDK ${CMAKE_ANDROID_NDK_VERSION} at ${ANDROID_NDK}.")
else ()
    message(WARNING "ANDROID_NDK not provided. `cmake -DCMAKE_TOOLCHAIN_FILE=android-ndk/build/cmake/android.toolchain.cmake ...`")
endif ()

set(FOUND_BACKENDS "")
if (glfw3_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_opengl2" "glfw_opengl3")
endif ()
if (glfw3_FOUND AND Vulkan_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_vulkan")
endif ()
if (SDL2_FOUND)
    list(APPEND FOUND_BACKENDS "sdl2_sdlrenderer2")
endif ()
if (SDL2_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "sdl2_opengl2" "sdl2_opengl3")
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
if (Allegro_FOUND)
    list(APPEND FOUND_BACKENDS "allegro5")
endif ()
if (GLUT_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "glut_opengl2")
endif ()
if (IMGUI_EMSCRIPTEN_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_wgpu_emscripten")
endif ()
if (IMGUI_DAWN_FOUND AND glfw3_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_wgpu_dawn")
endif ()
if (IMGUI_EMSCRIPTEN_FOUND AND glfw3_FOUND AND OpenGL_FOUND)
    list(APPEND FOUND_BACKENDS "glfw_web_opengl3")
endif ()
if (ANDROID_NDK)
    list(APPEND FOUND_BACKENDS "android_opengl3")
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

if ("sdl3_sdlrenderer3" IN_LIST SUPPORTED_BACKENDS)
    find_package(SDL3 REQUIRED)

    set(HEADER_FILES imgui_impl_sdl3.h imgui_impl_sdlrenderer3.h)
    set(CPP_FILES imgui_impl_sdl3.cpp imgui_impl_sdlrenderer3.cpp)
    set(TARGET_LIBS SDL3::SDL3)

    add_backend("sdl3_sdlrenderer3" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")
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
    set(TARGET_LIBS glfw)

    add_backend("glfw_wgpu_emscripten" "${HEADER_FILES}" "${CPP_FILES}" "${TARGET_LIBS}")

    if(EMSCRIPTEN_VERSION VERSION_GREATER_EQUAL "3.1.57")
        set(IMGUI_EMSCRIPTEN_GLFW3 "--use-port=contrib.glfw3" CACHE STRING "Choose between --use-port=contrib.glfw3 and -sUSE_GLFW=3 for GLFW implementation (default to --use-port=contrib.glfw3)")
    else()
        # cannot use contrib.glfw3 prior to 3.1.57
        set(IMGUI_EMSCRIPTEN_GLFW3 "-sUSE_GLFW=3" CACHE STRING "Use -sUSE_GLFW=3 for GLFW implementation" FORCE)
    endif()
    if("${IMGUI_EMSCRIPTEN_GLFW3}" STREQUAL "--use-port=contrib.glfw3")
        target_compile_options(imgui_backend_glfw_wgpu_emscripten
            PUBLIC "${IMGUI_EMSCRIPTEN_GLFW3}"
        )
    endif()

    target_compile_options(imgui_backend_glfw_wgpu_emscripten PUBLIC -sDISABLE_EXCEPTION_CATCHING=1 -DIMGUI_DISABLE_FILE_FUNCTIONS=1)

    target_link_options(imgui_backend_glfw_wgpu_emscripten
        PUBLIC
        "-sUSE_WEBGPU=1"
        "${IMGUI_EMSCRIPTEN_GLFW3}"
        "-sWASM=1"
        "-sALLOW_MEMORY_GROWTH=1"
        "-sNO_EXIT_RUNTIME=0"
        "-sASSERTIONS=1"
        "-sDISABLE_EXCEPTION_CATCHING=1"
        "-sNO_FILESYSTEM=1"
    )

endif ()

if ("glfw_wgpu_dawn" IN_LIST SUPPORTED_BACKENDS)
    add_library(imgui_backend_glfw_wgpu_dawn STATIC)
    add_library(imgui::backend_glfw_wgpu_dawn ALIAS imgui_backend_glfw_wgpu_dawn)

    target_compile_features(imgui_backend_glfw_wgpu_dawn PRIVATE cxx_std_17)

    target_sources(imgui_backend_glfw_wgpu_dawn
        PUBLIC FILE_SET HEADERS FILES imgui_impl_glfw.h imgui_impl_wgpu.h
        PRIVATE imgui_impl_glfw.cpp imgui_impl_wgpu.cpp
    )

    target_compile_definitions(imgui_backend_glfw_wgpu_dawn PUBLIC "IMGUI_IMPL_WEBGPU_BACKEND_DAWN")

    target_link_libraries(imgui_backend_glfw_wgpu_dawn PUBLIC imgui::imgui webgpu_dawn webgpu_cpp webgpu_glfw glfw)
endif ()

if ("android_opengl3" IN_LIST SUPPORTED_BACKENDS)
    set(HEADER_FILES imgui_impl_android.h imgui_impl_opengl3.h)
    set(CPP_FILES imgui_impl_android.cpp imgui_impl_opengl3.cpp)
    set(TARGET_LIBS android EGL GLESv3 log)

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

install(EXPORT imguiTargets
        NAMESPACE imgui::
        DESTINATION share/cmake/imgui
)
