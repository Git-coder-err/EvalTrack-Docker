<?php
/**
 * ai_config.php - Configuration for AI Services
 * PASTE YOUR API KEY BELOW
 */

// API Keys Configuration - Supports multiple keys for rotation/redundancy
// Add your 10 reserve keys here (system will automatically try them in order)
$AI_API_KEYS = [
    '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', // EvalTrackSmartV1 (Primary)
    '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', // EvalTrackSmartV2
    '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', // EvalTrackSmartV3
    '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', // EvalTrackSmartV4
    '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', // EvalTrackSmartV5
    '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', // EvalTrackSmartV6
    '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', // EvalTrackSmartV7
    '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', // EvalTrackSmartV8
    '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', // EvalTrackSmartV9
    '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', // EvalTrackSmartV10
];
define('AI_MODEL', 'google/gemini-2.0-flash-001'); // Recommended default
define('AI_API_URL', 'https://openrouter.ai/api/v1/chat/completions');

// APP IDENTIFIER (OpenRouter requires this for its leaderboard)
define('AI_SITE_URL', 'http://localhost/EvalTrack');
define('AI_SITE_NAME', 'EvalTrack Automation System');
?>
