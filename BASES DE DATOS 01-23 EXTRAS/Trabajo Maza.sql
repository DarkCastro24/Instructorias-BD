/*SELECT dp.cantidad, pf.codigo_producto, dp.precio_unitario, dp.venta_gravada, id_color, precio_producto, id_marca, id_producto
FROM tbDetallesPedidos dp
JOIN tbPrecioProductos pp ON dp.id_precio_producto = pp.id_precio_producto
JOIN tbProductosFinales pf ON pp.id_producto_final = pf.id_producto_final
WHERE id_pedido = 48
GROUP BY dp.cantidad, pf.codigo_producto, dp.precio_unitario, dp.venta_gravada, id_color, precio_producto, id_marca, pf.id_producto
ORDER BY id_color, pp.precio_producto, pf.id_marca, pf.id_producto, codigo_producto;*/


CREATE PROCEDURE factura
@id_pedido INT
AS BEGIN
	
	IF OBJECT_ID (N'Facturas_Agrupadas', N'U') IS NOT NULL 
	DROP TABLE Facturas_Agrupadas;

	DECLARE @cantidad INT, @codigo_producto VARCHAR(12), @precio_unitario NUMERIC(8,5), @venta_gravada NUMERIC(10,5), @id_color INT, @precio_producto NUMERIC(10,5),@id_marca INT, @id_producto INT;
	DECLARE @cantidad2 INT = 0, @codigo_producto2 VARCHAR(150) = '', @precio_unitario2 NUMERIC(8,5) = 0, @venta_gravada2 NUMERIC(10,5) = 0, @id_color2 INT, @precio_producto2 NUMERIC(10,5),@id_marca2 INT, @id_producto2 INT;
	DECLARE cursor1  CURSOR FOR
	SELECT dp.cantidad, pf.codigo_producto, dp.precio_unitario, dp.venta_gravada, id_color, precio_producto, id_marca, id_producto
	FROM tbDetallesPedidos dp
	JOIN tbPrecioProductos pp ON dp.id_precio_producto = pp.id_precio_producto
	JOIN tbProductosFinales pf ON pp.id_producto_final = pf.id_producto_final
	WHERE id_pedido = @id_pedido
	GROUP BY dp.cantidad, pf.codigo_producto, dp.precio_unitario, dp.venta_gravada, id_color, precio_producto, id_marca, pf.id_producto
	ORDER BY id_color, pp.precio_producto, pf.id_marca, pf.id_producto, codigo_producto;
	OPEN cursor1;
	FETCH NEXT FROM cursor1 INTO @cantidad, @codigo_producto, @precio_unitario, @venta_gravada, @id_color, @precio_producto, @id_marca, @id_producto;
	CREATE TABLE Auxiliar (
        cantidad INT,
        codigo_producto VARCHAR(150),
		precio_unitario NUMERIC(8,5),
		venta_gravada NUMERIC(10,5),
		id_color int,
		precio_producto NUMERIC(10,5),
		id_marca int,
		id_producto int
    );
	DECLARE @contador INT = 0;
	DECLARE @id_color_aux INT = @id_color;
	DECLARE @precio_producto_aux NUMERIC(10,5) = @precio_producto;
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @contador = @contador + 1;
		IF(@id_color_aux = @id_color AND @precio_producto_aux = @precio_producto)
		BEGIN 
			PRINT CAST(@contador as varchar(4)) + '		' + CAST(@id_color_aux AS VARCHAR(30)) + '	  ' + CAST(@precio_producto_aux AS VARCHAR(30));
		END
		ELSE
		BEGIN
			INSERT INTO AUXILIAR VALUES (@cantidad2, @codigo_producto2, @precio_unitario2, @venta_gravada2, @id_color,@precio_producto,@id_marca, @id_producto);
			SET @cantidad2 = 0; SET @codigo_producto2 = ''; SET @precio_unitario2 = 0; SET @venta_gravada2 = 0;
			SET @id_color_aux = @id_color;
			SET @precio_producto_aux = @precio_producto;
		END
		SET @cantidad2 = @cantidad2 + @cantidad;
		SET @codigo_producto2 = CAST(@codigo_producto2 AS VARCHAR(30)) + CAST(@codigo_producto AS VARCHAR(30)) + '/' + CAST(@cantidad AS VARCHAR(30)) + '		'
		SET @precio_unitario2 = @precio_unitario;
		SET @venta_gravada2 = @venta_gravada + @venta_gravada2;
		FETCH NEXT FROM cursor1 INTO @cantidad, @codigo_producto, @precio_unitario, @venta_gravada , @id_color,@precio_producto,@id_marca, @id_producto;
	END;
	INSERT INTO AUXILIAR VALUES (@cantidad2, @codigo_producto2, @precio_unitario2, @venta_gravada2, @id_color,@precio_producto,@id_marca, @id_producto);
	CLOSE cursor1;
	DEALLOCATE cursor1;
	SELECT cantidad,codigo_producto,precio_unitario,venta_gravada INTO Facturas_Agrupadas FROM Auxiliar;
	DROP TABLE Auxiliar;
END;

EXEC factura 48;

SELECT cantidad, codigo_producto, precio_unitario, CAST(venta_gravada AS NUMERIC(8,2)) 'venta_gravada' 
FROM Facturas_Agrupadas;
