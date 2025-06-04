-- Comprehensive Dummy Data for University Database
-- This file contains extensive test data for development and testing purposes

USE university_db;

-- Insert dummy users (students, professors, secretaries)
INSERT INTO users (username, password, user_type, name, email, phone) VALUES
-- Students
('alice_johnson', SHA2('student123', 256), 'student', 'Alice Johnson', 'alice.johnson@university.edu', '+30 210 123 4567'),
('bob_smith', SHA2('student123', 256), 'student', 'Bob Smith', 'bob.smith@university.edu', '+30 210 123 4568'),
('charlie_brown', SHA2('student123', 256), 'student', 'Charlie Brown', 'charlie.brown@university.edu', '+30 210 123 4569'),
('diana_prince', SHA2('student123', 256), 'student', 'Diana Prince', 'diana.prince@university.edu', '+30 210 123 4570'),
('emma_watson', SHA2('student123', 256), 'student', 'Emma Watson', 'emma.watson@university.edu', '+30 210 123 4571'),
('frank_miller', SHA2('student123', 256), 'student', 'Frank Miller', 'frank.miller@university.edu', '+30 210 123 4572'),
('grace_kelly', SHA2('student123', 256), 'student', 'Grace Kelly', 'grace.kelly@university.edu', '+30 210 123 4573'),
('henry_ford', SHA2('student123', 256), 'student', 'Henry Ford', 'henry.ford@university.edu', '+30 210 123 4574'),
('isabella_swan', SHA2('student123', 256), 'student', 'Isabella Swan', 'isabella.swan@university.edu', '+30 210 123 4575'),
('jack_sparrow', SHA2('student123', 256), 'student', 'Jack Sparrow', 'jack.sparrow@university.edu', '+30 210 123 4576'),
('kate_bishop', SHA2('student123', 256), 'student', 'Kate Bishop', 'kate.bishop@university.edu', '+30 210 123 4577'),
('luke_skywalker', SHA2('student123', 256), 'student', 'Luke Skywalker', 'luke.skywalker@university.edu', '+30 210 123 4578'),
('maria_garcia', SHA2('student123', 256), 'student', 'Maria Garcia', 'maria.garcia@university.edu', '+30 210 123 4579'),
('nick_fury', SHA2('student123', 256), 'student', 'Nick Fury', 'nick.fury@university.edu', '+30 210 123 4580'),
('olivia_wilde', SHA2('student123', 256), 'student', 'Olivia Wilde', 'olivia.wilde@university.edu', '+30 210 123 4581'),
('peter_parker', SHA2('student123', 256), 'student', 'Peter Parker', 'peter.parker@university.edu', '+30 210 123 4582'),
('quinn_fabray', SHA2('student123', 256), 'student', 'Quinn Fabray', 'quinn.fabray@university.edu', '+30 210 123 4583'),
('rachel_green', SHA2('student123', 256), 'student', 'Rachel Green', 'rachel.green@university.edu', '+30 210 123 4584'),
('steve_rogers', SHA2('student123', 256), 'student', 'Steve Rogers', 'steve.rogers@university.edu', '+30 210 123 4585'),
('tony_stark', SHA2('student123', 256), 'student', 'Tony Stark', 'tony.stark@university.edu', '+30 210 123 4586'),

-- Graduate Students
('natasha_romanoff', SHA2('grad123', 256), 'student', 'Natasha Romanoff', 'natasha.romanoff@university.edu', '+30 210 123 4587'),
('bruce_banner', SHA2('grad123', 256), 'student', 'Bruce Banner', 'bruce.banner@university.edu', '+30 210 123 4588'),
('wanda_maximoff', SHA2('grad123', 256), 'student', 'Wanda Maximoff', 'wanda.maximoff@university.edu', '+30 210 123 4589'),
('vision_android', SHA2('grad123', 256), 'student', 'Vision Android', 'vision.android@university.edu', '+30 210 123 4590'),
('scott_lang', SHA2('grad123', 256), 'student', 'Scott Lang', 'scott.lang@university.edu', '+30 210 123 4591'),

-- Professors
('prof_xavier', SHA2('prof123', 256), 'professor', 'Professor Charles Xavier', 'charles.xavier@university.edu', '+30 210 987 6543'),
('prof_stark', SHA2('prof123', 256), 'professor', 'Professor Howard Stark', 'howard.stark@university.edu', '+30 210 987 6544'),
('prof_banner', SHA2('prof123', 256), 'professor', 'Dr. Betty Banner', 'betty.banner@university.edu', '+30 210 987 6545'),
('prof_storm', SHA2('prof123', 256), 'professor', 'Dr. Ororo Storm', 'ororo.storm@university.edu', '+30 210 987 6546'),
('prof_richards', SHA2('prof123', 256), 'professor', 'Dr. Reed Richards', 'reed.richards@university.edu', '+30 210 987 6547'),
('prof_grey', SHA2('prof123', 256), 'professor', 'Dr. Jean Grey', 'jean.grey@university.edu', '+30 210 987 6548'),
('prof_mccoy', SHA2('prof123', 256), 'professor', 'Dr. Henry McCoy', 'henry.mccoy@university.edu', '+30 210 987 6549'),
('prof_summers', SHA2('prof123', 256), 'professor', 'Dr. Scott Summers', 'scott.summers@university.edu', '+30 210 987 6550'),

