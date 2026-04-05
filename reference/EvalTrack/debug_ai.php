<?php
/**
 * debug_ai.php - Test AI connectivity
 */
require_once 'ai_service.php';

echo "<h1>AI Debug Tool</h1>";

// 1. Check cURL
if (function_exists('curl_init')) {
    echo "<p style='color:green;'>✅ cURL is enabled.</p>";
} else {
    echo "<p style='color:red;'>❌ cURL is NOT enabled in your php.ini. Please enable it in XAMPP (php.ini -> remove semicolon from extension=curl).</p>";
}

// 2. Check API Key
if (AI_API_KEY === 'PASTE_YOUR_OPENROUTER_KEY_HERE') {
    echo "<p style='color:orange;'>⚠️ API Key is still a placeholder. Please update ai_config.php.</p>";
} else {
    echo "<p style='color:green;'>✅ API Key found: " . substr(AI_API_KEY, 0, 10) . "...</p>";
}

// 3. Test Query
echo "<h3>Testing Query to OpenRouter...</h3>";
$response = EvalTrackAI::query("You are a tester.", "Say 'Testing 123'");
echo "<div style='padding:10px; border:1px solid #ccc; background:#f0f0f0;'>Response: " . htmlspecialchars($response) . "</div>";
?>
