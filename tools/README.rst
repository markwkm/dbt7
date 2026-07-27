These scripts are for build testing, and evaluating DBT-7 with the
smallest scale factor.

The container image does not run a database itself; point the test at an
external PostgreSQL instance with the PGHOST and PGPORT environment
variables.  See doc/container.rst for more details.

The quickest way to try out the kit is to run::

    tools/build-container
    PGHOST=dbserver tools/run-test pgsql

* `build-appimage` - Build an AppImage of the DBT-7 kit in a container.
* `build-appimage-container` - Build the container image used to build
                               the AppImage.
* `build-container` - Build a container image with the DBT-7 kit
                      installed, using the Containerfile at the top of
                      the repository.
* `run-test` - Run a small test using the container image against an
               external PostgreSQL instance.
