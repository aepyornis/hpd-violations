ALTER TABLE  hpd_open_violations ADD COLUMN bbl char(10);
UPDATE hpd_open_violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

CREATE INDEX on hpd_open_violations(bbl);
