<?php
// api/client/candidates/list.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Responder::error("Método no permitido. Use GET.", 405);
}

// Proteger la ruta
$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];

try {
    // Actualmente las invitaciones MOCK se guardan en evaluation_invites 
    // y no tienen relación con la empresa en la BD mock actual (solo email y token).
    // Idealmente deberían unirse a una tabla "evaluations -> companyId".
    // 
    // Para propósitos visuales de Dashboard, sacaremos las invitaciones genéricas por ahora,
    // o agregaremos una columna ficticia si el schema fallase, pero ajustaremos a la lógica
    // de la DB de la Fase 4:

    $sql = "
        SELECT id, name, email, token, expiresAt, usedAt, createdAt 
        FROM evaluation_invites 
        ORDER BY createdAt DESC
    ";

    // NOTA: Si esta tabla crece, debería filtrarse por creador o compañía. 
    // En el schema original `evaluation_invites` no tiehe FK. Lo dejamos genérico como mock.

    $stmt = $pdo->query($sql);
    $candidates = $stmt->fetchAll();

    Responder::success([
        "candidates" => $candidates
    ], "Postulantes obtenidos.");

}
catch (Exception $e) {
    Responder::error("Error del servidor obteniendo postulantes.", 500);
}
?>
