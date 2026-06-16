SET search_path = dorm_mgmt, public;

TRUNCATE building, room_type, room, facility, room_facility, student, assignment, payment, maintenance_request, maintenance_log CASCADE;

ALTER SEQUENCE building_building_id_seq RESTART WITH 1;
ALTER SEQUENCE room_type_room_type_id_seq RESTART WITH 1;
ALTER SEQUENCE room_room_id_seq RESTART WITH 1;
ALTER SEQUENCE facility_facility_id_seq RESTART WITH 1;
ALTER SEQUENCE student_student_id_seq RESTART WITH 1;
ALTER SEQUENCE assignment_assignment_id_seq RESTART WITH 1;
ALTER SEQUENCE payment_payment_id_seq RESTART WITH 1;
ALTER SEQUENCE maintenance_request_request_id_seq RESTART WITH 1;
ALTER SEQUENCE maintenance_log_log_id_seq RESTART WITH 1;

INSERT INTO building (name) VALUES 
('Basement Floor'),
('First Floor'),
('Second Floor'),
('Third Floor'),
('Fourth Floor'),
('Fifth Floor');

INSERT INTO room_type (name, capacity, monthly_rate) VALUES
('Single', 1, 15000.00),
('Double', 2, 10000.00),
('Triple', 3, 7500.00),
('Quad', 4, 6000.00);

INSERT INTO facility (name) VALUES 
('AC'),
('Private Bathroom'),
('Balcony'),
('Mini Fridge'),
('Study Desk'),
('Wardrobe'),
('Shared Bathroom');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(1, 2, 'B01-Kitchen', 'available'),
(1, 2, 'B02-Common', 'available');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(2, 2, '101-Hall', 'available'),
(2, 1, '102-Guard', 'occupied');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(3, 2, '201', 'available'),
(3, 2, '202', 'available'),
(3, 3, '203', 'available'),
(3, 2, '204', 'available'),
(3, 2, '205', 'available'),
(3, 3, '206', 'available'),
(3, 2, '207', 'available'),
(3, 2, '208', 'available'),
(3, 2, '209', 'available'),
(3, 2, '210', 'available');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(4, 2, '301', 'available'),
(4, 2, '302', 'available'),
(4, 3, '303', 'available'),
(4, 2, '304', 'available'),
(4, 1, '305', 'available'),
(4, 3, '306', 'available'),
(4, 2, '307', 'available'),
(4, 2, '308', 'available'),
(4, 2, '309', 'available'),
(4, 2, '310', 'available');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(5, 2, '401', 'available'),
(5, 2, '402', 'available'),
(5, 3, '403', 'available'),
(5, 2, '404', 'available'),
(5, 2, '405', 'available'),
(5, 4, '406', 'available'),
(5, 2, '407', 'available'),
(5, 2, '408', 'available'),
(5, 2, '409', 'available'),
(5, 2, '410', 'available');

INSERT INTO room (building_id, room_type_id, room_no, status) VALUES
(6, 1, '501', 'available'),
(6, 1, '502', 'available'),
(6, 2, '503', 'available'),
(6, 2, '504', 'available'),
(6, 2, '505', 'available'),
(6, 3, '506', 'available'),
(6, 2, '507', 'available'),
(6, 2, '508', 'available'),
(6, 2, '509', 'available'),
(6, 2, '510', 'available');

INSERT INTO room_facility(room_id, facility_id) VALUES
(1, 4), (1, 5), (1, 6),
(2, 5), (2, 6),
(3, 5), (3, 6),
(4, 5);

INSERT INTO room_facility(room_id, facility_id) VALUES
(5, 1), (5, 5), (5, 6), (5, 7),
(6, 5), (6, 6), (6, 7),
(7, 5), (7, 6), (7, 7),
(8, 1), (8, 5), (8, 6), (8, 7),
(9, 5), (9, 6), (9, 7),
(10, 5), (10, 6), (10, 7),
(11, 1), (11, 5), (11, 6), (11, 7),
(12, 5), (12, 6), (12, 7),
(13, 5), (13, 6), (13, 7),
(14, 1), (14, 5), (14, 6), (14, 7);

INSERT INTO room_facility(room_id, facility_id) VALUES
(15, 1), (15, 5), (15, 6), (15, 7),
(16, 5), (16, 6), (16, 7),
(17, 5), (17, 6), (17, 7),
(18, 1), (18, 5), (18, 6), (18, 2),
(19, 5), (19, 6), (19, 2),
(20, 5), (20, 6), (20, 7),
(21, 1), (21, 5), (21, 6), (21, 7),
(22, 5), (22, 6), (22, 7),
(23, 5), (23, 6), (23, 7),
(24, 1), (24, 5), (24, 6), (24, 7);

