<?php
/**
 * Login handler for EvalTrack
 * Updated to work with EvalTrack_System database schema
 */

// Include the connection settings
include 'config.php';

// Prepare a clean JSON object for the response
$response = ['success' => false, 'message' => 'An error occurred while logging in.'];

// Only handle POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email_or_id = isset($_POST['email']) ? trim($_POST['email']) : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';

    if (empty($email_or_id) || empty($password)) {
        $response['message'] = "Please enter both credentials.";
    }
    else {
        // Special case for 'admin' shortcut as we have in JS
        if (strtolower($email_or_id) === 'admin') {
            // Check specifically for admin users
            $stmt = $conn->prepare("SELECT id, name, email, password, role, program, student_type, must_change_password, status FROM users WHERE role IN ('admin', 'dean') AND password = ?");
            $stmt->bind_param("s", $password);
        }
        else {
            // Normal search by email or student ID
            $stmt = $conn->prepare("SELECT id, name, email, password, role, program, student_type, must_change_password, status FROM users WHERE (email = ? OR id = ?) AND password = ?");
            $stmt->bind_param("sss", $email_or_id, $email_or_id, $password);
        }

        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();

            if ($user['status'] !== 'Active') {
                $response['message'] = "Your account is currently inactive.";
            }
            else {
                // Success! (Note: In a Real project, use password_verify with hashed passwords)
                $response['success'] = true;
                $response['user'] = [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'role' => $user['role'],
                    'program' => $user['program'],
                    'student_type' => $user['student_type'] ?? 'regular',
                    'must_change_password' => (bool)$user['must_change_password']
                ];
                $response['message'] = "Login successful!";
            }
        }
        else {
            $response['message'] = "Invalid username/email or password.";
        }
    }
}

// Return the result to your app.js as JSON
header('Content-Type: application/json');
echo json_encode($response);
?>
