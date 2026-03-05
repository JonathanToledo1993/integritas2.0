<?php
// api/client/config/change_password.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    Responder::error("Método no permitido.", 405);
}

// Proteger la ruta
$payloadData = AuthMiddleware::requireClient();
$userId = $payloadData['id'];

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$currentPassword = $data['currentPassword'] ?? '';
$newPassword = $data['newPassword'] ?? '';

if (empty($currentPassword) || empty($newPassword)) {
    Responder::error("Debes ingresar la contraseña actual y la nueva.", 400);
}

if (strlen($newPassword) < 6) {
    Responder::error("La nueva contraseña debe tener al menos 6 caracteres.", 400);
}

try {
    // Verificar contraseña actual
    $stmt = $pdo->prepare("SELECT password FROM users WHERE id = :id LIMIT 1");
    $stmt->execute(['id' => $userId]);
    $user = $stmt->fetch();

    if (!$user) {
        Responder::error("Usuario no encontrado.", 404);
    }

    if (!password_verify($currentPassword, $user['password'])) {
        Responder::error("La contraseña actual es incorrecta.", 401);
    }

    // Hashear y actualizar
    $newHash = password_hash($newPassword, PASSWORD_BCRYPT);
    $updateStmt = $pdo->prepare("UPDATE users SET password = :pwd, updatedAt = NOW() WHERE id = :id");
    $updateStmt->execute([
        'pwd' => $newHash,
        'id' => $userId
    ]);

    Responder::success([], "Contraseña actualizada correctamente.");
}
catch (Exception $e) {
    Responder::error("Error actualizando la contraseña: " . $e->getMessage(), 500);
}
?>
