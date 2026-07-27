set (SCRIPTS "")
foreach (SCRIPT dbt7-gp-create-db
                dbt7-gp-create-tables
                dbt7-gp-create-indexes
                dbt7-gp-data-maintenance
                dbt7-gp-data-validation
                dbt7-gp-drop-tables
                dbt7-gp-get-query-time
                dbt7-gp-load-data
                dbt7-gp-report
                dbt7-gp-run-stream
                dbt7-gp-start-db
                dbt7-gp-stop-db
                dbt7-gp-time-statistics
        )
    configure_file(${SCRIPT}.in ${CMAKE_BINARY_DIR}/${SCRIPT} @ONLY)
    list (APPEND SCRIPTS ${CMAKE_BINARY_DIR}/${SCRIPT})
endforeach (SCRIPT)

install (PROGRAMS ${SCRIPTS} DESTINATION "bin")
