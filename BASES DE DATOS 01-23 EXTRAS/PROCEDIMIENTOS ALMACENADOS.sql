--****************************************************
-- Bases de datos: Transacciones y cursores
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- IMPORTANTE:
-- Para poder realizar algunos ejercicion de esta clase es necesario actualizar la base 
-- de datos HotelManagementDB, por lo que se debe:
--		* Agregar la columna "puntos_cliente_frecuente" de tipo INT a la tabla CLIENTE.
--		* Actualizar la columna recien creada con algunos datos.
ALTER TABLE CLIENTE ADD puntos_cliente_frecuente INT;
SELECT * FROM CLIENTE;

UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3626 WHERE id=3;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2387 WHERE id=4;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1233 WHERE id=5;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4028 WHERE id=6;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3089 WHERE id=7;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4061 WHERE id=8;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4051 WHERE id=9;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1065 WHERE id=10;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1759 WHERE id=11;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2240 WHERE id=12;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4889 WHERE id=13;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2233 WHERE id=14;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2021 WHERE id=15;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2431 WHERE id=16;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2751 WHERE id=17;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2156 WHERE id=18;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4470 WHERE id=19;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1986 WHERE id=20;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3619 WHERE id=21;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3754 WHERE id=22;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3745 WHERE id=23;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4781 WHERE id=24;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3036 WHERE id=25;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4239 WHERE id=26;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3178 WHERE id=27;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3948 WHERE id=28;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1563 WHERE id=29;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4366 WHERE id=30;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3624 WHERE id=31;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3667 WHERE id=32;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4372 WHERE id=33;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3307 WHERE id=34;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4883 WHERE id=35;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2307 WHERE id=36;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4106 WHERE id=37;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3898 WHERE id=38;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4610 WHERE id=39;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3126 WHERE id=40;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2439 WHERE id=41;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1882 WHERE id=42;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2043 WHERE id=43;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3143 WHERE id=44;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1274 WHERE id=45;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4369 WHERE id=46;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2939 WHERE id=47;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4112 WHERE id=48;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3697 WHERE id=49;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2300 WHERE id=50;

SELECT * FROM CLIENTE;

--*****************************************************
/*
CREATE OR ALTER PROCEDURE nombre
AS BEGIN

END;

*/
-- 1.0 	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, 
--		id de metodo de pago, 
--		el id del cliente y el id de la habitacion.
CREATE OR ALTER PROCEDURE insertar_reserva
	@id_reserva INT,
	@checkin VARCHAR(35),
	@checkout VARCHAR(35),
	@id_m_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS BEGIN
	INSERT INTO RESERVA 
		VALUES (@id_reserva, CONVERT(DATETIME,@checkin,103), CONVERT(DATETIME,@checkout,103), @id_m_pago, @id_cliente, @id_habitacion);
END;



EXEC insertar_reserva 201, '07/06/2023 15:00:00','10/06/2023 15:00:00', 2, 5, 10;


-- Procedimientos almacenados con tratamiento de tablas.
-- 1.2. Crear un procedimiento almacenado que reciba como parametros dos enteros
--		El objetivo es mostrar la ganancia de cada hotel y la suma total de la ganancia
--		Parametro 1: numero entero entre 1 y 12 que representa un mes
--		Parametro 2: numero entero que representa un año.

-- Creando consulta que muestra la ganancia de cada hotel en un periodo definido
SELECT dbo.subtotal_habitacion(1);
SELECT dbo.subtotal_servicio(1);

SELECT HO.id, HO.nombre,
		SUM(dbo.subtotal_habitacion(R.id)+dbo.subtotal_servicio(R.id)) 'total'
FROM HOTEL HO
	INNER JOIN HABITACION H
		ON HO.id = H.id_hotel
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
WHERE MONTH (R.checkin) = 5
		AND YEAR(R.checkin) = 2023
GROUP BY HO.id, HO.nombre
ORDER BY HO.id ASC;

