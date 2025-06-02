-- Create the database
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    user_type ENUM('student', 'professor', 'secretary') NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create assignments table (for thesis projects)
CREATE TABLE IF NOT EXISTS assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    topic VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    language VARCHAR(50),
    technologies VARCHAR(200),
    progress VARCHAR(100),
    student_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    day_time DATETIME NOT NULL,
    duration INT NOT NULL DEFAULT 60, -- Duration in minutes
    purpose TEXT,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES assignments(id)
);

-- Insert sample data for testing
INSERT INTO users (username, password, user_type, name, email, phone) VALUES
('student1', 'pass123', 'student', 'John Doe', 'john.doe@university.edu', '+30 123 456 7890'),
('prof1', 'pass123', 'professor', 'Dr. Smith', 'smith@university.edu', '+30 987 654 3210'),
('sec1', 'pass123', 'secretary', 'Jane Admin', 'admin@university.edu', '+30 555 555 5555');

-- Insert sample thesis project (as an assignment)
INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id) VALUES
('AI-Powered Student Management System', '2024-01-15', 'Java', 'Spring Boot, MySQL', 'In Progress', 1);

-- Insert sample appointments
INSERT INTO appointments (assignment_id, day_time, duration, purpose, status) VALUES
(1, '2024-03-20 10:00:00', 60, 'Progress review and implementation discussion', 'scheduled'),
(1, '2024-03-27 14:00:00', 90, 'Code review and optimization suggestions', 'scheduled'); 