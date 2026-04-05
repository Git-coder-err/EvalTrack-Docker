<?php
/**
 * Quick Start Seed Script
 * Run this ONCE in your browser (e.g., http://localhost/EvalTrack/seed.php)
 * to add the default admin, instructor, and student accounts to your database.
 */

include 'config.php';

// 1. Clear existing users to avoid duplicates
$conn->query("SET FOREIGN_KEY_CHECKS = 0;");
$conn->query("DELETE FROM users");
$conn->query("SET FOREIGN_KEY_CHECKS = 1;");

// 2. Prepare the inserter
$stmt = $conn->prepare("INSERT INTO users (id, name, email, password, role, program, year_level, student_type, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

// 3. Add Admin account
// admin@jmc.edu.ph / Admin
$admin_id = "ADMIN";
$admin_name = "Admin";
$admin_email = "admin@jmc.edu.ph";
$admin_pass = "Admin";

$admin_role = "admin";
$admin_prog = "";
$admin_year = "";
$admin_type = "";
$admin_status = "Active";

$stmt->bind_param("sssssssss", $admin_id, $admin_name, $admin_email, $admin_pass, $admin_role, $admin_prog, $admin_year, $admin_type, $admin_status);
$stmt->execute();

// 4. Add Jerwin Carreon (Instructor)
// jerwin.carreon@jmc.edu.ph / password
$ins_id = "INS001";
$ins_name = "Jerwin Carreon";
$ins_email = "jerwin.carreon@jmc.edu.ph";
$ins_pass = "password";

$ins_role = "instructor";
$ins_status = "Active";

$stmt->bind_param("sssssssss", $ins_id, $ins_name, $ins_email, $ins_pass, $ins_role, $admin_prog, $admin_year, $admin_type, $ins_status);
$stmt->execute();

// 5. Add Genesis G. Diaz (Student)
// genesis.diaz@jmc.edu.ph / 107655
$stu_id = "107655";
$stu_name = "Genesis G. Diaz";
$stu_email = "genesis.diaz@jmc.edu.ph";
$stu_pass = "107655";

$stu_role = "student";
$stu_prog = "BSIT";
$stu_year = "3";
$stu_type = "regular";
$stu_status = "Active";

$stmt->bind_param("sssssssss", $stu_id, $stu_name, $stu_email, $stu_pass, $stu_role, $stu_prog, $stu_year, $stu_type, $stu_status);
$stmt->execute();

echo "<h2>✅ Database Seeded Successfully!</h2>";
echo "<p>The following accounts are now ready in your MySQL Database:</p>";
echo "<table border='1' cellpadding='10' style='border-collapse: collapse;'>
    <tr><th>Role</th><th>Email / Username</th><th>Password</th></tr>
    <tr><td><b>Admin</b></td><td>admin@jmc.edu.ph</td><td>Admin</td></tr>
    <tr><td><b>Instructor</b></td><td>jerwin.carreon@jmc.edu.ph</td><td>password</td></tr>
    <tr><td><b>Student</b></td><td>genesis.diaz@jmc.edu.ph</td><td>107655</td></tr>
</table>";
echo "<p><br><a href='login.html' style='padding: 10px 20px; background: #6a1b9a; color: white; text-decoration: none; border-radius: 5px;'>Go to Login Page</a></p>";

$stmt->close();
$conn->close();
?>
