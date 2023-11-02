MACRO (MYPACKAGEDEPENDENCY packageDepend packageDependSourceDir)
  #
  # Optional argument:
  # - Dependency localisation:
  #   + LOCAL     : Dependency source is local - default is false
  #
  # - Candidates:
  #   + ALL       : Sets TESTS, LIBS, IFACE and EXES - default is true
  #   + TESTS     : Lookup current project test executables - defaut is false
  #   + LIBS      : Lookup current project libraries - defaut is false
  #   + IFACE     : Lookup current project interface - defaut is false
  #   + EXES      : Lookup current project executables - defaut is false
  #
  # - Transitive usage requirements:
  #   + PUBLIC         : Forces scope to PUBLIC - default is true
  #   + INTERFACE      : Forces scope to INTERFACE - default is false
  #   + PRIVATE        : Forces scope to PRIVATE - default is false
  #
  # - Dependency source
  #   + IFACE_OBJECTS  : Adds interface of dependency - default is true
  #   + STATIC_OBJECTS : Adds static objects (if any) of dependency - default is false
  #   + SHARED_OBJECTS : Adds shared objects (if any) of dependency - default is false
  #   + STATIC_LIB     : Adds static library (if any) of dependency - default is false
  #   + SHARED_LIB     : Adds shared library (if any) of dependency - default is false
  #
  # Note that when we inspect our targets and find an INTERFACE_LIBRARY, then scope if forced to INTERFACE.
  #
  SET (_TESTS FALSE)
  SET (_LIBS FALSE)
  SET (_IFACE FALSE)
  SET (_EXES FALSE)
  SET (_ALL TRUE)
  SET (_LOCAL FALSE)
  SET (_PUBLIC TRUE)
  SET (_INTERFACE FALSE)
  SET (_PRIVATE FALSE)
  SET (_IFACE_OBJECTS TRUE)
  SET (_STATIC_OBJECTS FALSE)
  SET (_SHARED_OBJECTS FALSE)
  SET (_STATIC_LIB FALSE)
  SET (_SHARED_LIB FALSE)
  FOREACH (_var ${ARGN})
    IF (${_var} STREQUAL TESTS)
      SET (_ALL FALSE)
      SET (_TESTS TRUE)
    ENDIF ()
    IF (${_var} STREQUAL LIBS)
      SET (_ALL FALSE)
      SET (_LIBS TRUE)
    ENDIF ()
    IF (${_var} STREQUAL IFACE)
      SET (_ALL FALSE)
      SET (_IFACE TRUE)
    ENDIF ()
    IF (${_var} STREQUAL EXES)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} executables scope argument")
      ENDIF ()
      SET (_ALL FALSE)
      SET (_EXES TRUE)
    ENDIF ()
    IF (${_var} STREQUAL ALL)
      SET (_ALL TRUE)
    ENDIF ()
    IF (${_var} STREQUAL LOCAL)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} local mode")
      ENDIF ()
      SET (_LOCAL TRUE)
    ENDIF ()
    IF (${_var} STREQUAL INTERFACE)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} interface transitivity")
      ENDIF ()
      SET (_INTERFACE TRUE)
      SET (_PUBLIC FALSE)
      SET (_PRIVATE FALSE)
    ENDIF ()
    IF (${_var} STREQUAL PUBLIC)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} private transitivity")
      ENDIF ()
      SET (_INTERFACE FALSE)
      SET (_PUBLIC TRUE)
      SET (_PRIVATE FALSE)
    ENDIF ()
    IF (${_var} STREQUAL PRIVATE)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} private transitivity")
      ENDIF ()
      SET (_INTERFACE FALSE)
      SET (_PUBLIC FALSE)
      SET (_PRIVATE TRUE)
    ENDIF ()
    IF (${_var} STREQUAL IFACE_OBJECTS)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} interface \"objects\" inclusion")
      ENDIF ()
      SET (_IFACE_OBJECTS TRUE)
      SET (_STATIC_OBJECTS FALSE)
      SET (_SHARED_OBJECTS FALSE)
      SET (_STATIC_LIB FALSE)
      SET (_SHARED_LIB FALSE)
    ENDIF ()
    IF (${_var} STREQUAL STATIC_OBJECTS)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} static objects inclusion")
      ENDIF ()
      SET (_IFACE_OBJECTS FALSE)
      SET (_STATIC_OBJECTS TRUE)
      SET (_SHARED_OBJECTS FALSE)
      SET (_STATIC_LIB FALSE)
      SET (_SHARED_LIB FALSE)
    ENDIF ()
    IF (${_var} STREQUAL SHARED_OBJECTS)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} shared objects inclusion")
      ENDIF ()
      SET (_IFACE_OBJECTS FALSE)
      SET (_STATIC_OBJECTS FALSE)
      SET (_SHARED_OBJECTS TRUE)
      SET (_STATIC_LIB FALSE)
      SET (_SHARED_LIB FALSE)
    ENDIF ()
    IF (${_var} STREQUAL STATIC_LIB)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} static library inclusion")
      ENDIF ()
      SET (_IFACE_OBJECTS FALSE)
      SET (_STATIC_OBJECTS FALSE)
      SET (_SHARED_OBJECTS FALSE)
      SET (_STATIC_LIB TRUE)
      SET (_SHARED_LIB FALSE)
    ENDIF ()
    IF (${_var} STREQUAL SHARED_LIB)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} static library inclusion")
      ENDIF ()
      SET (_IFACE_OBJECTS FALSE)
      SET (_STATIC_OBJECTS FALSE)
      SET (_SHARED_OBJECTS FALSE)
      SET (_STATIC_LIB FALSE)
      SET (_SHARED_LIB TRUE)
    ENDIF ()
  ENDFOREACH ()
  IF (_ALL)
    SET (_TESTS TRUE)
    SET (_LIBS TRUE)
    SET (_IFACE TRUE)
    SET (_EXES TRUE)
  ENDIF ()
  IF (MYPACKAGE_DEBUG)
    MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} dependency check with: ALL=${_ALL} TEST=${_TESTS} LIBS=${_LIBS} EXES=${_EXES} LOCAL=${_LOCAL} PUBLIC=${_PUBLIC} PRIVATE=${_PRIVATE} INTERFACE=${_INTERFACE}")
  ENDIF ()
  #
  # Check if inclusion was already done - via us or another mechanism... guessed with TARGET check
  #
  GET_PROPERTY(_packageDepend_set GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend} SET)
  IF (${_packageDepend_set})
    GET_PROPERTY(_packageDepend GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend})
  ELSE ()
    SET (_packageDepend "")
  ENDIF ()
  IF ((NOT ("${_packageDepend}" STREQUAL "")) OR (TARGET ${packageDepend}))
    IF (${_packageDepend_set})
      IF (${_packageDepend} STREQUAL "PENDING")
        IF (MYPACKAGE_DEBUG)
          MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} is already being processed")
        ENDIF ()
      ELSE ()
        IF (${_packageDepend} STREQUAL "DONE")
          GET_PROPERTY(_packageDepend_version GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION)
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} is already available, version ${_packageDepend_version}")
          ENDIF ()
        ELSE ()
          MESSAGE (FATAL_ERROR "[${PROJECT_NAME}-DEPEND-STATUS] ${packageDepend} state is ${_packageDepend}, should be DONE or PENDING")
        ENDIF ()
      ENDIF ()
    ELSE ()
      # MESSAGE (WARNING "[${PROJECT_NAME}-DEPEND-WARNING] Target ${packageDepend} already exist - use MyPackageDependency to avoid this warning")
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend} to DONE")
      ENDIF ()
      SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend} "DONE")
    ENDIF ()
  ELSE ()
    IF (MYPACKAGE_DEBUG)
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${packageDepend} is not yet available")
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend} to PENDING")
    ENDIF ()
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend} "PENDING")
    #
    # ===================================================
    # Do the dependency: ADD_SUBDIRECTORY or FIND_PACKAGE
    # ===================================================
    #
    STRING (TOUPPER ${packageDepend} _PACKAGEDEPEND)
    IF (_LOCAL)
      GET_FILENAME_COMPONENT(packageDependSourceDirAbsolute ${packageDependSourceDir} ABSOLUTE)
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ADD_SUBDIRECTORY(${packageDependSourceDirAbsolute})")
      ENDIF ()
      ADD_SUBDIRECTORY(${packageDependSourceDirAbsolute})
      #
      # We want to get the dependency version in our scope
      #
      GET_DIRECTORY_PROPERTY(${packageDepend}_VERSION DIRECTORY ${packageDependSourceDirAbsolute} DEFINITION PROJECT_VERSION)
      GET_DIRECTORY_PROPERTY(${packageDepend}_VERSION_MAJOR DIRECTORY ${packageDependSourceDirAbsolute} DEFINITION PROJECT_VERSION_MAJOR)
      GET_DIRECTORY_PROPERTY(${packageDepend}_VERSION_MINOR DIRECTORY ${packageDependSourceDirAbsolute} DEFINITION PROJECT_VERSION_MINOR)
    ELSE ()
      MESSAGE(STATUS "[${PROJECT_NAME}-DEPEND-STATUS] Looking for ${packageDepend}")
      #
      # FIND_PACKAGE will set the variables ${packageDepend}_VERSION, ${packageDepend}_VERSION_MAJOR and ${packageDepend}_VERSION_MINOR
      #
      FIND_PACKAGE (${packageDepend})
      IF (NOT ${_PACKAGEDEPEND}_FOUND)
        MESSAGE (FATAL_ERROR "[${PROJECT_NAME}-DEPEND-STATUS] Find ${packageDepend} failed")
      ENDIF ()
    ENDIF ()
    IF (MYPACKAGE_DEBUG)
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION to ${${packageDepend}_VERSION}")
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION_MAJOR to ${${packageDepend}_VERSION_MAJOR}")
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION_MINOR to ${${packageDepend}_VERSION_MINOR}")
    ENDIF ()
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION "${${packageDepend}_VERSION}")
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION_MAJOR "${${packageDepend}_VERSION_MAJOR}")
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend}_VERSION_MINOR "${${packageDepend}_VERSION_MINOR}")
    IF (MYPACKAGE_DEBUG)
      MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Setting property MYPACKAGE_DEPENDENCY_${packageDepend} to DONE")
    ENDIF ()
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${packageDepend} "DONE")
  ENDIF ()
  #
  # Gather current project's target candidates
  #
  SET (_candidates)
  IF (_TESTS)
    LIST (APPEND _candidates ${${PROJECT_NAME}_TEST_EXECUTABLE})
  ENDIF ()
  IF (_LIBS)
    LIST (APPEND _candidates ${PROJECT_NAME}_shared ${PROJECT_NAME}_static)
  ENDIF ()
  IF (_IFACE)
    LIST (APPEND _candidates ${PROJECT_NAME}_iface)
  ENDIF ()
  IF (_EXES)
    LIST (APPEND _candidates ${${PROJECT_NAME}_EXECUTABLE})
  ENDIF ()
  #
  # Set dependency scope
  #
  IF (_PUBLIC)
    SET (_package_dependency_scope PUBLIC)
  ELSEIF (_INTERFACE)
    SET (_package_dependency_scope INTERFACE)
  ELSEIF (_PRIVATE)
    SET (_package_dependency_scope PRIVATE)
  ELSE ()
    MESSAGE (FATAL_ERROR "[${PROJECT_NAME}-DEPEND-ERROR} Dependency scope is unknown - should be one of PUBLIC, INTERFACE or PRIVATE")
  ENDIF ()
  #
  # Loop on current project's target candidates
  #
  IF (MYPACKAGE_DEBUG)
    MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Target candidates: ${_candidates}")
  ENDIF ()
  FOREACH (_target ${_candidates})
    IF (TARGET ${_target})
      IF (NOT _PRIVATE)
        IF (NOT ${packageDepend} IN_LIST ${PROJECT_NAME}_package_dependencies)
	  IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] LIST(APPEND ${PROJECT_NAME}_package_dependencies ${packageDepend})")
          ENDIF ()
          LIST(APPEND ${PROJECT_NAME}_package_dependencies ${packageDepend})
        ENDIF ()
      ENDIF ()
      GET_TARGET_PROPERTY(_target_type ${_target} TYPE)
      IF (_target_type STREQUAL "INTERFACE_LIBRARY")
        IF (MYPACKAGE_DEBUG)
          MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] ${_target} type is ${_target_type}: Forcing dependency scope to INTERFACE")
        ENDIF ()
        SET (_scope "INTERFACE")
      ELSE ()
        SET (_scope ${_package_dependency_scope})
      ENDIF ()
      IF (_IFACE_OBJECTS)
        IF (TARGET ${packageDepend}_iface)
          IF (_PRIVATE)
            #
            # BUILD_LOCAL_INTERFACE is the only way to prevent ${packageDepend}_iface to appear in referenced imported targets
            #
            IF (MYPACKAGE_DEBUG)
              MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} \$<BUILD_LOCAL_INTERFACE:${packageDepend}_iface>")
            ENDIF ()
            TARGET_LINK_LIBRARIES(${_target} ${_scope} $<BUILD_LOCAL_INTERFACE:${packageDepend}_iface>)
          ELSE ()
            IF (MYPACKAGE_DEBUG)
              MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_iface")
            ENDIF ()
            TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_iface)
          ENDIF ()
          CONTINUE ()
        ENDIF ()
      ENDIF ()
      IF (_STATIC_OBJECTS)
        IF (TARGET ${packageDepend}_static)
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_static \$<TARGET_OBJECTS:${packageDepend}_static>)")
          ENDIF ()
          TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_static $<TARGET_OBJECTS:${packageDepend}_static>)
          CONTINUE ()
        ENDIF ()
      ENDIF ()
      IF (_SHARED_OBJECTS)
        IF (TARGET ${packageDepend}_shared)
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_shared \$<TARGET_OBJECTS:${packageDepend}_shared>)")
          ENDIF ()
          TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_shared $<TARGET_OBJECTS:${packageDepend}_shared>)
          CONTINUE ()
        ENDIF ()
      ENDIF ()
      IF (_STATIC_LIB)
        IF (TARGET ${packageDepend}_static)
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_static)")
          ENDIF ()
          TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_static)
          CONTINUE ()
        ENDIF ()
      ENDIF ()
      IF (_SHARED_LIB)
        IF (TARGET ${packageDepend}_shared)
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_shared)")
          ENDIF ()
          TARGET_LINK_LIBRARIES(${_target} ${_scope} ${packageDepend}_shared)
          CONTINUE ()
        ENDIF ()
      ENDIF ()
      IF (_TESTS)
        #
        # A bit painful but the target locations are not known at this time.
        # We remember all library targets for later use in the check generation command.
        #
        GET_PROPERTY(_targets_for_test_set GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${PROJECT_NAME}_TARGETS_FOR_TEST)
        IF (NOT _targets_for_test_set)
          SET (_targets_for_test ${_targetOnFileDependency})
          IF (MYPACKAGE_DEBUG)
            MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Initialized MYPACKAGE_DEPENDENCY_${PROJECT_NAME}_TARGETS_FOR_TEST with ${_targetOnFileDependency}")
          ENDIF ()
          SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${PROJECT_NAME}_TARGETS_FOR_TEST ${_targets_for_test})
        ELSE ()
          LIST (FIND _targets_for_test ${_targetOnFileDependency} _targets_for_test_found)
          IF (${_targets_for_test_found} EQUAL -1)
            LIST (APPEND _targets_for_test ${_targetOnFileDependency})
            IF (MYPACKAGE_DEBUG)
              MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Appended MYPACKAGE_DEPENDENCY_${PROJECT_NAME}_TARGETS_FOR_TEST with ${_targetOnFileDependency}")
            ENDIF ()
            SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_DEPENDENCY_${PROJECT_NAME}_TARGETS_FOR_TEST ${_targets_for_test})
          ENDIF ()
        ENDIF ()
      ENDIF ()
    ELSE ()
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] No target ${_target}")
      ENDIF ()
    ENDIF ()
  ENDFOREACH ()
  #
  # Test path management
  #
  GET_PROPERTY(_test_path_set GLOBAL PROPERTY MYPACKAGE_TEST_PATH SET)
  IF (${_test_path_set})
    GET_PROPERTY(_test_path GLOBAL PROPERTY MYPACKAGE_TEST_PATH)
  ELSE ()
    SET (_test_path $ENV{PATH})
    IF ("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
      STRING(REGEX REPLACE "/" "\\\\"  _test_path "${_test_path}")
    ELSE ()
      STRING(REGEX REPLACE " " "\\\\ "  _test_path "${_test_path}")
    ENDIF ()
    IF (MYPACKAGE_DEBUG)
      MESSAGE(STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Initializing TEST_PATH with PATH")
    ENDIF ()
    SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_TEST_PATH ${_test_path})
  ENDIF ()
  #
  # On Windows we want to make sure it contains a bin in the last component
  #
  SET (_have_bin FALSE)
  IF ("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
    FOREACH (_dir ${_dependLibraryRuntimeDirectories})
      GET_FILENAME_COMPONENT(_lastdir ${_dir} NAME)
      STRING (TOUPPER ${_lastdir} _lastdir)
      IF ("${_lastdir}" STREQUAL "BIN")
        SET (_have_bin TRUE)
        BREAK ()
      ENDIF ()
    ENDFOREACH ()
    IF (NOT _have_bin)
      SET (_dependLibraryRuntimeDirectoriesOld ${_dependLibraryRuntimeDirectories})
      FOREACH (_dir ${_dependLibraryRuntimeDirectoriesOld})
        GET_FILENAME_COMPONENT(_updir ${_dir} DIRECTORY)
        SET (_bindir "${_updir}/bin")
        IF (EXISTS "${_bindir}")
          LIST (APPEND _dependLibraryRuntimeDirectories "${_bindir}")
        ENDIF ()
      ENDFOREACH ()
    ENDIF ()
  ENDIF ()
  IF (NOT ("${_dependLibraryRuntimeDirectories}" STREQUAL ""))
    IF ("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
      SET (SEP "\\;")
    ELSE ()
      SET (SEP ":")
    ENDIF ()
    FOREACH (_dir ${_dependLibraryRuntimeDirectories})
      IF ("${CMAKE_HOST_SYSTEM}" MATCHES ".*Windows.*")
        STRING(REGEX REPLACE "/" "\\\\"  _dir "${_dir}")
      ELSE ()
        STRING(REGEX REPLACE " " "\\\\ "  _dir "${_dir}")
      ENDIF ()
      SET (_test_path "${_dir}${SEP}${_test_path}")
      IF (MYPACKAGE_DEBUG)
        MESSAGE (STATUS "[${PROJECT_NAME}-DEPEND-DEBUG] Prepended ${_dir} to TEST_PATH")
      ENDIF ()
      SET_PROPERTY(GLOBAL PROPERTY MYPACKAGE_TEST_PATH ${_test_path})
    ENDFOREACH ()
  ENDIF ()
  SET (TEST_PATH ${_test_path} CACHE INTERNAL "Test Path" FORCE)
ENDMACRO()
