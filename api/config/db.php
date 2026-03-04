<?php
// api/config/db.php

$host = 'localhost';
$db_name = 'eintegri_allinone';
$username = 'eintegri_allinone';
$password = 'allinone2026.K'; // Nueva contraseña sin caracteres problemáticos PDO

try {
    // Configuración PDO con puerto 3306 explícito si se requiere
    $pdo = new PDO("mysql:host=$host;port=3306;dbname=$db_name;charset=utf8", $username, $password);

    // Configurar PDO para lanzar excepciones en caso de error SQL
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Devolver los resultados como arrays asociativos por defecto
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

}
catch (PDOException $e) {
    // Modo Debug: Mostrar el error real para identificar el problema en cPanel
    die(json_encode([
        "success" => false,
        "error" => "Error de conexión DB: " . $e->getMessage()
    ]));
}
?>
