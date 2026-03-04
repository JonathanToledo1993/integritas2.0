<?php
// api/client/evaluations/create.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Responder::error("Método no permitido.", 405);
}

$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$profileId = trim($data['profileId'] ?? '');
$cargo = trim($data['cargo'] ?? '');
$isConfidential = !empty($data['isConfidential']) ? 1 : 0;
$expiresAt = !empty($data['expiresAt']) ? trim($data['expiresAt']) : null;

if (empty($profileId) || empty($cargo)) {
    Responder::error("Perfil y Cargo son campos obligatorios.");
}

try {
    $evalId = 'EV-' . rand(10000, 99999);

    $sql = "
        INSERT INTO evaluations (id, companyId, profileId, userId, cargo, isConfidential, expiresAt, status, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE', NOW(), NOW())
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $evalId,
        $companyId,
        $profileId,
        $clientData['id'], // userId
        $cargo,
        $isConfidential,
        $expiresAt
    ]);

    Responder::success([
        "evaluationId" => $evalId
    ], "Evaluación creada exitosamente.");

}
catch (Exception $e) {
    Responder::error("Error guardando la evaluación.", 500);
}
?>
