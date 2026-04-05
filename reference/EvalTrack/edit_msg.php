<?php
include 'config.php';
$response = ['success' => false];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'];
    $text = $_POST['text'];
    $stmt = $conn->prepare("UPDATE messages SET message_text = ?, is_edited = 1 WHERE id = ?");
    $stmt->bind_param("si", $text, $id);
    if ($stmt->execute()) {
        $response['success'] = true;
    }
}
header('Content-Type: application/json');
echo json_encode($response);
?>
