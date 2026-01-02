/*
*	Recopilacion de todas las clases del curso de bases de datos
*	Autor: Diego Castro
*	Objetivo: Apoyo para el desarrollo del parcial 2 de consultas
*/

USE DB_HOTELMANAGEMENT;

/*
*	FUNCIONES IMPORTANTES 
*	
*	FUNCIONES PARA OBTENER UNA PARTE DE UNA FECHA	
*	YEAR(fecha) retorna solamente el año de la fecha
*	MONTH(fecha) retorna el mes de la fecha
*	DAY(fecha) retorna el dia de la fecha 
*
*	FUNCION PARA CONVERTIR UNA FECHA PARA QUE SE RECONOZCA EN CUALQUIER CONFIGURACION DE SQL SERVER
*	CONVERT(DATE,'DD/MM/YYYY',103);
*	CONVERT(DATE,'24/11/2002',103); // Ejemplo
*
*	DATEDIFF: Funcion para obtener diferencia entre dos fechas, puede ser diferencia en dias, meses u años	
*	DATEDIFF(DAY,fecha1,fecha2);  // Diferencia de dias
*	DATEDIFF(MONTH,fecha1,fecha2); // Diferencia de meses
*	DATEDIFF(YEAR,fecha1,fecha2); // Diferencia de años
*
*	IS NULL: en caso que el retorno de una funcion sea NULL se puede sustituir el valor de retorno para que no afecte el resultado 
*	ISNULL(SUM(num),0) // Si es nulo retorna un 0
*
*
*	Si hay que ocupar otra forma de fecha consultar aca:
*	https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/
*
*	FUNCION DE BUSQUEDA FILTRADA: LIKE
*	Coincidencias al final: LIKE '%asd'
*	Coincidencias en cualquier parte: LIKE '%asd%'
*	Coincidencias que haya un dato a antes de un dato b: LIKE '%a%@%'
*	No mostrar registros con coincidencias: NOT LIKE '%asd%'
*	
*	LEFT , RIGHT Y FULL JOIN
*	LEFT JOIN: Muestra TODOS los datos de la tabla que esta luego del FROM
*	RIGHT JOIN: Muestra TODOS los datos de la tabla que esta luego del RIGHT JOIN
*   FULL JOIN: Muestra TODO los datos de ambas tablas
*	
*	BEETWEEN: funcion para mostrar datos que se encuentren en un rango de cualquier tipo de dato
*	fecha_inicio BEETWEEN ('01/05/2023') AND ('31/06/2023')
*	id BEETWEEN (1) AND (4)
*   
*	ORDER BY: Ordenar por varios campos
*	ORDER BY campo1 DESC, campo2 ASC;
*
*   FUNCIONES DE AGREGACION (Todas se ocupan con GROUP BY)
*	COUNT(campo): retorna la cantidad de veces se repite un mismo valor 
*	SUM(campo_numerico): retorna la suma de los campos 	
*	AVG(campo_numerico): retorna el promedio de los campos
*	MIN(campo): retorna el dato menor
*	MAX(campo): retorna el dato mayor
*
*	OPERACIONES BASICAS
*	Sumar: (campo1 + campo 2) 'Alias'
*	Multiplicacion: (campo1 * campo2) 'Alias'
*	Dividir: (campo1 / campo 2) 'Alias'
*	Suma de multiplicaciones: (campo1 * campo2) + (campo3 * campo4) 'Alias'
*
*	CAST: funcion para convertir de manera explicita a un tipo de dato
*	CAST(numero AS FLOAT)
*
*	ROUND: funcion para redondear un decimal a N decimales
*	ROUND(3.3333333333 , 2) 'alias' = 3.33
*	ROUND(AVG(campo),2) 'alias'
*
*	CONCAT: funcion para unir dos datos como que fueran cadenas de texto
*	CONCAT(dato1 , dato2)
*
*	EJEMPLO: CALCULANDO UN % 
*	CONCAT(CAST (COUNT(c.id) AS FLOAT) / (SELECT COUNT(*) FROM CLIENTE) * 100 , '%') 'porcentaje'
*		   |---------------------		dato1		   ----------------------| dato 2
*
*	AUXILIAR DE SUBCONSULTAS:
*	Utilizar una subconsulta como tabla
*
*	SELECT id,usuario,t.tipo FROM USUARIOS u INNER JOIN TIPO_USUARIO t ON u.id_tipo_usuario = t.id;
*	
*	SELECT alias.id, alias.usuario, alias.tipo
*	FROM (SELECT id,usuario,t.tipo FROM USUARIOS u INNER JOIN TIPO_USUARIO t ON u.id_tipo_usuario = t.id) alias
*
*	UNIR DOS CONSULTAS EN UNA SOLA (REQUISITO: QUE AMBAS TENGAN LOS MISMOS CAMPOS)
*	SELECT * FROM tabla 
*	WHERE id IN (consulta1) OR id IN (consulta2)
*	
*	Ejemplo:
*	SELECT * FROM SERVICIO 
*	WHERE id IN (
*	SELECT TOP 2 S.id
*	FROM RESERVA R 
*		INNER JOIN EXTRA X
*			ON R.id = X.id_reserva
*		INNER JOIN SERVICIO S
*			ON S.id = X.id_servicio
*	GROUP BY S.id, S.nombre
*	ORDER BY SUM(DATEDIFF(DAY,R.checkin, R.checkout) * S.precio) DESC
*	) OR
*	id IN (
*	SELECT TOP 2 S.id
*	FROM RESERVA R 
*		INNER JOIN EXTRA X
*			ON R.id = X.id_reserva
*		INNER JOIN SERVICIO S
*			ON S.id = X.id_servicio
*	GROUP BY S.id, S.nombre
*	ORDER BY SUM(DATEDIFF(DAY,R.checkin, R.checkout) * S.precio) ASC
*	)	
*
*/

