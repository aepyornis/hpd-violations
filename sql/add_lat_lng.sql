BEGIN;

CREATE TABLE tmp_all_violations (LIKE all_violations INCLUDING ALL);

ALTER TABLE tmp_all_violations ADD COLUMN lat numeric;
ALTER TABLE tmp_all_violations ADD COLUMN lng numeric;

INSERT INTO tmp_all_violations (
       SELECT all_violations.*, pluto_16v2.lat, pluto_16v2.lng 
       FROM all_violations 
       LEFT JOIN pluto_16v2 ON all_violations.bbl = pluto_16v2.bbl
);

DROP TABLE all_violations;
ALTER TABLE tmp_all_violations RENAME TO all_violations;

COMMIT;
