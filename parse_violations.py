"""
This program converts HPD Violation XML files into CSVs
Copyright (C) 2015 Ziggy Mintz

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
import xml.etree.ElementTree as ET
import csv
import argparse

parser = argparse.ArgumentParser(description='converts HPD violations data (XML format) into CSVs')
parser.add_argument('input', help='input xml file')
parser.add_argument('output', help='output file')
args = parser.parse_args()

PATH_TO_VIOLATIONS = args.input
CSV_FILE_NAME = args.output

FIELDS = ['ViolationID', 'BuildingID', 'RegistrationID', 'BoroName', 'Boro', 'HouseNumber', 'LowHouseNumber', 'HighHouseNumber', 'StreetName', 'StreetCode', 'Zip', 'Block', 'Lot', 'Class', 'InspectionDate', 'OriginalCertifyByDate', 'OriginalCorrectByDate', 'NewCertifyByDate', 'NewCorrectByDate', 'CertifiedDate', 'OrderNumber', 'NOVID', 'NOVDescription', 'NOVIssuedDate', 'GroupName', 'SeqNo', 'ShortName', 'LongName', 'Order', 'CurrentStatusDate']

def write_headers():
    with open(CSV_FILE_NAME, 'a') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()  

def parse_one_violation(one_violation):
    root = ET.fromstring(one_violation)
    violation = {}
    # loop through to build dictionary
    for child in root:
        violation[child.tag] = child.text
    #get borough name
    violation['BoroName'] = root.find('Boro').find('ShortName').text
    # overwrite existing Boro with it's code (1,2,3,4,5)
    violation['Boro'] = root.find('Boro').find('SeqNo').text
    # loop through current status element
    for child in root.find('CurrentStatus'):
        violation[child.tag] = child.text
    # delete CurrentStatus dictionary element which contains nothing.
    # All details of current status are extracted in the above loop statement
    del violation['CurrentStatus']
    # write csv
    with open (CSV_FILE_NAME, 'a') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter='|')
        writer.writerow(violation)

def XML_to_csv():
    with open (PATH_TO_VIOLATIONS, 'r') as f:
        one_violation = ''
        for line in f:
            if line == '<Violation xmlns:i="http://www.w3.org/2001/XMLSchema-instance">\n':
                one_violation = line
            elif line == '</Violation>\n':
                one_violation += line
                parse_one_violation(one_violation)
            else:
                one_violation += line


if __name__ == "__main__":
    write_headers()
    XML_to_csv()
