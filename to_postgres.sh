#!/bin/bash

psql -d violations -f violations_schema.sql 

for file in $(ls csvs/); do
    printf "copying ${file}\n"
    windowspath=$(cygpath -aw "csvs/${file}")
    command="copy violations from '${windowspath}' WITH (FORMAT CSV, HEADER true, NULL '', DELIMITER '|');"
    echo ${command} | psql violations
done


