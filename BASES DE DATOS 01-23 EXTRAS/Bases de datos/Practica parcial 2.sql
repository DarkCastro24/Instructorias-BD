/*
*	BASE DE DATOS: ESTUDIO PARA PARCIAL 2 BASES DE DATOS 
*	CREADO POR: CASTROLL
*	FECHA CREACION: 26/05/2023
*/

-- Pasos para utilizar primero crear la base y utilizarla. luego seleccionar todo y darle execute.
-- si no da error ya puedes comenzar a hacer las consultas

create database practica_examen;
use practica_examen;

create table PROVEEDOR(
id int not null primary key,
proveedor varchar(32) not null
);

insert into PROVEEDOR (id,proveedor) values (1,'Plasticos SV'),
(2,'Despensa Familiar'),(3,'Super Selectos'),(4,'Panaderia Rosario'),
(5,'Sello de Oro'),(6,'Ut Sagittis'),(7,'Food Chow'),
(8,'Farmacia San Nicolas'),(9,'Pollo Indio'),(10,'Despensa de Don Juan');

create table AREA_PRODUCTO(
id int not null primary key,
area_producto varchar(32) not null
);

insert into AREA_PRODUCTO (id,area_producto) values (1,'Limpieza'),
(2,'Alimentos'),
(3,'Bebidas'),
(4,'Mascotas'),
(5,'Cuidado personal'),
(6,'Libreria'); 

create table PRODUCTO(
id int not null primary key identity,
producto varchar(32) not null,
precio money not null,
id_area_producto int null references AREA_PRODUCTO(id),
id_proveedor int not null references PROVEEDOR(id)
);

insert into PRODUCTO (producto,precio,id_area_producto,id_proveedor) values 
('Te de limon',2.28,3,2),
('Comida para perro',17.37,4,7),
('Comida para gato',9.94,4,7),
('Detergente liquido',16.24,1,3),
('Coca de 3 litros',0.65,3,3),
('Pollo asado',6.97,2,9),
('Muffin de chocolate',0.86,2,4),
('Comida de tortuga',3.54,4,2),
('Semilla de marañon',16.89,2,3),
('Transportador de perro',44.71,4,3),
('Te de durazno',5.74,3,2),
('Carne molida',1.95,2,5),
('Carton de huevos',5.96,2,2),
('Plato para perro',4.22,4,1),
('Semillas para loro',2.36,4,3),
('Desodorante barra',5.87,5,10),
('Shampoo',8.07,5,2),
('Talco de pies',4.71,5,6),
('Monster 310ml',2.84,3,10),
('Jabon barra',1.97,1,3),
('Jalea de piña',4.21,null,2),
('Agua de coco',2.71,null,2);

create table TIPO_CLIENTE(
id int not null primary key,
tipo_cliente varchar(32)
);

insert into TIPO_CLIENTE (id,tipo_cliente) values (1,'Natural'),(2,'Juridico');

create table CLIENTE(
id int not null primary key identity,
nombre varchar(48),
telefono char(8),
correo_electronico varchar(72),
fecha_nacimiento date, 
id_tipo_cliente int not null references TIPO_CLIENTE(id)
);

insert into CLIENTE (nombre,telefono,correo_electronico,fecha_nacimiento,id_tipo_cliente) values 
('Althea Atkins','77115555','id.risus@icloud.net','Feb 1, 1997',1),
('Venus Whitley','72720262','turpis.egestas@yahoo.org','Sep 14, 2002',1),
('Raphael Emerson INC','79625308','justo.eu@hotmail.couk','Jun 11, 1998',2),
('Yeo Massey','72173585','donec.consectetuer.mauris@outlook.ca','May 26, 1999',1),
('Regan Murray','66891522','mi.felis@aol.org','May 29, 1998',1),
('Odette Sampson','68967481','facilisis.magna.tellus@icloud.edu','Oct 12, 2001',1),
('Ferris Company','26533137','vestibulum.massa@icloud.edu','Jan 22, 2002',2),
('Kelly Calhoun','26767357','lacus@outlook.com','Aug 20, 2002',1),
('Travis Hodge INC','76944274','lobortis.augue@yahoo.edu','Mar 23, 2000',2),
('Gillian Koch SV','61771781','in.felis@protonmail.edu','Dec 9, 1995',2);

