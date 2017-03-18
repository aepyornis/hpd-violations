BEGIN;

ALTER TABLE violations add COLUMN lat numeric;
ALTER TABLE violations add COLUMN lng numeric;

UPDATE violations SET 
    lat = pluto_16v2.lat, 
    lng = pluto_16v2.lng 
FROM pluto_16v2
WHERE violations.bbl = pluto_16v2.bbl;

COMMIT;

BEGIN;

ALTER TABLE all_violations add COLUMN lat numeric;
ALTER TABLE all_violations add COLUMN lng numeric;

UPDATE all_violations SET 
    lat = pluto_16v2.lat, 
    lng = pluto_16v2.lng 
FROM pluto_16v2
WHERE all_violations.bbl = pluto_16v2.bbl;

COMMIT;

BEGIN;

ALTER TABLE uniq_violations add COLUMN lat numeric;
ALTER TABLE uniq_violations add COLUMN lng numeric;

UPDATE uniq_violations SET 
    lat = pluto_16v2.lat, 
    lng = pluto_16v2.lng 
FROM pluto_16v2
WHERE uniq_violations.bbl = pluto_16v2.bbl;

COMMIT;

BEGIN;

ALTER TABLE open_violations add COLUMN lat numeric;
ALTER TABLE open_violations add COLUMN lng numeric;

UPDATE open_violations SET 
    lat = pluto_16v2.lat, 
    lng = pluto_16v2.lng 
FROM pluto_16v2
WHERE open_violations.bbl = pluto_16v2.bbl;

COMMIT;
