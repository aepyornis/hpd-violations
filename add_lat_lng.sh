#!/bin/bash

source ./pg_setup.sh

if [[ $(execute_sql_cmd "SELECT EXISTS(SELECT 1 FROM information_schema.tables where table_name = 'pluto_16v2')" | sed -n '3p' | grep t) ]]
then
    printf 'adding lat and lng to violation tables from pluto 16v2\n'
    execute_sql sql/add_lat_lng.sql
else
    printf 'table pluto 16v2 is missing!\n'
fi
