CREATE TABLE People (
  PID char(4) not null,
  Name text,
  Address text,
  Birthday date,
  HairColor text,
  EyeColor text,
  Height integer,
  Weight integer,
  FavColor text,
  PRIMARY KEY (`PID`)
);

CREATE TABLE Directors (
  PID char(4) not null references People(PID),
  FilmSchool text
  FavoriteLensMaker text,
  DirectorsGuildDate date,
  primary key (PID)
);

CREATE TABLE MarriedPeople (
  PID char(4) not null references People(PID),
  SpouseName text,
  KEY PK, FK (PID)
);

CREATE TABLE Actors (
  PID char(4) not null references People(PID),
  ActorsGuildDate date,
  KEY PK, FK (PID)
);

CREATE TABLE DirectorList (
  PID char(4) not null references People(PID),
  MID char(4) not null references Movie(MID),
  primary key (PID, MID)
);

CREATE TABLE Movie (
  MID char(4) not null,
  Name text,
  YearReleased char(4),
  MPAANumber integer,
  DomesticBoxOfficeSales numeric(12,2),
  ForeignBoxOfficeSales numeric(12,2),
  DVD/BluRaySales integer,
  primary key(MID)
);