--------- CONSULTAS BASICAS SELECT * FROM CON FUNCION WHERE ---------

-- Mostrar todas las reservas con id mayor a 90
SELECT * FROM RESERVA
WHERE id > 90;

-- OPERADORES COMPARATIVOS

-- ">" mayor que
-- "<" menor que
-- ">=" mayor o igual que
-- "<=" menor o igual que
-- "!=" no es igual
-- "<>" no es igual

-- Mostrar todas las reservas con id menor o igual a 10
SELECT * FROM RESERVA
WHERE id <= 10;

-- Mostrar todas las reservas con id entre 25 y 40, inclusive 25 y 40
SELECT * FROM RESERVA
WHERE id >= 25 AND id <= 40;

-- OPERADORES LOGICOS 
-- AND: Ambas condiciones deben cumplirse para que sea verdadero
-- OR: Una de las dos deben cumplirse para que el resultado sea verdadero
-- NOT: Niega la condicion 

-- FUNCION BETWEEN: Mostrar todas las reservas con id entre 25 y 40
SELECT * FROM RESERVA
WHERE id BETWEEN 25 AND 40;

-- APLICANDO OPERADOR NOT EN BETWEEN
SELECT * FROM RESERVA
WHERE id NOT BETWEEN 25 AND 40;

-- FUNCION OR: Mostrar las reservas con id menores a 10 y mayores a 90
SELECT * FROM RESERVA
WHERE id < 10 OR id > 90;

-- Mostrar las reservas con id menores a 10, mayores a 90 pero menores a 100
SELECT * FROM RESERVA
WHERE (id < 10 OR id > 90) and id < 100;

-- Opcionalmete
SELECT * FROM RESERVA
WHERE id < 10 OR id BETWEEN 90 AND 99;

-- Mostrar las reservas que realizadas en mayo
SELECT * FROM RESERVA WHERE MONTH(checkin) = 5;

--------- FUNCIONES RELACIONADAS CON FECHAS ---------
 
 /*	
	YEAR(fecha) retorna solamente el año de la fecha
	MONTH(fecha) retorna el mes de la fecha
	DAY(fecha) retorna el dia de la fecha 
*/

-- Mostrar las reservas que realizadas en mayo cambiando la fecha del servidor
-- SET LANGUAGE 'us_english'; cambia el idioma del servidor 
SELECT * FROM RESERVA
WHERE checkin >= CONVERT(DATE,'01-05-2023',103) AND checkin <= CONVERT(DATE,'01-06-2023',103);
		
-- Mostrar las reservas que realizadas en mayo (Forma mas eficiente)
SELECT * FROM RESERVA
WHERE checkin BETWEEN CONVERT(DATE,'01-05-2023',103) AND CONVERT(DATE,'01-06-2023',103);

