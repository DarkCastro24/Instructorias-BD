--****************************************************
-- Bases de datos: Funciones y procedimientos almacenados
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

/*CREATE FUNCTION TITULO(Parámetors)
	RETURNS TYPE
	AS BEGIN
		///
	END;*/


-- *****************************************************
-- 1.	Funciones
-- *****************************************************
-- 1.1	Crear una funcion que tome como parametro el id de un cliente
--		y retorne el nombre del pais del que procede dicho cliente.
CREATE OR ALTER FUNCTION obtener_pais(@id_cliente INT)
RETURNS VARCHAR(32)
AS BEGIN 
	DECLARE @pais VARCHAR (32);
	SELECT @pais = P.pais
	FROM PAIS P
		INNER JOIN CLIENTE C
			ON P.id = C.id_pais
	WHERE C.id = @id_cliente;
	RETURN @pais;
END;


-- 1.1.1	Ejecutando la funcion.
SELECT dbo.obtener_pais(1) 'pais del cliente';

-- 1.1.2	Ejecutando la funcion en una consulta.
SELECT *, dbo.obtener_pais(1)  FROM CLIENTE WHERE id = 1;

SELECT id, nombre, categoria_cliente, vip, dbo.obtener_pais(id) 'pais'
FROM CLIENTE;



-- 1.2	Crear una funcion que calcule el sub total de los servicios 
--		extras adquiridos en una reserva.
--		Si la reserva no tiene servicios extras, la funcion retorna 0.0
-- Consulta
/*

*/

SELECT R.id, ISNULL( SUM(DATEDIFF(DAY, R.checkin, R.checkout)* S.precio), 0)
FROM RESERVA R
	LEFT JOIN EXTRA X
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id
ORDER BY R.id ASC;


CREATE OR ALTER FUNCTION subtotal_servicio (@id_reserva INT)
RETURNS MONEY
AS BEGIN
	DECLARE @subtotal MONEY;
	SELECT @subtotal = ISNULL( SUM(DATEDIFF(DAY, R.checkin, R.checkout)* S.precio), 0)
	FROM RESERVA R
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	WHERE R.id = @id_reserva
	GROUP BY R.id
	ORDER BY R.id ASC;
	RETURN @subtotal;
END;

SELECT dbo.subtotal_servicio(2);

SELECT *, dbo.subtotal_servicio(id) FROM RESERVA 



-- 1.3 	Crear una funcion que calcula el sub total de la habitacion utilizada en cada reserva
-- Consulta
/*
SELECT R.id, R.checkin, R.checkout, H.id, H.precio, DATEDIFF(DAY, R.checkin, R.checkout)
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;
*/

SELECT H.precio * DATEDIFF(DAY, R.checkin, R.checkout) 
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;

CREATE OR ALTER FUNCTION subtotal_habitacion (@id_reserva INT)
RETURNS MONEY
AS BEGIN
	DECLARE @subtotal_habitacion MONEY;
	SELECT @subtotal_habitacion = H.precio * DATEDIFF(DAY, R.checkin, R.checkout) 
	FROM RESERVA R 
		INNER JOIN HABITACION H 
			ON H.id = R.id_habitacion
	WHERE R.id = @id_reserva
	RETURN @subtotal_habitacion;
END;





-- 2.1.1	Calcular el total de cada reserva 
-- consulta realizada en la clase 15:
-- consulta utilizando funciones.

SELECT R.id, R.checkin, R.checkout, H.precio, 
			DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
			H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
			 ISNULL(SUM(S.precio),0)'suma servicios',
			 ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
				H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
					ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
	INNER JOIN HABITACION H
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X
		ON X.id_reserva = R.id 
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, 
			DATEDIFF(DAY,R.checkin,R.checkout),
			H.precio * DATEDIFF(DAY,R.checkin,R.checkout);

			-- 1.3	Crear una funcion que calcule el total de una reserva
--		La funcion recibira como parametro el id de una reserva.
SELECT *, dbo.subtotal_habitacion(id) 'habitacion',  dbo.subtotal_servicio(id) 'servicio', dbo.subtotal_habitacion(id)+dbo.subtotal_servicio(id) 'TOTAL_RESERVA'
FROM RESERVA;








-- 1.4	Crear la funcion llamada, RESERVA_DETALLE. Debe mostrar el subtotal
--		obtenido de la multiplicaci�n del precio de la habitaci�n y el numero de dias reservados (A).
--		mostrar el total de la suma de los servicios extra incluidos (B).
--		y el total resultante de toda la reserva (A+B).
CREATE FUNCTION RESERVA_DETALLE ()
RETURNS TABLE
AS
	RETURN (
		SELECT *, dbo.subtotal_habitacion(id)+dbo.subtotal_servicio(id) 'TOTAL_RESERVA'
		FROM RESERVA
	);

SELECT * FROM dbo.RESERVA_DETALLE();
