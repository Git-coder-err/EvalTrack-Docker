<?php
/**
 * Handles password change for first-time login
 */
include 'config.php';

$response = ['success' => false, 'message' => 'Failed to update password.'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? $_POST['id'] : '';
    $new_password = isset($_POST['new_password']) ? $_POST['new_password'] : '';

    if (empty($id) || empty($new_password)) {
        $response['message'] = "Missing data.";
    }
    else {
        $stmt = $conn->prepare("UPDATE users SET password = ?, must_change_password = 0 WHERE id = ?");
        $stmt->bind_param("ss", $new_password, $id);

        if ($stmt->execute()) {
            $response['success'] = true;
            $response['message'] = "Password updated successfully.";
        }
        else {
            $response['message'] = "Database error: " . $conn->error;
        }
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
