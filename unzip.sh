#!/bin/bash
set -e

source ./pg_setup.sh

cd ${HPD_VIOLATIONS_DATA_FOLDER:-data}

# removing old .txt and xml files
rm -f *.txt
rm -f *.xml
# unzip the All Open Violationz zip file
unzip *.zip
# rename the file to AllOpenViolations.txt
mv Violation*.txt AllOpenViolations.txt
# We don't use the xml version, so we can remove it
rm -f *.xml

for i in 2015 2016 2017; do
    cd $i
    for zipfile in *.zip; do
        unzip -uo $zipfile
    done
    rm -f *.xml
    cd ..
done

cd ..
