--****************************************************
-- Bases de datos: Triggers
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- Sintaxis básica de un trigger
/*
	CREATE OR ALTER TRIGGER trigger_name
	ON NOMBRE_TABLA
	[BEFORE|AFTER] [INSERT|DELETE|UPDATE]
	AS BEGIN
		-- Cuerpo del trigger
	END;
*/


/*
TABLA INSERTED: almacena los datos nuevos y actualizados en el contexto de un trigger
TABLA DELETED:almacena los datos actualizados y eliminados en el contexto de un trigger

*/


/* 1. Crear un trigger que permita verificar que cada vez
que se incluya una reserva, se evalue el estado VIP
del cliente que ha reservado. Puede suceder alguno de los
siguientes casos:
	- Clientes regulares:
		- Que el cliente mantega el estado de cliente regular
		- Que el cliente obtenga el estado VIP
	- Clientes VIP:
		- Que el cliente mantenga su estado VIP
		- Que el cliente pierda su estado VIP

Utilizar como base la siguiente consulta:
SELECT CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre, ROUND(AVG(CLIENTE_TOTAL_RESERVA.Reserva),2) 'promedio'
FROM (
	SELECT C.id, C.nombre, 
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
			ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'Reserva'
	FROM HABITACION H
		INNER JOIN RESERVA R
			ON H.id = R.id_habitacion
		INNER JOIN CLIENTE C
			ON C.id = R.id_cliente_reserva
		LEFT JOIN EXTRA X 
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
			DATEDIFF (DAY,R.checkin,R.checkout),
				H.precio * DATEDIFF (DAY,R.checkin,R.checkout)
) CLIENTE_TOTAL_RESERVA
GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00
ORDER BY CLIENTE_TOTAL_RESERVA.id ASC;
*/

SELECT * FROM RESERVA;
INSERT INTO RESERVA 
VALUES(201, CONVERT(DATETIME,'01-05-2023 15:00:00',103), CONVERT(DATETIME,'02-05-2023 15:00:00',103), 1, 5, 24);
SELECT * FROM CLIENTE;
DELETE FROM RESERVA WHERE id > 200;





CREATE OR ALTER FUNCTION check_vip(@id_cliente INT)
RETURNS BIT
AS BEGIN
	DECLARE @vip BIT;
	SELECT @vip = CASE 
		WHEN exists (
			SELECT CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre, ROUND(AVG(CLIENTE_TOTAL_RESERVA.Reserva),2) 'promedio'
			FROM (
				SELECT C.id, C.nombre, 
						H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
						ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'Reserva'
				FROM HABITACION H
					INNER JOIN RESERVA R
						ON H.id = R.id_habitacion
					INNER JOIN CLIENTE C
						ON C.id = R.id_cliente_reserva
					LEFT JOIN EXTRA X 
						ON R.id = X.id_reserva
					LEFT JOIN SERVICIO S
						ON S.id = X.id_servicio
				GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
						DATEDIFF (DAY,R.checkin,R.checkout),
							H.precio * DATEDIFF (DAY,R.checkin,R.checkout)
			) CLIENTE_TOTAL_RESERVA
			WHERE CLIENTE_TOTAL_RESERVA.id = @id_cliente
			GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
			HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00	
		)
		THEN 
			1
		ELSE 
			0
		END;
	RETURN @vip;
END;


SELECT dbo.check_vip(23);


CREATE OR ALTER TRIGGER t_check_vip
	ON RESERVA
	AFTER INSERT
	AS BEGIN
		DECLARE @vip BIT;
		DECLARE @id_cliente INT;
		SELECT @id_cliente = id_cliente_reserva FROM inserted;
		SELECT @vip = dbo.check_vip(@id_cliente);
		IF @vip = 0 
		BEGIN
			UPDATE CLIENTE SET vip = 0 WHERE id = @id_cliente;
		END
		ELSE 
		BEGIN
			UPDATE CLIENTE SET vip = 1 WHERE id = @id_cliente;
		END;
	END;
DROP TRIGGER t_check_vip;


SELECT * FROM RESERVA;
INSERT INTO RESERVA 
VALUES(201, CONVERT(DATETIME,'01-05-2023 15:00:00',103), CONVERT(DATETIME,'02-05-2023 15:00:00',103), 1, 5, 24);
SELECT * FROM CLIENTE;
DELETE FROM RESERVA WHERE id > 200;


CREATE OR ALTER TRIGGER t_check_vip_del
	ON RESERVA
	AFTER DELETE
	AS BEGIN
		DECLARE @vip BIT;
		DECLARE @id_cliente INT;
		SELECT @id_cliente = id_cliente_reserva FROM deleted;
		SELECT @vip = dbo.check_vip(@id_cliente);
		IF @vip = 0 
		BEGIN
			UPDATE CLIENTE SET vip = 0 WHERE id = @id_cliente;
		END
		ELSE 
		BEGIN
			UPDATE CLIENTE SET vip = 1 WHERE id = @id_cliente;
		END;
	END;

DELETE FROM RESERVA WHERE id > 200;
SELECT * FROM CLIENTE;

DROP TRIGGER t_check_vip;
DROP TRIGGER t_check_vip_del;

-- 2.	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id del cliente
--		y el id de la habitacion.
--		NOTA: Validar que la nueva reserva no se solape con otras reservas

