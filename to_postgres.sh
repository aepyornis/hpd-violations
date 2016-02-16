#!/bin/bash
# use: export HPD_VIOLATIONS_DATA_DIR=/path/to/processed/csvs/folder; to_postgres.sh

psql -d hpd -f violations_schema.sql 

for file in $(ls ${HPD_VIOLATIONS_DATA_DIR}*.csv); do
    printf "copying ${file}\n"
    command="copy hpd.violations from '${file}' WITH (FORMAT CSV, HEADER true, NULL '', DELIMITER '|');"
    echo ${command} | psql hpd
done

printf "Adding bbl column, id, and indexing\n"
psql -d hpd -f index.sql