-- Secretaries
('mary_jane', SHA2('sec123', 256), 'secretary', 'Mary Jane Watson', 'mary.jane@university.edu', '+30 210 555 0001'),
('pepper_potts', SHA2('sec123', 256), 'secretary', 'Pepper Potts', 'pepper.potts@university.edu', '+30 210 555 0002'),
('may_parker', SHA2('sec123', 256), 'secretary', 'May Parker', 'may.parker@university.edu', '+30 210 555 0003');

-- Insert dummy assignments
-- Now includes supervisor_id (professor)
INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id, supervisor_id) VALUES
('AI-Powered Student Management System', '2024-01-15', 'Java', 'Spring Boot, MySQL, Bootstrap, REST API', 'In Progress', (SELECT id FROM users WHERE username = 'alice_johnson'), (SELECT id FROM users WHERE username = 'prof_xavier')),
('Machine Learning Classification Model', '2024-02-01', 'Python', 'Scikit-learn, Pandas, NumPy, Matplotlib', 'Completed', (SELECT id FROM users WHERE username = 'bob_smith'), (SELECT id FROM users WHERE username = 'prof_banner')),
('Distributed Database System', '2024-01-20', 'Java', 'Apache Cassandra, Spring Data, Microservices', 'Not Started', (SELECT id FROM users WHERE username = 'charlie_brown'), (SELECT id FROM users WHERE username = 'prof_stark')),
('Web Scraping and Data Analysis Tool', '2024-03-01', 'Python', 'BeautifulSoup, Selenium, Flask, PostgreSQL', 'In Progress', (SELECT id FROM users WHERE username = 'diana_prince'), (SELECT id FROM users WHERE username = 'prof_storm')),
('Real-time Chat Application', '2024-02-15', 'JavaScript', 'Node.js, Socket.io, React, MongoDB', 'In Progress', (SELECT id FROM users WHERE username = 'emma_watson'), (SELECT id FROM users WHERE username = 'prof_richards')),
('Computer Vision Object Detection', '2024-01-10', 'Python', 'OpenCV, TensorFlow, YOLO, Keras', 'Completed', (SELECT id FROM users WHERE username = 'frank_miller'), (SELECT id FROM users WHERE username = 'prof_grey')),
('Statistical Analysis of Climate Data', '2024-02-10', 'R', 'ggplot2, dplyr, shiny, time series analysis', 'In Progress', (SELECT id FROM users WHERE username = 'grace_kelly'), (SELECT id FROM users WHERE username = 'prof_mccoy')),
('Numerical Methods for Differential Equations', '2024-01-25', 'MATLAB', 'Simulink, Symbolic Math Toolbox', 'Not Started', (SELECT id FROM users WHERE username = 'henry_ford'), (SELECT id FROM users WHERE username = 'prof_summers')),
('Quantum Mechanics Simulation', '2024-02-20', 'Python', 'QuTiP, NumPy, SciPy, Matplotlib', 'Not Started', (SELECT id FROM users WHERE username = 'isabella_swan'), (SELECT id FROM users WHERE username = 'prof_xavier')),
('Electromagnetic Field Analysis', '2024-01-30', 'MATLAB', 'COMSOL Multiphysics, Antenna Toolbox', 'In Progress', (SELECT id FROM users WHERE username = 'jack_sparrow'), (SELECT id FROM users WHERE username = 'prof_banner')),
('IoT Home Automation System', '2024-01-12', 'C++', 'Arduino, Raspberry Pi, MQTT, Node-RED', 'Completed', (SELECT id FROM users WHERE username = 'kate_bishop'), (SELECT id FROM users WHERE username = 'prof_stark')),
('Robotic Arm Control System', '2024-02-25', 'Python', 'ROS, OpenCV, Kinematics libraries', 'Not Started', (SELECT id FROM users WHERE username = 'luke_skywalker'), (SELECT id FROM users WHERE username = 'prof_storm')),
('Sustainable Energy Management System', '2024-01-18', 'Java', 'Spring Boot, InfluxDB, Grafana', 'In Progress', (SELECT id FROM users WHERE username = 'maria_garcia'), (SELECT id FROM users WHERE username = 'prof_richards')),
('Bioinformatics Sequence Analysis', '2024-02-12', 'Python', 'Biopython, BLAST, phylogenetic tools', 'In Progress', (SELECT id FROM users WHERE username = 'nick_fury'), (SELECT id FROM users WHERE username = 'prof_grey')),
('Marine Ecosystem Modeling', '2024-03-01', 'R', 'Ecological modeling packages, GIS tools', 'Not Started', (SELECT id FROM users WHERE username = 'olivia_wilde'), (SELECT id FROM users WHERE username = 'prof_mccoy')),
('Astronomical Data Pipeline', '2024-01-28', 'Python', 'Astropy, Photutils, FITS handling', 'Not Started', (SELECT id FROM users WHERE username = 'peter_parker'), (SELECT id FROM users WHERE username = 'prof_summers')),
('Chemical Reaction Kinetics Simulator', '2024-02-18', 'MATLAB', 'Chemical kinetics toolboxes', 'In Progress', (SELECT id FROM users WHERE username = 'quinn_fabray'), (SELECT id FROM users WHERE username = 'prof_xavier')),
('Cognitive Behavior Analysis Tool', '2024-01-22', 'R', 'Shiny, psychological testing packages', 'In Progress', (SELECT id FROM users WHERE username = 'rachel_green'), (SELECT id FROM users WHERE username = 'prof_banner')),
('Music Composition Algorithm', '2024-02-28', 'Python', 'Music21, MIDI libraries, ML algorithms', 'Not Started', (SELECT id FROM users WHERE username = 'steve_rogers'), (SELECT id FROM users WHERE username = 'prof_stark')),
('Fashion Trend Prediction Model', '2024-01-08', 'Python', 'Computer Vision, Fashion datasets, CNN', 'Completed', (SELECT id FROM users WHERE username = 'tony_stark'), (SELECT id FROM users WHERE username = 'prof_storm')),
('Historical Document Digitization', '2024-02-22', 'Python', 'OCR, NLP, Digital humanities tools', 'In Progress', (SELECT id FROM users WHERE username = 'natasha_romanoff'), (SELECT id FROM users WHERE username = 'prof_richards')),
('Deep Learning Framework for Medical Imaging', '2024-01-05', 'Python', 'PyTorch, DICOM processing, CUDA, Docker', 'In Progress', (SELECT id FROM users WHERE username = 'bruce_banner'), (SELECT id FROM users WHERE username = 'prof_grey')),
('Neural Network Optimization for Edge Computing', '2024-02-01', 'Python', 'TensorFlow Lite, ARM processors, optimization', 'In Progress', (SELECT id FROM users WHERE username = 'wanda_maximoff'), (SELECT id FROM users WHERE username = 'prof_mccoy')),
('Advanced Computer Vision for Autonomous Systems', '2024-01-20', 'C++', 'OpenCV, ROS, SLAM algorithms, LiDAR', 'In Progress', (SELECT id FROM users WHERE username = 'vision_android'), (SELECT id FROM users WHERE username = 'prof_summers')),
('Distributed Machine Learning Platform', '2024-02-10', 'Python', 'Apache Spark, Kubernetes, MLOps, cloud computing', 'Not Started', (SELECT id FROM users WHERE username = 'scott_lang'), (SELECT id FROM users WHERE username = 'prof_xavier'));

