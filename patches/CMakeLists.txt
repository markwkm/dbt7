file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/series SERIES)

set(PATCHES "")
foreach(PATCH ${SERIES})
    list(APPEND PATCHES ${CMAKE_CURRENT_SOURCE_DIR}/${PATCH})
endforeach(PATCH)

install(
    FILES ${PATCHES} ${CMAKE_CURRENT_SOURCE_DIR}/series
    DESTINATION "share/dbt7/patches"
)
