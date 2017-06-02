BEGIN;

CREATE TABLE tmp_all_violations (LIKE hpd_all_violations INCLUDING ALL);

ALTER TABLE tmp_all_violations ADD COLUMN lat numeric;
ALTER TABLE tmp_all_violations ADD COLUMN lng numeric;

INSERT INTO tmp_all_violations (
       SELECT hpd_all_violations.*, pluto_16v2.lat, pluto_16v2.lng 
       FROM hpd_all_violations 
       LEFT JOIN pluto_16v2 ON hpd_all_violations.bbl = pluto_16v2.bbl
);

DROP TABLE hpd_all_violations;
ALTER TABLE tmp_all_violations RENAME TO hpd_all_violations;

COMMIT;
