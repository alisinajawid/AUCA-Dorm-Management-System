SET search_path = dorm_mgmt, public;

CREATE INDEX IF NOT EXISTS idx_room_building     ON room(building_id);
CREATE INDEX IF NOT EXISTS idx_room_type         ON room(room_type_id);
CREATE INDEX IF NOT EXISTS idx_assign_student    ON assignment(student_id) WHERE active;
CREATE INDEX IF NOT EXISTS idx_assign_room       ON assignment(room_id)    WHERE active;
CREATE INDEX IF NOT EXISTS idx_payment_student   ON payment(student_id);
CREATE INDEX IF NOT EXISTS idx_payment_status    ON payment(status);
CREATE INDEX IF NOT EXISTS idx_req_room          ON maintenance_request(room_id);
CREATE INDEX IF NOT EXISTS idx_req_status        ON maintenance_request(status);
