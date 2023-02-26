#[=======================================================================[.rst:
FindJack
-------

Finds the Jack library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Jack::libJack``
  The Jack library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Jack_FOUND``
  True if the system has the Jack library.

#]=======================================================================]

# Use pkg-config if available
find_package(PkgConfig QUIET)
pkg_check_modules(PC_JACK QUIET jack)

# Find the headers and library
find_path(
  Jack_INCLUDE_DIR
  NAMES "jack/jack.h"
  PATHS "${PC_JACK_INCLUDEDIR}")

find_library(
  Jack_LIBRARY
  NAMES "jack"
  PATHS "${PC_JACK_LIBDIR}")

# Handle transitive dependencies
if(PC_JACK_FOUND)
  get_linker_flags_from_pkg_config("${Jack_LIBRARY}" "PC_JACK"
                                   "_jack_link_libraries")
else()
  set(_jack_link_libraries "Threads::Threads")
endif()

# Forward the result to CMake
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Jack REQUIRED_VARS "Jack_LIBRARY"
                                                     "Jack_INCLUDE_DIR")

# Create the target
if(Jack_FOUND AND NOT TARGET Jack::Jack)
  add_library(Jack::Jack UNKNOWN IMPORTED)
  set_target_properties(
    Jack::Jack
    PROPERTIES IMPORTED_LOCATION "${Jack_LIBRARY}"
               INTERFACE_COMPILE_OPTIONS "${PC_JACK_CFLAGS_OTHER}"
               INTERFACE_INCLUDE_DIRECTORIES "${Jack_INCLUDE_DIR}"
               INTERFACE_LINK_LIBRARIES "${_jack_link_libraries}")
endif()

mark_as_advanced(Jack_INCLUDE_DIR Jack_LIBRARY)
