SET search_path = dorm_mgmt, public;

BEGIN;

UPDATE assignment
SET active = FALSE, end_date = CURRENT_DATE
WHERE student_id = (SELECT student_id FROM student WHERE full_name = 'Sanzhar S.')
  AND active = TRUE;

INSERT INTO assignment(student_id, room_id, bed_no, start_date, active)
SELECT s.student_id, r.room_id, 1, CURRENT_DATE, TRUE
FROM student s
JOIN room r ON r.room_no = '202' AND r.building_id = (SELECT building_id FROM building WHERE name='Ala-Too')
WHERE s.full_name = 'Sanzhar S.';

INSERT INTO payment(student_id, assignment_id, period_start, period_end, amount, status, method)
SELECT s.student_id, a.assignment_id, DATE_TRUNC('month', CURRENT_DATE)::date,
       (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::date,
       rt.monthly_rate, 'pending', 'cash'
FROM student s
JOIN assignment a ON a.student_id = s.student_id AND a.active
JOIN room r ON r.room_id = a.room_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
WHERE s.full_name = 'Sanzhar S.';

COMMIT;

SELECT s.full_name, b.name AS building, r.room_no, a.bed_no, a.start_date, a.end_date, a.active
FROM assignment a
JOIN student s ON s.student_id = a.student_id
JOIN room r ON r.room_id = a.room_id
JOIN building b ON b.building_id = r.building_id
WHERE s.full_name='Sanzhar S.'
ORDER BY a.start_date;
