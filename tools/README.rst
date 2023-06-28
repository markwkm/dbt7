These scripts and Docker files are for build testing, and evaluating DBT-7 with
the smallest scale factor.  While DBT-7 is compatible with multiple database
systems, this initial set of scripts is just for PostgreSQL.

The quickest way to try out the kit is to run::

    docker/build-pgsql
    docker/run-test

* `build-pgsql` - Build a Docker image prepared for running tests against
                  PostgreSQL.
* `prepare-image` - Build a Docker image to be further expanded by the other
                    components in the kit.
* `run-test` - Script to run a test.
