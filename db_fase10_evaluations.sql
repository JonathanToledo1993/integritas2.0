-- Base de datos: eintegri_allinone
-- Migración Fase 10: Evaluaciones y Perfiles Avanzados

-- 1. Modificar tabla Profiles
-- Asegurar que 'area' pueda ser texto libre si antes era enum (si ya lo es, ignora)
ALTER TABLE `profiles` MODIFY COLUMN `area` VARCHAR(255) COLLATE utf8mb4_unicode_ci;
-- Agregar duración total de minutos al perfil
ALTER TABLE `profiles` ADD COLUMN IF NOT EXISTS `totalDurationMins` INT DEFAULT 0 AFTER `area`;

-- 2. Crear tabla Pivot para Pruebas dentro de Perfiles
CREATE TABLE IF NOT EXISTS `profile_tests` (
    `profileId` CHAR(36) NOT NULL,
    `testId` VARCHAR(100) NOT NULL COMMENT 'Puede ser ID de catalog_tests o ID UUID de custom_tests',
    `isCustom` TINYINT(1) DEFAULT 0 COMMENT '0=Oficial, 1=Personalizada',
    PRIMARY KEY (`profileId`, `testId`),
    FOREIGN KEY (`profileId`) REFERENCES `profiles`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Crear tabla Maestra de Evaluaciones
CREATE TABLE IF NOT EXISTS `evaluations` (
    `id` CHAR(36) NOT NULL PRIMARY KEY,
    `companyId` CHAR(36) NOT NULL,
    `profileId` CHAR(36) NOT NULL,
    `userId` CHAR(36) NOT NULL COMMENT 'ID del usuario/admin que la creó',
    `cargo` VARCHAR(255) NOT NULL,
    `isConfidential` TINYINT(1) DEFAULT 0,
    `expiresAt` DATETIME NULL DEFAULT NULL,
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT 'ACTIVE, ARCHIVED',
    `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`companyId`) REFERENCES `companies`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`profileId`) REFERENCES `profiles`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`userId`) REFERENCES `users_client`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Re-Estructurar los Candidatos ligados a la Evaluación
CREATE TABLE IF NOT EXISTS `evaluation_candidates` (
    `id` CHAR(36) NOT NULL PRIMARY KEY,
    `evaluationId` CHAR(36) NOT NULL,
    `firstName` VARCHAR(100) NULL,
    `lastName` VARCHAR(100) NULL,
    `email` VARCHAR(150) NULL,
    `inviteToken` VARCHAR(255) NULL UNIQUE COMMENT 'Token para que el candidato entre',
    `status` VARCHAR(50) DEFAULT 'PENDING' COMMENT 'PENDING, IN_PROGRESS, COMPLETED, EXPIRED, DROPPED',
    `globalScore` DECIMAL(5,2) DEFAULT NULL,
    `startedAt` DATETIME NULL DEFAULT NULL,
    `finishedAt` DATETIME NULL DEFAULT NULL,
    `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`evaluationId`) REFERENCES `evaluations`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
