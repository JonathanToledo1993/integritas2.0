<?php
// api/client/ai/recommend.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Responder::error("Método no permitido. Use POST.", 405);
}

// Proteger la ruta
$clientData = AuthMiddleware::requireClient();

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$jobDescription = trim($data['jobDescription'] ?? '');

if (empty($jobDescription)) {
    Responder::error("Debes ingresar una descripción del cargo.", 400);
}

try {
    // 1. Obtener todas las pruebas base (Las 5 core de Kokoro)
    $stmt = $pdo->query("SELECT id, `key`, name, category, description, durationMins FROM catalog_tests WHERE isActive = 1");
    $catalog = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (count($catalog) === 0) {
        Responder::error("No hay pruebas en el catálogo base para analizar.", 500);
    }

    // 2. Conexión Real a Google Gemini API
    $geminiApiKey = 'AIzaSyA9ryg6uXJ3o7Mn5aay2e1S2nbMuf6feeA';
    $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=' . $geminiApiKey;

    $systemPrompt = "Eres un reclutador experto de Recursos Humanos. Analiza la siguiente descripción de vacante: '$jobDescription'. ";
    $systemPrompt .= "Tu tarea es recomendar EXACTAMENTE entre 2 y 4 pruebas psicológicas/técnicas del siguiente catálogo en formato JSON estricto. ";
    $systemPrompt .= "Este es el catálogo disponible: " . json_encode($catalog) . ". ";
    $systemPrompt .= "RESPONDE ÚNICAMENTE CON UN OBJETO JSON VÁLIDO CON ESTA ESTRUCTURA EXACTA: ";
    $systemPrompt .= '{"bundleName":"Nombre Corto de la Batería Sugerida", "description":"Explicación de por qué elegiste este paquete en 1 oración.", "selectedTests":[{"id":"id_de_la_prueba", "key":"key", "name":"nombre", "reason":"por qué elegiste esta prueba específica en 10 palabras", "durationMins":20}]}';

    $payload = [
        "contents" => [
            [
                "parts" => [
                    ["text" => $systemPrompt]
                ]
            ]
        ],
        "generationConfig" => [
            "temperature" => 0.2,
            "responseMimeType" => "application/json"
        ]
    ];

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json'
    ]);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200 || !$response) {
        Responder::error("Error de conexión con el motor IA de Google (Gemini). Código: $httpCode", 500);
    }

    $geminiData = json_decode($response, true);
    $responseText = $geminiData['candidates'][0]['content']['parts'][0]['text'] ?? null;

    if (!$responseText) {
        Responder::error("El motor IA no devolvió una respuesta válida.", 500);
    }

    // El modelo devuelve un JSON string puro gracias a jsonMode
    $iaRecommendation = json_decode($responseText, true);

    if (!$iaRecommendation || !isset($iaRecommendation['selectedTests'])) {
        Responder::error("Error parseando la estructura de IA. Inténtalo de nuevo.", 500);
    }

    // Calcular minutos totales reales sumando
    $totalMins = 0;
    foreach ($iaRecommendation['selectedTests'] as $st) {
        $totalMins += (int)$st['durationMins'];
    }

    Responder::success([
        "recommendation" => [
            "bundleName" => $iaRecommendation['bundleName'],
            "description" => $iaRecommendation['description'],
            "totalMins" => $totalMins,
            "tests" => $iaRecommendation['selectedTests']
        ]
    ], "Recomendación generada por Gemini con éxito.");

}
catch (Exception $e) {
    Responder::error("Error procesando IA: " . $e->getMessage(), 500);
}
?>