INSERT INTO room_facility(room_id, facility_id) VALUES
(25, 1), (25, 3), (25, 5), (25, 6), (25, 7),
(26, 5), (26, 6), (26, 7),
(27, 5), (27, 6), (27, 7),
(28, 1), (28, 5), (28, 6), (28, 7),
(29, 5), (29, 6), (29, 7),
(30, 5), (30, 6), (30, 7),
(31, 1), (31, 5), (31, 6), (31, 7),
(32, 5), (32, 6), (32, 7),
(33, 5), (33, 6), (33, 7),
(34, 1), (34, 5), (34, 6), (34, 7);

INSERT INTO room_facility(room_id, facility_id) VALUES
(35, 1), (35, 2), (35, 3), (35, 4), (35, 5), (35, 6),
(36, 1), (36, 2), (36, 4), (36, 5), (36, 6),
(37, 1), (37, 3), (37, 5), (37, 6), (37, 7),
(38, 1), (38, 5), (38, 6), (38, 7),
(39, 5), (39, 6), (39, 7),
(40, 5), (40, 6), (40, 7),
(41, 1), (41, 5), (41, 6), (41, 7),
(42, 5), (42, 6), (42, 7),
(43, 5), (43, 6), (43, 7),
(44, 1), (44, 5), (44, 6), (44, 7);

INSERT INTO student (full_name, email, phone, gender) VALUES
('Azamat Tursunov', 'azamat_t@auca.kg', '0555-123-456', 'M'),
('Bektur Asanov', 'bektur_a@auca.kg', '0777-234-567', 'M'),
('Chyngyz Moldoshev', 'chyngyz_m@auca.kg', '0700-345-678', 'M'),
('Daniyar Mamatov', 'daniyar_m@auca.kg', '0555-456-789', 'M'),
('Ermek Kadyrov', 'ermek_k@auca.kg', '0777-567-890', 'M'),
('Farkhad Ismailov', 'farkhad_i@auca.kg', '0700-678-901', 'M'),
('Gulzhigit Abdukarimov', 'gulzhigit_a@auca.kg', '0555-789-012', 'M'),
('Husein Orozov', 'husein_o@auca.kg', '0777-890-123', 'M'),
('Ilyas Toktosunov', 'ilyas_t@auca.kg', '0700-901-234', 'M'),
('Javid Alimov', 'javid_a@auca.kg', '0555-012-345', 'M'),
('Kanat Bekov', 'kanat_b@auca.kg', '0777-123-456', 'M'),
('Maksat Usupov', 'maksat_u@auca.kg', '0700-234-567', 'M'),
('Nurlan Zhumabayev', 'nurlan_z@auca.kg', '0555-345-678', 'M'),
('Omurbek Satybaldiev', 'omurbek_s@auca.kg', '0777-456-789', 'M'),
('Ruslan Bekmuratov', 'ruslan_b@auca.kg', '0700-567-890', 'M'),
('Sanzhar Sultanov', 'sanzhar_s@auca.kg', '0555-678-901', 'M'),
('Temirlan Aitmatov', 'temirlan_a@auca.kg', '0777-789-012', 'M'),
('Ulan Kasymbek', 'ulan_k@auca.kg', '0700-890-123', 'M'),
('Vladislav Pak', 'vladislav_p@auca.kg', '0555-901-234', 'M'),
('Yerlan Mambetaliev', 'yerlan_m@auca.kg', '0777-012-345', 'M'),
('Zhanybek Toktogonov', 'zhanybek_t@auca.kg', '0700-111-222', 'M'),
('Amir Kasymov', 'amir_k@auca.kg', '0555-222-333', 'M'),
('Bakyt Jumabaev', 'bakyt_j@auca.kg', '0777-333-444', 'M'),
('Damir Bakirov', 'damir_b@auca.kg', '0700-444-555', 'M'),
('Eldiyar Niyazov', 'eldiyar_n@auca.kg', '0555-555-666', 'M'),

