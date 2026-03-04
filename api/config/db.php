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
    // Inject CORS so explicit database errors bubble up to the Client DOM instead of triggering a CORS Policy network block.
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    // Modo Debug: Mostrar el error real para identificar el problema en cPanel u Hostinger
    die(json_encode([
        "status" => "error",
        "message" => "Error interno DB: " . $e->getMessage()
    ]));
}
?>
