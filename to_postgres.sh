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
            execute_sql_cmd "COPY violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
    done
    cd ..
done

cd $pwd

printf "Creating the uniq_violations table\n"
execute_sql sql/unique_violations.sql

printf "Creating the open_violations table\n"
execute_sql sql/open_violations_schema.sql

printf "Copying data from "${HPD_VIOLATIONS_DATA_FOLDER:-data}"/AllOpenViolations.txt\n"

cat ${HPD_VIOLATIONS_DATA_FOLDER:-data}/AllOpenViolations.txt |
    sed 's/"//g' |
    execute_sql_cmd "COPY open_violations from STDIN (DELIMITER '|', FORMAT CSV, HEADER TRUE);"

printf "Adding columns bbl to open_violations\n"
execute_sql sql/process_open_violations.sql

printf "Creating the all_violations table\n"
execute_sql sql/all_violations.sql

# printf "There are "$(psql -At -d hpd_violations -c "SELECT COUNT(*) from all_violations")" rows in the all_violations table\n"
