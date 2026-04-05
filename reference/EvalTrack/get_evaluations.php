<?php
/**
 * get_evaluations.php
 * Fetches all grades/evaluations with student and subject details.
 */
include 'config.php';

$response = [];

try {
    $query = "
        SELECT 
            g.student_id,
            u.name as student_name,
            u.program,
            u.year_level,
            u.student_type,
            g.subject_code,
            g.grade,
            g.status,
            g.remarks as ai_insight,
            g.semester_taken as sem
        FROM grades g
        JOIN users u ON g.student_id = u.id
        ORDER BY g.id DESC
    ";
    
    $result = $conn->query($query);
    
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
} catch (Exception $e) {
    // Handle error quietly or return error in response
}

header('Content-Type: application/json');
echo json_encode($response);
?>
