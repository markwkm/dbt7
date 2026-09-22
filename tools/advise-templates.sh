#!/bin/sh
# Write a set of advised query templates for dsqgen.
#
# Usage: advise-templates.sh DSGEN LIST ADVICE_DIR [SET]
#
# For the dbt7 patch series: make dsgen, then
#   tools/advise-templates.sh dsgen \
#       dsgen/query_templates/templates-pgsql.lst advice/pg19-sf20 \
#       pg_plan_advice
# and refresh the pg_plan_advice patch with quilt.
#
# DSGEN is the TPC-DS Tools directory.  LIST is a template list in
# DSGEN/query_templates (entries relative to that directory).  ADVICE_DIR
# holds one file per statement, queryN.advice for a template with one
# statement and queryNa.advice, queryNb.advice for a template with two,
# each holding one pg_plan_advice string on one line.  SET names the
# output directory under DSGEN (default pg_plan_advice) and the list
# DSGEN/query_templates/templates-SET.lst.
#
# Each template is copied with, before every statement, a line
#   RESET pg_plan_advice.advice;
#   select set_config('pg_plan_advice.advice', '...', false);
# (one line in the template) so that each statement is planned under
# its own advice.  A statement without an advice file gets an empty
# string, which is no advice.
set -u
DSGEN="${1:?tools directory}"
LIST="${2:?template list}"
ADVICE="${3:?advice directory}"
SET="${4:-pg_plan_advice}"
OUT="${DSGEN}/${SET}"
mkdir -p "${OUT}"
NEWLIST="${DSGEN}/query_templates/templates-${SET}.lst"
: > "${NEWLIST}"
while IFS= read -r TPL; do
	[ -z "${TPL}" ] && continue
	SRC="${DSGEN}/query_templates/${TPL}"
	NAME=$(basename "${TPL}")
	NUM=$(printf '%s' "${NAME}" | sed 's/[^0-9]//g')
	awk -v advdir="${ADVICE}" -v num="${NUM}" -v name="${NAME}" '
	function advice(i,    f, a, sfx) {
		f = advdir "/query" num ".advice"
		if (i > 1 || (getline a < f) <= 0) {
			close(f)
			sfx = substr("abcdefgh", i, 1)
			f = advdir "/query" num sfx ".advice"
			if ((getline a < f) <= 0) a = ""
		}
		close(f)
		if (a ~ /[\[\]"]/) {
			printf "%s: advice for statement %d has [, ] or \"\n",
				name, i > "/dev/stderr"
			exit 1
		}
		gsub(/\047/, "\047\047", a)
		return a
	}
	BEGIN { state = "pre"; n = 0 }
	{
		t = $0
		sub(/[ \t\r]+$/, "", t)
		if (state == "pre") {
			if (t ~ /^[ \t]*$/ || t ~ /^[ \t]*--/) { print; next }
			if (t ~ /^[ \t]*define[ \t]/) {
				print
				if (t !~ /;$/) state = "def"
				next
			}
			n++
			printf "RESET pg_plan_advice.advice; " \
				"select set_config(\047pg_plan_advice.advice\047, " \
				"\047%s\047, false);\n", advice(n)
			print
			if (t !~ /;$/) state = "stmt"
			next
		}
		print
		if (t ~ /;$/) state = "pre"
	}
	END { printf "%s\t%d\n", name, n > "/dev/stderr" }
	' "${SRC}" > "${OUT}/${NAME}" || exit 1
	printf '../%s/%s\n' "${SET}" "${NAME}" >> "${NEWLIST}"
done < "${LIST}"