-- IMPORTANTE!!!!! FUNCION PARA SABER DIFERENCIA DE DIAS ENTRE DOS FECHAS 
-- DATEDIFF ( DAY , fecha1 , fecha2 );

-- OJO: El formato de las fechas pueden variar en mi compu es MM-DD-YYYY 
SELECT DATEDIFF ( DAY , '01-05-2023' , '01-09-2023' );

-- Para evitar eso podemos ocupar la conversion automatica utilizando CONVERT(DATE, fecha,103)

-- Mostrar las reservas que sean mayores a 3 días / El formato de la fecha es DD/MM/YYYY
SELECT DATEDIFF (DAY,CONVERT(DATE,'01-05-2023',103),CONVERT(DATE,'03-05-2023',103));

-- Mostrar las reservas con el numero de dias que dura cada reserva
SELECT id, checkin, checkout, id_metodo_pago, id_cliente_reserva, id_habitacion,
DATEDIFF (DAY,CONVERT(DATE,checkin,103),CONVERT(DATE,checkout,103)) 'dias reservados'
FROM RESERVA;

-- Mostrar las reservas cuya duracion sea mayor a 3 dias 
SELECT id, checkin, checkout, id_metodo_pago, id_cliente_reserva, id_habitacion, DATEDIFF (DAY,checkin,checkout)
FROM RESERVA
WHERE DATEDIFF (DAY,checkin,checkout) > 3;

--------- USO DEL LIKE ---------

-- Mostrar los correos de clientes que finalicen en .edu
SELECT * 
FROM CORREO_CLIENTE
WHERE correo LIKE '%.edu';

-- Mostrar los correos de clientes que utilizan outlook
SELECT * 
FROM CORREO_CLIENTE
WHERE correo LIKE '%@outlook%';

-- Mostrar los correos de clientes que NO utilizan outlook
SELECT * 
FROM CORREO_CLIENTE
WHERE correo NOT LIKE '%@outlook%';

-- Mostrar los correos de clientes que contengan al menos un punto en su nombre de usuario
SELECT * 
FROM CORREO_CLIENTE
WHERE correo LIKE '%.%@%';

-- UNION DE 2 O MAS TABLAS UTILIZANDO IGUALACION DE LLAVES

-- Mostrar cada el id, nombre de cada hotel, su teléfono y el nombre de su categoria:
SELECT HOTEL.id, HOTEL.nombre, HOTEL.telefono , CATEGORIA_HOTEL.categoria 
FROM HOTEL, CATEGORIA_HOTEL
WHERE HOTEL.id_categoria_hotel = CATEGORIA_HOTEL.id;

-- Para facilitar la consulta se puede ocupar un alias para hacer referencia a la tabla
SELECT H.id AS 'id hotel', H.nombre, H.telefono , C.categoria 
FROM HOTEL H, CATEGORIA_HOTEL C
WHERE H.id_categoria_hotel = C.id;

-- Mostrar toda la información de cada cliente, incluyendo el pais y el tipo
SELECT C.id, C.nombre, C.documento, P.pais, CC.categoria
FROM CLIENTE C, PAIS P, CATEGORIA_CLIENTE CC
WHERE P.id = C.id_pais AND CC.id = C.categoria_cliente;

--------- INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN ---------

-- INNER JOIN: cumple la misma funcion que la igualacion de llaves
SELECT * 
FROM PAIS P
INNER JOIN CLIENTE C ON P.id = C.id_pais;

-- LEFT JOIN: Muestra todos los registros de la tabla que esta luego de FROM (incluyendo los que tengan la FK de la otra tabla NUll)
SELECT *
FROM PAIS P
LEFT JOIN CLIENTE C ON P.id = C.id_pais;

SELECT * FROM CLIENTE WHERE id_pais = 10;

-- Mostrando los paises a los que no pertenezca ningun cliente
SELECT * FROM PAIS P
LEFT JOIN CLIENTE C ON P.id = C.id_pais WHERE C.id IS NULL;

-- RIGHT JOIN: funciona igual que el LEFT solo que toma como tabla principal la que se escribe luego de RIGHT JOIN
SELECT * 
FROM PAIS P
RIGHT JOIN CLIENTE C ON P.id = C.id_pais
WHERE P.id IS NULL;

-- FULL JOIN: Muestra absolutamente todos los registros de ambas tablas
SELECT *
FROM PAIS P
FULL JOIN CLIENTE C ON P.id = C.id_pais

