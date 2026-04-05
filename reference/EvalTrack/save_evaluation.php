<?php
/**
 * save_evaluation.php
 * Saves instructor-submitted grades and generates mock AI insights.
 */
include 'config.php';

$response = ['success' => false, 'message' => 'Failed to save evaluations.'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $rawData = file_get_contents("php://input");
    $data = json_decode($rawData, true);

    if (!$data || !isset($data['studentId']) || !isset($data['grades'])) {
        $response['message'] = "Invalid payload.";
    } else {
        $studentId = $data['studentId'];
        $grades = $data['grades']; // Array of { code, grade, sem, subject }

        $conn->begin_transaction();
        try {
            $stmtCheck = $conn->prepare("SELECT code FROM subjects WHERE code = ?");
            $stmt = $conn->prepare("INSERT INTO grades (student_id, subject_code, grade, status, remarks, semester_taken) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade), status = VALUES(status), remarks = VALUES(remarks), semester_taken = VALUES(semester_taken)");

            foreach ($grades as $g) {
                $code = $g['code'];
                
                // NEW: Validate Subject Existence (Prevents Foreign Key Error)
                $stmtCheck->bind_param("s", $code);
                $stmtCheck->execute();
                if ($stmtCheck->get_result()->num_rows === 0) {
                    throw new Exception("Subject code '$code' does not exist in the institutional database. Please run seed_all_subjects.php or contact Admin.");
                }

                $gradeVal = floatval($g['grade']);
                $sem = $g['sem'];
                
                // Logic for status
                $status = ($gradeVal >= 75) ? 'Passed' : 'Failed';
                
                // REAL AI Insight generation
                require_once 'ai_service.php';
                $studentName = "Student"; // Default
                $resUser = $conn->query("SELECT name FROM users WHERE id = '$studentId'");
                if($row = $resUser->fetch_assoc()) $studentName = $row['name'];

                $remarks = EvalTrackAI::generateStudentInsight($studentName, $code, $gradeVal, $status);
                
                $stmt->bind_param("ssdsss", $studentId, $code, $gradeVal, $status, $remarks, $sem);
                $stmt->execute();
            }

            $conn->commit();
            $response['success'] = true;
            $response['message'] = "Evaluations saved and AI insights generated.";
        } catch (Exception $e) {
            $conn->rollback();
            $response['message'] = "Database error: " . $e->getMessage();
        }
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