-- Creando el procedimiento almacenado
CREATE OR ALTER PROCEDURE ganancia_hoteles
	@mm INT,
	@yy INT
AS BEGIN
	-- Variable que almacenará la ganancia de todos lo hoteles (variable sumador)
	DECLARE @total_global MONEY; 
	-- Variables utilizadas para volcar el contenido de una fila de un cursor
	DECLARE @id INT, @nombre VARCHAR(64), @total_hotel MONEY;
	-- Declaración del cursor
	DECLARE ganancia_hotel CURSOR FOR
		SELECT HO.id, HO.nombre,
				SUM(dbo.subtotal_habitacion(R.id)+dbo.subtotal_servicio(R.id)) 'total'
		FROM HOTEL HO
			INNER JOIN HABITACION H
				ON HO.id = H.id_hotel
			INNER JOIN RESERVA R
				ON H.id = R.id_habitacion
		WHERE MONTH (R.checkin) = 5
				AND YEAR(R.checkin) = 2023
		GROUP BY HO.id, HO.nombre
		ORDER BY HO.id ASC;

	-- La variable sumador se inicializa en 0
	SET @total_global = 0;
	-- Abrir el flujo de cursor (paso importante)
	OPEN ganancia_hotel;

	-- Asumimos que el cursor tiene al menos una fila, entonces volcamos esa fila en las variables
	FETCH NEXT FROM ganancia_hotel INTO @id, @nombre, @total_hotel;

	-- Recorremos el cursor, hasta que no queden filas disponibles
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		-- Imprimir la fila volcada
		PRINT 'Hotel: '+@nombre+', ganancia: $'+CAST (@total_hotel AS VARCHAR(32));
		-- Se suma la ganancia del hotel al total
		SET @total_global += @total_hotel;
		-- se realiza el volcado de la siguiente fila (si existe)
		FETCH NEXT FROM ganancia_hotel INTO @id, @nombre, @total_hotel;
	END;

	PRINT '----------------------------------------------';
	PRINT 'Ganancia total $'+CAST (@total_global AS VARCHAR(32));

	-- Cerrar el flujo del cursor (paso importante)
	CLOSE ganancia_hotel;
	-- liberamos la estructura del cursor de la memoria (paso importante);
	DEALLOCATE ganancia_hotel;
END;

EXEC ganancia_hoteles 05, 2023;




--*****************************************************
--	TRANSACCIONES

-- 2.0	Crear un procedimiento almacenado que permita transferir puntos de cliente frecuente entre
--		2 usuarios. Como parametros se deberan recibir el id del usuario emisor, el id del usuario
--		receptor, y la cantidad de puntos a transferir.
--		NOTA: En la primera version de este ejercicio provocar un error de semantica y observar el resultado


CREATE OR ALTER PROCEDURE transferir_puntos 
	@id_emisor INT,
	@id_receptor INT,
	@puntos INT
AS BEGIN
	IF (SELECT puntos FROM CLIENTE WHERE id = @id_emisor) < @puntos
		PRINT 'ERROR: El cliente no tiene disponible los puntos que se van a tranferir :(';
	ELSE 
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION transferir_puntos
				UPDATE CLIENTE SET puntos = puntos - @puntos WHERE id = @id_emisor;
				DECLARE @error FLOAT;
				SELECT @error = 1/0;
				UPDATE CLIENTE SET puntos = puntos + @puntos WHERE id = @id_receptor;
			COMMIT TRANSACTION transferir_puntos
		END TRY
		BEGIN CATCH
			DECLARE @error_mensaje VARCHAR(100);
			SELECT @error_mensaje = ERROR_MESSAGE();
			PRINT @error_mensaje;
			ROLLBACK TRANSACTION transferir_puntos;
		END CATCH
	END;
END;

EXEC transferir_puntos 1, 2, 110;



SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
-- Ejecutando procedimiento almacenado (se espera un error)


-- Verificando datos


-- 2.1	Crear una version 2 del procedimiento almacenado anterior
--		Utilizar transacciones

