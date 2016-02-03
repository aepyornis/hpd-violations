#!/bin/bash
# Adds HPD registration data to database
# Uses SQL files from a different repo found here: https://github.com/aepyornis/hpd

HPD_REPO="/path/to/aepyornis/hpd/repo"
HPD_DATA_DIR="/path/to/hpd/data/files"

printf 'create table and COPY data'
psql -d hpd_violations -f ${HPD_REPO}/sql/schema.sql

printf 'Inserting data'
psql -d hpd_violations -c "COPY hpd.registrations FROM '"${HPD_DATA_DIR}"/Registration20151130.txt' (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
psql -d hpd_violations -c "COPY hpd.contacts FROM '"${HPD_DATA_DIR}"/contacts.txt' (DELIMITER '|', FORMAT CSV, HEADER TRUE);"

psql -d hpd_violations -c "COPY hpd.bbl_lookup FROM '"${HPD_REPO}"/bbl_lat_lng.txt' (FORMAT CSV,  HEADER TRUE);"

printf 'cleanup contact addresses'
psql -d hpd_violations -f ${HPD_REPO}/sql/address_cleanup.sql

printf 'cleanup registration addresses'
psql -d hpd_violations -f ${HPD_REPO}/sql/registrations_clean_up.sql

printf 'Add function anyarray_uniq()'
psql -d hpd_violations -f ${HPD_REPO}/sql/anyarray_uniq.sql

printf 'Add function anyarray_remove_null'
psql -d hpd_violations -f ${HPD_REPO}/sql/anyarray_remove_null.sql

printf 'Add aggregate functions first() and last()'
psql -d hpd_violations -f ${HPD_REPO}/sql/first_last.sql

printf 'Creating corporate_owners table'
psql -d hpd_violations -f ${HPD_REPO}/sql/corporate_owners.sql

printf 'Geocodes registrations via pluto'
psql -d hpd_violations -f ${HPD_REPO}/sql/registrations_geocode.sql

printf 'Creating view registrations_grouped_by_bbl'
psql -d hpd_violations -f ${HPD_REPO}/sql/registrations_grouped_by_bbl.sql

printf 'Indexing tables'
psql -d hpd_violations -f ${HPD_REPO}/sql/index.sql




