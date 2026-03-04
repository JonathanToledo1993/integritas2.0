<?php
// api/client/catalog/list.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Responder::error("Método no permitido. Use GET.", 405);
}

// Proteger la ruta
AuthMiddleware::requireClient();

try {
    // Listar Catálogo Oficial de Kokoro
    $sql = "
        SELECT id, `key`, name, category, description, durationMins 
        FROM catalog_tests 
        WHERE isActive = 1 
        ORDER BY category ASC, name ASC
    ";

    $stmt = $pdo->query($sql);
    $tests = $stmt->fetchAll();

    Responder::success([
        "catalog" => $tests
    ], "Catálogo de pruebas obtenido.");

}
catch (Exception $e) {
    Responder::error("Error obteniendo catálogo: " . $e->getMessage(), 500);
}
?>
