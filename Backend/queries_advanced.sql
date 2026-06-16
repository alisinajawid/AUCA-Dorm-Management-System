SET search_path = dorm_mgmt, public;

-- A1) Occupancy rate by building
WITH beds AS (
  SELECT r.building_id, SUM(rt.capacity) AS total_beds
  FROM room r JOIN room_type rt ON rt.room_type_id = r.room_type_id
  GROUP BY r.building_id
),
used AS (
  SELECT r.building_id, COUNT(*) AS used_beds
  FROM assignment a JOIN room r ON r.room_id = a.room_id
  WHERE a.active
  GROUP BY r.building_id
)
SELECT b.name,
       COALESCE(u.used_beds,0) AS used_beds,
       be.total_beds,
       ROUND(COALESCE(u.used_beds,0)::numeric / be.total_beds * 100, 2) AS occupancy_pct
FROM beds be
JOIN building b ON b.building_id = be.building_id
LEFT JOIN used u ON u.building_id = be.building_id
ORDER BY occupancy_pct DESC, b.name;

-- A2) Revenue by month 
SELECT DATE_TRUNC('month', period_start)::date AS month,
       SUM(amount) FILTER (WHERE status='paid')   AS paid_amt,
       SUM(amount) FILTER (WHERE status='pending') AS pending_amt
FROM payment
GROUP BY 1
ORDER BY 1;

-- A3) Top problem categories 
SELECT category, COUNT(*) AS tickets,
       RANK() OVER (ORDER BY COUNT(*) DESC, category) AS rnk
FROM maintenance_request
GROUP BY category;

-- A4) Students without any active assignment
SELECT s.student_id, s.full_name
FROM student s
LEFT JOIN assignment a ON a.student_id = s.student_id AND a.active
WHERE a.assignment_id IS NULL
ORDER BY s.full_name;

-- A5) Rooms with all current occupants 
SELECT b.name AS building, r.room_no,
       STRING_AGG(s.full_name, ', ' ORDER BY s.full_name) AS occupants
FROM room r
JOIN building b ON b.building_id = r.building_id
LEFT JOIN assignment a ON a.room_id = r.room_id AND a.active
LEFT JOIN student s ON s.student_id = a.student_id
GROUP BY b.name, r.room_no
ORDER BY b.name, r.room_no;
