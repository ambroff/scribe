# -*- cmake -*-

# Copyright (C) 2009-2010, Linden Research, Inc.
# Copyright (C) 2011, Formspring, Inc.

# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation;
# version 2.1 of the License only.

# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

# Linden Research, Inc., 945 Battery Street, San Francisco, CA  94111  USA

find_package(PythonInterp REQUIRED)

set(Boost_USE_MULTITHREADED ON)
find_package(Boost 1.42.0 COMPONENTS unit_test_framework)

macro (TEST_COMMAND OUTVAR LD_LIBRARY_PATH)
  # nat wonders how Kitware can use the term 'function' for a construct that
  # cannot return a value. And yet, variables you set inside a FUNCTION are
  # local. Try a MACRO instead.
  set(value
      ${PYTHON_EXECUTABLE}
      "${CMAKE_SOURCE_DIR}/cmake/run_build_test.py")
  FOREACH(dir ${LD_LIBRARY_PATH})
    LIST(APPEND value "-l${dir}")
  ENDFOREACH(dir)
  LIST(APPEND value ${ARGN})
  set(${OUTVAR} ${value})
endmacro (TEST_COMMAND)

# Given a project name and a list of sourcefiles (with optional properties
# on each), add targets to build and run the tests specified.
#
# ASSUMPTIONS:
# * this macro is being executed in the project file that is passed in
# * current working SOURCE dir is that project dir
# * there is a subfolder tests/ with test code corresponding to the filenames
#   passed in
# * properties for each sourcefile passed in indicate what libs to link that
#   file with (MAKE NO ASSUMPTIONS ASIDE FROM TUT)
macro (add_project_unit_tests project sources)
  # Start with the header and project-wide setup before making targets
  #project(UNITTEST_PROJECT_${project})
  # Setup includes, paths, etc
  set(alltest_SOURCE_FILES "")

  # needed by the test harness itself
  set(alltest_DEP_TARGETS "")

  set(alltest_INCLUDE_DIRS
      ${Boost_INCLUDE_DIRS})

  set(alltest_LIBRARIES
      ${Boost_LIBRARIES})

  # Headers, for convenience in targets.
  set(alltest_HEADER_FILES "")

  # start the source test executable definitions
  set(${project}_TEST_OUTPUT "")
  FOREACH (source ${sources})
    STRING( REGEX REPLACE "(.*)\\.[^.]+$" "\\1" name ${source} )
    STRING( REGEX REPLACE ".*\\.([^.]+)$" "\\1" extension ${source} )

    #
    # Per-codefile additional / external source, header, and include dir
    # property extraction
    #
    # Source
    GET_SOURCE_FILE_PROPERTY(
        ${name}_test_additional_SOURCE_FILES
        ${source} TEST_ADDITIONAL_SOURCE_FILES)
    IF(${name}_test_additional_SOURCE_FILES MATCHES NOTFOUND)
      set(${name}_test_additional_SOURCE_FILES "")
    ENDIF(${name}_test_additional_SOURCE_FILES MATCHES NOTFOUND)
    set(${name}_test_SOURCE_FILES ${source}
        tests/${name}_tests.${extension}
        ${alltest_SOURCE_FILES}
        ${${name}_test_additional_SOURCE_FILES} )

    # Headers
    GET_SOURCE_FILE_PROPERTY(
        ${name}_test_additional_HEADER_FILES
        ${source}
        TEST_ADDITIONAL_HEADER_FILES)
    IF(${name}_test_additional_HEADER_FILES MATCHES NOTFOUND)
      set(${name}_test_additional_HEADER_FILES "")
    ENDIF(${name}_test_additional_HEADER_FILES MATCHES NOTFOUND)
    set(
        ${name}_test_HEADER_FILES
        ${name}.hpp
        ${${name}_test_additional_HEADER_FILES})
    set_source_files_properties(
        ${${name}_test_HEADER_FILES}
        PROPERTIES HEADER_FILE_ONLY TRUE)
    LIST(APPEND ${name}_test_SOURCE_FILES ${${name}_test_HEADER_FILES})

    # Include dirs
    GET_SOURCE_FILE_PROPERTY(
        ${name}_test_additional_INCLUDE_DIRS
        ${source}
        TEST_ADDITIONAL_INCLUDE_DIRS)
    IF(${name}_test_additional_INCLUDE_DIRS MATCHES NOTFOUND)
      set(${name}_test_additional_INCLUDE_DIRS "")
    ENDIF(${name}_test_additional_INCLUDE_DIRS MATCHES NOTFOUND)
    INCLUDE_DIRECTORIES(
        ${alltest_INCLUDE_DIRS} ${name}_test_additional_INCLUDE_DIRS)

    # Setup target
    ADD_EXECUTABLE(PROJECT_${project}_TEST_${name} ${${name}_test_SOURCE_FILES})

    set(PROJECT_${project_}_TEST_${name}_COMPILE_FLAGS
        "-DBOOST_TEST_MODULE=${name} -DBOOST_TEST_DYN_LINK=1")
    set_target_properties(
        PROJECT_${project}_TEST_${name}
        PROPERTIES
        COMPILE_FLAGS ${PROJECT_${project_}_TEST_${name}_COMPILE_FLAGS})

    #
    # Per-codefile additional / external project dep and lib dep property
    # extraction
    #
    # WARNING: it's REALLY IMPORTANT to not mix these. I guarantee it will not
    # work in the future. + poppy 2009-04-19

    # Projects
    GET_SOURCE_FILE_PROPERTY(
        ${name}_test_additional_PROJECTS ${source} TEST_ADDITIONAL_PROJECTS)
    IF(${name}_test_additional_PROJECTS MATCHES NOTFOUND)
      set(${name}_test_additional_PROJECTS "")
    ENDIF(${name}_test_additional_PROJECTS MATCHES NOTFOUND)

    # Libraries
    GET_SOURCE_FILE_PROPERTY(
        ${name}_test_additional_LIBRARIES ${source} TEST_ADDITIONAL_LIBRARIES)
    IF(${name}_test_additional_LIBRARIES MATCHES NOTFOUND)
      set(${name}_test_additional_LIBRARIES "")
    ENDIF(${name}_test_additional_LIBRARIES MATCHES NOTFOUND)

    # Add to project
    TARGET_LINK_LIBRARIES(
        PROJECT_${project}_TEST_${name}
        ${alltest_LIBRARIES}
        ${alltest_DEP_TARGETS}
        ${${name}_test_additional_PROJECTS}
        ${${name}_test_additional_LIBRARIES})

    #
    # Setup test targets
    #
    GET_TARGET_PROPERTY(TEST_EXE PROJECT_${project}_TEST_${name} LOCATION)
    set(TEST_OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/PROJECT_${project}_TEST_${name}_ok.txt)
    set(TEST_CMD ${TEST_EXE} > ${TEST_OUTPUT})

    TEST_COMMAND(TEST_SCRIPT_CMD "${LD_LIBRARY_PATH}" ${TEST_CMD})

    # Add test
    ADD_CUSTOM_COMMAND(
        OUTPUT ${TEST_OUTPUT}
        COMMAND ${TEST_SCRIPT_CMD}
        DEPENDS PROJECT_${project}_TEST_${name}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    LIST(APPEND ${project}_TEST_OUTPUT ${TEST_OUTPUT})
  ENDFOREACH (source)

  # Add the test runner target per-project
  # (replaces old _test_ok targets all over the place)
  ADD_CUSTOM_TARGET(${project}_tests ALL DEPENDS ${${project}_TEST_OUTPUT})
  ADD_DEPENDENCIES(${project} ${project}_tests)
endmacro (add_project_unit_tests project sources)
