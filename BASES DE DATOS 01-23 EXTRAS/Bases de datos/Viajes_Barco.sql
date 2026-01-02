create database Viajes_Barco;
use Viajes_Barco

create table Pais(
id int not null primary key,
pais varchar(30) not null
);

insert into Pais (id,pais) values(1,'El Salvador'),(2,'Guatemala'),(3,'Nicaragua');

create table Fabricante(
id int not null primary key,
fabricante varchar(50) not null
);

insert into Fabricante (id,fabricante) values (1,'Jeanneau'),(2,'Quicksilver'),(3,'Sea Roy');

create table Modelo(
id int not null primary key,
fabricante int not null references Fabricante(id),
modelo varchar(50) not null 
);

insert into Modelo (id,fabricante,modelo) values (1,1,'Aguamarina'),(2,2,'Alba'),(3,2,'Calypso'),(4,3,'La Perla Negra');

create table Tipo_Cabina(
id int not null primary key,
tipo_cabina varchar(30) not null 
);

insert into Tipo_Cabina (id,tipo_cabina) values (1,'Interior'),(2,'Exterior'),(3,'Suite');

create table Servicio(
id int not null primary key,
nombre varchar(50) not null,
precio money not null default 0
);

insert into Servicio(id,nombre,precio) values (1,'Aire Acondicionado',10),(2,'Spa',30),
(3,'Buffet',15),(4,'Gimnasio',15);

create table Direccion(
id int not null primary key,
id_pais int not null references Pais(id),
ciudad varchar(50) not null
);

insert into Direccion (id,id_pais,ciudad) values(1,1,'Acajutla'),(2,1,'La union'),(3,2,'Santo Tomás de Castilla'),
(4,2,'San José'),(5,3,'Roatán'),(6,3,'San Lorenzo');

create table Barco(
matricula char(13) not null primary key,
modelo int not null references Modelo(id),
capacidad int not null
);

insert into Barco values('9-BA-2-999-21',1,1500),('9-CA-2-999-15',2,500),('3-CA-2-745-23',3,1500);

create table Pasajero(
pasaporte char(9) not null primary key,
nombre varchar(40) not null,
fecha_nacimiento date,
telefono char(8) not null,
correo varchar(70),
id_pais int not null references Pais(id)
);

insert into Pasajero values ('B04570140','Diego Castro','2002-11-24','79885288','DiegoCastro@gmail.com',1),
('P02570140','Alexis Figueroa','2002-12-24','73845218','AlexisFig@gmail.com',1),('P04472110','Roberto Sanchez','1999-05-13','73855228','Roberto@gmail.com',2),
('A32126545','Juan Lopez','1992-03-12','79885288','JuanLopez@gmail.com',3);

create table Puerto_Maritimo(
id int not null primary key,
nombre varchar(50) not null,
direccion int not null references Direccion(id),
gps text 
);

insert into Puerto_Maritimo values(1,'Puerto de acajutla',1,'13°3554.6"N 89°4912.7"W'),(2,'Puerto de cutuco',2,'12°3434.6"N 12°32434.7"W'),
(3,'Puerto santo tomas',3,'16°3544.6"N 54°32123.7"W'),(4,'Puerto San Jose',4,'15°7614.6"N 43°67434.7"W'),(5,'Puerto Roatan',5,'25°3213.4"N 41°67434.7"W'),
(6,'Puerto San Jose',6,'45°7614.6"N 54°65434.7"W');

create table Viaje(
id int not null primary key,
fecha date,
duracion int,
capitan varchar(50),
id_barco char(13) not null references Barco(matricula),
id_puerto_origen int not null references Puerto_Maritimo(id),
id_puerto_destino int not null references Puerto_Maritimo(id)
);

insert into Viaje values (1,'2023-05-01',24,'Popeye el marino','9-BA-2-999-21',1,2), (2,'2023-05-01',48,'Capitán Haddock ','9-BA-2-999-21',2,3), (3,'2023-05-01',12,'Popeye el marino','9-CA-2-999-15',3,4), (4,'2023-05-01',36,'Capitán Garfio','3-CA-2-745-23',4,5);

create table Reserva(
id int not null primary key,
precio money not null,
id_tipo_cabina int not null references Tipo_Cabina(id),
fecha date,
id_viaje int not null references Viaje(id),
id_pasajero char(9) not null references Pasajero(pasaporte)
);

insert into Reserva values (1,75,1,'2022-03-12',1,'B04570140'),(2,50,2,'2022-05-12',1,'P02570140'),(3,100,3,'2021-03-21',2,'A32126545'),(4,75,1,'2022-04-13',3,'A32126545'),(5,75,1,'2022-05-12',3,'B04570140'),(6,50,2,'2022-06-12',4,'B04570140'),(7,100,3,'2021-03-25',4,'P02570140');

create table Detalle_Reserva(
id_reserva int not null references Reserva(id),
id_servicio int not null references Servicio(id)
);