-- Mostrando todos los paises y clientes que tengan nula la fk
SELECT *
FROM PAIS P
FULL JOIN CLIENTE C ON P.id = C.id_pais
WHERE P.id IS NULL OR C.id IS NULL;

-- Mostrar el id, nombre, dirección de cada hotel y el titulo de la categoría a la que pertenece:
SELECT H.id, H.nombre, H.direccion, H.id_categoria_hotel, C.id, C.categoria
FROM CATEGORIA_HOTEL C 
INNER JOIN HOTEL H ON C.id = H.id_categoria_hotel;

-- Mostrar a los clientes e incluir el nombre del pais al cual pertenece y el tipo de cliente que es.
SELECT C.id, C.nombre, C.documento, P.pais, CC.categoria
FROM PAIS P 
INNER JOIN CLIENTE C ON P.id = C.id_pais
INNER JOIN CATEGORIA_CLIENTE CC ON CC.id = C.categoria_cliente;

-- Mostrar cada cliente incluir el nombre del pais y el tipo de cliente, filtrar a los clientes con categoria "viajero"
SELECT C.id, C.nombre, C.documento, P.pais, CC.categoria
FROM PAIS P 
INNER JOIN CLIENTE C ON P.id = C.id_pais
INNER JOIN CATEGORIA_CLIENTE CC ON CC.id = C.categoria_cliente
WHERE CC.categoria = 'viajero';

-- Mostrar todas las reservas e incluir el nombre del cliente que ha realizado la reserva.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre
FROM CLIENTE C 
INNER JOIN RESERVA R ON C.id = R.id_cliente_reserva;

-- Mostrar todas las reservas e incluir el nombre del cliente, método de pago y que habitacion reservo.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre, M.metodo_pago, H.numero
FROM CLIENTE C 
INNER JOIN RESERVA R ON C.id = R.id_cliente_reserva
INNER JOIN METODO_PAGO M ON  M.id = R.id_metodo_pago
INNER JOIN HABITACION H ON H.id = R.id_habitacion;

-- Mostrar todas las reservas e incluir el nombre del cliente que ha realizado la reserva, el método de pago y que habitacion reservo.
-- Mostrar ademas el tipo de habitacion reservada y en que hotel reservo.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre, M.metodo_pago, H.numero,TH.tipo, HO.nombre
FROM CLIENTE C 
INNER JOIN RESERVA R ON C.id = R.id_cliente_reserva
INNER JOIN METODO_PAGO M ON  M.id = R.id_metodo_pago
INNER JOIN HABITACION H ON H.id = R.id_habitacion
INNER JOIN TIPO_HABITACION TH ON TH.id = H.id_tipo_habitacion
INNER JOIN HOTEL HO ON HO.id = H.id_hotel;

--------- ORDER BY ---------

/*
*	ASC: nos permite ordenar de menor a mayor
*	DESC: nos permite ordenar de mayor a menor
*/

-- Mostrar los datos de la tabla reserva. Ordenar los datos a partir del id de cliente en orden descendente
SELECT * 
FROM RESERVA
ORDER BY RESERVA.id_cliente_reserva DESC;

-- Mostrar los datos de reserva e incluir el nombre del cliente, el hotel y el numero de habitacion. Ordenar respecto al nombre del cliente de forma ascendente.
SELECT R.id, R.checkin, R.checkout, C.nombre 'cliente', HO.nombre 'hotel', H.numero
FROM HOTEL HO, HABITACION H, RESERVA R, CLIENTE C
WHERE (HO.id = H.id_hotel AND H.id = R.id_habitacion AND R.id_cliente_reserva = C.id)
ORDER BY C.nombre ASC; 

-- Mostrar que cliente ha realizado 0, 1 o varias reservas, ordenar la lista segun el nombre del cliente en orden descendente 
-- y por cada cliente ordenar sus RESERVAS descendente.
SELECT R.id, R.checkin, R.checkout, C.nombre 'cliente', HO.nombre 'hotel', H.numero
FROM HOTEL HO, HABITACION H, RESERVA R, CLIENTE C
WHERE (HO.id = H.id_hotel AND H.id = R.id_habitacion AND R.id_cliente_reserva = C.id)
ORDER BY C.nombre ASC, R.checkin DESC; 

--------- GROUP BY ---------

