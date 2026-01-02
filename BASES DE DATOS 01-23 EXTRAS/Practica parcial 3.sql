/**		EJERCICIO 1	**/
SELECT F.id,F.id_cliente,F.id_restaurante, SUM(P.precio) 'subtotal plato'
FROM FACTURA F
LEFT JOIN DETALLE_PLATO DP ON F.id = DP.id_factura
LEFT JOIN PLATO P ON P.id = DP.id_plato
GROUP BY F.id, F.fecha, F.id_cliente,F.id_restaurante;

SELECT F.id, F.fecha, F.id_cliente, F.id_restaurante, SUM(P.precio) 'subtotal postre'
FROM FACTURA F
LEFT JOIN DETALLE_POSTRE DP ON F.id = DP.id_factura
LEFT JOIN POSTRE P ON P.id = DP.id_postre
GROUP BY F.id , F.fecha, F.id_cliente, F.id_restaurante

CREATE OR ALTER FUNCTION subtotalPlato (@id_factura int)
RETURNS DECIMAL(8,2)
AS
BEGIN 	
	RETURN (SELECT SUM(P.precio) 
	FROM FACTURA F
	LEFT JOIN DETALLE_PLATO DP ON F.id = DP.id_factura
	LEFT JOIN PLATO P ON P.id = DP.id_plato
	WHERE F.id = @id_factura
	GROUP BY F.id, F.fecha, F.id_cliente,F.id_restaurante);
END

CREATE OR ALTER FUNCTION subtotalPostre (@id_factura int)
RETURNS DECIMAL(8,2)
AS
BEGIN 
	RETURN(SELECT SUM(P.precio) 
	FROM FACTURA F
	LEFT JOIN DETALLE_POSTRE DP ON F.id = DP.id_factura
	LEFT JOIN POSTRE P ON P.id = DP.id_postre
	WHERE F.id = @id_factura
	GROUP BY F.id , F.fecha, F.id_cliente, F.id_restaurante)
END

select dbo.subtotalPostre(2);
select dbo.subtotalPlato(2);

/***	  EJERCICIO 2	***/
CREATE OR ALTER FUNCTION mostrarTotal (@fecha DATE, @fecha2 DATE)
RETURNS TABLE
AS
RETURN(SELECT *, (select dbo.subtotalPlato(f.id)) 'subtotal_plato',(select dbo.subtotalPostre(f.id)) 'subtotal_postre',
	((select dbo.subtotalPlato(f.id))+(select dbo.subtotalPostre(f.id))) 'total'
	FROM FACTURA f)
END

SELECT * FROM dbo.mostrarTotal('06/01/2022', '06/30/2022');

/***		EJERCICIO 3		***/
CREATE OR ALTER PROCEDURE ejercicio3
@id_restaurante int,
@fecha varchar(10),
@fecha2 varchar(10)
as 
BEGIN 
	
	DECLARE @restaurante VARCHAR(32);
	SET @restaurante = (SELECT RESTAURANTE.nombre FROM RESTAURANTE WHERE id = @id_restaurante);
	DECLARE @id_factura INT, @fecha_factura DATE, @total DECIMAL(8,2); 
	DECLARE CURSOR_EJ4 CURSOR STATIC FOR 

	SELECT t.id , t.fecha, t.total
	FROM dbo.mostrarTotal (CONVERT(DATE, '06/01/2022'), CONVERT(DATE, '06/30/2022')) t
	WHERE t.id_restaurante = 1;

	OPEN CURSOR_EJ4;
	
	FETCH NEXT FROM CURSOR_EJ4  INTO @id_factura, @fecha_factura, @total
	
	PRINT 'Las facturas registradas del restaurante "' + @restaurante + '" son: ';
	PRINT '-----------------------------------------------------------------------';

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'id factura: ' + CAST(@id_factura AS VARCHAR(4)) + ' fecha: ' + CAST(@fecha_factura AS VARCHAR(32)) + ' TOTAL: $' +CAST(@total AS VARCHAR(24)) ; 
		FETCH NEXT FROM CURSOR_EJ4 INTO @id_factura, @fecha_factura, @total;
	END;
	PRINT '-----------------------------------------------------------------------';
	CLOSE CURSOR_EJ4;
	DEALLOCATE CURSOR_EJ4;
