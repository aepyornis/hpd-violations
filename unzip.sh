#!/bin/bash
set -e

cd data/

# unzip the All Open Violationz zip file
unzip *.zip
# rename the file to AllOpenViolations.txt
mv Violation*.txt AllOpenViolations.txt
# We don't use the xml version, so we can remove it
rm *.xml

for i in 2015 2016 2017; do
    cd $i
    for zipfile in *.zip; do
         unzip $zipfile
    done
    rm *.xml
    cd ..
done

cd ..
