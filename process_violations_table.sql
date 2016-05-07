BEGIN;

ALTER TABLE  violations ADD COLUMN bbl char(10);
UPDATE violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');


CREATE TABLE bbl_lookup (
  lat numeric,
  lng numeric,
  bbl char(10) PRIMARY KEY
);

COPY bbl_lookup from '/home/michael/data/pluto/bbl_lat_lng.txt' (FORMAT CSV,  HEADER TRUE);

ALTER TABLE violations add COLUMN lat numeric;
ALTER TABLE violations add COLUMN lng numeric;

UPDATE violations SET 
    lat = bbl_lookup.lat, 
    lng = bbl_lookup.lng 
FROM bbl_lookup 
WHERE violations.bbl = bbl_lookup.bbl;

DROP TABLE bbl_lookup;

ALTER TABLE violations ADD COLUMN id serial;
UPDATE violations SET id = DEFAULT;
ALTER TABLE violations ADD PRIMARY KEY (id);

COMMIT;


CREATE INDEX on violations(bbl);
CREATE INDEX on violations(violationid);
CREATE INDEX on violations(registrationid);
CREATE INDEX on violations(violationclass);
CREATE INDEX on violations(inspectiondate);
CREATE INDEX on violations(CertifiedDate);
CREATE INDEX on violations(CurrentStatusID);
CREATE INDEX on violations(CurrentStatusDate);
CREATE INDEX on violations (currentstatusdate, violationid);
