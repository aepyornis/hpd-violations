BEGIN;

ALTER TABLE  violations ADD COLUMN bbl char(10);
UPDATE violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

COMMIT;
