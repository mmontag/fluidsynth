macro ( ADD_FLUID_TEST _test )
    ADD_EXECUTABLE(${_test} ${_test}.c $<TARGET_OBJECTS:libfluidsynth-OBJ> )
    
    # only build this unit test when explicitly requested by "make check"
    set_target_properties(${_test} PROPERTIES EXCLUDE_FROM_ALL TRUE)
    
    # import necessary compile flags and dependency libraries
    if ( FLUID_CPPFLAGS )
        set_target_properties ( ${_test} PROPERTIES COMPILE_FLAGS ${FLUID_CPPFLAGS} )
    endif ( FLUID_CPPFLAGS )
    TARGET_LINK_LIBRARIES(${_test} $<TARGET_PROPERTY:libfluidsynth,INTERFACE_LINK_LIBRARIES>)
    
    # disable clang-tidy for unit tests
    set_target_properties(${_test} PROPERTIES C_CLANG_TIDY "")

    # use the local include path to look for fluidsynth.h, as we cannot be sure fluidsynth is already installed
    target_include_directories(${_test}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include> # include auto generated headers
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include> # include "normal" public (sub-)headers
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src> # include private headers
    $<TARGET_PROPERTY:libfluidsynth,INCLUDE_DIRECTORIES> # include all other header search paths needed by libfluidsynth (esp. glib)
    )

    # add the test to ctest
    ADD_TEST(NAME ${_test} COMMAND ${_test})
    
    # append the current unit test to check-target as dependency
    add_dependencies(check ${_test})

endmacro ( ADD_FLUID_TEST )
