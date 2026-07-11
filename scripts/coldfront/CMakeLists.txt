foreach (SCRIPT dbt7-coldfront-create-db
                dbt7-coldfront-create-tables
                dbt7-coldfront-create-indexes
                dbt7-coldfront-data-maintenance
                dbt7-coldfront-data-validation
                dbt7-coldfront-drop-tables
                dbt7-coldfront-get-query-time
                dbt7-coldfront-load-data
                dbt7-coldfront-report
                dbt7-coldfront-run-stream
                dbt7-coldfront-start-db
                dbt7-coldfront-stop-db
                dbt7-coldfront-time-statistics
        )
    configure_file(${SCRIPT}.in ${CMAKE_BINARY_DIR}/${SCRIPT} @ONLY)
endforeach (SCRIPT)

install (
    PROGRAMS ${CMAKE_BINARY_DIR}/dbt7-coldfront-create-db
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-create-tables
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-create-indexes
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-data-maintenance
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-data-validation
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-drop-tables
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-get-query-time
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-load-data
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-report
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-run-stream
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-start-db
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-stop-db
             ${CMAKE_BINARY_DIR}/dbt7-coldfront-time-statistics
    DESTINATION "bin"
)
