<?php
/**
 * ai_service.php - Centralized AI Logic for EvalTrack
 * Handles communication with OpenRouter LLM.
 */
require_once 'ai_config.php';

class EvalTrackAI
{

    /**
     * Sends a prompt to the LLM and returns the response.
     */
    public static function query($systemPrompt, $userPrompt)
    {
        // Access the global variable from ai_config.php
        global $AI_API_KEYS;

        // Ensure we have an array to work with
        $keys = isset($AI_API_KEYS) && is_array($AI_API_KEYS) ? $AI_API_KEYS : [];

        if (empty($keys)) {
            return "AI Error: Please configure your API Keys in ai_config.php";
        }

        foreach ($keys as $index => $apiKey) {
            // Skip empty or placeholder keys
            if (empty($apiKey) || strpos($apiKey, 'RESERVE_KEY') !== false) {
                continue;
            }

            $ch = curl_init();

            $headers = [
                'Content-Type: application/json',
                'Authorization: Bearer ' . $apiKey,
                'HTTP-Referer: ' . AI_SITE_URL,
                'X-Title: ' . AI_SITE_NAME,
            ];

            $payload = [
                'model' => AI_MODEL,
                'messages' => [
                    ['role' => 'system', 'content' => $systemPrompt],
                    ['role' => 'user', 'content' => $userPrompt]
                ],
                'temperature' => 0.7
            ];

            curl_setopt($ch, CURLOPT_URL, AI_API_URL);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

            $response = curl_exec($ch);
            $error = curl_error($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($error) {
                error_log("EvalTrackAI: Key #$index failed (Network Error): $error");
                continue;
            }

            $result = json_decode($response, true);

            if (isset($result['choices'][0]['message']['content'])) {
                return $result['choices'][0]['message']['content'];
            }

            // Check for quota or invalid key errors
            if ($httpCode === 401 || $httpCode === 429 || $httpCode === 402) {
                error_log("EvalTrackAI: Key #$index failed (Quota/Auth-401/429/402). Trying next...");
                continue;
            }

            // If it's another error, return it or try next
            $errMsg = $result['error']['message'] ?? 'Unknown Error';
            error_log("EvalTrackAI: Key #$index API Error: $errMsg");
            if ($index === count($keys) - 1) {
                return "AI Error: " . $errMsg;
            }
        }

        return "AI Error: All configured API channels are currently exhausted. Please add more reserve keys to ai_config.php.";
    }

    /**
     * Context-aware query (RAG)
     */
    public function queryWithContext($systemPrompt, $userPrompt, $studentId = null, $studentName = null)
    {
        if ($studentId) {
            $context = "Context: You are discussing student $studentName (ID: $studentId). ";

            // Fetch student grades for context
            require_once 'config.php';
            global $conn;

            if ($conn) {
                try {
                    $stmt = $conn->prepare("
                        SELECT g.grade, g.status, s.title as subject_name, g.subject_code 
                        FROM grades g 
                        JOIN subjects s ON g.subject_code = s.code 
                        WHERE g.student_id = ?
                        ORDER BY g.id DESC LIMIT 15
                    ");
                    $stmt->bind_param("s", $studentId);
                    $stmt->execute();
                    $result = $stmt->get_result();

                    if ($result->num_rows > 0) {
                        $context .= "Their recent grades in EvalTrack are: ";
                        while ($g = $result->fetch_assoc()) {
                            $context .= "{$g['subject_name']} ({$g['subject_code']}): Grade {$g['grade']} ({$g['status']}); ";
                        }
                    } else {
                        $context .= "This student has no grades recorded in EvalTrack yet.";
                    }
                } catch (Exception $e) {
                    $context .= " (Notice: Database query for context failed: " . $e->getMessage() . ")";
                }
            } else {
                $context .= " (Notice: Database connection for context failed)";
            }

            $systemPrompt .= "\n" . $context;
        }

        return self::query($systemPrompt, $userPrompt);
    }

    /**
     * Utility to generate student insights.
     */
    public static function generateStudentInsight($studentName, $subject, $grade, $status)
    {
        $system = "You are an Academic Advisor at Jose Maria College. Provide a brief, professional, and encouraging AI Insight for a student's evaluation report.";
        $user = "Student: $studentName\nSubject: $subject\nGrade: $grade\nStatus: $status\n\nGenerate a 1-sentence analytical remark.";
        return self::query($system, $user);
    }
}
?>
