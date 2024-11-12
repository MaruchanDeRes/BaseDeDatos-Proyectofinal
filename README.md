# BaseDeDatos-Proyectofinal

-----------------------------------------------------------------------------------------------
storeproduce
--Borra la base de datos  con este nombre
DROP DATABASE [practicaTransactions_22211660]

--Accede al administrador raiz
USE master
GO

--Crea una base de datos con este nombre
CREATE DATABASE [practicaTransactions_22211660]
GO

--Usa la base de datos con ese nombre para futuras referencias
USE [practicaTransactions_22211660]
GO

--Crea una tabla llamada EMPLEADO
CREATE TABLE Empleado(
NoEmpleado int not null default 0 primary key,
ApellidoPaterno varchar (30) not null,
ApellidoMaterno varchar (30),
Nombre varchar (30) not null)

INSERT INTO Empleado (NoEmpleado, ApellidoPaterno, ApellidoMaterno, Nombre) 
	VALUES	(1, 'sandoval', 'marques', 'oscar')
GO
INSERT INTO Empleado (NoEmpleado, ApellidoPaterno, ApellidoMaterno, Nombre) 
	VALUES	(2, 'sandoval', 'rosas', 'oscar')
GO

-- CREAR PROCEDIMIENTO ALMACENADO
CREATE PROCEDURE ObtenerEmpleado
    @Opcion INT,
    @ActualizarViejoRegistro INT,
    @NuevoNoEmpleado INT,
    @EliminarRegistro INT,
    @AgregarNoEmpleado INT,
    @AgregarApeP VARCHAR(30),
    @AgregarApeM VARCHAR(30),
    @AgregarNombre VARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Opción 1: Actualizar el NoEmpleado
        IF @Opcion = 1
            UPDATE Empleado
            SET NoEmpleado = @NuevoNoEmpleado,
                ApellidoPaterno = @AgregarApeP,
                ApellidoMaterno = @AgregarApeM,
                Nombre = @AgregarNombre
            WHERE NoEmpleado = @ActualizarViejoRegistro;
        -- Opción 2: Eliminar un registro de empleado
        IF @Opcion = 2
            DELETE FROM Empleado 
            WHERE NoEmpleado = @EliminarRegistro;
        -- Opción 3: Insertar un nuevo registro de empleado
        IF @Opcion = 3
            INSERT INTO Empleado (NoEmpleado, ApellidoPaterno, ApellidoMaterno, Nombre) 
            VALUES (@AgregarNoEmpleado, @AgregarApeP, @AgregarApeM, @AgregarNombre);
        SELECT * FROM Empleado;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;

--
DROP PROCEDURE ObtenerEmpleado;
-- EXECUTE
EXEC ObtenerEmpleado 
    @Opcion = 1,                
    @ActualizarViejoRegistro = 3,
    @NuevoNoEmpleado = 2,        
    @EliminarRegistro = NULL,    
    @AgregarNoEmpleado = NULL,   
    @AgregarApeP = PEREZ,         
    @AgregarApeM = PEREZ,         
    @AgregarNombre = JUAN;   

    ------------------------------------------------------------------------------------------------------------------------------------------
    
