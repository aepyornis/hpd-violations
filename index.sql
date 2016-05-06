ALTER TABLE  violations ADD COLUMN bbl char(10);
UPDATE violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE violations ADD COLUMN id serial;
UPDATE violations SET id = DEFAULT;
ALTER TABLE violations ADD PRIMARY KEY (id);

CREATE INDEX on violations(bbl);
CREATE INDEX on violations(violationid);
CREATE INDEX on violations(registrationid);
CREATE INDEX on violations(violationclass);
CREATE INDEX on violations(inspectiondate);
CREATE INDEX on violations(CertifiedDate);
CREATE INDEX on violations(CurrentStatusID);
CREATE INDEX on violations(CurrentStatusDate);
