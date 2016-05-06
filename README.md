# HPD-Violations

To build a database of hpd-violations since 2015, run the following scripts:

``` bash
# Downloads all the data into two folders: 2015, 2016
./download_violations.sh
# Unzips the data & deletes the .xml files
./unzip.sh
# Inserts the data into postgres
./to_postgres.sh
```


## HPD-Violation XML to CSV converter: parse_violations_xml

This this is an XML converter for HPD violation data. HPD provides only XML data for all violations prior to Aug. 2014. However, there are a complex set of schema changes prior to 2015 ([see HPD's metadata](http://www1.nyc.gov/assets/hpd/downloads/pdf/ViolationsOpenDataDoc.zip)), so I have temporarily abandoned the project of bringing in all historic violation data and instead I'm just dealing with the data since 2015. One day, I'd like to revisit the goal of parsing all the violation data.

#### Violations Parser
USE: python3 parse_violations.py input [output]

The input can be a single xml file or a directory (and subdirectories) of files. If no output is provided, it will produce an output csv with the same name as the input. For example, python3 parse_violations.py Violations20150201.xml creates Violations20150201.csv.

HPD violation XML files can download from their website here: [HPD Open Data - Violations]( http://www1.nyc.gov/site/hpd/about/violation-open-data.page)

IMPORTANT NOTE: For the xml files to work with this program they must be peprocessed to have each element on its own line. This can be done with a simple perl script:

``` bash
perl -pe 's/></>\n</g' inputfile.xml > outputfile.xml
```

