BEGIN;

drop table if exists violations;

create table violations (
  ViolationID integer,
  BuildingID integer,
  RegistrationID integer,
  BoroID char(1),
  Boro text,
  HouseNumber text,
  LowHouseNumber text,
  HighHouseNumber text,
  StreetName text,
  StreetCode integer,
  Zip char(5),
  Apartment text,
  Story text,
  Block integer,
  Lot integer,
  ViolationClass char(1),
  InspectionDate date,
  ApprovedDate date,
  OriginalCertifyByDate date,
  OriginalCorrectByDate date,
  NewCertifyByDate date,
  NewCorrectByDate date,
  CertifiedDate date,
  OrderNumber text,
  NOVID integer,
  NOVDescription text,
  NOVIssuedDate date,
  CurrentStatusID integer,
  CurrentStatus text,
  CurrentStatusDate date
);

COMMIT;
