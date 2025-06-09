-- Script to create the notifications table
USE university_db;

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipient_username VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    related_id VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipient_username) REFERENCES users(username) ON DELETE CASCADE
);

-- Add some indexes for better performance
CREATE INDEX idx_notifications_recipient ON notifications(recipient_username);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

-- Optional: Insert a test notification to verify the table works
-- INSERT INTO notifications (recipient_username, title, message, type, related_id, is_read) 
-- VALUES ('professor1', 'Test Notification', 'This is a test notification to verify the table works correctly.', 'system', NULL, FALSE);

SELECT 'Notifications table created successfully!' as status; 