#!/bin/bash

mkdir -p processed

for i in $( ls *.xml ); do
    perl -pe 's/></>\n</g' $i > processed/${i}
    printf "${i} has been processed\n"
done
