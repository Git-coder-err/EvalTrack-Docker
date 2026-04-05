<?php
/**
 * get_messages.php
 * Fetches the conversation between two users from MySQL.
 */
include 'config.php';

$sender_id = isset($_GET['sender_id']) ? $_GET['sender_id'] : '';
$receiver_id = isset($_GET['receiver_id']) ? $_GET['receiver_id'] : '';

$messages = [];

if (!empty($sender_id) && !empty($receiver_id)) {
    $stmt = $conn->prepare("SELECT id, sender_id, sender_name, receiver_id, message_text as text, timestamp_display as timestamp, is_edited as edited 
                            FROM messages 
                            WHERE (sender_id = ? AND receiver_id = ?) 
                               OR (sender_id = ? AND receiver_id = ?) 
                            ORDER BY created_at ASC");
    $stmt->bind_param("ssss", $sender_id, $receiver_id, $receiver_id, $sender_id);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        $messages[] = $row;
    }
    $stmt->close();
}

header('Content-Type: application/json');
echo json_encode($messages);
?>