create table COMPRA(
id int not null primary key identity,
id_cliente int not null references CLIENTE(id),
total money null,
fecha date null
);

insert into COMPRA (id_cliente,total,fecha) values 
(2,null,'Apr 19, 2023'),
(10,null,'Apr 24, 2023'),
(1,null,'Feb 17, 2023'),
(3,null,'Apr 30, 2023'),
(10,null,'May 27, 2023'),
(3,null,'Mar 14, 2023'),
(3,null,'May 31, 2023'),
(2,null,'Mar 26, 2023'),
(1,null,'Apr 1, 2023'),
(6,null,'May 26, 2023'),
(3,null,'May 11, 2023'),
(4,null,'Feb 23, 2023'),
(10,null,'Jan 4, 2023'),
(9,null,'Feb 26, 2023'),
(9,null,'May 17, 2023');

create table DETALLE_COMPRA(
id int not null primary key identity,
id_compra int not null references COMPRA(id),
id_producto int not null references PRODUCTO(id),
cantidad smallint
);

insert into DETALLE_COMPRA (id_compra,id_producto,cantidad) 
values (8,19,4),(1,5,1),(14,12,2),(2,10,2),(15,8,5),(4,4,2),(8,10,3),
(12,12,1),(10,11,2),(9,1,2),(6,6,2),(8,2,3),(15,5,3),(12,13,5),(12,8,4),
(7,2,4),(10,11,5),(13,15,4),(7,4,4),(6,11,4),(2,9,3),(3,11,2),(14,14,4),
(14,4,3),(5,7,5),(6,2,3),(11,12,3),(3,19,5),(6,15,3),(8,12,2),(8,2,3),(2,15,2),
(4,3,4),(10,1,2),(13,18,4),(13,19,3),(6,15,2),(1,17,3),(10,15,2),(2,1,1),(4,16,5),
(11,5,3),(15,12,3),(14,5,4),(5,10,4),(6,9,2),(6,20,3),(8,17,2),(9,10,1),(9,10,1); 

update COMPRA set total = 24.86 where id = 1;
update COMPRA set total = 147.09 where id = 2;
update COMPRA set total = 25.68 where id = 3;
update COMPRA set total = 101.59 where id = 4;
update COMPRA set total = 183.14 where id = 5;
update COMPRA set total = 140.50 where id = 6;
update COMPRA set total = 134.44 where id = 7;
update COMPRA set total = 269.75 where id = 8;
update COMPRA set total = 93.98 where id = 9;
update COMPRA set total = 49.46 where id = 10;
update COMPRA set total = 7.80 where id = 11;
update COMPRA set total = 45.91 where id = 12;
update COMPRA set total = 36.80 where id = 13;
update COMPRA set total = 72.10 where id = 14;
update COMPRA set total = 25.50 where id = 15;

-- PRACTICA PARA PARCIAL 2: CONSULTAS DE BASICO A AVANZADO 

-------------------   SELECT * FROM BASICO ----------------------  

-- Mostrar todos los clientes registrados
SELECT * FROM CLIENTE

-- Mostrar todos los productos registrados 
SELECT * FROM PRODUCTO

-- Mostrar el id,nombre,telefono y correo de todos los clientes
SELECT id,nombre,telefono,correo_electronico FROM CLIENTE

-------------------  APLICACION DE LA FUNCION WHERE ------------------- ---- 

-- Mostrar los clientes que cuyo tipo_cliente sea igual 2
SELECT * FROM CLIENTE WHERE id_tipo_cliente = 2

-- Mostrar los clientes que hayan nacido en el mes de Mayo y año sea 1999
SELECT * FROM CLIENTE WHERE MONTH(fecha_nacimiento) = 5 AND YEAR(fecha_nacimiento) = 1999

-------------------  APLICACION DE LOS OPERADORES AND Y OR ------------------------------

-- Mostrar los Productos que tengan proveedor igual 1 o 10 (solo debe cumplirse una de las dos condiciones)
SELECT * FROM PRODUCTO WHERE id_proveedor = 1 OR id_proveedor = 10

