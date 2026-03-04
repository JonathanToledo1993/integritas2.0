-- Base de datos: eintegri_allinone
-- Importación de Catálogo Maestro de Pruebas y Preguntas DEMO (Fase 9)

-- 1. LIMPIEZA PREVIA (Opcional, en caso de re-importar)
DELETE FROM `catalog_tests` WHERE `key` IN ('integridad', 'estabilidad', '16pf', 'liderazgo', 'ventas');

-- 2. INSERTAR PRUEBAS MAESTRAS
INSERT INTO `catalog_tests` (`id`, `key`, `name`, `category`, `description`, `durationMins`, `isActive`, `createdAt`, `updatedAt`) VALUES
('cat_1', 'integridad', 'Integridad', 'Personalidad', 'Evalúa tendencias de comportamiento ético, honestidad, cumplimiento normativo y riesgo conductual en el entorno laboral.', 20, 1, NOW(), NOW()),
('cat_2', 'estabilidad', 'Estabilidad Laboral', 'Personalidad', 'Identifica la probabilidad de permanencia laboral y factores asociados a rotación o abandono del puesto.', 15, 1, NOW(), NOW()),
('cat_3', '16pf', '16 Factores de Personalidad (16PF)', 'Personalidad', 'Explora 16 dimensiones fundamentales de personalidad relevantes para el desempeño laboral y adaptación organizacional.', 35, 1, NOW(), NOW()),
('cat_4', 'liderazgo', 'Liderazgo', 'Habilidad', 'Evalúa competencias de liderazgo, toma de decisiones, influencia interpersonal y gestión de equipos.', 15, 1, NOW(), NOW()),
('cat_5', 'ventas', 'Estilo de Venta', 'Habilidad', 'Evalúa el estilo comercial del evaluado, su orientación al cliente y su capacidad de persuasión en contextos de venta.', 10, 1, NOW(), NOW());

-- 3. INSERTAR PREGUNTAS (5 por prueba para la Demo)
-- Prueba 1: Integridad
INSERT INTO `catalog_questions` (`id`, `testId`, `type`, `questionText`, `points`) VALUES
('cq_1_1', 'cat_1', 'SINGLE_CHOICE', '¿En qué medida consideras importante cumplir con los compromisos laborales adquiridos?', 1),
('cq_1_2', 'cat_1', 'SINGLE_CHOICE', '¿Qué harías si observaras a un compañero llevarse material de la oficina a su casa?', 1),
('cq_1_3', 'cat_1', 'SINGLE_CHOICE', 'Si un supervisor te pide ocultar un pequeño error a un cliente, ¿tú qué harías?', 1),
('cq_1_4', 'cat_1', 'SINGLE_CHOICE', '¿Creo firmemente que las reglas estrictas a veces impiden hacer el trabajo eficientemente?', 1),
('cq_1_5', 'cat_1', 'SINGLE_CHOICE', '¿Alguna vez te has llevado algo de tus antiguos trabajos sin permiso previo?', 1);

-- Prueba 2: Estabilidad Laboral
INSERT INTO `catalog_questions` (`id`, `testId`, `type`, `questionText`, `points`) VALUES
('cq_2_1', 'cat_2', 'SINGLE_CHOICE', '¿Cuánto tiempo sueles visualizarte en un mismo trabajo cuando recién ingresas?', 1),
('cq_2_2', 'cat_2', 'SINGLE_CHOICE', '¿Qué factor es más determinante para que decidas buscar empleo en otra empresa?', 1),
('cq_2_3', 'cat_2', 'SINGLE_CHOICE', 'Cuando el ambiente se pone estresante, yo suelo...', 1),
('cq_2_4', 'cat_2', 'SINGLE_CHOICE', '¿Qué tan de acuerdo estás con "Cambiar de empresa frecuentemente ayuda a crecer profesionalmente"?', 1),
('cq_2_5', 'cat_2', 'SINGLE_CHOICE', 'Si me ofrecen el mismo sueldo pero más cerca de casa, yo...', 1);

-- Prueba 3: 16PF
INSERT INTO `catalog_questions` (`id`, `testId`, `type`, `questionText`, `points`) VALUES
('cq_3_1', 'cat_3', 'SINGLE_CHOICE', 'Generalmente prefiero trabajar:', 1),
('cq_3_2', 'cat_3', 'SINGLE_CHOICE', 'Si alguien se molesta conmigo:', 1),
('cq_3_3', 'cat_3', 'SINGLE_CHOICE', 'A la hora de resolver un problema complejo:', 1),
('cq_3_4', 'cat_3', 'SINGLE_CHOICE', 'En grupos grandes:', 1),
('cq_3_5', 'cat_3', 'SINGLE_CHOICE', 'Cuando planifico unas vacaciones:', 1);

