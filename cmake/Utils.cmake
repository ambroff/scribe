# -*- cmake -*-
#
# Miscellaneous utility macros

# configure_files - macro to simplify calling configure_file on source files
#
# arguments:
#   GENERATED FILES - variable to hold a list of generated files
#   FILES           - names of files to be configured.
macro(configure_files GENERATED_FILES)
  set(_files_to_add "")
  foreach (_template_file ${ARGV})
    if (NOT "${GENERATED_FILES}" STREQUAL "${_template_file}")
      configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/${_template_file}.in
        ${CMAKE_CURRENT_BINARY_DIR}/${_template_file}
        @ONLY
        )
      set(_files_to_add
          ${_files_to_add}
          ${CMAKE_CURRENT_BINARY_DIR}/${_template_file}
          )
    endif (NOT "${GENERATED_FILES}" STREQUAL "${_template_file}")
  endforeach(_template_file)
  set(${GENERATED_FILES} ${_files_to_add})
endmacro(configure_files)
