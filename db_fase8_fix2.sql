-- Script Correctivo: db_fase8_fix2.sql
-- Ejecutar en phpMyAdmin para resolver los errores de la plantilla de correo

-- 1. Crear la empresa 'global' para satisfacer la regla de Foreign Key de Prisma
INSERT IGNORE INTO `companies` (`id`, `name`, `credits`, `plan`, `isActive`, `createdAt`, `updatedAt`)
VALUES ('global', 'Global (Sistema)', 0, 'PAY_PER_USE', 1, NOW(), NOW());

-- 2. Insertar la plantilla de correo especificando explícitamente el campo 'updatedAt' requerido
INSERT IGNORE INTO `email_templates` (`id`, `companyId`, `key`, `name`, `subject`, `bodyHtml`, `createdAt`, `updatedAt`) 
VALUES 
('sys_tpl_1', 'global', 'invitation_eval', 'Nueva Evaluación: Invitación Postulante', 'Fuiste invitado a una evaluación en [{{NOMBRE_EMPRESA}}]', '<p>Hola {{NOMBRE_POSTULANTE}}, has sido invitado a completar la evaluación: <strong>{{NOMBRE_EVALUACION}}</strong>.</p><p><br></p><p>Haz clic en el siguiente enlace para comenzar:</p><p><br></p><p><a href="{{LINK_EVALUACION}}" class="btn">Comenzar evaluación</a></p>', NOW(), NOW());
