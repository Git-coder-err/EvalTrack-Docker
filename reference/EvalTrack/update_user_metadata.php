<?php
/**
 * Update user metadata (program, year_level, student_type)
 * Called by Instructor to manage student profiles
 */
include 'config.php';

$response = ['success' => false, 'message' => 'Update failed.'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? trim($_POST['id']) : '';
    $program = isset($_POST['program']) ? trim($_POST['program']) : '';
    $year_level = isset($_POST['year_level']) ? trim($_POST['year_level']) : '';
    $student_type = isset($_POST['student_type']) ? trim($_POST['student_type']) : '';

    if (empty($id)) {
        $response['message'] = "User ID is required.";
    } else {
        $stmt = $conn->prepare("UPDATE users SET program = ?, year_level = ?, student_type = ? WHERE id = ?");
        $stmt->bind_param("ssss", $program, $year_level, $student_type, $id);

        if ($stmt->execute()) {
            $response['success'] = true;
            $response['message'] = "User metadata updated successfully.";
        } else {
            $response['message'] = "Database error: " . $conn->error;
        }
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
