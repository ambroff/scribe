# -*- cmake -*-

cmake_minimum_required(VERSION 2.8.0 FATAL_ERROR)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# This is the version of this application
set(SCRIBE_VERSION "3.0-dev")

# Common build stuff
add_subdirectory(cmake)

# Actual code for yermaum lives in here.
add_subdirectory(src)
