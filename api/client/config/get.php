<?php
// api/client/config/get.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    Responder::error("Método no permitido. Use GET.", 405);
}

$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];
$userId = $clientData['id'];

try {
    // Info Empresa
    $stmtC = $pdo->prepare("SELECT name, rfc, phone, country FROM companies WHERE id = ?");
    $stmtC->execute([$companyId]);
    $company = $stmtC->fetch();

    if (!$company) {
        Responder::error("Empresa no encontrada", 404);
    }

    // Info Notificaciones (si existe)
    $notif = [
        "emailOnEvalCompleted" => true,
        "dailySummary" => false
    ];

    $stmtN = $pdo->prepare("SELECT emailOnEvalCompleted, dailySummary FROM notification_settings WHERE userId = ?");
    $stmtN->execute([$userId]);
    $dbNotif = $stmtN->fetch();

    if ($dbNotif) {
        $notif['emailOnEvalCompleted'] = (bool)$dbNotif['emailOnEvalCompleted'];
        $notif['dailySummary'] = (bool)$dbNotif['dailySummary'];
    }

    Responder::success([
        "company" => $company,
        "notifications" => $notif
    ], "Configuración obtenida.");

}
catch (Exception $e) {
    Responder::error("Error obteniendo configuración: " . $e->getMessage(), 500);
}
?>
