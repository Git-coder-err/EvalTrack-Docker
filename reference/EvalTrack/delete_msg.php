<?php
include 'config.php';
$response = ['success' => false];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'];
    $stmt = $conn->prepare("DELETE FROM messages WHERE id = ?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        $response['success'] = true;
    }
}
header('Content-Type: application/json');
echo json_encode($response);
?>
