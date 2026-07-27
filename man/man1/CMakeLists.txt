execute_process(
    COMMAND sed -n "s/^.*(\\(.*\\)).*$/\\1/p;q" ${CMAKE_HOME_DIRECTORY}/ChangeLog
    OUTPUT_VARIABLE MANDATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

find_program(RST2MAN NAMES rst2man.py rst2man)
if (NOT RST2MAN)
    message(WARNING "rst2man not found, man pages not generated")
else (NOT RST2MAN)
    set (MANPAGES "")
    foreach (MANPAGE dbt7 dbt7-build-dsgen dbt7-generate-data
                     dbt7-generate-queries dbt7-get-config dbt7-load-test
                     dbt7-plot-results dbt7-post-process dbt7-power-test
                     dbt7-report dbt7-run dbt7-run-query
                     dbt7-throughput-test)
        configure_file(
            ${MANPAGE}.1.rst.in
            ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1.rst
        )

        add_custom_command(
            OUTPUT ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1
            COMMAND ${RST2MAN} ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1.rst
                    ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1
            DEPENDS ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1.rst
        )
        list (APPEND MANPAGES ${CMAKE_BINARY_DIR}/man/man1/${MANPAGE}.1)
    endforeach(MANPAGE)

    add_custom_target(manpages ALL DEPENDS ${MANPAGES})

    install(FILES ${MANPAGES} DESTINATION "share/man/man1")
endif (NOT RST2MAN)