insert into Detalle_Reserva values (1,1),(1,2),(1,4),(2,1),(2,3),(3,2),(4,1),(4,2),(5,1),(5,3),(6,4);

-- SELECT A TABLA BARCO, FABRICANTE Y MODELO
select * from Barco;
select * from Fabricante;
select * from Modelo;

-- Actualizar la capacidad a 1000 del Barco con matricula 3-CA-2-745-23
update Barco set capacidad = 1000 where matricula = '3-CA-2-745-23';

-- Actualizar el numero de telefono del pasajero con pasaporte B04570140
update Pasajero set telefono = '79862345' where pasaporte = 'B04570140';

-- Eliminar el ultimo registro de la tabla modelo
delete from Modelo where id = 4;

-- Borrar la tabla Barco
--drop table Barco;

-- Alter table para hacer UNIQUE el nombre de fabricante en tabla Fabricante
ALTER TABLE Fabricante
ADD UNIQUE (fabricante);

-- Alter table para agregar columna y eliminarla 
ALTER TABLE Barco ADD columna1 varchar(150) null;
ALTER TABLE Barco DROP COLUMN columna1;

-- Alter table para agregar valor default de 1 al numero de pasajeros de un barco 
ALTER TABLE Barco ADD DEFAULT 1 FOR capacidad;

-- Alter table para implementar CHECK restricciones 

-- La capacidad no puede ser menor a 1
ALTER TABLE Barco
ADD CONSTRAINT check_capacidad   
CHECK (capacidad >= 1); 

-- La matricula del barco debe tener 13 caracteres de longitud
ALTER TABLE Barco
ADD CONSTRAINT check_longitud
CHECK (LEN(matricula) = 13); 

-- A PARTIR DE ACA SERA COMPLETAMENTE DEDICADO A CONSULTAS (SELECT)

-- SELECT BASICO con el * indicamos que queremos mostrar todas las columnas de la tabla
SELECT * FROM Pasajero;

-- SELECT BASICO tenemos la opcion de seleccionar que columnas queremos mostrar en la consulta si escribimos sus nombre entre SELECT y FROM el resto de columnas no se mostraran
SELECT pasaporte,nombre,telefono FROM Pasajero

-- SELECT CON WHERE: la sentencia WHERE nos sirve para poder mostrar uno o varios registros que cumplan la condicion que nosotros le pongamos

-- Ejemplo: Mostrar la reserva que tenga id = 1
SELECT id,precio,fecha,id_pasajero,id_tipo_cabina 
FROM Reserva 
WHERE id = 1;

-- Ejemplo: Mostrar todas las reservas realizadas por (una persona)
SELECT id,precio,fecha,id_pasajero,id_tipo_cabina 
FROM Reserva 
WHERE id_pasajero = 'B04570140';

-- Mostrar las reservas que tengan tipo de cabina interior 
SELECT id,precio,fecha,id_pasajero
FROM Reserva 
WHERE id_tipo_cabina = 1

-- FUNCIONES COUNT(): retorna numero de registros, MAX() retorna el valor maximo, MIN() retorna el valor minimo 
-- SUM() retorna la sumatoria de una columna tipo numerica, AVG() retorna el promedio de los valores de una columna tipo numerica

-- Obtenga el numero de reservas que existen en la tabla Reserva
SELECT COUNT(*) FROM Reserva;

-- Obtenga el precio de la reserva mas cara 
SELECT MAX(precio) FROM Reserva;

-- Obtenega el precio de la reserva mas barata
SELECT MIN(precio) FROM Reserva;

-- Obtener la sumatoria de los precios de todas las reservas 
SELECT SUM(precio) FROM Reserva;

-- Obtener el promedio de precio de todas las reservas 
SELECT AVG(precio) FROM Reserva;

-- BEETWEEN: indicamos un rango para seleccionar valores de un valor a otro

-- Ejemplo seleccionar las reservas realizadas entre Marzo y Abril del 2022
SELECT id,precio,fecha,id_pasajero 
FROM Reserva 
WHERE fecha BETWEEN '2022-03-01' AND '2022-04-30';

-- Ejemplo mostrar los pasajeros que cumplen años entre el año 2000 y 2004
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo 
FROM Pasajero
WHERE fecha_nacimiento BETWEEN '2000-01-01' AND '2004-12-31';

-- LIKE: comando para verificar si existen coincidencias entre el valor que asignemos y los registros de la tabla que indiquemos 

-- Mostrar los pasajeros cuyos numeros de telefono contengan '798'
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo 
FROM Pasajero
WHERE telefono LIKE '%798%';

-- TOP: nos sirve para indicar el maximo de registros que puede retornar una consulta

-- Mostrar los primeras 3 reservas registradas
SELECT TOP 3 id,precio,fecha,id_pasajero 
FROM Reserva

-- JOINS ver datos de dos o mas tablas a la vez 
 
-- DATOS IMPORTANTES: Para hacer el JOIN necesitamos ocupar 2 o mas tablas porque el objetivo es mostrar informacion de las llaves foraneas de una tabla en lugar de mostrar el id 

