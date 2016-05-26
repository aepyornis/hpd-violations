BEGIN;

CREATE TABLE bbl_lookup (
       lat numeric,
       lng numeric,
       bbl char(10) PRIMARY KEY
);

COMMIT;
