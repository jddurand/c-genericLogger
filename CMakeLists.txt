cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR)
project(genericLogger VERSION 1.0.52 LANGUAGES C)
#
# Get library helper
#
include(FetchContent)
FetchContent_Declare(cmake-helpers
  GIT_REPOSITORY https://github.com/jddurand/cmake-helpers.git
  GIT_SHALLOW TRUE
  GIT_REMOTE_UPDATE_STRATEGY CHECKOUT # We always want the latest version
)
FetchContent_MakeAvailable(cmake-helpers)
#
# Create library
#
cmake_helpers_library(genericLogger
  CONFIG_ARGS include/genericLogger/internal/config.h.in include/genericLogger/internal/config.h
)
#
# Create test executables
#
include(CTest)
cmake_helpers_exe(genericLoggerTester TEST TRUE SOURCES test/genericLoggerTester.c)
#
# Package
#
cmake_helpers_package()
