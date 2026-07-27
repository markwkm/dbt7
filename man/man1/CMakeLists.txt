execute_process(
    COMMAND sed -n "s/^.*(\\(.*\\)).*$/\\1/p;q" ${CMAKE_HOME_DIRECTORY}/ChangeLog
    OUTPUT_VARIABLE MANDATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

find_program(RST2MAN NAMES rst2man.py rst2man)
if (NOT RST2MAN)
    message(WARNING "rst2man not found, man pages not generated")
endif (NOT RST2MAN)

foreach (MANPAGE dbt7 dbt7-build-dsgen dbt7-generate-data
                 dbt7-generate-queries dbt7-get-config dbt7-load-test
                 dbt7-plot-results dbt7-post-process dbt7-power-test
                 dbt7-report dbt7-run dbt7-run-query dbt7-throughput-test)
    configure_file(
        ${MANPAGE}.1.rst.in
        ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1.rst
    )

    execute_process(
        COMMAND ${RST2MAN} ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1.rst
        OUTPUT_FILE ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1
    )
endforeach(MANPAGE)

install(
    FILES ${CMAKE_BINARY_DIR}/man/man1/dbt7.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-build-dsgen.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-generate-data.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-generate-queries.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-get-config.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-load-test.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-plot-results.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-post-process.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-power-test.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-report.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-run.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-run-query.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt7-throughput-test.1
    DESTINATION "share/man/man1"
)
