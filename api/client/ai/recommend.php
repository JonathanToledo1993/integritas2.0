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

    // 2. Lógica Mock de "IA" (Keyword matching avanzado básico para PHP)
    $descLower = strtolower($jobDescription);
    $selectedTests = [];
    $totalMins = 0;

    // Reglas de ejemplo:
    $keywords = [
        'liderazgo' => ['category' => 'Personalidad', 'reason' => 'evaluar habilidades de gestión de equipos'],
        'ventas' => ['category' => 'Emocional', 'reason' => 'medir tolerancia al rechazo y persuasión'],
        'desarrollador' => ['category' => 'Lógica', 'reason' => 'analizar capacidad de resolución de problemas técnicos'],
        'gerente' => ['category' => 'Personalidad', 'reason' => 'determinar competencias directivas'],
        'atención' => ['category' => 'Emocional', 'reason' => 'verificar empatía y manejo de conflictos'],
        'inglés' => ['category' => 'Idioma', 'reason' => 'validar competencias técnicas del idioma']
    ];

    $matches = [];
    foreach ($keywords as $kw => $rule) {
        if (strpos($descLower, $kw) !== false) {
            $matches[] = $rule;
        }
    }

    // Seleccionamos 2 o 3 pruebas del catálogo que encajen mejor
    // (En un entorno real, aquí se llamaría a la API de OpenAI)

    // Si no pilla nada, agarramos 2 al azar como baseline
    if (empty($matches)) {
        $keysToPick = array_rand($catalog, min(2, count($catalog)));
        if (!is_array($keysToPick))
            $keysToPick = [$keysToPick];

        foreach ($keysToPick as $idx) {
            $t = $catalog[$idx];
            $selectedTests[] = [
                'id' => $t['id'],
                'key' => $t['key'],
                'name' => $t['name'],
                'reason' => 'Prueba fundamental de base recomendada para evaluación estándar.',
                'durationMins' => $t['durationMins']
            ];
            $totalMins += $t['durationMins'];
        }
    }
    else {
        // Mapeo inteligente
        $addedKeys = [];
        foreach ($matches as $match) {
            foreach ($catalog as $t) {
                if (stripos($t['category'], $match['category']) !== false && !in_array($t['key'], $addedKeys)) {
                    $selectedTests[] = [
                        'id' => $t['id'],
                        'key' => $t['key'],
                        'name' => $t['name'],
                        'reason' => 'Recomendado para ' . $match['reason'] . ' según la descripción.',
                        'durationMins' => $t['durationMins']
                    ];
                    $addedKeys[] = $t['key'];
                    $totalMins += $t['durationMins'];
                    break; // Una prueba por keyword encontrada
                }
            }
        }
    }

    // Generar un nombre sugerido
    $bundleName = "Evaluación: " . substr($jobDescription, 0, 30) . "...";

    Responder::success([
        "recommendation" => [
            "bundleName" => $bundleName,
            "description" => "Batería de pruebas diseñada por IA para medir las competencias clave del perfil solicitado.",
            "totalMins" => $totalMins,
            "tests" => $selectedTests
        ]
    ], "Recomendación generada con éxito.");

}
catch (Exception $e) {
    Responder::error("Error procesando IA: " . $e->getMessage(), 500);
}
?>
