<?php
/**
 * setup_db.php
 * RE-DASHED VERSION: Super clear and safe.
 * http://localhost/EvalTrack/setup_db.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "evaltrack_db";

echo "<h1>EvalTrack System Reset</h1>";

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
$conn->query("DROP TABLE IF EXISTS student_goals");
$conn->query("DROP TABLE IF EXISTS evaluations");
$conn->query("DROP TABLE IF EXISTS messages");
$conn->query("DROP TABLE IF EXISTS users");
echo "<p>✅ Old tables dropped.</p>";

// 4. CREATE USERS
$sqlUsers = "CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'instructor', 'admin', 'dean') NOT NULL,
    program VARCHAR(20) DEFAULT 'BSIT',
    year_level VARCHAR(10) DEFAULT '1',
    student_type VARCHAR(20) DEFAULT 'regular',
    status VARCHAR(20) DEFAULT 'Active',
    must_change_password BOOLEAN DEFAULT TRUE,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
if ($conn->query($sqlUsers))
    echo "<p>✅ 'users' table created.</p>";
else
    die("Error creating users: " . $conn->error);

// 5. CREATE MESSAGES
$sqlMsgs = "CREATE TABLE messages (
    id BIGINT PRIMARY KEY,
    sender_id VARCHAR(50) NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    receiver_id VARCHAR(50) NOT NULL,
    message_text TEXT NOT NULL,
    timestamp_display VARCHAR(20) NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
if ($conn->query($sqlMsgs))
    echo "<p>✅ 'messages' table created.</p>";

// 6. CREATE SUBJECTS
$sqlSubjects = "CREATE TABLE subjects (
    code VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    units INT NOT NULL,
    program ENUM('BSIT', 'BSEMC') NOT NULL,
    year_level INT NOT NULL,
    semester INT NOT NULL
)";
if ($conn->query($sqlSubjects))
    echo "<p>✅ 'subjects' table created.</p>";

// 7. CREATE PREREQUISITES
$sqlPrereqs = "CREATE TABLE prerequisites (
    subject_code VARCHAR(20),
    prerequisite_code VARCHAR(20),
    PRIMARY KEY (subject_code, prerequisite_code),
    FOREIGN KEY (subject_code) REFERENCES subjects(code) ON DELETE CASCADE,
    FOREIGN KEY (prerequisite_code) REFERENCES subjects(code) ON DELETE CASCADE
)";
if ($conn->query($sqlPrereqs))
    echo "<p>✅ 'prerequisites' table created.</p>";

// 8. CREATE GRADES
$sqlGrades = "CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50),
    subject_code VARCHAR(20),
    grade DECIMAL(5,2),
    status ENUM('Passed', 'Failed', 'Incomplete'),
    remarks TEXT,
    semester_taken VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_code) REFERENCES subjects(code) ON DELETE CASCADE
)";
if ($conn->query($sqlGrades))
    echo "<p>✅ 'grades' table created.</p>";

// 8.5 SEED SUBJECTS
$sqlSeedSubs = "INSERT INTO subjects (code, title, units, program, year_level, semester) VALUES 
('CC 101', 'Introduction to Computing', 3, 'BSIT', 1, 1),
('CC 102', 'Computer Programming 1', 3, 'BSIT', 1, 2),
('CC 103', 'Computer Programming 2', 3, 'BSIT', 2, 1),
('IT 201', 'Data Structures', 3, 'BSIT', 2, 2)";
$conn->query($sqlSeedSubs);

// 8.6 SEED PREREQUISITES
$sqlSeedPre = "INSERT INTO prerequisites (subject_code, prerequisite_code) VALUES 
('CC 102', 'CC 101'),
('CC 103', 'CC 102'),
('IT 201', 'CC 103')";
$conn->query($sqlSeedPre);

// 9. INSERT ACCOUNTS (Safe bind_param)
$stmt = $conn->prepare("INSERT INTO users (id, name, email, password, role, program, year_level, student_type, status, must_change_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

$must_change = 0; // Existing seeded accounts don't necessarily need to change immediately if we know the password

// ADMIN 
$a_id = "ADMIN";
$a_name = "Admin";
$a_email = "admin@jmc.edu.ph";
$a_pass = "Admin";
$a_role = "admin";
$a_p = "";
$a_y = "";
$a_t = "";
$a_s = "Active";
$stmt->bind_param("sssssssssi", $a_id, $a_name, $a_email, $a_pass, $a_role, $a_p, $a_y, $a_t, $a_s, $must_change);
$stmt->execute();
echo "<p>✅ Admin Account added.</p>";

// INSTRUCTOR
$i_id = "INS001";
$i_name = "Jerwin Carreon";
$i_email = "jerwin.carreon@jmc.edu.ph";
$i_pass = "password";
$i_role = "instructor";
$i_p = "";
$i_y = "";
$i_t = "";
$i_s = "Active";
$stmt->bind_param("sssssssssi", $i_id, $i_name, $i_email, $i_pass, $i_role, $i_p, $i_y, $i_t, $i_s, $must_change);
$stmt->execute();
echo "<p>✅ Instructor Account added.</p>";

// STUDENT
$s_id = "107655";
$s_name = "Genesis G. Diaz";
$s_email = "genesis.diaz@jmc.edu.ph";
$s_pass = "107655";
$s_role = "student";
$s_p = "BSIT";
$s_y = "3";
$s_t = "regular";
$s_s = "Active";
$stmt->bind_param("sssssssssi", $s_id, $s_name, $s_email, $s_pass, $s_role, $s_p, $s_y, $s_t, $s_s, $must_change);
$stmt->execute();
echo "<p>✅ Student Account added.</p>";

$conn->query("SET FOREIGN_KEY_CHECKS = 1;");
echo "<h2>🎉 EVERYTHING IS READY!</h2>";
echo "<p><a href='login.html'>Go to Login Page</a></p>";
?>
