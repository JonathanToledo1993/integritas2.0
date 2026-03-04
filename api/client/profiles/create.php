<?php
// api/client/profiles/create.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Responder::error("Método no permitido. Use POST.", 405);
}

// Proteger la ruta
$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (empty($data['name'])) {
    Responder::error("El nombre del perfil es requerido.");
}

$name = trim($data['name']);
$hierarchy = trim($data['hierarchy'] ?? '');
$area = trim($data['area'] ?? '');

// Asumiremos testKeys vacías por ahora si no envía el frontend
$testKeys = json_encode($data['testKeys'] ?? []);
$totalMinutes = (int)($data['totalMinutes'] ?? 0);

try {
    $profileId = 'prof_' . uniqid();

    $sql = "
        INSERT INTO profiles (id, companyId, name, testKeys, totalMinutes, hierarchy, area, creatorId, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        $profileId,
        $companyId,
        $name,
        $testKeys,
        $totalMinutes,
        $hierarchy,
        $area,
        $clientData['id'] // creatorId
    ]);

    Responder::success([
        "profile" => [
            "id" => $profileId,
            "name" => $name,
            "hierarchy" => $hierarchy,
            "area" => $area
        ]
    ], "Perfil Creado Exitosamente.");

}
catch (Exception $e) {
    Responder::error("Error guardando el perfil: " . $e->getMessage(), 500);
}
?>
