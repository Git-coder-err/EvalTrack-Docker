<?php
/**
 * get_standing.php
 * Calculates Regular/Irregular status for all students.
 */
include 'config.php';

$response = [];

try {
    // 1. Get all students
    $students = $conn->query("SELECT id, name, program, year_level, student_type FROM users WHERE role = 'student'");
    
    while ($student = $students->fetch_assoc()) {
        $sid = $student['id'];
        $yearLimit = intval($student['year_level']);
        $prog = $student['program'];
        
        // 2. Get all grades for this student
        $gradeQuery = $conn->prepare("SELECT subject_code, status FROM grades WHERE student_id = ?");
        $gradeQuery->bind_param("s", $sid);
        $gradeQuery->execute();
        $gradesResult = $gradeQuery->get_result();
        $passedSubjects = [];
        $hasFailed = false;
        while ($g = $gradesResult->fetch_assoc()) {
            if ($g['status'] === 'Passed') {
                $passedSubjects[] = $g['subject_code'];
            } else if ($g['status'] === 'Failed') {
                $hasFailed = true;
            }
        }
        
        // 3. Get all subjects for student's program up to they current year level
        // For simplicity, subjects of previous years are prerequisites
        $standing = 'Regular';
        $reason = 'All prerequisites met.';
        
        if ($hasFailed) {
            $standing = 'Irregular';
            $reason = 'Student has failed subjects in history.';
        } else {
            // Check if missing prerequisites for subjects in their current year
            $preQuery = $conn->prepare("
                SELECT p.prerequisite_code, s.title 
                FROM subjects s
                JOIN prerequisites p ON s.code = p.subject_code
                WHERE s.program = ? AND s.year_level <= ?
            ");
            $preQuery->bind_param("si", $prog, $yearLimit);
            $preQuery->execute();
            $preResult = $preQuery->get_result();
            
            while ($pre = $preResult->fetch_assoc()) {
                if (!in_array($pre['prerequisite_code'], $passedSubjects)) {
                    $standing = 'Irregular';
                    $reason = "Missing prerequisite: " . $pre['prerequisite_code'];
                    break;
                }
            }
        }
        
        $response[] = [
            'id' => $sid,
            'name' => $student['name'],
            'program' => $prog,
            'year' => $student['year_level'],
            'standing' => $standing,
            'reason' => $reason
        ];
    }
} catch (Exception $e) {
    // Silence for now
}

header('Content-Type: application/json');
echo json_encode($response);
?>
