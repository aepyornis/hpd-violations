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
import os

FIELDS = ['ViolationID', 'BuildingID', 'RegistrationID', 'BoroName', 'Boro', 'HouseNumber', 'LowHouseNumber', 'HighHouseNumber', 'StreetName', 'StreetCode', 'Zip', 'Apartment', 'Story', 'Block', 'Lot', 'Class', 'InspectionDate', 'ApprovedDate', 'OriginalCertifyByDate', 'OriginalCorrectByDate', 'NewCertifyByDate', 'NewCorrectByDate', 'CertifiedDate', 'OrderNumber', 'NOVID', 'NOVDescription', 'NOVIssuedDate', 'GroupName', 'SeqNo', 'ShortName', 'LongName', 'Order', 'CurrentStatusDate']

def write_headers(out_file, fields=FIELDS):
    with open(out_file, 'a') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()  

def parse_one_violation(one_violation, out_file):
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
    with open (out_file, 'a') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter='|')
        writer.writerow(violation)

def XML_to_csv(PATH_TO_VIOLATIONS, out_file):
    with open (PATH_TO_VIOLATIONS, 'r') as f:
        one_violation = ''
        for line in f:
            if line == '<Violation xmlns:i="http://www.w3.org/2001/XMLSchema-instance">\n':
                one_violation = line
            elif line == '</Violation>\n':
                one_violation += line
                parse_one_violation(one_violation, out_file)
            else:
                one_violation += line

def process_dir(INPUT_PATH, output_dir=None):
    for root, dirs, files in os.walk(INPUT_PATH):
        for file in files:
            file_ext = os.path.splitext(file)[1]
            full_path = os.path.join(root, file)
            if file_ext == '.xml' or file_ext == '.XML':
                # determine output path
                if output_dir:
                    csv_file_path = os.path.join(output_dir, os.path.splitext(file)[0] + '.csv')
                else:
                    csv_file_path = os.path.join(root, os.path.splitext(file)[0] + '.csv')
                # process file
                write_headers(csv_file_path)
                XML_to_csv(full_path, csv_file_path)
                print(file + " is done")
            else:
                pass # not a csv

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='converts HPD violations data (XML format) into CSVs')
    parser.add_argument('input', help='input xml file or directory')
    parser.add_argument('output', help='output file or output directory',nargs='?') 
    args = parser.parse_args()

    INPUT_PATH = args.input

    if args.output:
        CSV_FILE_NAME = args.output
    else:
        CSV_FILE_NAME = os.path.splitext(INPUT_PATH)[0] + '.csv'

    file_ext = os.path.splitext(INPUT_PATH)[1]
    
    if file_ext == '.xml' or file_ext == '.XML':
        write_headers(CSV_FILE_NAME)
        XML_to_csv(INPUT_PATH, CSV_FILE_NAME)
    elif file_ext == '':
        process_dir(INPUT_PATH, args.output);
    else:
        print('INPUT is not an xml file or a directory')
