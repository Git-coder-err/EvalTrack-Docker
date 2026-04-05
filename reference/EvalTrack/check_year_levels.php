<?php
require 'config.php';
$countRes = $conn->query('SELECT COUNT(*) as c FROM users');
$count = $countRes->fetch_assoc()['c'];
echo "Total Users: $count\n";

$res = $conn->query('SELECT DISTINCT year_level FROM users');
if (!$res) {
    echo "Query Error: " . $conn->error . "\n";
} else {
    while($row = $res->fetch_assoc()) {
        echo "Year Level: [" . ($row['year_level'] ?? 'NULL') . "]\n";
    }
}
?>
