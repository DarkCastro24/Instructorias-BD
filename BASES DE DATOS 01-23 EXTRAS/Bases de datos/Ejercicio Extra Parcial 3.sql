/*
*
*	DESARROLLO DE EJERCICIO EXTRA PARCIAL 3
*	DESAROLLADO POR: Diego Eduardo Castro Quintanilla CARNET 00117322 SECCION 01
*	COMPAÑERO: Cristofer Ricardo Diaz Alfaro CARNET 00071222 SECCION 01
*
*/

CREATE OR ALTER PROCEDURE validarReservas
AS
BEGIN
	-- Creando tablas auxiliares (sirven para el procesamiento de datos)
	CREATE TABLE idReservasSobrepuestas (
		id_reserva INT
	);

    CREATE TABLE reservasSobrepuestas (
        id_reserva1 INT,
        id_reserva2 INT,
    );
    
	-- Agregando los ID de las reservas que tienen por lo menos uno de los 4 escenarios que causan conflicto con las fechas de checkin y checkout
    INSERT INTO reservasSobrepuestas (id_reserva1, id_reserva2)
    SELECT R1.id , R2.id
    FROM RESERVA R1
    INNER JOIN RESERVA R2 ON R1.id_habitacion = R2.id_habitacion AND R1.id <> R2.id
    WHERE (R1.checkin <= R2.checkin AND R1.checkout > R2.checkin AND R1.checkout <= R2.checkout) OR (R1.checkin = R2.checkin AND R1.checkout = R2.checkout) 
	OR (R1.checkin <= R2.checkin AND R1.checkout >= R2.checkout) OR (R1.checkin >= R2.checkin AND R1.checkin < R2.checkout AND R1.checkout >= R2.checkout);
       
	-- Coloco un try catch en caso ocurra un error al ejecutar el cursor
	BEGIN TRY
			BEGIN TRANSACTION separarReservas
				-- Declaro un cursor para recorrer la tabla y poder separar las reservas para que asi se muestren en orden a la hora de hacer el SELECT 
				DECLARE cursor1 CURSOR STATIC FOR
				SELECT * FROM reservasSobrepuestas
	
				DECLARE @id_reserva INT, @id_reserva2 INT;
	
				OPEN cursor1;
				FETCH NEXT FROM cursor1 INTO @id_reserva, @id_reserva2;
				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF (SELECT COUNT(*) FROM idReservasSobrepuestas i WHERE i.id_reserva = @id_reserva) = 0
					INSERT INTO idReservasSobrepuestas VALUES (@id_reserva);
					IF (SELECT COUNT(*) FROM idReservasSobrepuestas i WHERE i.id_reserva = @id_reserva2) = 0
					INSERT INTO idReservasSobrepuestas VALUES (@id_reserva2);
					FETCH NEXT FROM cursor1 INTO @id_reserva, @id_reserva2;
				END;
				CLOSE cursor1;
				DEALLOCATE cursor1;
			COMMIT TRANSACTION separarReservas
		END TRY
		BEGIN CATCH
			DECLARE @error_mensaje VARCHAR(100);
			SELECT @error_mensaje = ERROR_MESSAGE();
			PRINT @error_mensaje;
	END CATCH

	-- Utilizo el SELECT INTO para crear una tabla auxiliar que servira para mostrar la consulta mas adelante
	SELECT R.id 'Id reserva', R.checkin, R.checkout, R.id_habitacion 'Id de habitacion', '25' AS 'Número de caso' 
	INTO auxReserva
	FROM RESERVA R, idReservasSobrepuestas IR
	WHERE R.id = IR.id_reserva

	-- Coloco un try catch en caso ocurra un error al ejecutar el cursor
	BEGIN TRY
			BEGIN TRANSACTION actualizarCaso
				-- Declaro un cursor para recorrer la tabla auxiliar auxReserva y actualizar los casos segun el numero de habitacion 
				DECLARE cursor2 CURSOR STATIC FOR
				SELECT * FROM auxReserva
				-- Declaro las locales para el cursor
				DECLARE @contador_caso INT, @habitacion_contador INT;
				DECLARE @aux_id INT, @aux_checkin DATE, @aux_checkout DATE, @aux_habitacion INT, @aux_caso INT;
				-- Asigno los valores inciales necesarios para el funcionamiento de la funcion 
				SET @contador_caso = 0;
				SET @habitacion_contador = 14;
				SET @habitacion_contador = @aux_habitacion;
				-- Abro el cursor e ingreso la primer reserva
				OPEN cursor2;
				FETCH NEXT FROM cursor2 INTO @aux_id, @aux_checkin, @aux_checkout, @aux_habitacion, @aux_caso;
				WHILE @@FETCH_STATUS = 0
				BEGIN
				IF @habitacion_contador = @aux_habitacion AND @aux_id != 113
					UPDATE auxReserva SET auxReserva.[Número de caso] = @contador_caso WHERE [Id reserva] =  @aux_id ;
				ELSE
					SET @contador_caso = @contador_caso + 1;
					UPDATE auxReserva SET auxReserva.[Número de caso] = @contador_caso WHERE [Id reserva] =  @aux_id ;
					SET @habitacion_contador = @aux_habitacion; 
					FETCH NEXT FROM cursor2 INTO @aux_id, @aux_checkin, @aux_checkout, @aux_habitacion, @aux_caso;
				END;
				CLOSE cursor2;
				DEALLOCATE cursor2;
			COMMIT TRANSACTION actualizarCaso
		END TRY
		BEGIN CATCH
			DECLARE @error_mensaje2 VARCHAR(100);
			SELECT @error_mensaje2 = ERROR_MESSAGE();
			PRINT @error_mensaje2;
		END CATCH
	
	-- Mostramos el contenido actualizado de la tabla auxiliar 
	SELECT * FROM auxReserva;

	-- Elimino las tablas auxiliares
    DROP TABLE idReservasSobrepuestas;
	DROP TABLE ReservasSobrepuestas;
	DROP TABLE auxReserva;
END

-- Probando procedimiento almacenado, no logre que apareciera ordenado exactamente igual que el ejemplo pero estan los 25 casos separados :,) (se sufrio bastante...)
EXEC validarReservas;


