<?php
/**
 * seed_all_subjects.php
 * Extracts subjects from app.js (via mock array) and seeds the database.
 */
include 'config.php';

$subjects = [
    // 1st Year - 1st Sem
    ['GE 4', 'Reading in Philippine History', 3, 'BSIT', 1, 1],
    ['GE 5', 'The Contemporary World', 3, 'BSIT', 1, 1],
    ['GE 11', 'Entrepreneurial Mind', 3, 'BSIT', 1, 1],
    ['GE 9', 'Life and Works of Rizal', 3, 'BSIT', 1, 1],
    ['GE 10', 'Environmental Science', 3, 'BSIT', 1, 1],
    ['CC 101', 'Introduction to Computing 1', 3, 'BSIT', 1, 1],
    ['CC 102', 'Computer Programming 1', 3, 'BSIT', 1, 1],
    ['PE 1', 'Physical Education', 2, 'BSIT', 1, 1],
    ['NSTP 1', 'National Service Training Program 1', 3, 'BSIT', 1, 1],
    ['SF 1', 'Student Formation 1', 2, 'BSIT', 1, 1],
    // 1st Year - 2nd Sem
    ['GE 1', 'Understanding the Self', 3, 'BSIT', 1, 2],
    ['GE 2', 'Mathematics in the Modern World', 3, 'BSIT', 1, 2],
    ['GE 3', 'Purposive Communication', 3, 'BSIT', 1, 2],
    ['CC 103', 'Introduction to Computing', 3, 'BSIT', 1, 2],
    ['HCI 101', 'Human Computer Interaction', 3, 'BSIT', 1, 2],
    ['MS 101 A', 'Discrete Mathematics 1', 3, 'BSIT', 1, 2],
    ['WEBDEV', 'Web Development', 3, 'BSIT', 1, 2],
    ['PE 2', 'Physical Education 2', 2, 'BSIT', 1, 2],
    ['NSTP 2', 'National Service Training Program 2', 3, 'BSIT', 1, 2],
    ['SF 2', 'Student Formation 2', 2, 'BSIT', 1, 2],
    // Summer
    ['GE 12', 'Great Books', 3, 'BSIT', 1, 3],
    ['GE 7', 'Science Technology and Society', 3, 'BSIT', 1, 3],
    // 2nd Year - 1st Sem
    ['GE 6', 'Art Appreciation', 3, 'BSIT', 2, 1],
    ['GE 8', 'Ethics', 3, 'BSIT', 2, 1],
    ['MS 101 B', 'Discrete Mathematics 2', 3, 'BSIT', 2, 1],
    ['PF 101', 'Object Oriented Programming', 3, 'BSIT', 2, 1],
    ['CC 104', 'Data Structure and Algorithms', 3, 'BSIT', 2, 1],
    ['PT 101', 'Platform Technologies', 3, 'BSIT', 2, 1],
    ['IT ELECT 1', 'IT Elective 1', 3, 'BSIT', 2, 1],
    ['PE 3', 'Physical Education 3', 2, 'BSIT', 2, 1],
    ['SF 3', 'Student Formation 3', 2, 'BSIT', 2, 1]
];

echo "<h1>Seeding All Subjects...</h1>";

$conn->query("SET FOREIGN_KEY_CHECKS = 0;");
$conn->query("TRUNCATE TABLE subjects");

$stmt = $conn->prepare("INSERT INTO subjects (code, title, units, program, year_level, semester) VALUES (?, ?, ?, ?, ?, ?)");

foreach ($subjects as $s) {
    $stmt->bind_param("ssisii", $s[0], $s[1], $s[2], $s[3], $s[4], $s[5]);
    if ($stmt->execute()) {
        echo "<p>✅ Seeded: {$s[0]} - {$s[1]}</p>";
    } else {
        echo "<p style='color:red;'>❌ Error seeding {$s[0]}: " . $stmt->error . "</p>";
    }
}

$conn->query("SET FOREIGN_KEY_CHECKS = 1;");
echo "<h2>🎉 Seeding Complete!</h2>";
?>