-- Ejemplo: mostrar todos los datos de los pasajeros y el nombre del pais de origen
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo,Pais.pais 
FROM Pasajero
INNER JOIN Pais ON Pais.id = Pasajero.id_pais

-- En la consulta anterior ocupe 2 tablas Pasajero mi tabla principal Pasajero (tiene la FK) y las tablas externas Pais pero podemos colocar un identificador a las tablas para referirnos a ellas
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo, pa.pais 
FROM Pasajero p
INNER JOIN Pais pa ON pa.id = p.id_pais

-- Ejemplo: Mostrar todos los datos los barcos registrados 
SELECT b.matricula,m.modelo,f.fabricante,b.capacidad
FROM Barco b
INNER JOIN Modelo m ON m.id = b.modelo
INNER JOIN Fabricante f ON f.id = m.fabricante;

-- Mostrar los datos de la reserva: id reserva , precio, tipo cabina, fecha, nombre del pasajero, telefono del pasajero y pais del pasajero
SELECT r.id,r.precio,t.tipo_cabina,r.fecha,p.nombre,p.telefono,pa.pais 
FROM Reserva r 
INNER JOIN Pasajero p ON p.pasaporte = r.id_pasajero
INNER JOIN Tipo_Cabina t ON t.id = r.id_tipo_cabina
INNER JOIN Pais pa ON pa.id = p.id_pais

-- Instruccion ORDER BY: nos sirve para mostrar los datos de manera ordenada puede ser de manera ASC (menor a mayor) o DESC (mayor a menor)

-- Ejemplo: mostrar los pasajeros del mas joven al mas viejo
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo,id_pais 
FROM Pasajero 
ORDER BY fecha_nacimiento DESC;

-- Ejemplo: mostrar los pasajeros del mas viejo al mas joven
SELECT pasaporte,nombre,fecha_nacimiento,telefono,correo,id_pais 
FROM Pasajero 
ORDER BY fecha_nacimiento ASC;

-- Ejemplo: mostrar de las reservas mas baratas a las mas caras
SELECT id,precio,fecha,id_pasajero 
FROM Reserva
ORDER BY precio ASC;

-- Ejemplo: mostrar de las reservas mas caras a las mas baratas
SELECT id,precio,fecha,id_pasajero 
FROM Reserva
ORDER BY precio DESC;

-- Instruccion GROUP BY: debe incluir obligatoriamente una funcion como COUNT,MAX,MIN,SUM,AVG

-- Ejemplo: mostrar el numero de pasajeros por pais 
SELECT Pais.pais, COUNT(id_pais) as num_pasajeros
FROM Pasajero
INNER JOIN Pais ON Pais.id = Pasajero.id_pais
GROUP BY Pais.pais

-- Ejemplo: mostrar el numero de reservas realizada por cada pasajero y mostrar de forma ascendente (menor a mayor)
SELECT p.nombre, COUNT(r.id) as num_reservas
FROM Reserva r
INNER JOIN Pasajero p ON p.pasaporte = r.id_pasajero
GROUP BY p.nombre
ORDER BY num_reservas ASC 

-- Ejemplo: mostrar el monto total de los servicios por cada reserva
SELECT r.id as id_reserva , SUM(s.precio) as monto_total 
FROM Detalle_Reserva dr
INNER JOIN Reserva r ON r.id = dr.id_reserva
INNER JOIN Servicio s ON s.id = dr.id_servicio
GROUP BY r.id

-- Instrucciones INTO y HAVING

-- Having: es un filtro que nos sirve para delimitar los registros que queremos mostrar funciona como un where

-- Ejemplo: mostrar los montos totales de cada reserva que sean mayores a $30 
SELECT r.id as id_reserva, SUM(s.precio) as monto_total 
FROM Detalle_Reserva dr
INNER JOIN Reserva r ON r.id = dr.id_reserva
INNER JOIN Servicio s ON s.id = dr.id_servicio
GROUP BY r.id
HAVING SUM(s.precio) >= 30

-- Ejemplo: mostrar los paises que tengan como minimo 2 pasajeros 
SELECT Pais.pais, COUNT(id_pais) as num_pasajeros
FROM Pasajero
INNER JOIN Pais ON Pais.id = Pasajero.id_pais
GROUP BY Pais.pais
HAVING COUNT(id_pais) >= 2 

-- INTO: selecciona la informacion de una tabla y crea e inserta todos los registros en la nueva tabla (hace un backup)

-- Hacer un respaldo de los tipos de cabina 
SELECT * INTO Tipo_Cabina_Backup 
FROM Tipo_Cabina

SELECT * FROM Tipo_Cabina;
SELECT * FROM Tipo_Cabina_Backup ;

-- Hacer un respaldo de los pasajeros 
SELECT * INTO Pasajero_Respaldo
FROM Pasajero

SELECT * FROM Pasajero;
SELECT * FROM Pasajero_Respaldo;

