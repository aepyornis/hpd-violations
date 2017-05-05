#!/bin/bash

###
# Downloads HPD's violation data files for 2015, 2016, & Jan-March 2017
#
mkdir -p data
cd data

# 2017
mkdir -p 2017
cd 2017
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20170201.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20170301.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20170401.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20170501.zip
cd ..

# 2016
mkdir -p 2016
cd 2016

wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160201.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160301.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160401.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160501.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160601.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160701.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160801.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160901.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20161001.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20161101.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20161201.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20170101.zip
cd ..

mkdir -p 2015
cd 2015
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150201.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violation20150301.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150401.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150501.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150601.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150701.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150801.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20150901.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20151001.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20151101.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20151201.zip
wget http://www1.nyc.gov/assets/hpd/downloads/misc/Violations20160101.zip
cd ..

# Download open violations :
wget http://www1.nyc.gov/assets/hpd/downloads/misc/AllOpenViolation20170501.zip
cd ..
