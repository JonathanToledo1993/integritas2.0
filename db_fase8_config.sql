-- Actualización de Esquema para Módulo de Configuración (Fase 8)
-- Ejecutar en phpMyAdmin

-- 1. Ampliar tabla companies
ALTER TABLE `companies` 
ADD COLUMN IF NOT EXISTS `rfc` varchar(191) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `country` varchar(191) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `logoUrl` varchar(255) DEFAULT NULL;

-- 2. Ampliar tabla users
ALTER TABLE `users` 
ADD COLUMN IF NOT EXISTS `lastName` varchar(191) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `phone` varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `emailPersonal` varchar(191) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `role` varchar(50) NOT NULL DEFAULT 'admin',
ADD COLUMN IF NOT EXISTS `status` varchar(50) NOT NULL DEFAULT 'ACTIVE';

-- 3. Crear tabla users_invitations (Gestión de equipo)
CREATE TABLE IF NOT EXISTS `users_invitations` (
  `id` varchar(191) NOT NULL,
  `companyId` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'recruiter',
  `token` varchar(191) NOT NULL,
  `expiresAt` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `users_invitations_companyId_fkey` (`companyId`),
  CONSTRAINT `users_invitations_companyId_fkey` FOREIGN KEY (`companyId`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Insertar la plantilla de correo por defecto
INSERT IGNORE INTO `email_templates` (`id`, `companyId`, `key`, `name`, `subject`, `bodyHtml`) 
VALUES 
('sys_tpl_1', 'global', 'invitation_eval', 'Nueva Evaluación: Invitación Postulante', 'Fuiste invitado a una evaluación en [{{NOMBRE_EMPRESA}}]', '<p>Hola {{NOMBRE_POSTULANTE}}, has sido invitado a completar la evaluación: <strong>{{NOMBRE_EVALUACION}}</strong>.</p><p>Haz clic en el siguiente enlace para comenzar:</p><p><a href="{{LINK_EVALUACION}}" class="btn">Comenzar evaluación</a></p>');
