<?php
// api/client/config/save.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Responder::error("Método no permitido. Use POST.", 405);
}

$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];
$userId = $clientData['id'];

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$rfc = trim($data['rfc'] ?? '');

try {
    // 1. Update Company (Solo RFC según mockup actual)
    if ($rfc !== '') {
        $stmt = $pdo->prepare("UPDATE companies SET rfc = ?, updatedAt = NOW() WHERE id = ?");
        $stmt->execute([$rfc, $companyId]);
    }

    Responder::success([], "Configuración guardada exitosamente.");

}
catch (Exception $e) {
    Responder::error("Error guardando configuración: " . $e->getMessage(), 500);
}
?>
