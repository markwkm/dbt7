ColdFront
=========

`ColdFront <https://github.com/pgedge/coldfront>`_ is a PostgreSQL extension
that transparently stores table data in Apache Iceberg on S3-compatible object
storage (*decoupled mode*).  From the client's perspective it looks and behaves
like ordinary PostgreSQL: connections use ``psql`` with a standard connection
string, and SQL queries run unchanged.  The difference is that all TPC-DS table
data is held in Iceberg Parquet files rather than PostgreSQL heap storage.

Setting Up the ColdFront Stack
-------------------------------

See `https://github.com/pgEdge/coldfront/blob/main/docs/installation.md
<https://github.com/pgEdge/coldfront/blob/main/docs/installation.md>`_ for
instructions on setting up ColdFront.

Running DBT-7
-------------

Note that the example profile defines a number of environment variables that
the scripts need in order to use ColdFront.  They correspond to the operating
mode used to set up ColdFront in the previous section.

**Source the profile**::

    source examples/dbt7_coldfront_profile

Then run a scale factor 1 test::

    dbt7 run --tpcdstools=$DSHOME coldfront /tmp/results

Run only the Load Test::

    dbt7 run --load --tpcdstools=$DSHOME coldfront /tmp/results

Run only the Power Test::

    dbt7 run --power --tpcdstools=$DSHOME coldfront /tmp/results

Environment Variables
---------------------

ColdFront cold-tier variables:

.. list-table::
   :header-rows: 1

   * - Variable
     - Purpose
   * - ``COLDFRONT_BACKEND``
     - Storage backend: ``s3``, ``azure``, ``gcs``, or ``aws``
   * - ``COLDFRONT_S3_ENDPOINT``
     - S3 endpoint (``host:port``)
   * - ``COLDFRONT_LK_ENDPOINT``
     - Lakekeeper REST catalog URL
   * - ``COLDFRONT_WAREHOUSE``
     - Iceberg warehouse name
   * - ``COLDFRONT_NAMESPACE``
     - Iceberg namespace
   * - ``COLDFRONT_ACCESS_KEY``
     - S3 access key
   * - ``COLDFRONT_SECRET_KEY``
     - S3 secret key
   * - ``COLDFRONT_AZURE_CONN``
     - Azure connection string (azure backend only)
   * - ``COLDFRONT_AWS_REGION``
     - AWS region (aws backend only)

Implementation Notes
--------------------

**Table creation** — ``dbt7-coldfront-create-tables`` calls
``coldfront.create_iceberg_table()`` for each of the 24 primary TPC-DS tables.
This provisions a PostgreSQL view backed by an Iceberg table in the configured
warehouse.  Data maintenance tables (``s_purchase``, ``s_store_returns``, etc.)
and the internal ``time_statistics`` table are created as regular PostgreSQL
heap tables.

**Data loading** — ``COPY`` is not supported on ColdFront views.  The load
script uses a two-step approach:

1. Parallel ``\COPY`` of each ``*.dat`` file into a staging table
   (``public.staging_<table>``).
2. A single ``INSERT INTO public.<table> SELECT * FROM public.staging_<table>``
   which the ColdFront extension intercepts and routes to Iceberg.

``DBT7DBNAME`` must be set to the ColdFront service database name (typically
``coldfront``).  The server's ``postgresql.conf`` sets
``coldfront.local_pg_dsn`` to point to that database, so ``pglocal`` can
find the staging tables without any additional configuration.

The staging tables are created alongside the Iceberg tables by
``dbt7-coldfront-create-tables`` and dropped by ``dbt7-coldfront-drop-tables``.

**Index creation** — No indexes are created.  All primary table data lives in
Iceberg Parquet files.
