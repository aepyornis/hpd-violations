BEGIN;

ALTER TABLE  open_violations ADD COLUMN bbl char(10);
UPDATE open_violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE open_violations add COLUMN lat numeric;
ALTER TABLE open_violations add COLUMN lng numeric;

UPDATE open_violations SET 
    lat = bbl_lookup.lat, 
    lng = bbl_lookup.lng 
FROM bbl_lookup 
WHERE open_violations.bbl = bbl_lookup.bbl;

COMMIT;

