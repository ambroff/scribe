# -*- cmake -*-

include(Common)
include(Utils)
include(UnitTesting)

project(scribed)

set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)
find_package(
  Boost 1.53.0
  COMPONENTS system filesystem
  REQUIRED
  )

find_package(Thrift)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
  ${Boost_INCLUDE_DIRS}
  )

set(scribed_HEADER_FILES
  CMakeLists.txt

  common.h
  conf.h
  conn_pool.h
  dynamic_bucket_updater.h
  env_default.h
  file.h
  HdfsFile.h
  network_dynamic_config.h
  scribe_server.h
  store.h
  store_queue.h
  )

set(scribed_SOURCE_FILES
  conf.cpp
  conn_pool.cpp
  dynamic_bucket_updater.cpp
  env_default.cpp
  file.cpp
  HdfsFile.cpp
  network_dynamic_config.cpp
  scribe_server.cpp
  store.cpp
  store_queue.cpp
  )

set_source_files_properties(
  ${scribed_HEADER_FILES}
  PROPERTIES HEADER_FILE_ONLY TRUE
  )
list(
  APPEND
  scribed_SOURCE_FILES
  ${scribed_HEADER_FILES}
  )

configure_files(
  scribed_GENERATED_HEADER_FILES
  version.h
  )
set_source_files_properties(
  ${scribed_GENERATED_HEADER_FILES}
  PROPERTIES HEADER_FILE_ONLY TRUE
  )
list(
  APPEND
  scribed_SOURCE_FILES
  ${scribed_GENERATED_HEADER_FILES}
  )

add_executable(scribed ${scribed_SOURCE_FILES})

target_link_libraries(
  scribed
  ${Boost_LIBRARIES}
  ${COMMON_LIBRARIES}
  )

# Unit tests
set(scribed_UNIT_TEST_FILES
  )
add_project_unit_tests(
  scribed
  "${scribed_UNIT_TEST_FILES}"
  )
