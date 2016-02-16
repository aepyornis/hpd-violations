ALTER TABLE  hpd.violations ADD COLUMN bbl char(10);
UPDATE hpd.violations SET bbl = boro || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE hpd.violations ADD COLUMN id serial;
UPDATE hpd.violations SET id = DEFAULT;
ALTER TABLE hpd.violations ADD PRIMARY KEY (id);

CREATE INDEX on hpd.violations(bbl);
CREATE INDEX on hpd.violations(violationid);
CREATE INDEX on hpd.violations(registrationid);
CREATE INDEX on hpd.violations(violationclass);
CREATE INDEX on hpd.violations(inspectiondate);
CREATE INDEX on hpd.violations(seqno);