-- Mostrar los productos que tengan id_area_producto = 4 y id_proveedor = 7 (ambas condiciones deben cumplirse)
SELECT * FROM PRODUCTO WHERE id_area_producto = 4 AND id_proveedor = 7

-------------------  UNION DE DOS O MAS TABLAS (IGUALACION DE LLAVES) ------------------------------

-- Mostrar todos los datos de los clientes incluyendo su tipo de cliente 
SELECT c.id, nombre, telefono,correo_electronico,fecha_nacimiento, t.tipo_cliente
FROM CLIENTE c, TIPO_CLIENTE t
WHERE t.id = c.id_tipo_cliente

-- Mostrar los datos de todas las compras incluyendo el id y nombre del cliente 
SELECT c.id, total,fecha,cl.id 'id cliente', nombre
FROM COMPRA c, CLIENTE cl
WHERE c.id_cliente = cl.id

--------------- UNION DE DOS TABLAS UTILIZANDO INNER JOIN ------------------- 
 
-- Convertir los dos ejercicios anteriores a INNER JOIN 
SELECT c.id, nombre, telefono,correo_electronico,fecha_nacimiento, t.tipo_cliente
FROM CLIENTE c
INNER JOIN TIPO_CLIENTE t ON t.id = c.id_tipo_cliente

SELECT c.id, total,fecha,cl.id 'id cliente', nombre
FROM COMPRA c
INNER JOIN CLIENTE cl ON c.id_cliente = cl.id

--------------- UNION DE MAS DE DOS TABLAS UTILIZANDO INNER JOIN ---------------

-- Mostrar los datos de todos los productos incluyendo su proveedor y area de producto 
SELECT p.id,producto,precio,pr.proveedor,a.area_producto 
FROM PRODUCTO p
INNER JOIN PROVEEDOR pr ON pr.id = p.id_proveedor
INNER JOIN AREA_PRODUCTO a ON a.id = p.id_area_producto

-- Mostrar todos los registros de la tabla detalle compra incluyendo el nombre del producto, precio del producto, area del producto y su proveedor
SELECT d.id, d.id_compra, d.cantidad, producto,precio,pr.proveedor,a.area_producto 
FROM DETALLE_COMPRA d 
INNER JOIN PRODUCTO p ON p.id = d.id_producto
INNER JOIN PROVEEDOR pr ON pr.id = p.id_proveedor
INNER JOIN AREA_PRODUCTO a ON a.id = p.id_area_producto

-------------------- LEFT Y RIGHT JOIN  ---------------------------------------------

-- Mostrar el id, nombre, precio y area de todos los productos (incluyendo los que no tengan area asignada) 
SELECT * 
FROM PRODUCTO p
LEFT JOIN AREA_PRODUCTO a ON a.id = p.id_area_producto

-- Realizar la consulta anterior colocando la tabla AREA_PRODUCTO LUEGO DEL FROM 
SELECT * 
FROM AREA_PRODUCTO a
RIGHT JOIN PRODUCTO p ON a.id = p.id_area_producto

-----------------------  FULL JOIN -----------------------------------------------

-- Mostrar el id,nombre,precio,id_area y area del producto (tambien mostrar los productos que no tengan area y las areas que no tengan productos)
SELECT p.id,p.producto,precio,a.id,a.area_producto 
FROM PRODUCTO p 
FULL JOIN AREA_PRODUCTO a ON a.id = p.id_area_producto

---------------------- ORDER BY ASC Y DESC ----------------------------------------

-- Mostrar el id, nombre y precio de todos los productos ordenados del mas barato al mas caro.
SELECT id,producto,precio
FROM PRODUCTO
ORDER BY precio ASC

-- Mostrar id, nombre, telefono, correo y fecha de nacimiento de los clientes y ordenados del menor al mayor (edad) 
SELECT id,nombre,telefono,correo_electronico,fecha_nacimiento 
FROM CLIENTE
ORDER BY fecha_nacimiento desc

-- Mostrar el id, fecha, total ,nombre del cliente de las compras (ordenar de la mas barata a la mas cara) 
SELECT c.id,fecha,total,cl.nombre
FROM COMPRA c
INNER JOIN CLIENTE cl ON cl.id = c.id_cliente
ORDER BY total ASC

