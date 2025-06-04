-- Create the database
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    user_type ENUM('student', 'professor', 'secretary') NOT NULL,
    title VARCHAR(100),
    major VARCHAR(100),
    year_level VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create assignments table
CREATE TABLE IF NOT EXISTS assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    topic VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    language VARCHAR(100),
    technologies TEXT,
    progress ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    student_id INT NOT NULL,
    supervisor_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (supervisor_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
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

-- Insert test users
INSERT INTO users (username, password, name, email, phone, user_type, title, major, year_level) VALUES
('student1', SHA2('password123', 256), 'John Doe', 'john.doe@university.edu', '+30 123 456 7890', 'student', 'Undergraduate Student', 'Computer Science', '4th Year'),
('professor1', SHA2('prof123', 256), 'Dr. Jane Smith', 'jane.smith@university.edu', '+30 123 456 7891', 'professor', 'Professor', 'Computer Science', NULL),
('test', SHA2('test', 256), 'Test User', 'test@university.edu', '+30 123 456 7892', 'student', 'Test Student', 'Computer Science', '1st Year');

-- Insert test assignments
INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id) VALUES
('AI-Powered Student Management System', '2024-01-15', 'Java', 'Spring Boot, MySQL, Bootstrap', 'In Progress', 1),
('Machine Learning Classifier', '2024-02-01', 'Python', 'Scikit-learn, Pandas, NumPy', 'Not Started', 1);

-- Insert test appointments
INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, status) VALUES
('student1', '2', 'Thesis Meeting', '2024-12-20', '10:00:00', 'Discuss thesis progress and next steps', 'confirmed'),
('student1', '2', 'Thesis Meeting', '2024-12-25', '14:00:00', 'Review implementation details', 'pending'); 