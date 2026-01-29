foreach (SCRIPT dbt7-pgaa-create-db
                dbt7-pgaa-create-tables
                dbt7-pgaa-create-indexes
                dbt7-pgaa-data-maintenance
                dbt7-pgaa-data-validation
                dbt7-pgaa-drop-tables
                dbt7-pgaa-get-query-time
                dbt7-pgaa-load-data
                dbt7-pgaa-report
                dbt7-pgaa-run-stream
                dbt7-pgaa-start-db
                dbt7-pgaa-stop-db
                dbt7-pgaa-time-statistics
        )
    configure_file(${SCRIPT}.in ${CMAKE_BINARY_DIR}/${SCRIPT} @ONLY)
endforeach (SCRIPT)

install (
    PROGRAMS ${CMAKE_BINARY_DIR}/dbt7-pgaa-create-db
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-create-tables
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-create-indexes
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-data-maintenance
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-data-validation
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-drop-tables
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-get-query-time
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-load-data
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-report
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-run-stream
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-start-db
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-stop-db
             ${CMAKE_BINARY_DIR}/dbt7-pgaa-time-statistics
    DESTINATION "bin"
)
