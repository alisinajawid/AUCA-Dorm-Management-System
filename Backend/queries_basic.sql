SET search_path = dorm_mgmt, public;

-- 1) Current active assignments
SELECT a.assignment_id, s.full_name, b.name AS building, r.room_no, a.bed_no, a.start_date, a.end_date, a.active
FROM assignment a
JOIN student  s ON s.student_id = a.student_id
JOIN room     r ON r.room_id    = a.room_id
JOIN building b ON b.building_id= r.building_id
WHERE a.active
ORDER BY building, r.room_no, a.bed_no;

-- 2) Available rooms with free beds
WITH occ AS (
  SELECT room_id, COUNT(*) AS used_beds
  FROM assignment
  WHERE active
  GROUP BY room_id
)
SELECT r.room_id, b.name AS building, r.room_no, rt.name AS type, rt.capacity,
       COALESCE(rt.capacity - o.used_beds, rt.capacity) AS free_beds
FROM room r
JOIN building b ON b.building_id = r.building_id
JOIN room_type rt ON rt.room_type_id = r.room_type_id
LEFT JOIN occ o ON o.room_id = r.room_id
WHERE r.status = 'available'
ORDER BY building, r.room_no;

-- 3) Room facilities list
SELECT b.name AS building, r.room_no,
       STRING_AGG(f.name, ', ' ORDER BY f.name) AS facilities
FROM room r
JOIN building b ON b.building_id = r.building_id
LEFT JOIN room_facility rf ON rf.room_id = r.room_id
LEFT JOIN facility f ON f.facility_id = rf.facility_id
GROUP BY b.name, r.room_no
ORDER BY b.name, r.room_no;

-- 4) Pending payments
SELECT p.payment_id, s.full_name, p.period_start, p.period_end, p.amount, p.status
FROM payment p JOIN student s ON s.student_id = p.student_id
WHERE p.status = 'pending'
ORDER BY p.period_start, s.full_name;

-- 5) Open maintenance requests
SELECT mr.request_id, b.name AS building, r.room_no, mr.priority, mr.category, mr.status, mr.created_at
FROM maintenance_request mr
JOIN room r ON r.room_id = mr.room_id
JOIN building b ON b.building_id = r.building_id
WHERE mr.status IN ('open','in_progress')
ORDER BY mr.priority DESC, mr.created_at;
