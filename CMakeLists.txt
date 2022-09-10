cmake_minimum_required(VERSION 3.19)
project(gm82joy C)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

if(${CMAKE_C_COMPILER_ID} STREQUAL "MSVC")
    set(CMAKE_C_FLAGS "/O2 /GS- /W2 /WX")
endif()

add_library(gm82joy SHARED gm82joy.c)

target_link_libraries(gm82joy "${PROJECT_SOURCE_DIR}/lib/x86/SDL2.lib")

option(INSTALL_GEX "Install the generated .gex" OFF)

if (INSTALL_GEX)
	add_custom_command(
		TARGET gm82joy
		POST_BUILD
		COMMAND py build_gex.py gm82joy.gej
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		COMMENT "Building .gex"
	)
else()
	add_custom_command(
		TARGET gm82joy
		POST_BUILD
		COMMAND py build_gex.py gm82joy.gej --noinstall
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		COMMENT "Building .gex"
	)
endif()