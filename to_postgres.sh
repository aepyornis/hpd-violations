#!/bin/bash

DB="hpd_violations"

psql -d ${DB} -f schema.sql

for year in 2015 2016; do
    cd $year
    for f in *.txt; do
        printf "copying "${year}"/"${f}"\n"
        cat ${f} |
            sed 's/"//g' |   # DoubleQuotes just mess things up
            psql -d ${DB} -c "COPY violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
    done
    cd ..
done

printf "Adding columns -- bbl, lat, lng, id -- and indexing\n"
psql -d ${DB} -f process_violations_table.sql