('Aizada Nurbekova', 'aizada_n@auca.kg', '0555-100-200', 'F'),
('Asel Tashmatova', 'asel_t@auca.kg', '0777-200-300', 'F'),
('Bermet Osmonova', 'bermet_o@auca.kg', '0700-300-400', 'F'),
('Cholpon Isaeva', 'cholpon_i@auca.kg', '0555-400-500', 'F'),
('Dinara Sydykova', 'dinara_s@auca.kg', '0777-500-600', 'F'),
('Eliza Madaminova', 'eliza_m@auca.kg', '0700-600-700', 'F'),
('Gulnara Abdullaeva', 'gulnara_a@auca.kg', '0555-700-800', 'F'),
('Jamilya Kamilova', 'jamilya_k@auca.kg', '0777-800-900', 'F'),
('Kamila Askarova', 'kamila_a@auca.kg', '0700-900-100', 'F'),
('Kunduz Erkinbaeva', 'kunduz_e@auca.kg', '0555-110-220', 'F'),
('Meerim Baktybekova', 'meerim_b@auca.kg', '0777-220-330', 'F'),
('Nazira Sharipova', 'nazira_s@auca.kg', '0700-330-440', 'F'),
('Perizat Toktorova', 'perizat_t@auca.kg', '0555-440-550', 'F'),
('Saltanat Akmatova', 'saltanat_a@auca.kg', '0777-550-660', 'F'),
('Tolkun Karabaeva', 'tolkun_k@auca.kg', '0700-660-770', 'F'),
('Aidana Kurbanova', 'aidana_k@auca.kg', '0555-770-880', 'F'),
('Begaiym Musaeva', 'begaiym_m@auca.kg', '0777-880-990', 'F'),
('Nazgul Alieva', 'nazgul_a@auca.kg', '0700-990-110', 'F'),
('Medina Asylbekova', 'medina_a@auca.kg', '0555-101-202', 'F'),
('Rahat Bekbolotova', 'rahat_b@auca.kg', '0777-202-303', 'F'),
('Saniya Jumabekova', 'saniya_j@auca.kg', '0700-303-404', 'F'),
('Venera Turgunbaeva', 'venera_t@auca.kg', '0555-404-505', 'F'),
('Zarina Esengulova', 'zarina_e@auca.kg', '0777-505-606', 'F'),
('Nurzhan Kubanychbekova', 'nurzhan_k@auca.kg', '0700-606-707', 'F'),
('Ainura Abdyldaeva', 'ainura_a@auca.kg', '0555-707-808', 'F');

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(1, 5, 1, '2024-09-01', TRUE),
(2, 5, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(3, 6, 1, '2024-09-01', TRUE),
(4, 6, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(5, 7, 1, '2024-09-01', TRUE),
(6, 7, 2, '2024-09-01', TRUE),
(7, 7, 3, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(8, 8, 1, '2024-09-01', TRUE),
(9, 8, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(10, 9, 1, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(11, 10, 1, '2024-09-01', TRUE),
(12, 10, 2, '2024-09-01', TRUE),
(13, 10, 3, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(14, 11, 1, '2024-09-01', TRUE),
(15, 11, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(16, 12, 1, '2024-09-01', TRUE),
(17, 12, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(18, 13, 1, '2024-09-01', TRUE),
(19, 13, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(20, 14, 1, '2024-09-01', TRUE),
(21, 14, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(26, 15, 1, '2024-09-01', TRUE),
(27, 15, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(28, 16, 1, '2024-09-01', TRUE),
(29, 16, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(30, 17, 1, '2024-09-01', TRUE),
(31, 17, 2, '2024-09-01', TRUE),
(32, 17, 3, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(33, 19, 1, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(34, 20, 1, '2024-09-01', TRUE),
(35, 20, 2, '2024-09-01', TRUE),
(36, 20, 3, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(37, 25, 1, '2024-09-01', TRUE),
(38, 25, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(39, 27, 1, '2024-09-01', TRUE),
(40, 27, 2, '2024-09-01', TRUE),
(41, 27, 3, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(42, 35, 1, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(43, 36, 1, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(44, 37, 1, '2024-09-01', TRUE),
(45, 37, 2, '2024-09-01', TRUE);

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active) VALUES
(46, 40, 1, '2024-09-01', TRUE),
(47, 40, 2, '2024-09-01', TRUE),
(48, 40, 3, '2024-09-01', TRUE);

INSERT INTO payment(student_id, assignment_id, period_start, period_end, amount, status, paid_at, method)
SELECT s.student_id, a.assignment_id, '2024-09-01'::date, '2024-09-30'::date,
       rt.monthly_rate, 'paid', '2024-09-05 10:00:00'::timestamp, 
       CASE WHEN s.student_id % 3 = 0 THEN 'card'
            WHEN s.student_id % 3 = 1 THEN 'transfer'
            ELSE 'cash' END
FROM assignment a
JOIN student s ON s.student_id = a.student_id
JOIN room r ON r.room_id = a.room_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
WHERE a.active AND a.start_date <= '2024-09-30';

INSERT INTO payment(student_id, assignment_id, period_start, period_end, amount, status, paid_at, method)
SELECT s.student_id, a.assignment_id, '2024-10-01'::date, '2024-10-31'::date,
       rt.monthly_rate, 'paid', '2024-10-03 09:00:00'::timestamp,
       CASE WHEN s.student_id % 3 = 0 THEN 'transfer'
            WHEN s.student_id % 3 = 1 THEN 'cash'
            ELSE 'card' END
FROM assignment a
JOIN student s ON s.student_id = a.student_id
JOIN room r ON r.room_id = a.room_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
WHERE a.active AND a.start_date <= '2024-10-31';

INSERT INTO payment(student_id, assignment_id, period_start, period_end, amount, status, paid_at, method)
SELECT s.student_id, a.assignment_id, '2024-11-01'::date, '2024-11-30'::date,
       rt.monthly_rate, 
       CASE WHEN s.student_id % 5 = 0 THEN 'pending' ELSE 'paid' END,
       CASE WHEN s.student_id % 5 = 0 THEN NULL ELSE '2024-11-04 11:00:00'::timestamp END,
       CASE WHEN s.student_id % 3 = 0 THEN 'card'
            WHEN s.student_id % 3 = 1 THEN 'transfer'
            ELSE 'cash' END
FROM assignment a
JOIN student s ON s.student_id = a.student_id
JOIN room r ON r.room_id = a.room_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
WHERE a.active AND a.start_date <= '2024-11-30';

INSERT INTO payment(student_id, assignment_id, period_start, period_end, amount, status, method)
SELECT s.student_id, a.assignment_id, '2024-12-01'::date, '2024-12-31'::date,
       rt.monthly_rate, 'pending', 'cash'
FROM assignment a
JOIN student s ON s.student_id = a.student_id
JOIN room r ON r.room_id = a.room_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
WHERE a.active;

INSERT INTO maintenance_request(room_id, student_id, priority, category, status, description, created_at) VALUES
(5, 1, 'high', 'plumbing', 'resolved', 'Water leak in bathroom', '2024-09-15 10:00:00'),
(7, 5, 'medium', 'electrical', 'in_progress', 'Light switch not working', '2024-10-20 14:30:00'),
(15, 26, 'low', 'furniture', 'open', 'Broken chair needs replacement', '2024-11-05 09:00:00'),
(12, 16, 'high', 'heating', 'in_progress', 'Heater not working, room too cold', '2024-11-25 08:00:00'),
(37, 44, 'medium', 'door', 'open', 'Door lock is loose', '2024-11-28 16:00:00'),
(10, 11, 'low', 'window', 'open', 'Window needs cleaning', '2024-11-30 10:00:00'),
(25, 37, 'high', 'plumbing', 'open', 'Toilet is clogged', '2024-12-01 07:30:00');

INSERT INTO maintenance_log(request_id, status, note, at_time) VALUES
(1, 'open', 'Request received', '2024-09-15 10:00:00'),
(1, 'in_progress', 'Plumber assigned', '2024-09-15 14:00:00'),
(1, 'resolved', 'Leak fixed and tested', '2024-09-16 11:00:00'),
(2, 'open', 'Request received', '2024-10-20 14:30:00'),
(2, 'in_progress', 'Electrician checking the issue', '2024-10-21 09:00:00'),
(3, 'open', 'Request received, low priority', '2024-11-05 09:00:00'),
(4, 'open', 'Urgent request received', '2024-11-25 08:00:00'),
(4, 'in_progress', 'Heating technician dispatched', '2024-11-25 10:00:00'),
(5, 'open', 'Request logged', '2024-11-28 16:00:00'),
(6, 'open', 'Request logged', '2024-11-30 10:00:00'),
(7, 'open', 'High priority - immediate attention needed', '2024-12-01 07:30:00');

SELECT 'Buildings' as table_name, COUNT(*) as count FROM building
UNION ALL
SELECT 'Rooms', COUNT(*) FROM room
UNION ALL
SELECT 'Students', COUNT(*) FROM student
UNION ALL
SELECT 'Active Assignments', COUNT(*) FROM assignment WHERE active
UNION ALL
SELECT 'Payments', COUNT(*) FROM payment
UNION ALL
SELECT 'Maintenance Requests', COUNT(*) FROM maintenance_request;