-- ¿Cuantos clientes hay por cada pais? Ordenar la lista en orden descendente
SELECT P.pais, COUNT(C.nombre) 'cantidad de clientes'
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais
GROUP BY P.pais
ORDER BY P.pais ASC;

-- ¿Cuantos clientes hay por cada pais? Ordenar la lista en orden descendente, incluir el id y nombre de cada pais.
SELECT P.id, P.pais, COUNT(C.nombre) 'cantidad de clientes'
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY P.pais ASC;

-- ¿Cuantos clientes hay por cada pais? Ordenar la lista en orden descendente incluir en el resultado los paises sin ningún cliente
SELECT P.id, P.pais, COUNT(C.nombre) 'cantidad de clientes'
FROM CLIENTE C 
RIGHT JOIN PAIS P ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY [cantidad de clientes] DESC;

-- ¿Cuantas RESERVAS se han realizado en cada hotel? Ordenar el resultado con respecto al id de cada hotel de forma ascendente
SELECT ho.id, ho.nombre, COUNT(h.id_hotel) 'Reservas' 
FROM RESERVA r
INNER JOIN HABITACION h ON r.id_habitacion = h.id
INNER JOIN HOTEL ho ON ho.id = h.id_hotel
GROUP BY ho.nombre, ho.id
ORDER BY ho.id ASC

-- ¿Cual es la habitacion mas barata y mas cara de cada hotel? 
SELECT HO.id, HO.nombre, MIN(H.precio) 'habitacion mas barata', MAX(H.precio) 'habitacion mas cara'
FROM HOTEL HO, HABITACION H
WHERE HO.id = H.id_hotel
GROUP BY HO.id, HO.nombre;

-- Mostrar el detalle de cada RESERVA con respecto a los precios. incluir el precio de la habitacion y el total de los servicios
SELECT R.id, R.checkin, R.checkout, H.precio, 
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout);

--------- HAVING ---------

/*
*	Funcion IS NULL: en caso que el resultado de una funcion de agregacion sea NULL se sustituye con un valor que nosotros le digamos
*	ISNULL(SUM(costo), 0); aca decimos que en caso que la suma sea nula el valor que retornara es 0 no NULL
*/

-- Mostrar las habitaciones que hayan sido reservadas durante al menos 10 dias durante junio de 2023.
SELECT H.id, H.numero, SUM(DATEDIFF(DAY, R.checkin, R.checkout)) 'cantidad de días'
FROM HABITACION H, RESERVA R
WHERE H.id = R.id_habitacion AND MONTH(R.checkin) = 6 AND YEAR(R.checkin) = 2023
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF(DAY, R.checkin, R.checkout)) >= 10
ORDER BY H.id ASC; 

-- Mostrar la lista de clientes 'VIP' se adquiere el estado si tiene al menos una estancia con valor igual o mayor a $999.99
SELECT R.id, R.checkin, R.checkout, H.precio, 
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout);

-- Paso 1: incluyendo la información del cliente:
SELECT R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre,
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
ORDER BY C.id ASC;

-- Paso 2: Filtrando
SELECT R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre,
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
HAVING H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) >= 999.99
ORDER BY C.id ASC;

-- Mostrar el tipo de habitacion de cada hotel que haya obtenido una ganancia mayor a $2000 en mayo y junio de 2023, tomar en cuenta solo el "subtotal habitacion" 
SELECT HO.id, HO.nombre 'hotel', TH.tipo, SUM(DATEDIFF(DAY, R.checkin, R.checkout) * H.precio) 'subtotal habitacion'
FROM HOTEL HO, HABITACION H, TIPO_HABITACION TH, RESERVA R
WHERE H.id_hotel = HO.id AND TH.id = H.id_tipo_habitacion AND H.id = R.id_habitacion
GROUP BY HO.id, HO.nombre, TH.tipo
HAVING SUM(DATEDIFF(DAY, R.checkin, R.checkout) * H.precio) > 2000
ORDER BY SUM(DATEDIFF(DAY, R.checkin, R.checkout) * H.precio) DESC;


-------  INSTRUCCION SELECT INTO  -------

-- A partir del ejercicio extra visto en la clase 15, almacenar el resultado en una nueva tabla con la instrucción INTO
SELECT R.id, R.checkin, R.checkout, H.precio, 
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
INTO INGRESOS
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout);


-----	SUBCONSULTAS   ------

-- ¿Cual es el porcentaje de clientes que vienen de cada pais? 

