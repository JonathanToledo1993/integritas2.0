-- Script de Actualización MySQL - Módulos Secundarios (Fase 6)
-- Ejecutar en phpMyAdmin dentro de la base de datos: eintegri_allinone

-- 1. TABLA DE PERFILES DE PUESTO (PROFILES)
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `testKeys` json NOT NULL,
  `totalMinutes` int(11) NOT NULL DEFAULT 0,
  `hierarchy` varchar(191) DEFAULT NULL,
  `area` varchar(191) DEFAULT NULL,
  `creatorId` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
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
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
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
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `catalog_tests_key_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catalog_questions` (
  `id` varchar(191) NOT NULL,
  `testId` varchar(191) NOT NULL,
  `type` enum('SINGLE_CHOICE','MULTIPLE_CHOICE','TRUE_FALSE','OPEN_ENDED','FILE_OR_IMAGE','TEXT_OR_CASE','LIMITED_TIME') NOT NULL,
  `questionText` text NOT NULL,
  `points` int(11) NOT NULL DEFAULT 1,
  `timeLimitSecs` int(11) DEFAULT NULL,
  `imageUrl` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `catalog_questions_testId_fkey` (`testId`),
  CONSTRAINT `catalog_questions_testId_fkey` FOREIGN KEY (`testId`) REFERENCES `catalog_tests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `catalog_answers` (
  `id` varchar(191) NOT NULL,
  `questionId` varchar(191) NOT NULL,
  `text` text NOT NULL,
  `isCorrect` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `catalog_answers_questionId_fkey` (`questionId`),
  CONSTRAINT `catalog_answers_questionId_fkey` FOREIGN KEY (`questionId`) REFERENCES `catalog_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. TABLAS DE PRUEBAS PERSONALIZADAS P/ EMPRESAS (CUSTOM TESTS - DIGITALIZA)
CREATE TABLE IF NOT EXISTS `custom_tests` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `testKeys` json DEFAULT NULL,
  `totalDuration` int(11) NOT NULL,
  `passingScore` int(11) DEFAULT NULL,
  `isAiGenerated` tinyint(1) NOT NULL DEFAULT 0,
  `creatorId` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_tests_companyId_fkey` (`companyId`),
  KEY `custom_tests_creatorId_fkey` (`creatorId`),
  CONSTRAINT `custom_tests_companyId_fkey` FOREIGN KEY (`companyId`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `custom_tests_creatorId_fkey` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
