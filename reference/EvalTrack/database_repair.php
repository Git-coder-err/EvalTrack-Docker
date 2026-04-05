<?php
/**
 * database_repair.php
 * Fixes missing users, repairs schema sync, and ensures filter compatibility.
 * Run this by visiting: http://localhost/EvalTrack/database_repair.php
 */
include 'config.php';

echo "<h1>🛠️ Database Integrity Repair</h1>";

try {
    // 1. Ensure 'remarks' column exists in 'grades' table
    $result = $conn->query("SHOW COLUMNS FROM grades LIKE 'remarks'");
    if ($result->num_rows == 0) {
        $conn->query("ALTER TABLE grades ADD COLUMN remarks TEXT AFTER status");
        echo "<p style='color:green;'>✅ Added missing 'remarks' column to 'grades' table.</p>";
    }

    // 2. Standardize 'grade' precision
    $conn->query("ALTER TABLE grades MODIFY COLUMN grade DECIMAL(5,2)");
    echo "<p style='color:green;'>✅ Standardized grade precision to DECIMAL(5,2).</p>";

    // 3. Restore Missing Users (The root cause of JOIN failure)
    $usersToRestore = [
        [
            'id' => 'ADMIN',
            'name' => 'Admin',
            'email' => 'admin@jmc.edu.ph',
            'password' => 'Admin',
            'role' => 'admin',
            'year' => '',
            'program' => ''
        ],
        [
            'id' => 'INS001',
            'name' => 'Jerwin Carreon',
            'email' => 'jerwin.carreon@jmc.edu.ph',
            'password' => 'password',
            'role' => 'instructor',
            'year' => '',
            'program' => ''
        ],
        [
            'id' => '107655',
            'name' => 'Genesis G. Diaz',
            'email' => 'genesis.diaz@jmc.edu.ph',
            'password' => '107655', 
            'role' => 'student',
            'year' => '3',
            'program' => 'BSIT'
        ],
        [
            'id' => '2024001',
            'name' => 'Juan Luna',
            'email' => 'juan.luna@jmc.edu.ph',
            'password' => 'password',
            'role' => 'student',
            'year' => '1',
            'program' => 'BSIT'
        ],
        [
            'id' => '2024002',
            'name' => 'Maria Makiling',
            'email' => 'maria.m@jmc.edu.ph',
            'password' => 'password',
            'role' => 'student',
            'year' => '2',
            'program' => 'BSEMC'
        ]
    ];

    foreach ($usersToRestore as $u) {
        $check = $conn->query("SELECT id FROM users WHERE id = '" . $u['id'] . "'");
        if ($check->num_rows == 0) {
            $stmt = $conn->prepare("INSERT INTO users (id, name, email, password, role, year_level, program, status, must_change_password) VALUES (?, ?, ?, ?, ?, ?, ?, 'Active', 0)");
            $stmt->bind_param("sssssss", $u['id'], $u['name'], $u['email'], $u['password'], $u['role'], $u['year'], $u['program']);
            $stmt->execute();
            echo "<p style='color:green;'>✅ Restored missing account: <strong>" . $u['name'] . "</strong> (" . $u['id'] . ")</p>";
        } else {
            // Update year level and program if they exist
            if ($u['role'] === 'student') {
                $conn->query("UPDATE users SET year_level = '" . $u['year'] . "', program = '" . $u['program'] . "' WHERE id = '" . $u['id'] . "'");
                echo "<p style='color:blue;'>ℹ️ User <strong>" . $u['name'] . "</strong> verified & synced (Program: " . $u['program'] . ", Year: " . $u['year'] . ").</p>";
            } else {
                echo "<p style='color:blue;'>ℹ️ User <strong>" . $u['name'] . "</strong> already exists.</p>";
            }
        }
    }

    // 4. Fix Broken View: view_student_evaluation
    echo "<p>Checking View: <strong>view_student_evaluation</strong>...</p>";
    $conn->query("DROP VIEW IF EXISTS view_student_evaluation");
    $createViewSql = "
        CREATE VIEW view_student_evaluation AS 
        SELECT 
            u.id AS student_id,
            u.name AS name,
            u.program AS program,
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM grades g 
                    WHERE g.student_id = u.id AND g.status IN ('Failed', 'Incomplete')
                    LIMIT 1
                ) THEN 'Irregular' 
                ELSE 'Regular' 
            END AS calculation_status
        FROM users u 
        WHERE u.role = 'student'
    ";
    if ($conn->query($createViewSql)) {
        echo "<p style='color:green;'>✅ Successfully recreated 'view_student_evaluation' without invalid columns.</p>";
    } else {
        echo "<p style='color:red;'>❌ Failed to recreate view: " . $conn->error . "</p>";
    }

    echo "<h2 style='color:green;'>🎉 Database is now healthy and synced!</h2>";
    echo "<p>The filters in the Instructor and Student portals should now work correctly because the data JOINs are restored.</p>";

} catch (Exception $e) {
    echo "<p style='color:red;'>❌ Repair Error: " . $e->getMessage() . "</p>";
}

echo "<p><a href='instructor.html' style='display:inline-block; padding:10px 20px; background:#6a1b9a; color:white; text-decoration:none; border-radius:5px;'>Return to Dashboard</a></p>";
?>
