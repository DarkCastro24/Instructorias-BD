-- LABORATORIO PRACTICO 5
-- Estudiante: Diego Eduardo Castro Quintanilla Carnet 00117322

USE Cruise_ManagementV1;

-- ENTREGO EJERCICIO 1:
CREATE OR ALTER FUNCTION ejercicio1 (@fecha DATE, @fecha2 DATE)
RETURNS @tabla TABLE
 (codigo INT,
  Puerto_maritimo_origen VARCHAR(40),
  Puerto_maritimo_destino VARCHAR(40),
  fecha_salida DATETIME,
  fecha_llegada DATETIME,
  Barco VARCHAR(30),
  Capitan VARCHAR(30)
 )
 AS
 BEGIN
    INSERT @tabla
		SELECT v.id, p2.nombre 'Puerto_maritimo_origen' ,p.nombre 'Puerto_maritimo_destino' , v.fecha_salida ,v.fecha_llegada,b.matricula 'Barco', c.nombre 'Capitan'
		FROM VIAJE v
		INNER JOIN PUERTO_MARITIMO p ON v.id_puerto_maritimo_destino = p.id
		INNER JOIN PUERTO_MARITIMO p2 ON v.id_puerto_maritimo_origen = p2.id
		INNER JOIN CAPITAN c ON c.id = v.id_capitan
		INNER JOIN BARCO b ON b.id = v.id_barco
		WHERE (v.fecha_salida between @fecha and @fecha2) OR
		(v.fecha_llegada between @fecha and @fecha2)
	RETURN
END;

-- Probando la funcion del ejercicio 1
SELECT * FROM dbo.ejercicio1('06/08/2023', '06/11/2023');


-- (OPCIONAL) Adicionalmente incluyo la solucion del ejercicio 2: Primero hay que crear una nueva columna y asignar valor 0 a todos los registros.
ALTER TABLE PASAJERO ADD vip int;
UPDATE PASAJERO set vip = 0;

-- Creando el procedimiento almacenado
CREATE OR ALTER PROCEDURE ejercicio2 
AS BEGIN
	DECLARE @id_pasajero INT;

	DECLARE pasajeros_vip CURSOR FOR
	SELECT detalle_reserva.[Id de Pasajero]
	FROM (SELECT p.id 'Id de Pasajero', p.nombre 'Nombre de Pasajero', (ISNULL(SUM(s.precio),0.0) + r.precio) 'Promedio de Reservas'
	FROM PASAJERO p
	LEFT JOIN RESERVA r ON r.id_pasajero = p.id
	LEFT JOIN SERVICIOXRESERVA x ON x.id_reserva = r.id
	LEFT JOIN SERVICIO s ON s.id = x.id_servicio
	GROUP BY p.id, p.nombre,r.precio
	) detalle_reserva
	group by detalle_reserva.[Id de Pasajero] , detalle_reserva.[Nombre de Pasajero]
	having AVG(detalle_reserva.[Promedio de Reservas]) > 1650.00
	order by [Id de Pasajero] asc

	OPEN pasajeros_vip;

	FETCH NEXT FROM pasajeros_vip INTO @id_pasajero;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		UPDATE PASAJERO set vip = 1 WHERE PASAJERO.id = @id_pasajero;
		FETCH NEXT FROM pasajeros_vip INTO @id_pasajero;
	END;
	CLOSE pasajeros_vip;
	DEALLOCATE pasajeros_vip;
END;

-- Probamos el funcionamiento del ejercicio 2
EXEC ejercicio2;

-- Verificamos que se realizaron los cambios
SELECT * FROM PASAJERO;