-- Prueba 4: Liderazgo
INSERT INTO `catalog_questions` (`id`, `testId`, `type`, `questionText`, `points`) VALUES
('cq_4_1', 'cat_4', 'SINGLE_CHOICE', 'La mejor forma de motivar a un equipo decaído es:', 1),
('cq_4_2', 'cat_4', 'SINGLE_CHOICE', 'Si dos miembros de tu equipo entran en conflicto, ¿qué haces primero?', 1),
('cq_4_3', 'cat_4', 'SINGLE_CHOICE', '¿Qué opinas sobre delegar tareas críticas?', 1),
('cq_4_4', 'cat_4', 'SINGLE_CHOICE', 'Un líder debe ser visto principalmente como:', 1),
('cq_4_5', 'cat_4', 'SINGLE_CHOICE', 'Ante el fracaso del equipo en un proyecto, un buen líder:', 1);

-- Prueba 5: Estilo de Ventas
INSERT INTO `catalog_questions` (`id`, `testId`, `type`, `questionText`, `points`) VALUES
('cq_5_1', 'cat_5', 'SINGLE_CHOICE', 'Al atender a un cliente nuevo por primera vez, mi prioridad es:', 1),
('cq_5_2', 'cat_5', 'SINGLE_CHOICE', 'Si un cliente objeta sobre el precio del producto:', 1),
('cq_5_3', 'cat_5', 'SINGLE_CHOICE', 'En una venta B2B, ¿qué consideras lo más importante?', 1),
('cq_5_4', 'cat_5', 'SINGLE_CHOICE', 'Cuando me cierran la puerta a una oferta, yo:', 1),
('cq_5_5', 'cat_5', 'SINGLE_CHOICE', 'Para mí, la palabra "Vender" significa:', 1);

-- 4. INSERTAR RESPUESTAS (Opciones genéricas para las preguntas DEMO)

-- Respuestas Integridad 1
INSERT INTO `catalog_answers` (`id`, `questionId`, `text`, `isCorrect`) VALUES
(UUID(), 'cq_1_1', 'No muy importante, siempre que no afecte mi bienestar', 0),
(UUID(), 'cq_1_1', 'Algo importante, pero no vital', 0),
(UUID(), 'cq_1_1', 'Importante en la mayoría de casos', 0),
(UUID(), 'cq_1_1', 'Muy importante, procuro cumplir siempre', 1),
(UUID(), 'cq_1_1', 'Es absolutamente fundamental cumplir', 1);

-- Respuestas Estabilidad 1
INSERT INTO `catalog_answers` (`id`, `questionId`, `text`, `isCorrect`) VALUES
(UUID(), 'cq_2_1', 'Menos de 6 meses', 0),
(UUID(), 'cq_2_1', '1 año', 0),
(UUID(), 'cq_2_1', 'Entre 2 y 3 años', 1),
(UUID(), 'cq_2_1', 'Más de 5 años', 1);

-- Respuestas 16PF 1
INSERT INTO `catalog_answers` (`id`, `questionId`, `text`, `isCorrect`) VALUES
(UUID(), 'cq_3_1', 'Completamente solo en mis proyectos', 0),
(UUID(), 'cq_3_1', 'En equipo colaborativo', 1),
(UUID(), 'cq_3_1', 'Me es indiferente', 0);

-- Respuestas Liderazgo 1
INSERT INTO `catalog_answers` (`id`, `questionId`, `text`, `isCorrect`) VALUES
(UUID(), 'cq_4_1', 'Bajar los objetivos para no frustrar', 0),
(UUID(), 'cq_4_1', 'Dar el ejemplo trabajando más duro', 1),
(UUID(), 'cq_4_1', 'Organizar una reunión de análisis', 1),
(UUID(), 'cq_4_1', 'Ofrecer bonos monetarios', 0);

-- Respuestas Ventas 1
INSERT INTO `catalog_answers` (`id`, `questionId`, `text`, `isCorrect`) VALUES
(UUID(), 'cq_5_1', 'Presentar todo el catálogo rápidamente', 0),
(UUID(), 'cq_5_1', 'Hacer preguntas de dolor y necesidad', 1),
(UUID(), 'cq_5_1', 'Romper el hielo cordialmente', 1),
(UUID(), 'cq_5_1', 'Hablar solo del precio', 0);
