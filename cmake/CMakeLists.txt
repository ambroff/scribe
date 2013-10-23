# -*- cmake -*-

project(cmake)

set(cmake_SOURCE_FILES
  ../CMakeLists.txt
  ../configure.py

  CMakeLists.txt

  Common.cmake
  FindThrift.cmake
  LintelFind.cmake
  UnitTesting.cmake
  Utils.cmake)

source_group("Shared CMake Macros" FILES ${cmake_SOURCE_FILES})

set_source_files_properties(
  ${cmake_SOURCE_FILES} PROPERTIES HEADER_FILE_ONLY TRUE)

# Add a dummy file. Yes, this is a big fat hack.
add_executable(dummy dummy.cpp ${cmake_SOURCE_FILES})
