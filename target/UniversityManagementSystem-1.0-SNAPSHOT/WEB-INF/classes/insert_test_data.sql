-- Insert test student user
INSERT INTO users (username, password, user_type, name, email) 
VALUES ('student1', 'password123', 'student', 'John Student', 'student@example.com')
ON DUPLICATE KEY UPDATE id = id;

-- Get the student ID
SET @student_id = (SELECT id FROM users WHERE username = 'student1');

-- Insert test assignment for the student
INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id)
VALUES ('Web Development Project', CURRENT_DATE(), 'Java', 'Spring Boot, MySQL', 'In Progress', @student_id)
ON DUPLICATE KEY UPDATE id = id;

-- Get the assignment ID
SET @assignment_id = (SELECT id FROM assignments WHERE student_id = @student_id LIMIT 1);

-- Insert test appointment
INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, status)
VALUES ('student1', 'PROF001', 'Thesis Meeting', DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY), '14:00:00', 'Project Progress Review', 'pending')
ON DUPLICATE KEY UPDATE id = id; 