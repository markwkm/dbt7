Container
=========

A *Containerfile* is provided for building a Docker image that can run DBT-7
against an external database management system.

The container image includes the TPC-DS Tools, and all dependencies needed to
generate data, execute queries, and produce reports.  The database must be
managed separately outside the container.

Read through all of the sections to determine which flags you need to use with
Docker.

Building the Container
----------------------

From the top of the repository, create a container image named `dbt7`::

    docker build -t dbt7 -f Containerfile .

Persisting Results
------------------

Mount a host directory to the `/results` directory in the container to save
results, which may need the use of the `--user` flag to set the ownership of
the results to your user::

    docker run --rm \
        -v ./results:/results \
        dbt7 run --scale-factor=1 pgsql /results/0

Running a Test
--------------

The entrypoint is the `dbt7` command.  Pass arguments to `dbt7` via `docker
run`.  Use `PGHOST` and `PGPORT` to point to the external database::

    docker run --rm \
        -e PGHOST=dbserver \
		-e PGPORT=5432 \
        --user $(id -u):$(id -g) \
        -v ./results:/results \
        dbt7 run --scale-factor=1 pgsql /results/0

Directory Layout
----------------

The container uses two directories for runtime data:

`/scratch`
    Temporary working space including generated flat files
    (`/scratch/dbt7data`).

`/results`
    Intended for saving test results.  Mount this to the host to save test
	results.

Mounting Storage
----------------

The `/scratch` directory within the container is used for generating flat files
from `dsdgen`, which can be very large depending on the scale factor. Mount it
to a location with sufficient disk space to save and reuse the data files::

    docker run --rm \
        -e PGHOST=dbserver \
        --user $(id -u):$(id -g) \
        -v /data/scratch:/scratch \
        -v /data/results:/results \
        dbt7 run --scale-factor=1 pgsql /results

As a rough guide, a scale factor of 1 generates approximately 1 GB of flat
files.  Plan storage for `/scratch` accordingly when using larger scale
factors.

Notes
-----

* The container runs as a non-root `dbt` user.
* The container does not for running a PostgreSQL instance.
* To connect to a database running on the same host, use
  `--network host` so the container shares the host's network
  namespace::

      docker run --rm \
          --network host \
          -v /data/scratch:/scratch \
          -v /data/results:/results \
          dbt7 run --scale-factor=1 pgsql /results

* System statistics collected by `sar` inside the container reflect
  only the container's cgroup, not the host.
