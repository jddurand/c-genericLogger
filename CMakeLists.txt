#
# Multi-config generator, e.g. Visual Studio on Windows:
#
# cmake -S c-genericLogger -B c-genericLogger-build
# cmake --build c-genericLogger-build --config RelWithDebInfo
# ctest --test-dir c-genericLogger-build -C RelWithDebInfo
# Windows:
#   cmake --install c-genericLogger-build --config RelWithDebInfo --prefix %cd%/c-genericLogger-install
# Others:
#   cmake --install c-genericLogger-build --config RelWithDebInfo --prefix `pwd`/c-genericLogger-install
# cmake --build c-genericLogger-build --config RelWithDebInfo --target package
#
# Single-config generator, e.g. NMake Makefiles on Windows, Unix Makefiles on Linxu:
#
# cmake -S c-genericLogger -B c-genericLogger-build -DCMAKE_BUILD_TYPE=RelWithDebInfo
# cmake --build c-genericLogger-build
# ctest --test-dir c-genericLogger-build
# Windows:
#   cmake --install c-genericLogger-build --prefix %cd%/c-genericLogger-install
# Others:
#   cmake --install c-genericLogger-build --prefix `pwd`/c-genericLogger-install
# cmake --build c-genericLogger-build --target package
#
cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR)
project(genericLogger VERSION 1.0.53 LANGUAGES C)
#
# Get library helper
#
include(FetchContent)
FetchContent_Declare(cmake-helpers GIT_REPOSITORY https://github.com/jddurand/cmake-helpers.git GIT_SHALLOW TRUE)
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
