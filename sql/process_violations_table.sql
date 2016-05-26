BEGIN;

ALTER TABLE  violations ADD COLUMN bbl char(10);
UPDATE violations SET bbl = boroid || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE violations add COLUMN lat numeric;
ALTER TABLE violations add COLUMN lng numeric;

UPDATE violations SET 
    lat = bbl_lookup.lat, 
    lng = bbl_lookup.lng 
FROM bbl_lookup 
WHERE violations.bbl = bbl_lookup.bbl;

COMMIT;