END;

EXEC ejercicio3 1, '06/01/2022', '06/30/2022'

/*** EJERCICIO 4 ***/

-- 5 facturas maximo en un mismo dia 
CREATE OR ALTER TRIGGER Ejercicio4
ON FACTURA
AFTER INSERT
AS BEGIN 
	DECLARE @numero_facturas INT;
	DECLARE @id_cliente INT;
	DECLARE @fecha DATE;
	SELECT @id_cliente = id_cliente , @fecha = fecha FROM inserted;
	SELECT @numero_facturas = COUNT(*) FROM FACTURA F WHERE F.id_cliente = @id_cliente AND F.fecha = @fecha
	IF @numero_facturas > 5
		BEGIN 
		RAISERROR ('ERROR: El maximo de facturas por cliente es de 5 por día',11,1);
		ROLLBACK TRANSACTION;
	END 
END;

SELECT COUNT(*) FROM FACTURA F WHERE F.id_cliente = 10 AND F.fecha = CONVERT(DATE,'05/07/2022',103)

DELETE FROM FACTURA WHERE id >30

INSERT INTO FACTURA VALUES(31, CONVERT(DATE,'05/07/2022',103),10,1);
INSERT INTO FACTURA VALUES(32, CONVERT(DATE,'05/07/2022',103),10,2);
INSERT INTO FACTURA VALUES(33, CONVERT(DATE,'05/07/2022',103),10,5);
INSERT INTO FACTURA VALUES(34, CONVERT(DATE,'05/07/2022',103),10,4);
INSERT INTO FACTURA VALUES(35, CONVERT(DATE,'05/07/2022',103),10,2);
INSERT INTO FACTURA VALUES(36, CONVERT(DATE,'05/07/2022',103),10,1);

/***	Ejercicio 5	  ***/

CREATE OR ALTER TRIGGER Ejercicio5
ON DETALLE_PLATO
AFTER INSERT
AS BEGIN 

	DECLARE @estacion_plato VARCHAR(30), @estacion_factura VARCHAR(30), @fecha_factura DATE;

	DECLARE @id_plato INT, @id_factura INT;

	SELECT @id_plato = inserted.id_plato, @id_factura = inserted.id_factura FROM inserted;

	SELECT @fecha_factura = fecha FROM FACTURA WHERE id = @id_factura;

	SELECT @estacion_plato = m.estacion FROM PLATO p INNER JOIN MENU m ON p.id_menu = m.id WHERE p.id = @id_plato;

	SELECT @estacion_factura = CASE 
	
	WHEN @fecha_factura BETWEEN CONVERT(DATE,'21/03/2022',103) AND CONVERT(DATE,'21/06/2022',103) THEN 'primavera'
	WHEN @fecha_factura BETWEEN CONVERT(DATE,'22/06/2022',103) AND CONVERT(DATE,'23/09/2022',103) THEN 'verano'
	WHEN @fecha_factura BETWEEN CONVERT(DATE,'24/09/2022',103) AND CONVERT(DATE,'21/12/2022',103) THEN 'otoño'
	ELSE 'invierno'
	
	END

	PRINT 'Temporada de la factura: ' + @estacion_factura;
	PRINT 'Temporada del plato: ' + @estacion_plato; 

	IF @estacion_plato != @estacion_factura
		BEGIN 
		RAISERROR ('ERROR: La estacion del plato y la temporada no coinciden....',11,1);
		ROLLBACK TRANSACTION;
	END
	
END;


INSERT INTO FACTURA VALUES (31, CONVERT(DATE, '05/07/2022', 103),3,2);

INSERT INTO DETALLE_PLATO VALUES (31,1);

INSERT INTO DETALLE_PLATO VALUES(31,12);
