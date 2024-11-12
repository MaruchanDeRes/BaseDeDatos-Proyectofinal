-- Cambia el contexto de la base de datos a AdventureWorks2022
USE [AdventureWorks2022];
-- Crea una función definida por el usuario llamada 'udfStatus' que acepta un parámetro de tipo tinyint
CREATE FUNCTION [udfStatus](@Status [tinyint])
-- Especifica que la función retorna un valor de tipo nvarchar(15)
RETURNS [nvarchar](15)
AS
BEGIN
    -- Declara una variable de tipo nvarchar(15) para almacenar el resultado
    DECLARE @ret [nvarchar](15);
    -- Asigna a la variable @ret un valor basado en el valor del parámetro @Status usando una estructura CASE
    SET @ret =
    CASE @Status
        WHEN 1 THEN 'En proceso'     -- Si @Status es 1, retorna 'En proceso'
        WHEN 2 THEN 'Approvado'      -- Si @Status es 2, retorna 'Approvado'
        WHEN 3 THEN 'Retorno'        -- Si @Status es 3, retorna 'Retorno'
        WHEN 4 THEN 'Rechazado'      -- Si @Status es 4, retorna 'Rechazado'
        WHEN 5 THEN 'Enviado'        -- Si @Status es 5, retorna 'Enviado'
        WHEN 6 THEN 'Cancelado'      -- Si @Status es 6, retorna 'Cancelado'
        ELSE '** Invalido **'        -- Para cualquier otro valor, retorna '** Invalido **'
    END;
    -- Retorna el valor asignado a la variable @ret
    RETURN @ret;
END;
SELECT dbo.udfStatus(1) AS StatusDescription;
