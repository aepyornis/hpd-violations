#!/bin/bash
set -e

for i in 2015 2016; do
    cd $i
    for zipfile in *.zip; do
         unzip $zipfile
    done
    rm *.xml
    cd ..
done
