<?php
/**
 * ai_chat_handler.php - Backend for AI Hub/Chatbot requests
 */
error_reporting(0);
require_once 'ai_service.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$rawData = file_get_contents("php://input");
$data = json_decode($rawData, true);

$topic     = trim($data['topic'] ?? 'General');
$query     = trim($data['query'] ?? '');
$studentId = $data['student_id'] ?? null;
$studentName = $data['student_name'] ?? null;

if (!$query) {
    echo json_encode(['success' => false, 'reply' => 'Query is empty.', 'message' => 'Query is empty']);
    exit;
}

// Normalize topic — strip any icon/emoji prefix that came from innerHTML
$topic = preg_replace('/^[\x{1F300}-\x{1FFFF}\s]+/u', '', $topic);
$topic = trim(preg_replace('/\s+/', ' ', $topic));

// --- Load professional system prompt from promt.md (if available) ---
// This keeps prompt definitions centralized and allows the AI to follow
// your Report + Recommendation + Add/Drop JSON contract.
$programHeadCurriculumSystemPrompt = '';
try {
    // ai_chat_handler.php is in EvalTrack/, so promt.md is in the project root.
    $promtPath = __DIR__ . DIRECTORY_SEPARATOR . 'promt.md';
    // Fallback for older layouts: try one level up.
    if (!is_readable($promtPath)) {
        $promtPath = __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'promt.md';
    }
    if (is_readable($promtPath)) {
        $md = file_get_contents($promtPath);
        $endpointMarker = '## Endpoint: ProgramHead_CurriculumEvaluation_BSIT';
        $posEndpoint = strpos($md, $endpointMarker);
        $posSystem = ($posEndpoint !== false) ? strpos($md, '### SYSTEM PROMPT', $posEndpoint) : false;
        if ($posSystem !== false) {
            $programHeadCurriculumSystemPrompt = trim(substr($md, $posSystem + strlen('### SYSTEM PROMPT')));
        }
    }
} catch (Exception $e) {
    // Silent fallback to inline defaults below
}

if (!$programHeadCurriculumSystemPrompt) {
    $programHeadCurriculumSystemPrompt = 'You are the Program Head Curriculum Evaluation AI for BSIT. Return a professional evaluation report and enrollment recommendation. If data is missing, ask for it.';
}

// System Prompt map — keys are loose-matched substrings
$promptMap = [
    'Schedule Manager'   => "You are a professional Scheduling Assistant for Jose Maria College. Help Program Heads and Deans organize meetings and academic schedules efficiently. Be concise, practical, and professional.",
    'Library AI'         => "You are an Academic Librarian at Jose Maria College (BSIT / BSEMC programs). Recommend books, online resources, and study materials for IT subjects. Provide clickable links where possible.",
    'Goal Coach'         => "You are a Professional Development Coach for educators and students at JMC. Help users set SMART goals, overcome obstacles, and build productive study/teaching habits. Be encouraging but honest.",
    'Career Advisor'     => "You are a Career Advisor specializing in Information Technology. Map out career paths, skills required, and industry trends for IT graduates. Be specific and data-driven.",
    'Exam'               => "You are an Assessment Specialist and educator. Generate quiz questions, multiple-choice tests, true/false sets, and rubrics for academic subjects. Format output clearly.",
    'Quiz'               => "You are an Assessment Specialist. Generate well-structured quiz questions for the subject topic given by the user.",
    'AI Hub'             => "You are the EvalTrack Central Intelligence — a specialized academic advisor at Jose Maria College. Help instructors analyze student performance, suggest enrollment paths, identify at-risk students, and answer academic questions. Be analytical and professional.",
    'Strategy AI'        => "You are a Higher Education Strategy Consultant. Help Deans plan long-term academic strategies, improve institutional KPIs, and manage program growth. Be executive-level in tone.",
    'KPI Coach'          => "You are an Institutional KPI Advisor for a Philippine college. Help track passing rates, retention, and enrollment KPIs. Suggest actionable improvements.",
    'Dean'               => "You are a senior academic consultant advising the Dean of Jose Maria College. Be formal, analytical, and provide executive-quality insights.",
    'Student Evaluation' => $programHeadCurriculumSystemPrompt,
    'Curriculum Evaluation' => $programHeadCurriculumSystemPrompt,
];

$system = "You are a helpful AI assistant for EvalTrack — an academic evaluation and enrollment management system at Jose Maria College, Digos City, Davao del Sur, Philippines.";

foreach ($promptMap as $key => $prompt) {
    if (stripos($topic, $key) !== false) {
        $system = $prompt;
        break;
    }
}

// If the admin's "topic" doesn't match, also detect keywords in the query text.
// This makes the endpoint behavior more reliable during early UI development.
if (
    stripos($query, 'student evaluation') !== false ||
    stripos($query, 'curriculum evaluation') !== false ||
    stripos($query, 'academic progress report') !== false
) {
    $system = $programHeadCurriculumSystemPrompt;
}

$ai = new EvalTrackAI();
$response = $ai->queryWithContext($system, $query, $studentId, $studentName);

// If our system prompt requested strict JSON, validate and clean up the AI response.
// This prevents the UI from failing when the model includes extra non-JSON text.
$finalReply = $response;
$wantsJson = stripos($system, 'return only valid json') !== false;
if ($wantsJson) {
    $decoded = json_decode($response, true);
    if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
        $finalReply = json_encode($decoded, JSON_UNESCAPED_SLASHES);
    } else {
        // Attempt to extract the first JSON object from the text.
        $start = strpos($response, '{');
        $end = strrpos($response, '}');
        if ($start !== false && $end !== false && $end > $start) {
            $candidate = substr($response, $start, $end - $start + 1);
            $decoded2 = json_decode($candidate, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded2)) {
                $finalReply = json_encode($decoded2, JSON_UNESCAPED_SLASHES);
            }
        }
    }
}

echo json_encode([
    'success' => true,
    'reply'   => $finalReply
]);
?>
