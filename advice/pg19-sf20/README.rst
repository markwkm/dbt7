Plan advice set pg19-sf20
=========================

One file per statement, ``queryN.advice`` (``queryNa.advice`` and
``queryNb.advice`` for the two-statement templates 14, 23, 24 and 39),
holding one pg_plan_advice string on one line.  A template without a
file gets an empty string, which is no advice.

``tools/advise-templates.sh`` writes the ``pg_plan_advice/`` templates
of the TPC-DS Tools patch series from these files and the plain
PostgreSQL templates.

Provenance
----------

The strings are the generated advice of the fastest executed plan found
for each statement by a plan study on 2026-09-16 to 2026-09-22:

- PostgreSQL 19beta3 with the ``pg_plan_advice`` contrib module, the
  DBT-7 schema and indexes, ``shared_buffers`` 16GB, ``work_mem`` 256MB,
  ``max_parallel_workers_per_gather`` 2, eight virtual processors.
- Scale factor 20, one statement at a time, three timed runs per plan
  after a warm-up, the parameters of the stream ``dsqgen`` writes for
  seed 0 at that scale factor.  Each string was first found at scale
  factor 1, 2, 5, 10 or 20 and kept while it stayed the fastest at the
  next scale factor.

Queries 1, 30 and 81 have no file.  They compare each row of a common
table expression with an average over the same expression through a
correlated subquery, which no advice reaches.

Cautions
--------

The advice matches a statement whatever its parameters, but the plan
it fixes was timed on one parameter set.  With other parameters q69
ran 14x to 73x slower under its advice than with the planner's own
plan, because the study's parameters for q69 select no store_sales
row.  At scale factor 1 the whole set was as fast as the plans found
at scale factor 1, with seven templates slower than the planner's own
plan.  A run at another scale factor, on another PostgreSQL version or
with other seeds needs its own validation, and the file of a losing
statement can be removed.
