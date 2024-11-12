-- primera funcion --
CREATE FUNCTION dbo.udfEstadoGrupo(@Activo BIT)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Estado NVARCHAR(20);
    
    SET @Estado = CASE 
        WHEN @Activo = 1 THEN 'Activo'
        WHEN @Activo = 0 THEN 'Inactivo'
        ELSE '**Desconocido**'
    END;
    
    RETURN @Estado;
END;
GO
-- segunda funcion-- 
CREATE FUNCTION dbo.udfDescripcionCancelacion(@TipoCancelacion INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(50);

    SET @Descripcion = CASE 
        WHEN @TipoCancelacion = 1 THEN 'Motivo personal'
        WHEN @TipoCancelacion = 2 THEN 'Problema técnico'
        WHEN @TipoCancelacion = 3 THEN 'Clima adverso'
        WHEN @TipoCancelacion = 4 THEN 'Reunión urgente'
        ELSE 'Otro'
    END;

    RETURN @Descripcion;
END;
GO
--tercera funcion--
CREATE FUNCTION dbo.udfNombreProfesor(@IdProfesor INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Nombre NVARCHAR(100);

    SELECT @Nombre = nombre
    FROM profesores
    WHERE id_profesor = @IdProfesor;

    RETURN ISNULL(@Nombre, '**No encontrado**');
END;
GO
--Tabla grupos: Utilizada para la función udfEstadoGrupo.--
--Tabla clases: Utilizada para la función udfDescripcionCancelacion.--
--Tabla profesores: Utilizada para la función udfNombreProfesor.
