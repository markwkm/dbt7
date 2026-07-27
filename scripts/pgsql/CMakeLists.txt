set (SCRIPTS "")
foreach (SCRIPT dbt7-pgsql-create-db
                dbt7-pgsql-create-tables
                dbt7-pgsql-create-indexes
                dbt7-pgsql-data-maintenance
                dbt7-pgsql-data-validation
                dbt7-pgsql-drop-tables
                dbt7-pgsql-get-query-time
                dbt7-pgsql-load-data
                dbt7-pgsql-report
                dbt7-pgsql-run-stream
                dbt7-pgsql-start-db
                dbt7-pgsql-stop-db
                dbt7-pgsql-time-statistics
        )
    configure_file(${SCRIPT}.in ${CMAKE_BINARY_DIR}/${SCRIPT} @ONLY)
    list (APPEND SCRIPTS ${CMAKE_BINARY_DIR}/${SCRIPT})
endforeach (SCRIPT)

install (PROGRAMS ${SCRIPTS} DESTINATION "bin")
