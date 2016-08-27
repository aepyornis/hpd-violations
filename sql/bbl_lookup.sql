BEGIN;

DROP TABLE IF EXISTS bbl_lookup;

CREATE TABLE bbl_lookup (
       lat numeric,
       lng numeric,
       bbl char(10) PRIMARY KEY
);

COMMIT;
