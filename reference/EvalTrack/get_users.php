<?php
/**
 * Get all users from Database
 */
include 'config.php';

$sql = "SELECT id, name, email, role, program, year_level, student_type, status, last_seen FROM users";
$result = $conn->query($sql);

$users = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($users);
?>
