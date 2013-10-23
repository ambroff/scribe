# -*- cmake -*-

# Handy platform flags
if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(LINUX ON BOOL FORCE)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set (DARWIN ON BOOL FORCE)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

# Only need DEBUG and RELEASE IMO
set(
  CMAKE_CONFIGURATION_TYPES "Release;Debug" CACHE STRING
  "Supported build types." FORCE)

if (LINUX OR DARWIN)
  if (FORCE_USE_CLANG)
	set(CXX11_OPTS "-std=c++11 -stdlib=libc++")
  else (FORCE_USE_CLANG)
	set(CXX11_OPTS "-std=c++11")
  endif (FORCE_USE_CLANG)

  set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -DDEBUG=1 ${CXX11_OPTS}")
  set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG=1 ${CXX11_OPTS}")

  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")

  # MOAR WARNINGS!
  set(GCC_WARNINGS "-Wall -Werror")

  set(CMAKE_CXX_FLAGS "${GCC_WARNINGS}")

  set(COMMON_LIBRARIES pthread)

  add_definitions(
    -D_REENTRANT
    -pthread
    )

  if (DARWIN)
	add_definitions(
      -D_FORTIFY_SOURCE
	  )
  else (DARWIN)
	list(APPEND COMMON_LIBRARIES rt)
  endif (DARWIN)

  include_directories(${CMAKE_SOURCE_DIR})
else (LINUX OR DARWIN)
  message(FATAL_ERROR "This platform isn't supported.")
endif (LINUX OR DARWIN)
