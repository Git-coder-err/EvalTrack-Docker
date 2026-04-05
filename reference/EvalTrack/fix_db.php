<?php
/**
 * fix_db.php
 * Adds the 'remarks' column to the 'grades' table if it doesn't exist.
 */
include 'config.php';

echo "<h1>🛠️ Database Column Fix</h1>";

try {
    // Check if remarks column exists
    $result = $conn->query("SHOW COLUMNS FROM grades LIKE 'remarks'");
    
    if ($result->num_rows == 0) {
        $conn->query("ALTER TABLE grades ADD COLUMN remarks TEXT AFTER status");
        echo "<p style='color:green;'>✅ Successfully added 'remarks' column to 'grades' table.</p>";
    } else {
        echo "<p style='color:blue;'>ℹ️ 'remarks' column already exists.</p>";
    }
    
    // Also ensuring DECIMAL precision is correct as per latest plan
    $conn->query("ALTER TABLE grades MODIFY COLUMN grade DECIMAL(5,2)");
    echo "<p style='color:green;'>✅ Updated 'grade' column precision.</p>";

} catch (Exception $e) {
    echo "<p style='color:danger;'>❌ Error: " . $e->getMessage() . "</p>";
}

echo "<p><a href='instructor.html'>Return to Dashboard</a></p>";
?>
