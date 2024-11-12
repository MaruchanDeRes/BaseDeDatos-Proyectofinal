DELIMITER //

-- Procedimiento almacenado: sp_cambiar_profesor_grupo
-- Parámetros:
--   p_id_grupo: ID del grupo en el que se va a realizar el cambio de profesor
--   p_id_profesor_nuevo: ID del nuevo profesor que se asignará al grupo
--   p_fecha_cambio: Fecha en que se realiza el cambio de profesor
CREATE PROCEDURE sp_cambiar_profesor_grupo(
    IN p_id_grupo INT,
    IN p_id_profesor_nuevo INT,
    IN p_fecha_cambio DATE
)
BEGIN
    -- Manejador de errores: en caso de error, se ejecuta ROLLBACK y se muestra un mensaje de error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Revertir la transacción en caso de error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en el procedimiento almacenado';
    END;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Declaración de variables locales
    DECLARE v_id_profesor_actual INT; -- ID del profesor actual del grupo
    DECLARE v_fecha_fin DATE; -- Fecha de fin para el registro en el historial

    -- 1. Obtener el profesor actual del grupo
    -- Guardamos el ID del profesor actual en la variable v_id_profesor_actual
    SELECT id_profesor INTO v_id_profesor_actual
    FROM grupos
    WHERE id_grupo = p_id_grupo;

    -- 2. Comprobar si el profesor ha cambiado
    -- Solo se actualiza si el profesor actual es diferente del nuevo
    IF v_id_profesor_actual <> p_id_profesor_nuevo THEN
        -- 3. Cerrar el registro en historial para el profesor actual
        -- Actualiza la fecha de fin para el registro en historial del profesor actual
        UPDATE historial_profesores_grupos
        SET fecha_fin = p_fecha_cambio
        WHERE id_grupo = p_id_grupo
          AND fecha_fin IS NULL;

        -- 4. Insertar un nuevo registro en historial para el nuevo profesor
        -- Registra el nuevo profesor en el historial con la fecha de inicio del cambio
        INSERT INTO historial_profesores_grupos (id_grupo, id_profesor, fecha_inicio, fecha_fin)
        VALUES (p_id_grupo, p_id_profesor_nuevo, p_fecha_cambio, NULL);

        -- 5. Actualizar el grupo con el nuevo profesor
        UPDATE grupos
        SET id_profesor = p_id_profesor_nuevo
        WHERE id_grupo = p_id_grupo;
    END IF;

    -- Ejemplo de consulta SELECT con JOIN
    -- Muestra información del grupo y su historial después de la actualización
    SELECT g.id_grupo, g.id_profesor, h.fecha_inicio, h.fecha_fin
    FROM grupos g
    JOIN historial_profesores_grupos h ON g.id_grupo = h.id_grupo
    WHERE g.id_grupo = p_id_grupo;

    -- Ejemplo de eliminación (DELETE) de registros antiguos en historial
    -- Elimina registros de historial que son más antiguos de un año
    DELETE FROM historial_profesores_grupos
    WHERE id_grupo = p_id_grupo
      AND id_profesor = v_id_profesor_actual
      AND fecha_inicio < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    -- Confirmar los cambios si todo se ejecutó correctamente
    COMMIT;
END //

DELIMITER ;