-- Insert dummy appointments
INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, additional_notes, status) VALUES
-- Upcoming appointments
('alice_johnson', 'prof_xavier', 'Thesis Meeting', '2024-12-20', '10:00:00', 'Discuss AI project progress and implementation challenges', 'Bring latest code repository access', 'confirmed'),
('bob_smith', 'prof_summers', 'Academic Counseling', '2024-12-21', '14:30:00', 'Course selection for final semester', 'Review graduation requirements', 'pending'),
('charlie_brown', 'prof_banner', 'Research Discussion', '2024-12-22', '09:15:00', 'Quantum mechanics simulation project guidance', 'Prepare theoretical background questions', 'confirmed'),
('diana_prince', 'prof_xavier', 'Progress Review', '2024-12-23', '11:00:00', 'Machine learning model performance evaluation', NULL, 'pending'),
('emma_watson', 'prof_stark', 'Thesis Defense Preparation', '2024-12-27', '13:00:00', 'Review presentation and prepare for questions', 'Final thesis draft required', 'confirmed'),
('frank_miller', 'prof_xavier', 'Orientation Meeting', '2025-01-03', '10:30:00', 'Introduction to research opportunities', 'First-year student guidance', 'pending'),
('grace_kelly', 'prof_summers', 'Academic Support', '2025-01-05', '15:00:00', 'Mathematics coursework assistance', 'Struggling with advanced calculus', 'confirmed'),
('henry_ford', 'prof_stark', 'Project Consultation', '2025-01-07', '09:00:00', 'Robotic arm control system design review', 'Bring mechanical drawings', 'pending'),
('isabella_swan', 'prof_mccoy', 'Research Planning', '2025-01-08', '14:00:00', 'Bioinformatics project scope definition', NULL, 'confirmed'),
('jack_sparrow', 'prof_storm', 'Field Study Discussion', '2025-01-10', '11:30:00', 'Marine ecosystem research methodology', 'Discuss data collection methods', 'pending'),

