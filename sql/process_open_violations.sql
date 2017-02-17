BEGIN;

ALTER TABLE  open_violations ADD COLUMN bbl char(10);
UPDATE open_violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

COMMIT;

