-- create
CREATE TABLE museum (
  museum_id INTEGER NOT NULL,
  museum_name VARCHAR(70) NOT NULL,
  address VARCHAR(70) NOT NULL,
  foundation_year INTEGER NOT NULL,
  latitude FLOAT(6) NOT NULL,
  longitude FLOAT(6) NOT NULL
);
CREATE TABLE excursion (
  excursion_id INTEGER NOT NULL,
  excursion_name VARCHAR(100) NOT NULL,
  museum_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  guide_id INTEGER
);
CREATE TABLE visitor (
  visitor_id INTEGER NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  gender CHAR(1) NOT NULL
);
create table schedule (
  schedule_id INTEGER NOT NULL,
  excursion_id INTEGER NOT NULL,
  starts_on TIMESTAMP NOT NULL
);
create table visitor_schedule (
  visitor_id INTEGER NOT NULL,
  schedule_id INTEGER NOT NULL
);
CREATE TABLE hall (
  hall_id INTEGER NOT NULL,
  hall_name VARCHAR(100) NOT NULL,
  floor INTEGER NOT NULL,
  museum_id INTEGER NOT NULL
);
CREATE TABLE exhibit (
  exhibit_id INTEGER NOT NULL,
  exhibit_name VARCHAR(150) NOT NULL,
  author VARCHAR(150),
  hall_id INTEGER NOT NULL,
  year_of_creation INTEGER,
  country_of_creation VARCHAR(50)
);
CREATE TABLE guide (
  guide_id INTEGER NOT NULL,
  first_name VARCHAR(20) NOT NULL,
  phone CHAR(12) NOT NULL
);
ALTER TABLE museum ADD PRIMARY KEY (museum_id);
ALTER TABLE excursion ADD PRIMARY KEY (excursion_id);
ALTER TABLE visitor ADD PRIMARY KEY (visitor_id);
ALTER TABLE schedule ADD PRIMARY KEY (schedule_id);
ALTER TABLE hall ADD PRIMARY KEY (hall_id);
ALTER TABLE exhibit ADD PRIMARY KEY (exhibit_id);
ALTER TABLE guide ADD PRIMARY KEY (guide_id);

ALTER TABLE visitor_schedule ADD CONSTRAINT fk_visitor_id FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id);
ALTER TABLE visitor_schedule ADD CONSTRAINT fk_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id);
ALTER TABLE schedule ADD CONSTRAINT fk_excursion_id FOREIGN KEY (excursion_id) REFERENCES excursion(excursion_id);
ALTER TABLE excursion ADD CONSTRAINT fk_museum_id_excursion FOREIGN KEY (museum_id) REFERENCES museum(museum_id);
ALTER TABLE excursion ADD CONSTRAINT fk_guide_id FOREIGN KEY (guide_id) REFERENCES guide(guide_id);
ALTER TABLE hall ADD CONSTRAINT fk_museum_id_hall FOREIGN KEY (museum_id) REFERENCES museum(museum_id);
ALTER TABLE exhibit ADD CONSTRAINT fk_hall_id FOREIGN KEY (hall_id) REFERENCES hall(hall_id);
/*
DROP TABLE exhibit CASCADE;
DROP TABLE hall CASCADE;
DROP TABLE schedule CASCADE;
DROP TABLE visitor_sched CASCADE;
DROP TABLE excursion CASCADE;
DROP TABLE guide CASCADE;
DROP TABLE visitor CASCADE;
DROP TABLE museum CASCADE;
*/
