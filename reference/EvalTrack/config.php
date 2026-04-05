<?php
/**
 * evaltrack_db connection configuration
 * This file connects your website to the XAMPP MySQL database.
 */

$host = "localhost";
$user = "root";  // Default XAMPP username
$password = "";  // Default XAMPP password (empty)
$dbname = "evaltrack_db";

// Create connection
$conn = new mysqli($host, $user, $password, $dbname);

// Check if connection worked
if ($conn->connect_error) {
    die("Database Connection failed: " . $conn->connect_error);
}

// Set character set to match what we created in phpMyAdmin
$conn->set_charset("utf8mb4");
?>
