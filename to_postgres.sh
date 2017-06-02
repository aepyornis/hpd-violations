#!/bin/bash

############################################
# Assumes this folder structure:
#  ./
#     data /  
#            AllOpenViolations.txt
#            2015 / 
#                   2015 violation data....
#            2016 /
#                   2016 violation data...
#            2017 /
#                   2017 violation data...
############################################

# If the var HPD_VIOLATIONS_DATA_FOLDER is not set
# the script uses the default of 'data'

source ./pg_setup.sh
pwd=$(pwd)

printf "Creating the violations table\n"
execute_sql sql/schema.sql

cd ${HPD_VIOLATIONS_DATA_FOLDER:-data}
for year in 2015 2016 2017; do
    cd $year
    for f in *.txt; do
        printf "copying "${year}"/"${f}"\n"
        cat ${f} |
            sed 's/"//g' |   # DoubleQuotes just mess things up
            execute_sql_cmd "COPY hpd_violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
    done
    cd ..
done

cd $pwd

printf "Adding column bbl to violations\n"
execute_sql sql/add_bbl_to_violations.sql

printf "Creating the uniq_violations table\n"
execute_sql sql/unique_violations.sql

printf "Creating the open_violations table\n"
execute_sql sql/open_violations_schema.sql

printf "Copying data from "${HPD_VIOLATIONS_DATA_FOLDER:-data}"/AllOpenViolations.txt\n"

cat ${HPD_VIOLATIONS_DATA_FOLDER:-data}/AllOpenViolations.txt |
    sed 's/"//g' |
    execute_sql_cmd "COPY hpd_open_violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"

printf "Adding columns bbl to hpd_open_violations\n"
execute_sql sql/process_open_violations.sql

printf "Creating the all_violations table\n"
execute_sql sql/all_violations.sql

if [[ $(execute_sql_cmd "SELECT EXISTS(SELECT 1 FROM information_schema.tables where table_name = 'pluto_16v2')" | sed -n '3p' | grep t) ]]
then
    printf 'Adding lat and lng to the all_violations table from pluto 16v2\n'
    execute_sql sql/add_lat_lng.sql
else
    printf 'Table pluto 16v2 is missing!\n'
    printf 'Skipping Lat & Lng for now\n'
fi

printf "Indexing the all_violations table\n"
execute_sql sql/index_all_violations.sql
