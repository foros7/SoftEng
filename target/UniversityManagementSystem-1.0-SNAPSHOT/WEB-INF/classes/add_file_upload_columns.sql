-- Add file upload columns to assignments table
USE university_db;

ALTER TABLE assignments 
ADD COLUMN file_name VARCHAR(255) NULL,
ADD COLUMN file_path VARCHAR(500) NULL,
ADD COLUMN file_size BIGINT DEFAULT 0,
ADD COLUMN file_uploaded_at TIMESTAMP NULL;

-- Add index for better performance when querying files
CREATE INDEX idx_assignments_file_name ON assignments(file_name);
CREATE INDEX idx_assignments_file_uploaded_at ON assignments(file_uploaded_at); 