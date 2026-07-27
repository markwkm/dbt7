configure_file(
    dsdgen-chunking-test.sh.in
    ${CMAKE_BINARY_DIR}/tests/dsdgen-chunking-test.sh
    @ONLY
)

add_test(
    NAME dsdgen-chunking
    COMMAND ${CMAKE_BINARY_DIR}/tests/dsdgen-chunking-test.sh
)

# The web_sales run at scale factor 100 makes this test exceed the
# default ctest timeout of 1500 seconds.
set_tests_properties(
    dsdgen-chunking
    PROPERTIES TIMEOUT 14400
)
