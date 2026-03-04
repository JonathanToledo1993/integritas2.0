<?php
// api/client/catalog/demo.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Responder::error("Método no permitido. Use GET.", 405);
}

// Proteger la ruta
AuthMiddleware::requireClient();

$testId = $_GET['testId'] ?? '';
if (empty($testId)) {
    Responder::error("El ID de la prueba (testId) es requerido.", 400);
}

try {
    // Verificar si la prueba existe en el catálogo
    $stmt = $pdo->prepare("SELECT id, name, category, durationMins FROM catalog_tests WHERE id = ? AND isActive = 1");
    $stmt->execute([$testId]);
    $test = $stmt->fetch();

    if (!$test) {
        Responder::error("Prueba no encontrada en el catálogo oficial.", 404);
    }

    // Traer las primeras 5 preguntas de esta prueba
    $stmtQ = $pdo->prepare("SELECT id, type, questionText FROM catalog_questions WHERE testId = ? LIMIT 5");
    $stmtQ->execute([$testId]);
    $questions = $stmtQ->fetchAll();

    // Llenar las opciones para cada pregunta
    foreach ($questions as &$q) {
        $stmtA = $pdo->prepare("SELECT id, text FROM catalog_answers WHERE questionId = ?");
        $stmtA->execute([$q['id']]);
        $q['options'] = $stmtA->fetchAll();
    }

    Responder::success([
        "test" => $test,
        "questions" => $questions
    ], "Demo cargada exitosamente.");

}
catch (Exception $e) {
    Responder::error("Error cargando demo: " . $e->getMessage(), 500);
}
?>
