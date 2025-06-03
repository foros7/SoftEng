-- Drop the existing appointments table if it exists
DROP TABLE IF EXISTS appointments;

-- Recreate the appointments table with the correct schema
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_username VARCHAR(50) NOT NULL,
    advisor_id VARCHAR(10) NOT NULL,
    appointment_type VARCHAR(100) DEFAULT 'Thesis Meeting',
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason TEXT,
    additional_notes TEXT,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a test appointment
INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, status)
VALUES ('student1', 'PROF001', 'Thesis Meeting', DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY), '14:00:00', 'Project Progress Review', 'pending'); 