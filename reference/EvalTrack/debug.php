<?php
include 'config.php';
echo "<h2>Database Debugger</h2>";
$res = $conn->query("SELECT COUNT(*) as total FROM users");
if ($res) {
    $row = $res->fetch_assoc();
    echo "Total users in database: " . $row['total'];
}
else {
    echo "Error querying users table: " . $conn->error;
}
echo "<hr>";
echo "<h3>Current Users List:</h3>";
$res2 = $conn->query("SELECT id, name, email, role, password FROM users");
if ($res2 && $res2->num_rows > 0) {
    while ($u = $res2->fetch_assoc()) {
        echo "ID: " . $u['id'] . " | Name: " . $u['name'] . " | Email: " . $u['email'] . " | Role: " . $u['role'] . " | PW: " . $u['password'] . "<br>";
    }
}
else {
    echo "No users found.";
}
?>
