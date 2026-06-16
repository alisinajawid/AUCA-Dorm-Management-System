
DROP SCHEMA IF EXISTS dorm_mgmt CASCADE;
CREATE SCHEMA dorm_mgmt;
SET search_path = dorm_mgmt, public;

CREATE TABLE building (
  building_id SERIAL PRIMARY KEY,
  name        VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE room_type (
  room_type_id SERIAL PRIMARY KEY,
  name         VARCHAR(40) UNIQUE NOT NULL,           
  capacity     INT NOT NULL CHECK (capacity BETWEEN 1 AND 6),
  monthly_rate NUMERIC(10,2) NOT NULL CHECK (monthly_rate >= 0)
);


CREATE TABLE room (
  room_id      SERIAL PRIMARY KEY,
  building_id  INT NOT NULL REFERENCES building(building_id) ON DELETE RESTRICT,
  room_type_id INT NOT NULL REFERENCES room_type(room_type_id) ON DELETE RESTRICT,
  room_no      VARCHAR(20) NOT NULL,
  status       VARCHAR(20) NOT NULL DEFAULT 'available',   
  deleted_at   TIMESTAMP,
  UNIQUE (building_id, room_no)
);

CREATE TABLE student (
  student_id  SERIAL PRIMARY KEY,
  full_name   VARCHAR(120) NOT NULL,
  email       VARCHAR(120) UNIQUE,
  phone       VARCHAR(40),
  gender      VARCHAR(10),
  deleted_at  TIMESTAMP
);

CREATE TABLE assignment (
  assignment_id SERIAL PRIMARY KEY,
  student_id    INT NOT NULL REFERENCES student(student_id) ON DELETE CASCADE,
  room_id       INT NOT NULL REFERENCES room(room_id) ON DELETE RESTRICT,
  bed_no        INT NOT NULL,
  start_date    DATE NOT NULL,
  end_date      DATE,
  active        BOOLEAN NOT NULL DEFAULT TRUE,
  CHECK (end_date IS NULL OR end_date >= start_date),
  UNIQUE (room_id, bed_no, active) DEFERRABLE INITIALLY IMMEDIATE
 
);


CREATE TABLE facility (
  facility_id SERIAL PRIMARY KEY,
  name        VARCHAR(80) UNIQUE NOT NULL     
);

CREATE TABLE room_facility (
  room_id     INT NOT NULL REFERENCES room(room_id) ON DELETE CASCADE,
  facility_id INT NOT NULL REFERENCES facility(facility_id) ON DELETE RESTRICT,
  PRIMARY KEY (room_id, facility_id)
);

CREATE TABLE payment (
  payment_id    SERIAL PRIMARY KEY,
  student_id    INT NOT NULL REFERENCES student(student_id) ON DELETE CASCADE,
  assignment_id INT REFERENCES assignment(assignment_id) ON DELETE SET NULL,
  period_start  DATE NOT NULL,
  period_end    DATE NOT NULL,
  amount        NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  status        VARCHAR(20) NOT NULL DEFAULT 'pending',  
  paid_at       TIMESTAMP,
  method        VARCHAR(20),  
  deleted_at    TIMESTAMP
);

CREATE TABLE maintenance_request (
  request_id  SERIAL PRIMARY KEY,
  room_id     INT NOT NULL REFERENCES room(room_id) ON DELETE CASCADE,
  student_id  INT REFERENCES student(student_id) ON DELETE SET NULL,
  priority    VARCHAR(10) NOT NULL DEFAULT 'medium',     -- low|medium|high
  category    VARCHAR(40) NOT NULL,                      -- plumbing|electric|furniture|other
  status      VARCHAR(20) NOT NULL DEFAULT 'open',       -- open|in_progress|resolved|cancelled
  description TEXT,
  created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at  TIMESTAMP
);

CREATE TABLE maintenance_log (
  log_id     SERIAL PRIMARY KEY,
  request_id INT NOT NULL REFERENCES maintenance_request(request_id) ON DELETE CASCADE,
  status     VARCHAR(20) NOT NULL,
  note       TEXT,
  at_time    TIMESTAMP NOT NULL DEFAULT NOW()
);
