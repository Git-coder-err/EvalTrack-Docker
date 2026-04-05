<?php
/**
 * update_status.php
 * Updates the user's last_seen timestamp in the database.
 */
include 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['user_id'])) {
    $uid = $_POST['user_id'];
    $stmt = $conn->prepare("UPDATE users SET last_seen = NOW() WHERE id = ?");
    $stmt->bind_param("s", $uid);
    $stmt->execute();
    $stmt->close();
}
?>
