<?php
// api/client/evaluations/list.php
require_once '../../config/db.php';
require_once '../../utils/auth_middleware.php';

Responder::setupCORS();

$clientData = AuthMiddleware::requireClient();
$companyId = $clientData['companyId'];

try {
    $sql = "
        SELECT 
            e.id, e.cargo, e.isConfidential, e.expiresAt, e.status, e.createdAt, e.updatedAt,
            p.name as profileName,
            u.name as creatorFirst, u.lastName as creatorLast,
            (SELECT COUNT(*) FROM evaluation_candidates ec WHERE ec.evaluationId = e.id) as totalCandidates,
            (SELECT COUNT(*) FROM evaluation_candidates ec WHERE ec.evaluationId = e.id AND ec.status IN ('COMPLETED')) as finishedCandidates
        FROM evaluations e
        LEFT JOIN profiles p ON e.profileId = p.id
        LEFT JOIN users u ON e.userId = u.id
        WHERE e.companyId = ?
        ORDER BY e.createdAt DESC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([$companyId]);
    $evaluations = $stmt->fetchAll(PDO::FETCH_ASSOC);

    Responder::success([
        "evaluations" => $evaluations
    ]);

}
catch (Exception $e) {
    Responder::error("Error obteniendo evaluaciones.", 500);
}
?>
