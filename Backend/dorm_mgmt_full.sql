\restrict zbQRMfWGg7V4112CN1XPq1Gu6yfLqDq6XHDo0ppXCMjIpPP8OGI7hETTNNgYY77


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA dorm_mgmt;


ALTER SCHEMA dorm_mgmt OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE dorm_mgmt.assignment (
    assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    room_id integer NOT NULL,
    bed_no integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    active boolean DEFAULT true NOT NULL,
    CONSTRAINT assignment_check CHECK (((end_date IS NULL) OR (end_date >= start_date)))
);


ALTER TABLE dorm_mgmt.assignment OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.assignment_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.assignment_assignment_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.assignment_assignment_id_seq OWNED BY dorm_mgmt.assignment.assignment_id;



CREATE TABLE dorm_mgmt.building (
    building_id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE dorm_mgmt.building OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.building_building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.building_building_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.building_building_id_seq OWNED BY dorm_mgmt.building.building_id;



CREATE TABLE dorm_mgmt.facility (
    facility_id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE dorm_mgmt.facility OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.facility_facility_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.facility_facility_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.facility_facility_id_seq OWNED BY dorm_mgmt.facility.facility_id;



CREATE TABLE dorm_mgmt.maintenance_log (
    log_id integer NOT NULL,
    request_id integer NOT NULL,
    status character varying(20) NOT NULL,
    note text,
    at_time timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dorm_mgmt.maintenance_log OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.maintenance_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.maintenance_log_log_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.maintenance_log_log_id_seq OWNED BY dorm_mgmt.maintenance_log.log_id;



CREATE TABLE dorm_mgmt.maintenance_request (
    request_id integer NOT NULL,
    room_id integer NOT NULL,
    student_id integer,
    priority character varying(10) DEFAULT 'medium'::character varying NOT NULL,
    category character varying(40) NOT NULL,
    status character varying(20) DEFAULT 'open'::character varying NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dorm_mgmt.maintenance_request OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.maintenance_request_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.maintenance_request_request_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.maintenance_request_request_id_seq OWNED BY dorm_mgmt.maintenance_request.request_id;



CREATE TABLE dorm_mgmt.payment (
    payment_id integer NOT NULL,
    student_id integer NOT NULL,
    assignment_id integer,
    period_start date NOT NULL,
    period_end date NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    paid_at timestamp without time zone,
    method character varying(20),
    CONSTRAINT payment_amount_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE dorm_mgmt.payment OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.payment_payment_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.payment_payment_id_seq OWNED BY dorm_mgmt.payment.payment_id;



CREATE TABLE dorm_mgmt.room (
    room_id integer NOT NULL,
    building_id integer NOT NULL,
    room_type_id integer NOT NULL,
    room_no character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'available'::character varying NOT NULL
);


ALTER TABLE dorm_mgmt.room OWNER TO postgres;


CREATE TABLE dorm_mgmt.room_facility (
    room_id integer NOT NULL,
    facility_id integer NOT NULL
);


ALTER TABLE dorm_mgmt.room_facility OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.room_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.room_room_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.room_room_id_seq OWNED BY dorm_mgmt.room.room_id;



CREATE TABLE dorm_mgmt.room_type (
    room_type_id integer NOT NULL,
    name character varying(40) NOT NULL,
    capacity integer NOT NULL,
    monthly_rate numeric(10,2) NOT NULL,
    CONSTRAINT room_type_capacity_check CHECK (((capacity >= 1) AND (capacity <= 6))),
    CONSTRAINT room_type_monthly_rate_check CHECK ((monthly_rate >= (0)::numeric))
);


ALTER TABLE dorm_mgmt.room_type OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.room_type_room_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.room_type_room_type_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.room_type_room_type_id_seq OWNED BY dorm_mgmt.room_type.room_type_id;



CREATE TABLE dorm_mgmt.student (
    student_id integer NOT NULL,
    full_name character varying(120) NOT NULL,
    email character varying(120),
    phone character varying(40),
    gender character varying(10)
);


ALTER TABLE dorm_mgmt.student OWNER TO postgres;


CREATE SEQUENCE dorm_mgmt.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dorm_mgmt.student_student_id_seq OWNER TO postgres;


ALTER SEQUENCE dorm_mgmt.student_student_id_seq OWNED BY dorm_mgmt.student.student_id;



ALTER TABLE ONLY dorm_mgmt.assignment ALTER COLUMN assignment_id SET DEFAULT nextval('dorm_mgmt.assignment_assignment_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.building ALTER COLUMN building_id SET DEFAULT nextval('dorm_mgmt.building_building_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.facility ALTER COLUMN facility_id SET DEFAULT nextval('dorm_mgmt.facility_facility_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.maintenance_log ALTER COLUMN log_id SET DEFAULT nextval('dorm_mgmt.maintenance_log_log_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.maintenance_request ALTER COLUMN request_id SET DEFAULT nextval('dorm_mgmt.maintenance_request_request_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.payment ALTER COLUMN payment_id SET DEFAULT nextval('dorm_mgmt.payment_payment_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.room ALTER COLUMN room_id SET DEFAULT nextval('dorm_mgmt.room_room_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.room_type ALTER COLUMN room_type_id SET DEFAULT nextval('dorm_mgmt.room_type_room_type_id_seq'::regclass);



ALTER TABLE ONLY dorm_mgmt.student ALTER COLUMN student_id SET DEFAULT nextval('dorm_mgmt.student_student_id_seq'::regclass);



COPY dorm_mgmt.assignment (assignment_id, student_id, room_id, bed_no, start_date, end_date, active) FROM stdin;
1	1	1	1	2025-09-01	\N	t
3	3	3	1	2025-09-10	\N	t
2	2	1	2	2025-09-01	2025-11-19	f
4	2	2	1	2025-11-19	\N	t
\.



COPY dorm_mgmt.building (building_id, name) FROM stdin;
1	Ala-Too
2	Issyk-Kul
\.



COPY dorm_mgmt.facility (facility_id, name) FROM stdin;
1	AC
2	PrivateBathroom
3	Balcony
\.



COPY dorm_mgmt.maintenance_log (log_id, request_id, status, note, at_time) FROM stdin;
1	1	open	Ticket created	2025-11-19 10:41:22.218332
2	1	in_progress	Plumber assigned	2025-11-19 10:41:22.218332
\.



COPY dorm_mgmt.maintenance_request (request_id, room_id, student_id, priority, category, status, description, created_at) FROM stdin;
1	1	1	high	plumbing	open	Leak under sink	2025-11-19 10:41:22.217473
\.



COPY dorm_mgmt.payment (payment_id, student_id, assignment_id, period_start, period_end, amount, status, paid_at, method) FROM stdin;
1	1	1	2025-09-01	2025-09-30	8000.00	paid	2025-09-05 00:00:00	card
2	2	2	2025-09-01	2025-09-30	8000.00	pending	\N	cash
3	3	3	2025-09-01	2025-09-30	12000.00	paid	2025-09-12 00:00:00	transfer
4	2	4	2025-11-01	2025-11-30	8000.00	pending	\N	cash
\.



COPY dorm_mgmt.room (room_id, building_id, room_type_id, room_no, status) FROM stdin;
1	1	2	201	available
2	1	2	202	available
3	1	1	301	available
4	2	3	101	available
\.



COPY dorm_mgmt.room_facility (room_id, facility_id) FROM stdin;
1	1
1	2
2	1
3	2
4	1
4	3
\.



COPY dorm_mgmt.room_type (room_type_id, name, capacity, monthly_rate) FROM stdin;
1	Single	1	12000.00
2	Double	2	8000.00
3	Triple	3	6000.00
\.



COPY dorm_mgmt.student (student_id, full_name, email, phone, gender) FROM stdin;
1	Aizada A.	aizada@uni.kg	0500-111-222	F
2	Sanzhar S.	sanzhar@uni.kg	0500-333-444	M
3	Meerim B.	meerim@uni.kg	0500-555-666	F
\.



SELECT pg_catalog.setval('dorm_mgmt.assignment_assignment_id_seq', 4, true);



SELECT pg_catalog.setval('dorm_mgmt.building_building_id_seq', 2, true);



SELECT pg_catalog.setval('dorm_mgmt.facility_facility_id_seq', 3, true);



SELECT pg_catalog.setval('dorm_mgmt.maintenance_log_log_id_seq', 2, true);



SELECT pg_catalog.setval('dorm_mgmt.maintenance_request_request_id_seq', 1, true);



SELECT pg_catalog.setval('dorm_mgmt.payment_payment_id_seq', 4, true);



SELECT pg_catalog.setval('dorm_mgmt.room_room_id_seq', 4, true);



SELECT pg_catalog.setval('dorm_mgmt.room_type_room_type_id_seq', 3, true);



SELECT pg_catalog.setval('dorm_mgmt.student_student_id_seq', 3, true);



ALTER TABLE ONLY dorm_mgmt.assignment
    ADD CONSTRAINT assignment_pkey PRIMARY KEY (assignment_id);



ALTER TABLE ONLY dorm_mgmt.assignment
    ADD CONSTRAINT assignment_room_id_bed_no_active_key UNIQUE (room_id, bed_no, active) DEFERRABLE;



ALTER TABLE ONLY dorm_mgmt.building
    ADD CONSTRAINT building_name_key UNIQUE (name);



ALTER TABLE ONLY dorm_mgmt.building
    ADD CONSTRAINT building_pkey PRIMARY KEY (building_id);



ALTER TABLE ONLY dorm_mgmt.facility
    ADD CONSTRAINT facility_name_key UNIQUE (name);



ALTER TABLE ONLY dorm_mgmt.facility
    ADD CONSTRAINT facility_pkey PRIMARY KEY (facility_id);



ALTER TABLE ONLY dorm_mgmt.maintenance_log
    ADD CONSTRAINT maintenance_log_pkey PRIMARY KEY (log_id);



ALTER TABLE ONLY dorm_mgmt.maintenance_request
    ADD CONSTRAINT maintenance_request_pkey PRIMARY KEY (request_id);



ALTER TABLE ONLY dorm_mgmt.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);



ALTER TABLE ONLY dorm_mgmt.room
    ADD CONSTRAINT room_building_id_room_no_key UNIQUE (building_id, room_no);



ALTER TABLE ONLY dorm_mgmt.room_facility
    ADD CONSTRAINT room_facility_pkey PRIMARY KEY (room_id, facility_id);



ALTER TABLE ONLY dorm_mgmt.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_id);



ALTER TABLE ONLY dorm_mgmt.room_type
    ADD CONSTRAINT room_type_name_key UNIQUE (name);



ALTER TABLE ONLY dorm_mgmt.room_type
    ADD CONSTRAINT room_type_pkey PRIMARY KEY (room_type_id);



ALTER TABLE ONLY dorm_mgmt.student
    ADD CONSTRAINT student_email_key UNIQUE (email);



ALTER TABLE ONLY dorm_mgmt.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);



CREATE INDEX idx_assign_room ON dorm_mgmt.assignment USING btree (room_id) WHERE active;



CREATE INDEX idx_assign_student ON dorm_mgmt.assignment USING btree (student_id) WHERE active;



CREATE INDEX idx_payment_status ON dorm_mgmt.payment USING btree (status);



CREATE INDEX idx_payment_student ON dorm_mgmt.payment USING btree (student_id);



CREATE INDEX idx_req_room ON dorm_mgmt.maintenance_request USING btree (room_id);



CREATE INDEX idx_req_status ON dorm_mgmt.maintenance_request USING btree (status);



CREATE INDEX idx_room_building ON dorm_mgmt.room USING btree (building_id);



CREATE INDEX idx_room_type ON dorm_mgmt.room USING btree (room_type_id);



ALTER TABLE ONLY dorm_mgmt.assignment
    ADD CONSTRAINT assignment_room_id_fkey FOREIGN KEY (room_id) REFERENCES dorm_mgmt.room(room_id) ON DELETE RESTRICT;



ALTER TABLE ONLY dorm_mgmt.assignment
    ADD CONSTRAINT assignment_student_id_fkey FOREIGN KEY (student_id) REFERENCES dorm_mgmt.student(student_id) ON DELETE CASCADE;



ALTER TABLE ONLY dorm_mgmt.maintenance_log
    ADD CONSTRAINT maintenance_log_request_id_fkey FOREIGN KEY (request_id) REFERENCES dorm_mgmt.maintenance_request(request_id) ON DELETE CASCADE;



ALTER TABLE ONLY dorm_mgmt.maintenance_request
    ADD CONSTRAINT maintenance_request_room_id_fkey FOREIGN KEY (room_id) REFERENCES dorm_mgmt.room(room_id) ON DELETE CASCADE;



ALTER TABLE ONLY dorm_mgmt.maintenance_request
    ADD CONSTRAINT maintenance_request_student_id_fkey FOREIGN KEY (student_id) REFERENCES dorm_mgmt.student(student_id) ON DELETE SET NULL;



ALTER TABLE ONLY dorm_mgmt.payment
    ADD CONSTRAINT payment_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES dorm_mgmt.assignment(assignment_id) ON DELETE SET NULL;



ALTER TABLE ONLY dorm_mgmt.payment
    ADD CONSTRAINT payment_student_id_fkey FOREIGN KEY (student_id) REFERENCES dorm_mgmt.student(student_id) ON DELETE CASCADE;



ALTER TABLE ONLY dorm_mgmt.room
    ADD CONSTRAINT room_building_id_fkey FOREIGN KEY (building_id) REFERENCES dorm_mgmt.building(building_id) ON DELETE RESTRICT;



ALTER TABLE ONLY dorm_mgmt.room_facility
    ADD CONSTRAINT room_facility_facility_id_fkey FOREIGN KEY (facility_id) REFERENCES dorm_mgmt.facility(facility_id) ON DELETE RESTRICT;



ALTER TABLE ONLY dorm_mgmt.room_facility
    ADD CONSTRAINT room_facility_room_id_fkey FOREIGN KEY (room_id) REFERENCES dorm_mgmt.room(room_id) ON DELETE CASCADE;



ALTER TABLE ONLY dorm_mgmt.room
    ADD CONSTRAINT room_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES dorm_mgmt.room_type(room_type_id) ON DELETE RESTRICT;



\unrestrict zbQRMfWGg7V4112CN1XPq1Gu6yfLqDq6XHDo0ppXCMjIpPP8OGI7hETTNNgYY77

