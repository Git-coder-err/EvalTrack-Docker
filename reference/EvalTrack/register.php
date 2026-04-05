<?php
/**
 * Registration handler for EvalTrack
 * Updated to work with EvalTrack_System database schema
 */

include 'config.php';

$response = ['success' => false, 'message' => 'Registration failed.'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? trim($_POST['id']) : '';
    $name = isset($_POST['name']) ? trim($_POST['name']) : '';
    $email = isset($_POST['email']) ? trim($_POST['email']) : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';
    $role = isset($_POST['role']) ? $_POST['role'] : '';
    $program = isset($_POST['program']) ? $_POST['program'] : 'BSIT';
    $student_type = isset($_POST['student_type']) ? $_POST['student_type'] : 'regular';
    $status = 'Active';

    if (empty($email) || empty($password)) {
        $response['message'] = "Required fields are missing.";
    }
    elseif (!preg_match('/@jmc\.edu\.ph$/', $email)) {
        $response['message'] = "Registration is restricted to @jmc.edu.ph emails.";
    }
    else {
        // Check if email already exists
        $check = $conn->prepare("SELECT email FROM users WHERE email = ? OR id = ?");
        $check->bind_param("ss", $email, $id);
        $check->execute();
        if ($check->get_result()->num_rows > 0) {
            $response['message'] = "Email or User ID already exists.";
        }
        else {
            // Check if must_change_password column exists
            $column_check = $conn->query("SHOW COLUMNS FROM users LIKE 'must_change_password'");
            $has_must_change_column = $column_check->num_rows > 0;
            
            // Check if status column exists
            $status_check = $conn->query("SHOW COLUMNS FROM users LIKE 'status'");
            $has_status_column = $status_check->num_rows > 0;
            
            // Build query based on available columns
            if ($has_must_change_column && $has_status_column) {
                // Full query with all columns
                $must_change = ($role === 'student' ? 1 : 0);
                $stmt = $conn->prepare("INSERT INTO users (id, name, email, password, role, program, student_type, must_change_password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("sssssssis", $id, $name, $email, $password, $role, $program, $student_type, $must_change, $status);
            } else {
                // Minimal query without optional columns
                $stmt = $conn->prepare("INSERT INTO users (id, name, email, password, role, program, student_type) VALUES (?, ?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("sssssss", $id, $name, $email, $password, $role, $program, $student_type);
            }

            if ($stmt->execute()) {
                // If student, also create student record
                if ($role === 'student') {
                    $student_check = $conn->query("SHOW TABLES LIKE 'students'");
                    if ($student_check->num_rows > 0) {
                        $student_stmt = $conn->prepare("INSERT INTO students (id, user_id, program_code, student_type, date_admitted, enrollment_status, year_level) VALUES (?, ?, ?, ?, CURDATE(), 'active', 1)");
                        $student_stmt->bind_param("sssss", $id, $id, $program, $student_type, $student_type);
                        $student_stmt->execute();
                    }
                }
                
                $response['success'] = true;
                $response['message'] = "Registration successful!";
            }
            else {
                $response['message'] = "Error saving to database: " . $conn->error;
            }
        }
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
