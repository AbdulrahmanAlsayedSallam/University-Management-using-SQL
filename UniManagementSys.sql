-- Create database
-- CREATE DATABASE IF NOT EXISTS university_management;

-- Use the created database
-- USE university_management;

-- Table for faculties
CREATE TABLE IF NOT EXISTS faculties (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(100),
    department VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

-- Table for students
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male', 'Female'),
    address VARCHAR(255),
    major VARCHAR(100),
    gpa float,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id)
);

-- Table for professors
CREATE TABLE IF NOT EXISTS professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('Male', 'Female'),
    address VARCHAR(255),
    salary INT,  
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id)
);

-- Table for courses
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    faculty_id INT,
    professor_id INT,
    FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id),
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

-- Table for enrollments
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Table for grades
CREATE TABLE IF NOT EXISTS grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT,
    grade FLOAT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

-- table for rooms
CREATE TABLE IF NOT EXISTS rooms (
    room_number VARCHAR(20) PRIMARY KEY,
    capacity INT,
    building VARCHAR(100),
    floor INT
);

-- Table for examinations
CREATE TABLE IF NOT EXISTS examinations (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    exam_date DATE,
    start_time TIME,
    end_time TIME,
    location VARCHAR(20),
    FOREIGN KEY (location) REFERENCES rooms(room_number),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- table for fee payments
CREATE TABLE IF NOT EXISTS fee_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    payment_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


-- Table for scholarships
CREATE TABLE IF NOT EXISTS scholarships (
    student_id INT,
    full_name VARCHAR(100),
    gpa FLOAT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Create index for grade column
CREATE INDEX idx_grade ON grades (grade);

-- Inserting sample data into the faculties table
INSERT INTO faculties (faculty_name, department, email, phone_number) VALUES
('Faculty of Computer Science', 'Computer Science', 'cs_faculty@example.com', '123-456-7890'),
('Faculty of Biology', 'Biology', 'bio_faculty@example.com', '987-654-3210');

-- Inserting sample data into the students table
INSERT INTO students (first_name, last_name, email, date_of_birth, gender, address, major, gpa, faculty_id) VALUES
('John', 'Doe', 'john.doe@example.com', '1998-05-15', 'Male', '123 Main St, City', 'Computer Science', 0.0, 1),
('Jane', 'Smith', 'jane.smith@example.com', '1997-09-20', 'Female', '456 Elm St, Town', 'Biology', 0.0, 2);

-- Inserting sample data into the professors table with faculty_id
INSERT INTO professors (first_name, last_name, email, date_of_birth, gender, address, salary, faculty_id) VALUES
('Michael', 'Johnson', 'michael.johnson@example.com', '1975-03-10', 'Male', '789 Oak St Village', 14500, 1),
('Emily', 'Brown', 'emily.brown@example.com', '1982-11-25', 'Female', '101 Pine St, County', 15000, 2);

-- Inserting sample data into the courses table
INSERT INTO courses (course_name, credits, faculty_id, professor_id) VALUES
('Introduction to Computer Science', 3, 1, 1), -- Professor Michael Johnson teaches this course
('Introduction to Biology', 4, 2, 2),          -- Professor Emily Brown teaches this course
('Introduction to Psychology', 3, 2, 2);        -- Professor Emily Brown teaches this course


-- Inserting sample data into the enrollments table
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-01-15'),
(1, 2, '2024-01-20'),
(2, 1, '2024-01-15'),
(2, 3, '2024-01-25');

-- Inserting sample data into the grades table
INSERT INTO grades (enrollment_id, grade) VALUES
(1, 3.5),
(2, 4.0),
(3, 3.7),
(4, 2.9),
(4, 3.0);

-- Inserting sample data into the rooms table
INSERT INTO rooms (room_number, capacity, building, floor) VALUES
('Room 101', 30, 'Main Building', 1),
('Room 201', 25, 'Science Building', 2),
('Room 102', 35, 'Main Building', 1);

-- Inserting sample data into the examinations table
INSERT INTO examinations (course_id, exam_date, start_time, end_time, location) VALUES
(1, '2024-05-10', '09:00:00', '11:00:00', 'Room 101'),
(2, '2024-05-15', '10:00:00', '12:00:00', 'Room 201'),
(3, '2024-05-20', '09:30:00', '11:30:00', 'Room 102');

-- Inserting sample data into the fee_payments table
INSERT INTO fee_payments (student_id, payment_date, amount) VALUES
(1, '2024-04-01', 500.00),
(2, '2024-04-05', 600.00),
(1, '2024-04-10', 450.00),
(2, '2024-04-15', 550.00);

UPDATE students s
SET s.gpa = (
    SELECT AVG(grade)
    FROM grades g
    WHERE g.enrollment_id IN (SELECT enrollment_id FROM enrollments WHERE student_id = s.student_id)
);

-- Insert students with grades above 3.5 into the scholarships table
INSERT INTO scholarships (student_id, full_name, gpa)
SELECT student_id, CONCAT(first_name, ' ', last_name) AS full_name, gpa
FROM students
WHERE gpa > 3.5;


-- displaying tables
select * from faculties;
select * from students;
select * from grades;
select * from professors;
select * from enrollments;
select * from courses;
select * from rooms;
select * from examinations;
select * from fee_payments;
select * from scholarships;

-- display only students info that take computer science major
SELECT * FROM students WHERE major = 'Computer Science';

-- display students who are female
SELECT * FROM students WHERE gender = 'Female';

-- display courses info that are in the biology faculty
SELECT * FROM courses WHERE faculty_id = 2;

-- show students info with total fees between 800 and 1000
SELECT s.*
FROM students s
WHERE s.student_id IN (
    SELECT fp.student_id
    FROM fee_payments fp
    GROUP BY fp.student_id
    HAVING SUM(fp.amount) BETWEEN 800 AND 1000
);

-- displays exam and room info for exams that are in rooms on the 1st floor
SELECT e.*, r.*
FROM examinations e
INNER JOIN rooms r ON e.location = r.room_number AND r.floor = 1;

-- Displays students who have GPA > 3.5 and professors with salary > 14500
SELECT
    s.first_name AS student_first_name,
    s.last_name AS student_last_name,
    s.email AS student_email,
    s.gpa AS student_gpa,
    p.first_name AS professor_first_name,
    p.last_name AS professor_last_name,
    p.email AS professor_email,
    p.salary AS professor_salary
FROM students s
INNER JOIN professors p ON s.gpa > 3.5 AND p.salary > 14500;


-- Displaying what courses each student is taking
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    (
        SELECT course_name
        FROM courses
        WHERE course_id = e.course_id
    ) AS course_name
FROM students s, enrollments e
WHERE s.student_id = e.student_id;


-- Displays the grades of the students from highest to lowest
SELECT 
    s.first_name, 
    s.last_name, 
    ROUND(g.grade, 2) AS grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
ORDER BY grade DESC;

