set(SUPPORTED_BACKENDS "glfw_opengl2")
set(BACKEND "glfw_opengl2" CACHE STRING "Choose one of: ${SUPPORTED_BACKENDS}")
set_property(CACHE BACKEND PROPERTY STRINGS ${SUPPORTED_BACKENDS})

if (NOT BACKEND IN_LIST SUPPORTED_BACKENDS)
    message(FATAL_ERROR "Invalid backend ${BACKEND}. Supported values ${SUPPORTED_BACKENDS}")
endif ()
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
