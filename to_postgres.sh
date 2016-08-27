#!/bin/bash

############################################
# Assumes this folder structure:
#  ./
#     data /  
#            bbl_lat_lng.txt
#            AllOpenViolationsFile.txt
#            2015 / 
#                   2015 violation data....
#            2016 /
#                   2016 violation data...
############################################

DB="hpd_violations"
open_violations_file="data/Violation20160731.txt"

printf "Creating the violations table\n"
psql -d ${DB} -f sql/schema.sql

cd data/
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
cd ..

printf "Adding the bbl lookup table\n"
psql -d ${DB} -f sql/bbl_lookup.sql 

psql -d ${DB} -c "COPY bbl_lookup from '"$(readlink -f data/bbl_lat_lng.txt)"' (FORMAT CSV,  HEADER TRUE)"

printf "Adding columns -- bbl, lat, lng -- to violations\n"
psql -d ${DB} -f sql/process_violations_table.sql

printf "Creating the uniq_violations table\n"
psql -d ${DB} -f sql/unique_violations.sql 

printf "Creating the open_violations table\n"
psql -d ${DB} -f sql/open_violations_schema.sql

cat ${open_violations_file} |
    sed 's/"//g' |
    psql -d ${DB} -c "COPY open_violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"

printf "Adding columns -- bbl, lat, lng -- to open_violations\n"
psql -d ${DB} -f sql/process_open_violations.sql

printf "Dropping bbl lookup table\n"
psql -d ${DB} -c "DROP TABLE bbl_lookup;"

printf "Creating the all_violations table\n"
psql -d ${DB} -f sql/all_violations.sql

printf "There are "$(psql -At -d hpd_violations -c "SELECT COUNT(*) from all_violations")" rows in the all_violations table\n"
