<?php
header('Content-Type: application/json; charset=utf-8');

// Copia aquí exactamente los mismos datos que tienes en tu api/config/db.php de Hostinger
$host = 'localhost';

$db_name = 'eintegri_allinone';
$username = 'eintegri_allinone';
$password = 'allinone2026.K';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo json_encode([
        "status" => "success",
        "message" => "¡Conexión a la base de datos EXITOSA! 🎉 El usuario y contraseña son correctos."
    ]);
}
catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Fallo de BD: " . $e->getMessage()
    ]);
}
?>
