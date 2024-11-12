-- Tabla de auditoría para registrar cambios en la tabla 'grupos'
	 -- ID único para cada registro en la auditoría
	 -- ID del grupo que sufrió el cambio
	 -- ID del profesor asignado en el grupo en el momento del cambio
	 -- ID del curso asignado en el grupo en el momento del cambio
	 -- Estado de actividad del grupo en el momento del cambio
	 -- Tipo de acción realizada: 'INSERT', 'UPDATE', o 'DELETE'
	 -- Fecha y hora del cambio
	 -- Nombre del usuario que realiza el cambio (si es aplicable)
CREATE TABLE auditoria_grupos (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    id_grupo INT, 
    id_profesor INT, 
    id_curso INT,
    activo bit default 1,
    accion VARCHAR(50), 
    fecha_cambio DATETIME DEFAULT GETDATE(), 
    usuario VARCHAR(100) 
);

-- Trigger para registrar inserciones en la tabla 'grupos'
CREATE TRIGGER tr_insert_grupos
ON grupos
AFTER INSERT --Disparador se ativa despues de hacer incerciones en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron insertados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'INSERT' -- Especifica la acción como 'INSERT'
    FROM inserted; -- Usa la tabla 'inserted' para obtener los valores nuevos
END;

-- Trigger para registrar actualizaciones en la tabla 'grupos'
CREATE TRIGGER tr_update_grupos
ON grupos
AFTER UPDATE --Disparador se ativa despues de hacer actualizaciones en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron actualizados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'UPDATE' -- Especifica la acción como 'UPDATE'
    FROM inserted; -- Usa la tabla 'inserted' para obtener los valores después de la actualización
END;

-- Trigger para registrar eliminaciones en la tabla 'grupos'
CREATE TRIGGER tr_delete_grupos
ON grupos
AFTER DELETE --Disparador se ativa despues de hacer bajas en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron eliminados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'DELETE' -- Especifica la acción como 'DELETE'
    FROM deleted; -- Usa la tabla 'deleted' para obtener los valores antes de la eliminación
END;
