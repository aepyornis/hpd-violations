DROP TABLE if exists hpd_all_violations;

-- create all_violations which initially contains everything from the open violations table
create table hpd_all_violations as (
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
       FROM hpd_open_violations 
);

-- add the 'records' columns that exists in the uniq_violations table
ALTER TABLE hpd_all_violations ADD COLUMN records int;
-- since there is only one entry per violation in the open violations data all rows should have records = 1
UPDATE hpd_all_violations set records = 1;
-- add unique constraint to ensure that there is no duplicate violations
ALTER TABLE hpd_all_violations ADD UNIQUE (violationid);

--Add datasource column to both open violations and uniq_violations;
-- 'O' -> All Open Violations
-- 'R' -> 'Regular' violations data
ALTER TABLE hpd_all_violations ADD COLUMN datasource char(1);
UPDATE hpd_all_violations SET datasource = 'O';
ALTER TABLE hpd_uniq_violations ADD COLUMN datasource char(1);
UPDATE hpd_uniq_violations SET datasource = 'R';

-- insert those records of uniq_violations into all_violations
-- only if the violationid does not already exist in the open_violations data
insert into hpd_all_violations (
       select hpd_uniq_violations.* 
       from hpd_uniq_violations
       left join hpd_open_violations
       on hpd_uniq_violations.violationid = hpd_open_violations.violationid
       where hpd_open_violations.violationid is null
);

ALTER TABLE hpd_all_violations ADD PRIMARY KEY (violationid);
