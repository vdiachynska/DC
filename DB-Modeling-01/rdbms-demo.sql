CREATE DATABASE RDBMS_DEMO;
USE RDBMS_DEMO;


-- 1. Drop tables if they exist
DROP TABLE IF EXISTS student_course;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

-- 2. Create base tables: students and courses
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);

-- 3. Create a junction table to handle many-to-many relationship
CREATE TABLE student_course (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
);

-- 4. Insert sample data into students
INSERT INTO students (name) VALUES
('Alice'),
('Bob'),
('Charlie');

-- 5. Insert sample data into courses
INSERT INTO courses (title) VALUES
('Math'),
('Science'),
('History');

-- 6. Insert data into student_course (many-to-many)
INSERT INTO student_course (student_id, course_id, enrollment_date) VALUES
(1, 1, '2025-06-01'), -- Alice enrolled in Math
(1, 2, '2025-06-02'), -- Alice enrolled in Science
(2, 1, '2025-06-03'), -- Bob enrolled in Math
(3, 3, '2025-06-04'); -- Charlie enrolled in History

-- 7. Create a limited-access role and user
-- (NOTE: Roles require MySQL 8.0+)

-- Drop if already exists
DROP ROLE IF EXISTS read_students_only;
DROP USER IF EXISTS 'readonly_user'@'localhost';

-- Create role
CREATE ROLE read_students_only;

-- Grant SELECT on students table only
GRANT SELECT ON RDBMS_DEMO.students TO read_students_only;

-- Create user and assign the role
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT read_students_only TO 'readonly_user'@'localhost';

-- Make role default for the user
SET DEFAULT ROLE read_students_only TO 'readonly_user'@'localhost';
