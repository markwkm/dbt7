set(CWD "${CMAKE_SOURCE_DIR}/patches/")

install(
    FILES ${CWD}/dbt7-DSGen-software-code-4.0.0_final-build.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-fread-fix.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-use-after-free.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-uninitialized-variable.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-ftime-deprecation.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-param-limits.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-prototypes.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-format-strings.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-unused.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-indentation.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-embed-string.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-postgresql-queries.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-postgresql-queries-test.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-greenplum-queries.diff
          ${CWD}/dbt7-DSGen-software-code-4.0.0_final-pg_plan_advice.diff
          ${CWD}/series
    DESTINATION "share/dbt7/patches"
)