-- Mostrar el id del detalle, nombre del producto, precio unitario, cantidad y subtotal (calcularlo multiplicando la cantidad y el precio unitario) mostrar en orden ascendente en base al subtotal
SELECT d.id, p.producto, p.precio, d.cantidad, (d.cantidad * p.precio) 'subtotal' 
FROM DETALLE_COMPRA d, PRODUCTO p
WHERE d.id_producto = p.id
ORDER BY subtotal asc

--------------------------- GROUP BY ---------------------------------------------

-- Mostrar cuantos clientes que hay por cada tipo y ordenar de forma descendente (en base al numero de clientes)
SELECT t.tipo_cliente, COUNT(c.id_tipo_cliente) 'numero clientes' 
FROM CLIENTE c,TIPO_CLIENTE t
WHERE c.id_tipo_cliente = t.id
GROUP BY t.tipo_cliente
ORDER BY [numero clientes] desc

-- Mostrar el numero de productos que existen por cada area (las areas que no tengan productos mostrar 0 y ordenar en forma descendente) TIP: LEFT JOIN 
SELECT a.area_producto, COUNT(p.id_area_producto) 'numero productos' 
FROM AREA_PRODUCTO a
LEFT JOIN PRODUCTO p on P.id_area_producto = a.id
GROUP BY a.area_producto
ORDER BY [numero productos] desc

-- Mostrar el nombre de todos los productos y cuantas veces se ha comprado (ordenar de manera descendiente)
SELECT p.producto, SUM(d.cantidad) 'total compras'
FROM PRODUCTO p, DETALLE_COMPRA d
WHERE p.id = d.id_producto
GROUP BY p.producto
ORDER BY [total compras] DESC

-- !!! Mostrar el total de ganancia que ha generado cada producto (ordenar de manera descendiente)
SELECT p.producto, SUM(d.cantidad * p.precio) 'ganancia total' 
FROM PRODUCTO p, DETALLE_COMPRA d
WHERE p.id = d.id_producto
GROUP BY p.producto
ORDER BY [ganancia total] DESC

---------------------------  HAVING  ----------------------------------------------

-- Mostrar el nombre de todos los productos que se hayan vendido mas de 10 unidades
SELECT p.producto, SUM(d.cantidad) 'cantidad ventas'
FROM PRODUCTO p, DETALLE_COMPRA d
WHERE p.id = d.id_producto
GROUP BY p.producto
HAVING SUM(d.cantidad) > 10
ORDER BY [cantidad ventas] DESC

-- Mostrar los productos cuya ganancia total haya sido igual o mayor a $30
SELECT p.producto, SUM(d.cantidad * p.precio) 'ganancia total' 
FROM PRODUCTO p, DETALLE_COMPRA d
WHERE p.id = d.id_producto
GROUP BY p.producto
HAVING SUM(d.cantidad * p.precio) >= 30
ORDER BY [ganancia total] ASC

--------------------------  SELECT INTO  --------------------------------------------- 

-- Crear una tabla incluyendo id del detalle de compra, fecha de la compra, nombre del producto y cantidad del detalle hacer INNER JOIN de las fk utilizar tablas DETALLE_COMPRA, PRODUCTO, COMPRA 
SELECT d.id,c.fecha,p.producto,d.cantidad 
INTO REGISTRO_COMPRAS
FROM DETALLE_COMPRA d, PRODUCTO p, COMPRA c
WHERE d.id_compra = c.id and p.id = d.id_producto

SELECT * FROM REGISTRO_COMPRAS

-- Crear una tabla con el contenido de la ultima consulta de la seccion GROUP BY (para identificarla le puse !!! al inicio) nombrar la nueva tabla REPORTE_VENTA
SELECT p.producto, SUM(d.cantidad * p.precio) 'ganancia total' 
INTO REPORTE_VENTAS
FROM PRODUCTO p, DETALLE_COMPRA d
WHERE p.id = d.id_producto
GROUP BY p.producto
ORDER BY [ganancia total] DESC

SELECT * FROM REPORTE_VENTAS

