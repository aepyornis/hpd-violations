-- generate add lat/lng from pluto
BEGIN;

CREATE TABLE bbl_lookup (
  lat numeric,
  lng numeric,
  bbl char(10) PRIMARY KEY
);

COPY bbl_lookup from '/home/michael/data/pluto/bbl_lat_lng.txt' (FORMAT CSV,  HEADER TRUE);

ALTER TABLE hpd.registrations add COLUMN lat numeric;
ALTER TABLE hpd.registrations add COLUMN lng numeric;

UPDATE violations SET 
       lat = hpd.bbl_lookup.lat, 
       lng = hpd.bbl_lookup.lng 
FROM bbl_lookup 
WHERE violationss.bbl = lookup.bbl;

DROP TABLE hpd.bbl_lookup;

COMMIT;

