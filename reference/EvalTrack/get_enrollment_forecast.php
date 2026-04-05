<?php
/**
 * get_enrollment_forecast.php
 * Analyzes prerequisites and passed grades to suggest next subjects.
 */
include 'config.php';

$response = [
    'success' => false,
    'recommendations' => [],
    'standing' => 'Regular',
    'message' => ''
];

if (isset($_GET['student_id'])) {
    $sid = $_GET['student_id'];
    
    try {
        // 1. Get student info
        $stmtS = $conn->prepare("SELECT program, year_level FROM users WHERE id = ?");
        $stmtS->bind_param("s", $sid);
        $stmtS->execute();
        $student = $stmtS->get_result()->fetch_assoc();
        
        if (!$student) {
            $response['message'] = "Student not found.";
        } else {
            $prog = $student['program'];
            
            // 2. Get passed subjects
            $stmtG = $conn->prepare("SELECT subject_code FROM grades WHERE student_id = ? AND status = 'Passed'");
            $stmtG->bind_param("s", $sid);
            $stmtG->execute();
            $gres = $stmtG->get_result();
            $passedCodes = [];
            while ($g = $gres->fetch_assoc()) {
                $passedCodes[] = $g['subject_code'];
            }
            
            // 3. Get all subjects for this program not yet passed
            $stmtSubs = $conn->prepare("SELECT code, title, year_level, semester FROM subjects WHERE program = ?");
            $stmtSubs->bind_param("s", $prog);
            $stmtSubs->execute();
            $allSubs = $stmtSubs->get_result();
            
            $forecast = [];
            while ($sub = $allSubs->fetch_assoc()) {
                $code = $sub['code'];
                
                // Skip if already passed
                if (in_array($code, $passedCodes)) continue;
                
                // Get prerequisites for this subject
                $stmtPre = $conn->prepare("SELECT prerequisite_code FROM prerequisites WHERE subject_code = ?");
                $stmtPre->bind_param("s", $code);
                $stmtPre->execute();
                $pres = $stmtPre->get_result();
                
                $canTake = true;
                $missing = [];
                while ($p = $pres->fetch_assoc()) {
                    if (!in_array($p['prerequisite_code'], $passedCodes)) {
                        $canTake = false;
                        $missing[] = $p['prerequisite_code'];
                    }
                }
                
                if ($canTake) {
                    $forecast[] = [
                        'code' => $code,
                        'title' => $sub['title'],
                        'year' => $sub['year_level'],
                        'sem' => $sub['semester']
                    ];
                }
            }
            
            // Sort by year and sem
            usort($forecast, function($a, $b) {
                if ($a['year'] == $b['year']) return $a['sem'] - $b['sem'];
                return $a['year'] - $b['year'];
            });
            
            // Cap at next 6 subjects or by current year level logic
            $response['success'] = true;
            $response['recommendations'] = $forecast;
        }
    } catch (Exception $e) {
        $response['message'] = $e->getMessage();
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
