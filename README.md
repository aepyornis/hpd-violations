## HPD-Violation XML to CSV converter

USE: python3 parse_violations.py input [output]

The input can be a single xml file or a directory (and subdirectories) of files. If no output is provided, it will produce an output csv with the same name as the input. For example, python3 parse_violations.py Violations20150201.xml creates Violations20150201.csv.

HPD violation XML files can download from their website here: [HPD Open Data - Violations]( http://www1.nyc.gov/site/hpd/about/violation-open-data.page)

IMPORTANT NOTE: For the xml files to work with this program they must be peprocessed to have each element on its own line. This can be done with a simple perl script:

``` bash
perl -pe 's/></>\n</g' inputfile.xml > outputfile.xml
```