CREATE OR ALTER PROCEDURE BOOKING 
	@id INT,
	@checkin VARCHAR(32),
	@checkout VARCHAR(32),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO RESERVA VALUES(@id,CONVERT(DATETIME, @checkin, 103),CONVERT(DATETIME, @checkout, 103),@id_metodo_pago,@id_cliente,@id_habitacion);		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH;
END;


CREATE OR ALTER TRIGGER CHECK_BOOKING
ON RESERVA
AFTER INSERT
AS BEGIN
		--declarando variables
		DECLARE @checkin DATETIME;
		DECLARE @checkout DATETIME;
		DECLARE @id_habitacion INT;
		DECLARE @resultado INT;
		--obteniendo datos desde tabla inserted
		SELECT @id_habitacion=i.id_habitacion, @checkin=i.checkin, @checkout=i.checkout 
		FROM inserted i;
		SELECT @resultado = COUNT(*) FROM RESERVA 
		WHERE 
			((@checkin < checkin AND (@checkout BETWEEN checkin AND checkout)) OR
			((@checkin BETWEEN checkin AND checkout) AND @checkout > checkout) OR
			(@checkin >= checkin AND @checkout <= checkout) OR
			(checkin >= @checkin AND checkout <= @checkout)) AND
			id_habitacion = @id_habitacion;
	IF @resultado > 1
	BEGIN 
		RAISERROR ('ERROR: Consulta invalida, la habitacion ya ha sido reservada en la fecha establecida...' ,11,1)
		ROLLBACK TRANSACTION
	END;
END;

EXEC BOOKING 
	201,
	'01-05-2023 15:00:00',
	'02-05-2023 15:00:00',
	1,
	5,
	24;
SELECT * FROM RESERVA WHERE id_habitacion = 24;


EXEC BOOKING 
	202,
	'05-05-2023 15:00:00',
	'06-05-2023 15:00:00',
	1,
	5,
	24;
-- Ejecutando procedimiento almacenado


-- 1.2.	Crear una tabla llamada "REGISTRO_PUNTOS_S#", el objetivo de esta tabla será funcionar
--		como registro de los intercambios de puntos de cliente frecuente que realizan los
--		clientes. La tabla debe almacenar: la fecha y hora de la transaccion, el id y nombre del
--		usuario involucrado, la cantidad de puntos antes y despues de la transacción y una 
--		descriptión breve del proceso realizado.


CREATE TABLE REGISTRO_PUNTOS(
	id INT PRIMARY KEY IDENTITY,
	fecha DATETIME,
	id_cliente INT,
	nombre_cliente VARCHAR(50),
	puntos_ini INT,
	puntos_fin INT,
	descripcion VARCHAR(100)
);

CREATE OR ALTER PROCEDURE TRANSFERIR_PUNTOS
    @id_emisor INT,
    @id_receptor INT,
    @puntos INT
AS BEGIN
    -- Validando si los puntos del cliente emisor son suficiente para realizar la transfencia
    DECLARE @puntos_cliente_emisor INT;
    SELECT @puntos_cliente_emisor = puntos FROM CLIENTE WHERE id = @id_emisor;
    IF @puntos_cliente_emisor < @puntos 
        BEGIN
            PRINT 'ERROR: El cliente no tiene suficientes puntos para ser transferidos :(';
        END
    ELSE   
        BEGIN
            BEGIN TRY 
                BEGIN TRANSACTION TRANSFERENCIA_DE_PUNTOS
                -- Restando puntos al emisor
                UPDATE CLIENTE SET puntos = puntos - @puntos 
                    WHERE id = @id_emisor;
                -- Sumando puntos al receptor
                UPDATE CLIENTE SET puntos = puntos + @puntos 
                    WHERE id = @id_receptor;
                COMMIT TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END TRY
            BEGIN CATCH
                DECLARE @ERROR_MESSAGE VARCHAR(100);
                SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
                PRINT 'ERROR OCURRIDO: '+ @ERROR_MESSAGE;
                ROLLBACK TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END CATCH; 
        END; 
END;


CREATE OR ALTER TRIGGER CHECK_POINTS
ON CLIENTE
AFTER UPDATE
AS BEGIN
	-- Seccion de declaracion de variables
	DECLARE @fecha DATETIME;
	DECLARE @id_cliente INT;
	DECLARE @nombre_cliente VARCHAR(50);
	DECLARE @puntos_ini INT;
	DECLARE @puntos_fin INT;
	DECLARE @descripcion VARCHAR (100);
	-- Sección de procesamiento de datos
	-- obteniendo fecha
	SELECT @fecha = GETDATE();
	SELECT @id_cliente = id, @nombre_cliente = nombre, @puntos_fin = puntos 
	FROM INSERTED;
	SELECT @puntos_ini = puntos FROM DELETED;
	IF @puntos_ini > @puntos_fin 
		SET @descripcion = 'Cliente ha gastado o regalado puntos';
	ELSE
		SET @descripcion = 'Cliente ha recibido puntos';

	INSERT INTO REGISTRO_PUNTOS (fecha, id_cliente, nombre_cliente, puntos_ini, puntos_fin, descripcion)
		VALUES(@fecha, @id_cliente, @nombre_cliente, @puntos_ini, @puntos_fin, @descripcion);
END;


EXEC TRANSFERIR_PUNTOS 2, 1, 1000;
SELECT * FROM REGISTRO_PUNTOS;

SELECT * FROM CLIENTE;