-- Paso 1: creando consulta inicial 
SELECT P.id, P.pais, COUNT(C.id) 'cantidad de clientes'
FROM PAIS P 
LEFT JOIN CLIENTE C ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY P.id ASC;

-- Paso 2: Calculando la cantidad de clientes disponibles
SELECT COUNT(id) FROM CLIENTE;

-- CALCULO DE PORCENTAJES
-- FUNCION CONCAT( ( CAST(COUNT (C.id) AS FLOAT) / numero registros) * 100, '%' )

-- Paso 3: calculando el porcentaje de clientes de forma dinámica
SELECT P.id, P.pais, COUNT(C.id) 'cantidad de clientes', CONCAT((CAST(COUNT(C.id) AS FLOAT)/(SELECT COUNT(id) FROM CLIENTE))*100,'%') 'Porcentaje de clientes'
FROM PAIS P 
LEFT JOIN CLIENTE C ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY P.id ASC;

-- Mostrar la lista de clientes 'VIP' si el promedio de sus estancias es igual o mayor a $550.00 (consulta realizada anteriormente).
SELECT R.id, R.checkin, R.checkout, H.precio, 
	DATEDIFF(DAY,R.checkin,R.checkout) 'cantidad de noches',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal habitacion',
	ISNULL(SUM(S.precio),0)'suma servicios',
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'subtotal servicios',
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
	ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout);

-- Paso 2: retirando columnas de poco interes
SELECT R.id, R.checkin, R.checkout, H.precio, 
H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout);

-- Paso 3: Utilizando subconsultas:
SELECT R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
FROM RESERVA R 
INNER JOIN HABITACION H ON H.id = R.id_habitacion
INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
LEFT JOIN EXTRA X ON X.id_reserva = R.id 
LEFT JOIN SERVICIO S ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
ORDER BY C.id ASC;

-- Paso 4: Para ocupar subconsultas agregamos toda la consulta anterior en el FROM(aca) Alias con el que haremos referencia a esa consulta
SELECT DETALLITO.id_cliente, DETALLITO.nombre, DETALLITO.TOTAL
FROM (
	SELECT R.id, R.checkin, R.checkout, H.precio, C.id 'id_cliente', C.nombre,
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
	FROM RESERVA R 
	INNER JOIN HABITACION H ON H.id = R.id_habitacion
	INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
	LEFT JOIN EXTRA X ON X.id_reserva = R.id 
	LEFT JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
) DETALLITO
ORDER BY DETALLITO.id_cliente ASC;

-- Paso 5: Calculando el promedio 
SELECT DETALLITO.id_cliente, DETALLITO.nombre, AVG(DETALLITO.TOTAL)
FROM (
	SELECT R.id, R.checkin, R.checkout, H.precio, C.id 'id_cliente', C.nombre,
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
	FROM RESERVA R 
	INNER JOIN HABITACION H ON H.id = R.id_habitacion
	INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
	LEFT JOIN EXTRA X ON X.id_reserva = R.id 
	LEFT JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
) DETALLITO
GROUP BY DETALLITO.id_cliente, DETALLITO.nombre
ORDER BY DETALLITO.id_cliente ASC;

-- Paso 6: filtrando resultado para mostrar a los clientes VIP
SELECT DETALLITO.id_cliente, DETALLITO.nombre, AVG(DETALLITO.TOTAL) 'promedio'
FROM (
	SELECT R.id, R.checkin, R.checkout, H.precio, C.id 'id_cliente', C.nombre,
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) AS 'total'
	FROM RESERVA R 
	INNER JOIN HABITACION H ON H.id = R.id_habitacion
	INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
	LEFT JOIN EXTRA X ON X.id_reserva = R.id 
	LEFT JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre, DATEDIFF(DAY,R.checkin,R.checkout), H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
) DETALLITO
GROUP BY DETALLITO.id_cliente, DETALLITO.nombre
HAVING AVG(DETALLITO.TOTAL) >= 550.0
ORDER BY DETALLITO.id_cliente ASC;

-- ACTUALIZAR DE MANERA DINAMICA UTILIZANDO SUBCONSULTA

-- Agregar una columna a la tabla cliente llamada 'vip' de tipo entero y configurar el valor 1 a todos los usuarios VIP
ALTER TABLE CLIENTE ADD vip BIT NULL;
UPDATE CLIENTE SET vip = 0;

