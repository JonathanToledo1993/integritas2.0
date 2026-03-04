-- Script de Actualización MySQL - Módulos Secundarios, IA, y Digitaliza (Fase 8)
-- Importante: Ejecutar en phpMyAdmin dentro de la base de datos `eintegri_allinone`
-- Este script CREA las tablas faltantes si no existen para garantizar integridad.

-- 1. TABLA DE PERFILES DE PUESTO (PROFILES)
-- Fix: Changed keys json to text for older cPanel MariaDB versions compatibility if needed, but keeping JSON for standard
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `testKeys` json NOT NULL,
  `totalMinutes` int(11) NOT NULL DEFAULT 0,
  `hierarchy` varchar(191) DEFAULT NULL,
  `area` varchar(191) DEFAULT NULL,
  `creatorId` varchar(191) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `profiles_companyId_fkey` (`companyId`),
  KEY `profiles_creatorId_fkey` (`creatorId`),
  CONSTRAINT `profiles_companyId_fkey` FOREIGN KEY (`companyId`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `profiles_creatorId_fkey` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2. TABLA DE CONFIGURACIÓN DE NOTIFICACIONES (NOTIFICATION SETTINGS)
CREATE TABLE IF NOT EXISTS `notification_settings` (
  `id` varchar(191) NOT NULL,
  `userId` varchar(191) NOT NULL,
  `emailOnEvalCompleted` tinyint(1) NOT NULL DEFAULT 1,
  `dailySummary` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `notification_settings_userId_key` (`userId`),
  CONSTRAINT `notification_settings_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 3. TABLA DE PLANTILLAS DE CORREO (EMAIL TEMPLATES)
CREATE TABLE IF NOT EXISTS `email_templates` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `subject` varchar(191) NOT NULL,
  `bodyHtml` text NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_templates_companyId_key_key` (`companyId`,`key`),
  CONSTRAINT `email_templates_companyId_fkey` FOREIGN KEY (`companyId`) REFERENCES `companies` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 4. TABLAS DEL CATÁLOGO DE PRUEBAS KOKORO (ADMIN LIBRARY)
CREATE TABLE IF NOT EXISTS `catalog_tests` (
  `id` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `durationMins` int(11) DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `catalog_tests_key_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Asegurarnos de tener datos MOCK de prueba oficial para que no arroje error
INSERT IGNORE INTO `catalog_tests` (`id`, `key`, `name`, `category`, `description`, `durationMins`, `isActive`) VALUES 
('cat_1', 'PERS01', 'Test de Liderazgo', 'Personalidad', 'Mide competencias directivas y manejo de equipos.', 20, 1),
('cat_2', 'EMOC01', 'Ventas y Resiliencia', 'Emocional', 'Mide tolerancia a la frustración e inteligencia emocional en el trabajo.', 15, 1),
('cat_3', 'LOGI01', 'Razonamiento Inductivo', 'Lógica', 'Evalúa el nivel de deducción para perfiles técnicos.', 30, 1),
('cat_4', 'VAL01', 'Test de Integridad', 'Valores', 'Analiza propensión al riesgo, robos y apegos a normas.', 20, 1);


-- 5. TABLAS DE PRUEBAS PERSONALIZADAS (CUSTOM TESTS / IA BUNDLES / DIGITALIZA)
-- testKeys column changed to LONGTEXT to avoid cPanel MariaDB json casting issues and support large objects
CREATE TABLE IF NOT EXISTS `custom_tests` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `testKeys` longtext DEFAULT NULL,
  `totalDuration` int(11) NOT NULL,
  `passingScore` int(11) DEFAULT NULL,
  `isAiGenerated` tinyint(1) NOT NULL DEFAULT 0,
  `creatorId` varchar(191) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `custom_tests_companyId_fkey` (`companyId`),
  KEY `custom_tests_creatorId_fkey` (`creatorId`),
  CONSTRAINT `custom_tests_companyId_fkey` FOREIGN KEY (`companyId`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `custom_tests_creatorId_fkey` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. ACTUALIZACIÓN A EVALUATION INVITES (Manejo Global)
-- Agregamos las nuevas columnas para el modal Global "Crear Evaluación" (Confidencialidad, Límite, Metadata)
ALTER TABLE `evaluation_invites` ADD COLUMN IF NOT EXISTS `sourceType` varchar(50) DEFAULT 'profile';
ALTER TABLE `evaluation_invites` ADD COLUMN IF NOT EXISTS `sourceId` varchar(191) DEFAULT NULL;
ALTER TABLE `evaluation_invites` ADD COLUMN IF NOT EXISTS `isConfidential` tinyint(1) NOT NULL DEFAULT 0;
