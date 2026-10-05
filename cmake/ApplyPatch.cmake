# Apply a patch to a FetchContent source tree (used as PATCH_COMMAND).
# Skips the patch if it is already applied, so re-configuring is safe.
#
# Usage:
#   cmake -DGIT_EXECUTABLE=<git> -DPATCH_FILE=<file.patch> -P ApplyPatch.cmake
# The working directory must be the source tree to patch.

execute_process(COMMAND ${GIT_EXECUTABLE} apply --reverse --check ${PATCH_FILE}
                RESULT_VARIABLE already_applied OUTPUT_QUIET ERROR_QUIET)
if(already_applied EQUAL 0)
    message(STATUS "Patch already applied: ${PATCH_FILE}")
    return()
endif()

execute_process(COMMAND ${GIT_EXECUTABLE} apply ${PATCH_FILE} RESULT_VARIABLE res)
if(NOT res EQUAL 0)
    message(FATAL_ERROR "Failed to apply patch ${PATCH_FILE}")
endif()
message(STATUS "Applied patch: ${PATCH_FILE}")