-- Ocupando la subconsulta anterior podemos saber que clientes son VIP si mostramos solo el id del cliente
SELECT DETALLITO.id_cliente
FROM (
	SELECT R.id, R.checkin, R.checkout, H.precio, C.id 'id_cliente', C.nombre,
	H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
	FROM RESERVA R 
	INNER JOIN HABITACION H ON H.id = R.id_habitacion
	INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
	LEFT JOIN EXTRA X ON X.id_reserva = R.id 
	LEFT JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre,DATEDIFF(DAY,R.checkin,R.checkout),H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
) DETALLITO
GROUP BY DETALLITO.id_cliente, DETALLITO.nombre
HAVING AVG(DETALLITO.TOTAL) >= 550.0
ORDER BY DETALLITO.id_cliente ASC;

UPDATE CLIENTE SET vip = 1 
WHERE id IN (
	SELECT DETALLITO.id_cliente
	FROM (
		SELECT R.id, R.checkin, R.checkout, H.precio, C.id 'id_cliente', C.nombre,
		H.precio * DATEDIFF(DAY,R.checkin,R.checkout) + ISNULL(SUM(S.precio),0)*DATEDIFF(DAY,R.checkin,R.checkout) 'TOTAL'
		FROM RESERVA R 
		INNER JOIN HABITACION H ON H.id = R.id_habitacion
		INNER JOIN CLIENTE C ON C.id = R.id_cliente_reserva
		LEFT JOIN EXTRA X ON X.id_reserva = R.id 
		LEFT JOIN SERVICIO S ON S.id = X.id_servicio
		GROUP BY R.id, R.checkin, R.checkout, H.precio,  C.id, C.nombre,DATEDIFF(DAY,R.checkin,R.checkout),H.precio * DATEDIFF(DAY,R.checkin,R.checkout)
	) DETALLITO
	GROUP BY DETALLITO.id_cliente, DETALLITO.nombre
	HAVING AVG(DETALLITO.TOTAL) >= 550.0
);

SELECT * FROM CLIENTE WHERE vip = 1 ORDER BY id ASC;

-- Mostrar en una vista los 2 servicios que más ingresos generan y los 2 servicios que menos ingresos generan

-- Obteniendo el top 2 de los que mas ingresos generaron 
SELECT TOP 2 s.id,s.nombre, SUM(DATEDIFF(DAY,r.checkin , r.checkout) * s.precio) 'ganancia'
FROM SERVICIO s
INNER JOIN EXTRA e ON e.id_servicio = s.id
INNER JOIN RESERVA r ON r.id = e.id_reserva
GROUP BY s.id,s.nombre
ORDER BY ganancia DESC

-- Obteniendo el top 2 de los que menos ingresos generaron
SELECT TOP 2 s.id,s.nombre, SUM(DATEDIFF(DAY,r.checkin , r.checkout) * s.precio) 'ganancia'
FROM SERVICIO s
INNER JOIN EXTRA e ON e.id_servicio = s.id
INNER JOIN RESERVA r ON r.id = e.id_reserva
GROUP BY s.id,s.nombre
ORDER BY ganancia ASC

-- Unimos las dos consultas anteriormente hechas
SELECT S.id, S.nombre, S.precio, SUM(DATEDIFF(DAY,R.checkin, R.checkout )*S.precio) 'ganancia'
FROM RESERVA R
INNER JOIN EXTRA X ON R.id = X.id_reserva
INNER JOIN SERVICIO S ON S.id = X.id_servicio
WHERE S.id IN (
	SELECT TOP 2 S.id
	FROM RESERVA R
	INNER JOIN EXTRA X ON R.id = X.id_reserva
	INNER JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY S.id, S.nombre, S.precio
	ORDER BY SUM(DATEDIFF(DAY,R.checkin, R.checkout ) * S.precio) DESC
) OR
	S.id IN (
	SELECT TOP 2 S.id
	FROM RESERVA R
	INNER JOIN EXTRA X ON R.id = X.id_reserva
	INNER JOIN SERVICIO S ON S.id = X.id_servicio
	GROUP BY S.id, S.nombre, S.precio
	ORDER BY SUM(DATEDIFF(DAY,R.checkin, R.checkout ) * S.precio) ASC	
)
GROUP BY S.id, S.nombre, S.precio
ORDER BY SUM(DATEDIFF(DAY,R.checkin, R.checkout ) * S.precio) DESC;