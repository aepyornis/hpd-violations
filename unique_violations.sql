BEGIN;

DROP TABLE IF EXISTS uniq_violations;

-- Using "distinct on (violationid)" results in a set with one less row than without.
-- There is (at least with the data through April 2016) one violationid with two entrees 
-- for the same currentstatusdate, which is probably a mistake.

create table uniq_violations as (
       select distinct on(v1.violationid) v1.violationid,
                v1.buildingid,
                v1.registrationid,
                v1.housenumber,
                v1.streetname,
                v1.apartment,
                v1.zip,
                v1.violationclass,
                v1.inspectiondate,
                v1.originalcertifybydate,
                v1.originalcorrectbydate,
                v1.newcertifybydate,
                v1.newcorrectbydate,
                v1.certifieddate,
                v1.currentstatusid,
                v1.currentstatus,
                v1.currentstatusdate,
                v1.bbl,
                v1.lat,
                v1.lng,
                v2.records
       from violations as v1
       inner join (
             select Max(currentstatusdate) as currentstatusdate, 
                    count(violationid) as records, 
                    violationid
             from violations
             group by violationid       
       ) as v2
       on v1.violationid = v2.violationid
       and v1.currentstatusdate = v2.currentstatusdate
);

ALTER TABLE uniq_violations ADD PRIMARY KEY (violationid);

COMMIT;

BEGIN;

CREATE INDEX on uniq_violations(bbl);
CREATE INDEX on uniq_violations(registrationid);
CREATE INDEX on uniq_violations(violationclass);
CREATE INDEX on uniq_violations(inspectiondate);
CREATE INDEX on uniq_violations(CertifiedDate);
CREATE INDEX on uniq_violations(CurrentStatusID);
CREATE INDEX on uniq_violations(CurrentStatusDate);

COMMIT;
