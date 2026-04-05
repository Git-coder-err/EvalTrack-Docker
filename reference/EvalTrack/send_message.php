<?php
/**
 * send_message.php
 * Saves a message to the MySQL database.
 */
include 'config.php';

$response = ['success' => false, 'message' => 'Failed to send message.'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = isset($_POST['id']) ? $_POST['id'] : null; // JS Timestamp
    $sender_id = isset($_POST['sender_id']) ? $_POST['sender_id'] : '';
    $sender_name = isset($_POST['sender_name']) ? $_POST['sender_name'] : '';
    $receiver_id = isset($_POST['receiver_id']) ? $_POST['receiver_id'] : '';
    $text = isset($_POST['text']) ? $_POST['text'] : '';
    $time_label = isset($_POST['time_label']) ? $_POST['time_label'] : '';

    if (!empty($sender_id) && !empty($receiver_id) && !empty($text)) {
        $stmt = $conn->prepare("INSERT INTO messages (id, sender_id, sender_name, receiver_id, message_text, timestamp_display) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("isssss", $id, $sender_id, $sender_name, $receiver_id, $text, $time_label);

        if ($stmt->execute()) {
            $response['success'] = true;
            $response['message'] = "Message sent.";
        }
        else {
            $response['message'] = "DB Error: " . $conn->error;
        }
        $stmt->close();
    }
    else {
        $response['message'] = "Missing required fields.";
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
