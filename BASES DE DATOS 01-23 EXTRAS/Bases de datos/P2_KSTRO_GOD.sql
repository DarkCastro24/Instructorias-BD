-- PARCIAL 2 BASE DE DATOS: DIEGO EDUARDO CASTRO 00117322 SECCION 02

-- 1- Mostrar los principales datos de los empleados.
SELECT id, nombre, direccion,fecha_nacimiento, YEAR(getDate()) - YEAR(fecha_nacimiento) 'Edad' 
FROM EMPLEADO e

-- 2- Mostrar la lista de peliculas y su respectiva clasificacion.
SELECT p.id , p.titulo, duracion, c.titulo 'clasificacion'
FROM PELICULA p 
INNER JOIN CLASIFICACION c ON c.id = p.id_clasificacion

-- 3- Mostrar la informacion principal de la sala 1.
SELECT s.id,nombre,ubicacion,CONCAT(a.fila ,a.columna) 'asiento'
FROM SALA s 
INNER JOIN ASIENTO a ON a.id_sala = s.id
WHERE s.id = 1 

-- 4- Mostrar la lista de compras que no incluyeron productos de la dulceria 
SELECT c.id,fecha 'fecha compra', descuento, id_cliente, id_empleado, id_producto 'id producto'
FROM COMPRA c
LEFT JOIN DETALLE_PRODUCTO d ON d.id_compra = c.id
LEFT JOIN PRODUCTO p ON  d.id_producto = p.id
WHERE id_producto is null
ORDER BY c.id ASC

-- 5- Mostrar las funciones disponibles en la cartelera de la semana del 5 al 11 de junio de 2023 
SELECT id_cartelera 'id cartelera',c.fecha_inicio 'inicio cartelera', c.fecha_fin 'din cartelera', f.id 'id funcion', f.fecha_hora 'fecha hora funcion', p.titulo 'titulo pelicula'
FROM FUNCION f
INNER JOIN PELICULA p ON p.id = f.id_pelicula
INNER JOIN ITEM_CARTELERA i ON i.id_funcion = f.id
INNER JOIN CARTELERA c ON c.id = i.id_cartelera
WHERE c.fecha_inicio BETWEEN '2023-06-05' AND '2023-06-11'
AND c.fecha_fin BETWEEN '2023-06-05' AND '2023-06-11'
ORDER BY f.id

-- 6- Mostrar una vista que calcule, para cada compra realizada el 1 de junio de 2023.
SELECT c.id 'id compra', c.fecha 'fecha compra',c.descuento, SUM(t.precio) 'subtotal funcion', (SUM(t.precio) - c.descuento) 'subtotal funcion con descuento'
FROM COMPRA c
INNER JOIN ENTRADA e ON c.id = e.id_compra
INNER JOIN FUNCION f ON f.id = e.id_funcion
INNER JOIN TIPO_FUNCION t ON t.id = f.id_tipo
WHERE DAY(fecha) = 1 AND MONTH(fecha) = 6 AND YEAR(fecha) = 2023
GROUP BY c.id, c.fecha,c.descuento
HAVING SUM(t.precio) > 20 
ORDER BY c.id

-- 7- Calcular el total de todas las compras con id menos o igual a 10
SELECT c.id, c.fecha,c.descuento, subFuncion.subtotal_funcion, subProducto.subtotal_producto,subCombo.subtotal_combo, ( subFuncion.subtotal_funcion + subProducto.subtotal_producto + subCombo.subtotal_combo) 'TOTAL SIN DESCUENTO',
( subFuncion.subtotal_funcion + subProducto.subtotal_producto + subCombo.subtotal_combo)-c.descuento 'TOTAL CON DESCUENTO'
FROM COMPRA c, (SELECT c.id,  SUM(t.precio) 'subtotal_funcion'
FROM COMPRA c
INNER JOIN ENTRADA e ON c.id = e.id_compra
INNER JOIN FUNCION f ON f.id = e.id_funcion
INNER JOIN TIPO_FUNCION t ON t.id = f.id_tipo
WHERE c.id <= 10
GROUP BY c.id) subFuncion, 
(SELECT c.id, ISNULL(SUM(p.precio * d.cantidad),0) 'subtotal_producto'
FROM COMPRA c
LEFT JOIN DETALLE_PRODUCTO d ON d.id_compra = c.id
LEFT JOIN PRODUCTO p ON p.id = d.id_producto
WHERE c.id <= 10
GROUP BY c.id, c.fecha,c.descuento) subProducto,
(SELECT c.id, ISNULL(SUM(co.precio),0) subtotal_combo
FROM COMPRA c 
LEFT JOIN DETALLE_COMBO dc ON dc.id_compra = c.id
LEFT JOIN COMBO co On co.id = dc.id_combo
LEFT JOIN ITEM_COMBO i ON i.id_combo = co.id
WHERE c.id <= 10
GROUP BY c.id) subCombo 
WHERE c.id <= 10 and subFuncion.id = c.id and subProducto.id = c.id and subCombo.id = c.id

-- Subtotal funcion
SELECT  SUM(t.precio) 'subtotal_funcion'
FROM COMPRA c
INNER JOIN ENTRADA e ON c.id = e.id_compra
INNER JOIN FUNCION f ON f.id = e.id_funcion
INNER JOIN TIPO_FUNCION t ON t.id = f.id_tipo
WHERE c.id <= 10
GROUP BY c.id, c.fecha,c.descuento

-- Subtotal producto
SELECT c.id, ISNULL(SUM(p.precio * d.cantidad),0) 'subtotal_producto'
FROM COMPRA c
LEFT JOIN DETALLE_PRODUCTO d ON d.id_compra = c.id
LEFT JOIN PRODUCTO p ON p.id = d.id_producto
WHERE c.id <= 10
GROUP BY c.id, c.fecha,c.descuento

-- Subtotal item combo
SELECT c.id, ISNULL(SUM(co.precio),0) 'subtotal_combo'
FROM COMPRA c 
LEFT JOIN DETALLE_COMBO dc ON dc.id_compra = c.id
LEFT JOIN COMBO co On co.id = dc.id_combo
LEFT JOIN ITEM_COMBO i ON i.id_combo = co.id
WHERE c.id <= 10
GROUP BY c.id

