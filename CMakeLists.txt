cmake_minimum_required (VERSION 3.21...3.31)

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message (FATAL_ERROR
        "In-source builds are not allowed. "
        "Use the top-level Makefile or specify a build directory: "
        "cmake --preset release")
endif ()

project (dbt7 VERSION 0.7.9 LANGUAGES NONE)

# Mark a build that is not a release: with the commit it came from when
# that commit is not tagged, and as dirty when the tree has uncommitted
# changes.  A source tree with no git metadata, such as an unpacked
# release tarball, keeps the version set above.
find_package (Git QUIET)
if (GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
    execute_process (
        COMMAND ${GIT_EXECUTABLE} tag --points-at HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_TAGS
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )

    if (NOT GIT_TAGS)
        execute_process (
            COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_SHA1
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )
        if (GIT_SHA1)
            set (PROJECT_VERSION "${PROJECT_VERSION}-${GIT_SHA1}")
        endif ()
    endif ()

    # Refresh the stat information recorded in the index first:
    # diff-index trusts it, so a tree whose files were merely touched or
    # copied anew would otherwise read as dirty.  git describe --dirty
    # does the same refresh before its own diff-index.
    execute_process (
        COMMAND ${GIT_EXECUTABLE} update-index -q --refresh
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        ERROR_QUIET
    )

    # diff-index reports 1 when tracked files differ from HEAD, which is
    # the test that git describe --dirty makes.  Anything else is a
    # failure to read the repository at all, such as a checkout whose
    # git directory is not reachable, and says nothing about the state
    # of the tree.
    execute_process (
        COMMAND ${GIT_EXECUTABLE} diff-index --quiet HEAD --
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        RESULT_VARIABLE GIT_DIFF_STATUS
        ERROR_QUIET
    )
    if (GIT_DIFF_STATUS EQUAL 1)
        set (PROJECT_VERSION "${PROJECT_VERSION}-dirty")
    endif ()
endif ()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set (SHELLOPTIONS "set -x")
endif ()

set (
    HOMEPAGE
    "Database Test 7 (DBT-7) project page: https://github.com/osdldbt/dbt7"
)

include (FetchContent)
# The dsgen patch series expects the tree to be in a directory named
# "dsgen", per the layout of this repository, so do not use the
# default FetchContent source directory naming.
# The dsgen git submodule in the source tree is for developers and the
# manual build documented in the user's guide; this separate clone
# keeps the source tree pristine during automated builds.
FetchContent_Declare(
    dsgen
    GIT_REPOSITORY https://github.com/osdldbt/dsgen.git
    GIT_TAG        4.0.0
    GIT_SHALLOW    TRUE
    SOURCE_DIR     ${CMAKE_BINARY_DIR}/dsgen
)
FetchContent_MakeAvailable (dsgen)
set (DSGEN_SOURCE_DIR ${dsgen_SOURCE_DIR})

# Included rather than added as a subdirectory so the appimage target
# runs in, and appimagetool writes the AppImage to, the top of the
# build directory.
include (appimage/CMakeLists.txt)
add_subdirectory (man)
add_subdirectory (patches)
add_subdirectory (scripts)

enable_testing ()
add_subdirectory (tests)

# CPack rules for creating distribution files.

set (CPACK_SOURCE_GENERATOR "TBZ2;TXZ;ZIP")
set (
    CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "database test 7"
)
set (CPACK_PACKAGE_VENDOR "osdl")
set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/README")
set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYING")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")

set (
    CPACK_SOURCE_IGNORE_FILES
    "\\\\.bz2\\$"
    "\\\\.gz\\$"
    "\\\\.xz\\$"
    "\\\\.Z\\$"
    "\\\\.zip\\$"
    "~$"
    "/\\\\.git"
    "/CMakeCache\\\\.txt\\$"
    "/CMakeFiles/"
    "/cmake_install\\\\.cmake\\$"
    "/CPackConfig\\\\.cmake\\$"
    "/\\\\.gitignore\\$"
    "/\\\\_CPack\\\\_Packages/"
    "/CPackSourceConfig\\\\.cmake\\$"
    "/Makefile.package$"
    "/dsgen/"
    "/doc/html/"
    "/doc/pdf/"
)

include (CPack)
