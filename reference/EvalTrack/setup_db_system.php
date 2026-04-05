<?php
/**
 * setup_db_system.php
 * Updated to match EvalTrack_System database schema
 * http://localhost/EvalTrack/setup_db_system.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "evaltrack_db";

echo "<h1>EvalTrack System Database Setup (Match EvalTrack_System)</h1>";

// 1. Connect
$conn = new mysqli($host, $user, $pass);
if ($conn->connect_error) {
    die("<p style='color:red;'>Connection Error: " . $conn->connect_error . "</p>");
}
echo "<p>✅ MySQL Connected.</p>";

// 2. Database
$conn->query("CREATE DATABASE IF NOT EXISTS $dbname");
$conn->select_db($dbname);
echo "<p>✅ Database '$dbname' selected.</p>";

// 3. WIPE Old Tables (Safety first)
$conn->query("SET FOREIGN_KEY_CHECKS = 0;");
$conn->query("DROP TABLE IF EXISTS student_grades");
$conn->query("DROP TABLE IF EXISTS student_enrollments");
$conn->query("DROP TABLE IF EXISTS course_offerings");
$conn->query("DROP TABLE IF EXISTS curriculum_courses");
$conn->query("DROP TABLE IF EXISTS curricula");
$conn->query("DROP TABLE IF EXISTS courses");
$conn->query("DROP TABLE IF EXISTS students");
$conn->query("DROP TABLE IF EXISTS programs");
$conn->query("DROP TABLE IF EXISTS users");
$conn->query("DROP TABLE IF EXISTS grades");
$conn->query("DROP TABLE IF EXISTS messages");
$conn->query("DROP TABLE IF EXISTS prerequisites");
$conn->query("DROP TABLE IF EXISTS subjects");
$conn->query("DROP TABLE IF EXISTS evaluations");
echo "<p>✅ Old tables dropped.</p>";

// 4. CREATE USERS TABLE (matching EvalTrack_System)
$sqlUsers = "CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'dean', 'registrar', 'instructor', 'student') NOT NULL,
    program VARCHAR(50),
    student_type ENUM('regular', 'irregular', 'transferee'),
    must_change_password BOOLEAN DEFAULT 0,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";
if ($conn->query($sqlUsers))
    echo "<p>✅ 'users' table created (EvalTrack_System schema).</p>";
else
    die("Error creating users: " . $conn->error);

// 5. CREATE PROGRAMS TABLE
$sqlPrograms = "CREATE TABLE programs (
    code VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    total_units INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
if ($conn->query($sqlPrograms))
    echo "<p>✅ 'programs' table created.</p>";
else
    die("Error creating programs: " . $conn->error);

// 6. CREATE STUDENTS TABLE
$sqlStudents = "CREATE TABLE students (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    program_code VARCHAR(50) NOT NULL,
    student_type ENUM('regular', 'irregular', 'transferee') NOT NULL,
    year_level INT DEFAULT 1,
    enrollment_status ENUM('active', 'inactive', 'graduated', 'dropped') DEFAULT 'active',
    date_admitted DATE,
    expected_graduation DATE,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    total_units_earned INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (program_code) REFERENCES programs(code) ON DELETE RESTRICT
)";
if ($conn->query($sqlStudents))
    echo "<p>✅ 'students' table created.</p>";
else
    die("Error creating students: " . $conn->error);

// 7. CREATE COURSES TABLE
$sqlCourses = "CREATE TABLE courses (
    code VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    units DECIMAL(3,1) NOT NULL,
    course_type ENUM('GE', 'IT', 'IT Elect', 'NSTP', 'PE', 'SF', 'CAP', 'SP', 'SWT', 'PRAC') NOT NULL,
    lec_hours INT DEFAULT 0,
    lab_hours INT DEFAULT 0,
    prerequisites TEXT,
    corequisites TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";
if ($conn->query($sqlCourses))
    echo "<p>✅ 'courses' table created.</p>";
else
    die("Error creating courses: " . $conn->error);

// 8. CREATE CURRICULA TABLE
$sqlCurricula = "CREATE TABLE curricula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_code VARCHAR(50) NOT NULL,
    curriculum_name VARCHAR(255) NOT NULL,
    description TEXT,
    effective_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    total_units INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (program_code) REFERENCES programs(code) ON DELETE CASCADE
)";
if ($conn->query($sqlCurricula))
    echo "<p>✅ 'curricula' table created.</p>";
else
    die("Error creating curricula: " . $conn->error);

// 9. CREATE CURRICULUM_COURSES TABLE
$sqlCurriculumCourses = "CREATE TABLE curriculum_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    curriculum_id INT NOT NULL,
    course_code VARCHAR(50) NOT NULL,
    year_level INT NOT NULL,
    semester ENUM('1st', '2nd', 'Summer') NOT NULL,
    is_elective BOOLEAN DEFAULT FALSE,
    sequence_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (curriculum_id) REFERENCES curricula(id) ON DELETE CASCADE,
    FOREIGN KEY (course_code) REFERENCES courses(code) ON DELETE CASCADE,
    UNIQUE KEY unique_curriculum_course (curriculum_id, course_code, year_level, semester)
)";
if ($conn->query($sqlCurriculumCourses))
    echo "<p>✅ 'curriculum_courses' table created.</p>";
else
    die("Error creating curriculum_courses: " . $conn->error);

// 10. CREATE COURSE_OFFERINGS TABLE
$sqlCourseOfferings = "CREATE TABLE course_offerings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(50) NOT NULL,
    term VARCHAR(50) NOT NULL,
    section VARCHAR(50),
    instructor_id VARCHAR(50),
    schedule TEXT,
    room VARCHAR(50),
    max_capacity INT DEFAULT 30,
    current_enrolled INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_code) REFERENCES courses(code) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE SET NULL
)";
if ($conn->query($sqlCourseOfferings))
    echo "<p>✅ 'course_offerings' table created.</p>";
else
    die("Error creating course_offerings: " . $conn->error);

// 11. CREATE STUDENT_ENROLLMENTS TABLE
$sqlStudentEnrollments = "CREATE TABLE student_enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    course_offering_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('enrolled', 'dropped', 'completed', 'failed', 'withdrawn') DEFAULT 'enrolled',
    final_grade DECIMAL(4,2),
    grade_status ENUM('passed', 'failed', 'incomplete'),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE
)";
if ($conn->query($sqlStudentEnrollments))
    echo "<p>✅ 'student_enrollments' table created.</p>";
else
    die("Error creating student_enrollments: " . $conn->error);

// 12. CREATE STUDENT_GRADES TABLE
$sqlStudentGrades = "CREATE TABLE student_grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    course_code VARCHAR(50) NOT NULL,
    term VARCHAR(50) NOT NULL,
    preliminary_grade DECIMAL(4,2),
    midterm_grade DECIMAL(4,2),
    final_grade DECIMAL(4,2),
    average_grade DECIMAL(4,2),
    grade_status ENUM('passed', 'failed', 'incomplete', 'dropped') NOT NULL,
    attendance_rate DECIMAL(5,2),
    date_completed DATE,
    instructor_id VARCHAR(50),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_code) REFERENCES courses(code) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE SET NULL
)";
if ($conn->query($sqlStudentGrades))
    echo "<p>✅ 'student_grades' table created.</p>";
else
    die("Error creating student_grades: " . $conn->error);

// 13. CREATE MESSAGES TABLE (for compatibility)
$sqlMessages = "CREATE TABLE messages (
    id BIGINT PRIMARY KEY,
    sender_id VARCHAR(50) NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    receiver_id VARCHAR(50) NOT NULL,
    message_text TEXT NOT NULL,
    timestamp_display VARCHAR(20) NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
if ($conn->query($sqlMessages))
    echo "<p>✅ 'messages' table created (for compatibility).</p>";

// 14. INSERT DEFAULT PROGRAMS
$sqlInsertPrograms = "INSERT INTO programs (code, name, description, total_units) VALUES
('BSIT', 'Bachelor of Science in Information Technology', '4-year degree program focusing on IT fundamentals and applications', 156),
('BSEMC', 'Bachelor of Science in Entertainment and Multimedia Computing', '4-year degree program focusing on multimedia and entertainment technologies', 166)";
if ($conn->query($sqlInsertPrograms))
    echo "<p>✅ Default programs inserted.</p>";

// 15. INSERT DEFAULT ADMIN USER
$sqlInsertAdmin = "INSERT INTO users (id, name, email, password, role) VALUES
('ADMIN001', 'System Administrator', 'admin@jmc.edu.ph', 'admin123', 'admin')";
if ($conn->query($sqlInsertAdmin))
    echo "<p>✅ Default admin user inserted.</p>";

// 16. INSERT BSIT COURSES (from curriculum document)
$sqlInsertCourses = "INSERT INTO courses (code, title, units, course_type, prerequisites) VALUES
('GE 10', 'Environmental Science', 3.0, 'GE', NULL),
('GE 11', 'The Entrepreneurial Mind', 3.0, 'GE', NULL),
('GE 4', 'Readings in the Philippine History', 3.0, 'GE', NULL),
('GE 5', 'The Contemporary World', 3.0, 'GE', NULL),
('GE 9', 'Life and Works of Rizal', 3.0, 'GE', NULL),
('IT 101', 'Introduction to Computing', 3.0, 'IT', NULL),
('IT 102', 'Computer Programming 1', 3.0, 'IT', NULL),
('NSTP 1', 'National Service Training Program I', 3.0, 'NSTP', NULL),
('PE 1', 'Physical Education 1', 2.0, 'PE', NULL),
('SF 1', 'Student Formation 1', 1.0, 'SF', NULL),
('GE 1', 'Understanding the Self', 3.0, 'GE', NULL),
('GE 2', 'Mathematics in the Modern World', 3.0, 'GE', NULL),
('GE 3', 'Purposive Communication', 3.0, 'GE', NULL),
('IT 103', 'Computer Programming 2', 3.0, 'IT', 'IT 102'),
('IT 104', 'Introduction to Human Computer Interaction', 3.0, 'IT', 'IT 101'),
('IT 105', 'Discrete Mathematics 1', 3.0, 'IT', 'IT 102'),
('NSTP 2', 'National Service Training Program II', 3.0, 'NSTP', 'NSTP 1'),
('PE 2', 'Physical Education 2', 2.0, 'PE', 'PE 1'),
('SF 2', 'Student Formation 2', 1.0, 'SF', 'SF 1')";
if ($conn->query($sqlInsertCourses))
    echo "<p>✅ BSIT courses inserted.</p>";

// 17. CREATE BSIT CURRICULUM
$sqlInsertCurriculum = "INSERT INTO curricula (program_code, curriculum_name, description, effective_date, total_units) VALUES
('BSIT', 'BSIT Curriculum 2024', 'Current BSIT curriculum effective 2024', '2024-06-01', 156)";
if ($conn->query($sqlInsertCurriculum))
    echo "<p>✅ BSIT curriculum created.</p>";

// 18. INSERT CURRICULUM COURSES
$curriculumId = $conn->insert_id;
$sqlInsertCurriculumCourses = "INSERT INTO curriculum_courses (curriculum_id, course_code, year_level, semester, sequence_order) VALUES
($curriculumId, 'GE 10', 1, '1st', 1),
($curriculumId, 'GE 11', 1, '1st', 2),
($curriculumId, 'GE 4', 1, '1st', 3),
($curriculumId, 'GE 5', 1, '1st', 4),
($curriculumId, 'GE 9', 1, '1st', 5),
($curriculumId, 'IT 101', 1, '1st', 6),
($curriculumId, 'IT 102', 1, '1st', 7),
($curriculumId, 'NSTP 1', 1, '1st', 8),
($curriculumId, 'PE 1', 1, '1st', 9),
($curriculumId, 'SF 1', 1, '1st', 10),
($curriculumId, 'GE 1', 1, '2nd', 1),
($curriculumId, 'GE 2', 1, '2nd', 2),
($curriculumId, 'GE 3', 1, '2nd', 3),
($curriculumId, 'IT 103', 1, '2nd', 4),
($curriculumId, 'IT 104', 1, '2nd', 5),
($curriculumId, 'IT 105', 1, '2nd', 6),
($curriculumId, 'NSTP 2', 1, '2nd', 7),
($curriculumId, 'PE 2', 1, '2nd', 8),
($curriculumId, 'SF 2', 1, '2nd', 9)";
if ($conn->query($sqlInsertCurriculumCourses))
    echo "<p>✅ First year courses added to curriculum.</p>";

// 19. CREATE INDEXES FOR PERFORMANCE
$sqlIndexes = [
    "CREATE INDEX idx_users_email ON users(email)",
    "CREATE INDEX idx_users_role ON users(role)",
    "CREATE INDEX idx_students_user_id ON students(user_id)",
    "CREATE INDEX idx_students_program ON students(program_code)",
    "CREATE INDEX idx_curriculum_courses_curriculum ON curriculum_courses(curriculum_id)",
    "CREATE INDEX idx_curriculum_courses_course ON curriculum_courses(course_code)",
    "CREATE INDEX idx_student_grades_student ON student_grades(student_id)",
    "CREATE INDEX idx_student_grades_course ON student_grades(course_code)",
    "CREATE INDEX idx_student_enrollments_student ON student_enrollments(student_id)",
    "CREATE INDEX idx_course_offerings_course ON course_offerings(course_code)",
    "CREATE INDEX idx_course_offerings_instructor ON course_offerings(instructor_id)"
];

foreach ($sqlIndexes as $index) {
    $conn->query($index);
}
echo "<p>✅ Database indexes created.</p>";

$conn->query("SET FOREIGN_KEY_CHECKS = 1;");
echo "<h2>🎉 DATABASE SETUP COMPLETE!</h2>";
echo "<p>EvalTrack database now matches EvalTrack_System schema.</p>";
echo "<p><a href='login.html'>Go to Login Page</a></p>";
?>
