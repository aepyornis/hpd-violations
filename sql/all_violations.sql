DROP TABLE if exists all_violations;

-- create all_violations which initially contains everything from the open violations table
create table all_violations as (
       select violationid,          
              buildingid,            
              registrationid,        
              housenumber,           
              streetname,            
              apartment,             
              zip,                   
              violationclass,        
              inspectiondate,        
              originalcertifybydate, 
              originalcorrectbydate, 
              newcertifybydate,      
              newcorrectbydate,      
              certifieddate,         
              novdescription,        
              currentstatusid,       
              currentstatus,         
              currentstatusdate,     
              bbl
       FROM open_violations 
);

-- add the 'records' columns that exists in the uniq_violations table
ALTER TABLE all_violations ADD COLUMN records int;
-- since there is only one entry per violation in the open violations data all rows should have records = 1
UPDATE all_violations set records = 1;
-- add unique constraint to ensure that there is no duplicate violations
ALTER TABLE all_violations ADD UNIQUE (violationid);

--Add datasource column to both open violations and uniq_violations;
-- 'O' -> All Open Violations
-- 'R' -> 'Regular' violations data
ALTER TABLE all_violations ADD COLUMN datasource char(1);
UPDATE all_violations SET datasource = 'O';
ALTER TABLE uniq_violations ADD COLUMN datasource char(1);
UPDATE uniq_violations SET datasource = 'R';

-- insert those records of uniq_violations into all_violations
-- only if the violationid does not already exists in the open_violations data
insert into all_violations (
       select uniq_violations.* 
       from uniq_violations
       left join open_violations
       on uniq_violations.violationid = open_violations.violationid
       where open_violations.violationid is null
);

ALTER TABLE all_violations ADD PRIMARY KEY (violationid);

-- Add Lat & Lng Columns
ALTER TABLE all_violations ADD COLUMN lat numeric;
ALTER TABLE all_violations ADD COLUMN lng numeric;


CREATE INDEX on all_violations(bbl);
CREATE INDEX on all_violations(datasource);
CREATE INDEX on all_violations(registrationid);
CREATE INDEX on all_violations(violationclass);
CREATE INDEX on all_violations(inspectiondate);
CREATE INDEX on all_violations(CertifiedDate);
CREATE INDEX on all_violations(CurrentStatusID);
CREATE INDEX on all_violations(CurrentStatusDate);
CREATE INDEX on all_violations(currentstatusdate, violationid);
