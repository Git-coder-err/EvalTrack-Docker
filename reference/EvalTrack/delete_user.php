<?php
/**
 * Delete a user from MySQL
 */
include 'config.php';

$response = ['success' => false];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'];

    if (!empty($id)) {
        $stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
        $stmt->bind_param("s", $id);
        if ($stmt->execute()) {
            $response['success'] = true;
        }
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
