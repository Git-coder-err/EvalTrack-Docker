<?php
/**
 * get_student_grades.php
 * Fetches grades and AI insights for a specific student.
 */
include 'config.php';

$response = [];

if (isset($_GET['student_id'])) {
    $sid = $_GET['student_id'];
    
    try {
        $stmt = $conn->prepare("
            SELECT 
                g.subject_code,
                s.title as subject_desc,
                g.grade,
                g.status,
                g.remarks as ai_insight,
                g.semester_taken as sem
            FROM grades g
            JOIN subjects s ON g.subject_code = s.code
            WHERE g.student_id = ?
            ORDER BY g.id DESC
        ");
        $stmt->bind_param("s", $sid);
        $stmt->execute();
        $result = $stmt->get_result();
        
        while ($row = $result->fetch_assoc()) {
            $response[] = $row;
        }
    } catch (Exception $e) {
        // Handle error
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
