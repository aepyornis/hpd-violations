BEGIN;

ALTER TABLE  hpd_violations ADD COLUMN bbl char(10);
UPDATE hpd_violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

COMMIT;

CREATE INDEX on hpd_violations(bbl);
