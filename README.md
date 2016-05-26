# HPD Violations
Creates a postgres database of housing violations in New York City. The Department of Housing, Preservation, and Development (HPD) releases every month a [dataset of all housing violations](https://www1.nyc.gov/site/hpd/about/open-data.page) they have issued. This code turns those CSV into a useful database. 

To build a database of hpd violations since 2015, run the following scripts:

``` bash
# Downloads all the data
./download_violations.sh
# Unzips the data & deletes the .xml files
./unzip.sh
# Inserts the data into postgres
./to_postgres.sh
```

This will produce 4 tables:

* *violations*:  Contains all violations since 2015. There are multiple entries for many violations. For instance, there might be an entry in May 2015 when the violation was opened and a second entry for the same violation in July 2015 when it was closed.
* *uniq_violations*: Contains one row for each unique violation in the violations table with the information of the most recent entry. 
* *open_violations*: Contains all currently open violations including those opened before 2015. HPD keeps a separate dataset of 'All Open Violations'. 
* *all_violations*: This is a combination of uniq_violations and open_violations. It contains all open violations (since the dawn of...hpd?) and all closed violations since 2015 and is careful to avoid duplicates between the two datasets.

There are two companion projects to this database:

[hpd-violations-server](https://github.com/aepyornis/hpd-violations-server) - A nodejs server serving JSON from the database

[hpd-violations-web](https://github.com/aepyornis/hpd-violations-web) - A website to look up buildings

#### Violation XML to CSV converter
See folder: _parse_violations_xml_

This this is an XML converter for HPD violation data. HPD provides data only in the XML format for all violation data prior to Aug. 2014. However, there are a complex set of schema changes prior to 2015 ([see HPD's metadata](http://www1.nyc.gov/assets/hpd/downloads/pdf/ViolationsOpenDataDoc.zip)), so I have temporarily abandoned the project of bringing in all historic violation data and instead I'm just dealing with the data since 2015. One day, I'd like to revisit the goal of parsing all the violation data.

*How to use the XML Violations Parser*

``` python3 parse_violations.py input [output] ```

The input can be a single xml file or a directory (and subdirectories) of files. If no output is provided, it will produce an output csv with the same name as the input. For example, python3 parse_violations.py Violations20150201.xml creates Violations20150201.csv.

The violation XML files can download from HPD's website here: [HPD Open Data - Violations](http://www1.nyc.gov/site/hpd/about/violation-open-data.page)

IMPORTANT NOTE: For the xml files to work with this program they must be pre-processed to have each element on its own line. This can be done with a simple perl script:

``` bash
perl -pe 's/></>\n</g' inputfile.xml > outputfile.xml
```

