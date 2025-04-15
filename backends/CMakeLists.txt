include(cmake/FindPackages.cmake)
include(cmake/ListBackends.cmake)
include(cmake/ConfigureBackends.cmake)

install(EXPORT imguiTargets
        NAMESPACE imgui::
        DESTINATION share/cmake/imgui
)
