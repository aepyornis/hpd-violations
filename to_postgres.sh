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

source ./pg_setup.sh
pwd=$(pwd)

printf "Creating the violations table\n"
execute_sql sql/schema.sql

cd $HPD_VIOLATIONS_DATA_FOLDER
for year in 2015 2016; do
    cd $year
    for f in *.txt; do
        printf "copying "${year}"/"${f}"\n"
        cat ${f} |
            sed 's/"//g' |   # DoubleQuotes just mess things up
            execute_sql_cmd "COPY violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
    done
    cd ..
done

cd $pwd

printf "Adding the bbl lookup table\n"
execute_sql sql/bbl_lookup.sql 

cat ${BBL_LAT_LNG_FILE} | execute_sql_cmd "COPY bbl_lookup from STDIN (FORMAT CSV,  HEADER TRUE)"

printf "Adding columns -- bbl, lat, lng -- to violations\n"
execute_sql sql/process_violations_table.sql

printf "Creating the uniq_violations table\n"
execute_sql sql/unique_violations.sql 

printf "Creating the open_violations table\n"
execute_sql sql/open_violations_schema.sql

cat $HPD_OPEN_VIOLATIONS_FILE |
    sed 's/"//g' |
    execute_sql_cmd "COPY open_violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"

printf "Adding columns -- bbl, lat, lng -- to open_violations\n"
execute_sql sql/process_open_violations.sql

printf "Dropping bbl lookup table\n"
execute_sql_cmd "DROP TABLE bbl_lookup;"

printf "Creating the all_violations table\n"
execute_sql sql/all_violations.sql

# printf "There are "$(psql -At -d hpd_violations -c "SELECT COUNT(*) from all_violations")" rows in the all_violations table\n"
