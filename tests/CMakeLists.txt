set(DSGEN ${CMAKE_SOURCE_DIR}/DSGen-software-code-4.0.0_final)

configure_file(
    dsdgen-chunking-test.sh.in
    ${CMAKE_BINARY_DIR}/tests/dsdgen-chunking-test.sh
    @ONLY
)

add_test(
    NAME dsdgen-chunking
    COMMAND ${CMAKE_BINARY_DIR}/tests/dsdgen-chunking-test.sh
)