-- Recent completed appointments
('kate_bishop', 'prof_banner', 'Lab Safety Training', '2024-12-15', '16:00:00', 'Physics lab safety protocols and procedures', 'Mandatory training completed', 'completed'),
('luke_skywalker', 'prof_richards', 'Course Registration', '2024-12-14', '10:00:00', 'Help with astronomy course selection', 'Registration completed successfully', 'completed'),
('maria_garcia', 'prof_mccoy', 'Thesis Progress', '2024-12-13', '13:30:00', 'Chemical analysis research update', 'Good progress, on track', 'completed'),
('nick_fury', 'prof_xavier', 'Technical Review', '2024-12-12', '15:15:00', 'Database system architecture discussion', 'Need to refactor data layer', 'completed'),
('olivia_wilde', 'prof_xavier', 'Research Ethics', '2024-12-11', '09:45:00', 'Psychology research ethics approval process', 'IRB application submitted', 'completed'),
('peter_parker', 'prof_xavier', 'Mentorship Meeting', '2024-12-10', '14:00:00', 'Computer vision project introduction', 'Assigned senior student mentor', 'completed'),
('quinn_fabray', 'prof_grey', 'Performance Review', '2024-12-09', '11:00:00', 'Music composition project evaluation', 'Excellent creative progress', 'completed'),
('rachel_green', 'prof_grey', 'Industry Connections', '2024-12-08', '10:30:00', 'Fashion industry internship opportunities', 'Contacts provided for summer internship', 'completed'),
('steve_rogers', 'prof_grey', 'Research Methods', '2024-12-07', '16:30:00', 'Historical research methodology guidance', 'Library resources tutorial scheduled', 'completed'),
('tony_stark', 'prof_stark', 'Senior Project', '2024-12-06', '12:00:00', 'Engineering capstone project planning', 'Project proposal approved', 'completed'),

-- Graduate student appointments
('natasha_romanoff', 'prof_xavier', 'Thesis Committee Meeting', '2025-01-15', '14:00:00', 'Master\'s thesis committee formation', 'Schedule committee availability', 'confirmed'),
('bruce_banner', 'prof_banner', 'PhD Qualifying Exam', '2025-01-12', '09:00:00', 'Qualifying exam preparation and timeline', 'Review exam format and requirements', 'pending'),
('wanda_maximoff', 'prof_grey', 'Research Proposal Defense', '2025-01-18', '15:30:00', 'Master\'s research proposal presentation', 'Final proposal draft due one week prior', 'confirmed'),
('vision_android', 'prof_xavier', 'Dissertation Progress', '2025-01-20', '11:00:00', 'PhD dissertation chapter review', 'Submit chapters 3-4 for review', 'pending'),
('scott_lang', 'prof_stark', 'Industry Collaboration', '2025-01-22', '13:15:00', 'Engineering industry partnership discussion', 'Explore internship and research opportunities', 'confirmed'),

-- Cancelled appointments
('alice_johnson', 'prof_xavier', 'Weekly Check-in', '2024-12-18', '15:00:00', 'Regular progress update meeting', 'Rescheduled due to conference attendance', 'cancelled'),
('bob_smith', 'prof_summers', 'Grade Appeal', '2024-12-16', '10:00:00', 'Discuss mathematics course grade', 'Issue resolved through email correspondence', 'cancelled'),
('charlie_brown', 'prof_banner', 'Equipment Training', '2024-12-17', '14:00:00', 'Physics lab equipment orientation', 'Training completed in group session instead', 'cancelled'),

-- Future appointments
('diana_prince', 'prof_xavier', 'Final Project Review', '2025-02-15', '10:00:00', 'Computer science capstone final evaluation', 'Schedule closer to completion date', 'pending'),
('emma_watson', 'prof_stark', 'Graduation Planning', '2025-03-01', '11:30:00', 'Post-graduation career planning discussion', 'Prepare career goals and questions', 'pending'),
('frank_miller', 'prof_xavier', 'Summer Research', '2025-04-10', '14:00:00', 'Summer undergraduate research opportunities', 'Research application deadlines approaching', 'pending'),
('grace_kelly', 'prof_summers', 'Study Abroad', '2025-03-15', '09:30:00', 'International exchange program information', 'GPA and language requirements review', 'pending'),
('henry_ford', 'prof_stark', 'Industry Visit', '2025-02-28', '13:45:00', 'Engineering company visit coordination', 'Transportation and logistics planning', 'pending'); 