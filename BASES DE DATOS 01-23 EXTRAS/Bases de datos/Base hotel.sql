/* 
	Materia: Base de datos 
	Autor: Diego Castro as Kstro
	Objetivo: aplicar los contenidos vistos en clases
*/

create database Hotel;
use Hotel

-- Primero voy a crear las tablas padre (tablas sin FK)

create table Tipo_Empleado(
id int not null primary key,
tipo varchar(30)
);

-- Empleado tiene la FK de tipo por ende Tipo debe existir antes de crear la tabla Empleado
create table Empleado(
dui char(9) not null primary key,
nombre varchar(30) not null,
numero_pension int,
isss int,
fecha_nacimiento date,
salario money,
tipo int not null references Tipo_Empleado(id),
correo varchar(60)
);

-- Region y Categoria son tablas padre de Hotel por ende hay que declararlas antes de hotel
create table Region_Hotel(
id int not null primary key,
region varchar(30)
);

create table Categoria_Hotel(
id int not null primary key,
categoria varchar(30)
);

create table Hotel(
id int not null primary key,
region int not null references Categoria_Hotel(id),
nombre varchar(50),
prefijo_telefono char(4),
numero_telefono char(8),
categoria int not null references Categoria_Hotel(id),
id_hotel_coordinador int null references Hotel(id),
direccion varchar(100)
);

-- Pais y Categoria son tablas padres de cliente (esta ultima tiene sus FK) por ende debemos crearlas antes de cliente
create table Pais(
id int not null primary key,
pais varchar(30) not null
);

create table Categoria(
id int not null primary key,
categoria varchar(30) not null
);

create table Cliente(
documento char(9) not null primary key,
nombre varchar(30) not null,
pais int not null references Pais(id),
categoria int not null references Categoria(id)
);

-- Telefono es producto de una FN3 es una tabla que depende de la tabla principal ya que es una
-- extension de informacion por ende la creamos luego de crear la tabla cliente ya que incluye su PK
create table Telefono(
id int not null primary key,
prefijo_telefono char(4),
numero_telefono varchar(12),
id_cliente char(9) not null references Cliente(documento)
);

-- Correo es una tabla generada de la FN1 y contiene la FK de cliente
-- por ende es necesario que ya exista cliente para crear las tablas de los atributos multivaluados
create table Correo(
id int not null primary key,
id_cliente char(9) not null references Cliente(documento),
correo varchar(75) not null
);

create table Servicio(
id int not null primary key,
nombre varchar(60) not null,
precio money,
descripcion varchar(150)
);

-- Fotografia_Servicio se genera con un campo multivaluado por ende incluye la FK de servicio debemos crearla despues de servicio
create table Fotografia_Servicio(
id int not null primary key,
id_servicio int not null references Servicio(id),
fotografia text not null
);

create table Tipo_Habitacion(
id int not null primary key,
tipo varchar(30) not null 
);

create table Habitacion(
id int not null primary key,
numero smallint,
tipo int not null references Tipo_Habitacion(id),
id_hotel int not null references Hotel(id),
precio money
);

create table Metodo_Pago(
id int not null primary key,
metodo_pago varchar(30) not null
);

create table Reserva(
id int not null primary key,
checkin date,
checkout date,
metodo_pago int not null references Metodo_Pago(id),
id_habitacion int not null references Habitacion(id),
id_cliente_reserva char(9) not null references Cliente(documento),
id_cliente_cancela char(9) null references Cliente(documento),
justificacion_cancelacion varchar(90) not null,
hora_cancelacion time,
fecha_cancelacion date
);

create table Comentario(
id int not null primary key,
id_hotel int not null references Hotel(id),
id_documento char(9) not null references Cliente(documento),
comentario varchar(50) not null,
calificacion tinyint,
);

create table Fotografia_Comentario(
id int not null primary key,
id_comentario int not null references Comentario(id),
fotografia text not null
);

create table Contrato(
id int not null primary key,
DUI_empleado char(9) not null references Empleado(DUI),
id_hotel int not null references Hotel(id)
);

create table Representante(
id int not null primary key,
DUI_empleado char(9) not null references Empleado(DUI),
id_hotel int not null references Hotel(id),
periodo_inicio date,
periodo_fin date
);

create table Extra(
id_reserva int not null references Reserva(id),
id_servicio int not null references Servicio(id)
);

-- Aca termina la creacion de las tablas (porfin....)

-- Estructuras DML (insert, update, delete, select) para ir al nivel de la clase vamos a ocupar las tablas Hotel y Habitacion (incluyendo sus tablas Catalogo: Region, Categoria y Tipo_Habitacion) 
-- Primero veremos el INSERT: funcion ingresar registros dentro de una tabla

-- Para comenzar a llenar la base primero debemos llenar las tablas que no tengan FK osea los catalogos
-- Estructura INSERT INTO tabla (columnas) values (valores);
INSERT INTO Categoria_Hotel(id,categoria) values (1,'1 estrella'),(2,'2 estrellas'),(3,'3 estrellas'),(4,'4 estrellas'),(5,'5 estrellas');
INSERT INTO Region_Hotel(id,region) values (1,'Region 1'),(2,'Region 2');
INSERT INTO Tipo_Habitacion (id,tipo) values(1,'Sencilla'),(2,'Suite Lujo'),(3,'Doble');

-- Ahora podemos ingresar en las tablas Habitacion y Hotel ya que tenemos registros dentro de los catalogos
INSERT INTO Hotel (id,region,nombre,prefijo_telefono,numero_telefono,categoria,id_hotel_coordinador,direccion) values (1,1,'Intercontinental','+503','70654595',3,null,'Calle las amapolas, San Salvador')
INSERT INTO Habitacion (id,numero,tipo,id_hotel,precio) values (1,1,1,1,75),(2,2,2,1,150);
-- SELECT: sirve para ver los registros que hay en una tabla
SELECT * FROM Categoria_Hotel;
SELECT * FROM Habitacion;
SELECT * FROM Hotel;

-- UPDATE: sirve para actualizar los valores de uno o varios registros de una tabla 
-- Vamos a modificar solo 2 campos del hotel en este caso nombre y telefono

-- Con el where indicamos que solo modificaremos el registro con el ID 1
UPDATE Hotel set nombre = 'Hotel Intercontinental', numero_telefono = '79885288' where id = 1;

-- Ejecutamos un select para verificar que se haya realizado el cambio
SELECT * FROM Hotel;

-- DELETE: sirve para borrar uno o varios registros de una tabla

-- Asi indicamos que registro queremos borrar el registro con el ID 1
DELETE FROM Habitacion where id = 1;

-- Con el select verificamos que solo se haya borrado uno de los dos registros
SELECT * FROM Habitacion;

-- Si queremos borrar todos los registros no colocamos el WHERE
DELETE FROM Habitacion;

-- Con el select nos daremos cuenta que se han borrado los campos de la tabla
SELECT * FROM Habitacion;

-- DROP TABLE: sirve para eliminar una tabla (solo coloco sintaxis pero no ejecuto)
DROP TABLE Habitacion; -- Comando para borrar la tabla Habitacion

-- ALTER TABLE: es un comando para modificar la estructura de una tabla ya creada puede ocuparse para eliminar, agregar o modificar una columna

-- Agregar PK, FK, UNIQUE, NOT NULL utilizando ALTER TABLE
ALTER TABLE Hotel
ADD PRIMARY KEY (id);

ALTER TABLE Habitacion
ADD FOREIGN KEY (id_hotel) REFERENCES Hotel(id);

ALTER TABLE Hotel
ADD UNIQUE (nombre);

ALTER TABLE Hotel
ALTER COLUMN direccion varchar(150) not null;

-- Columna DEFAULT: podemos definir un valor por defecto que tendra un campo en caso de colocar default en su valor a la hora de darle un valor

-- Aca colocamos que el valor default de una habitacion es $0
ALTER TABLE Habitacion ADD DEFAULT 0 FOR precio;

-- Probamos que funcione el DEFAULT
INSERT INTO Habitacion (id,numero,tipo,id_hotel,precio) values (1,1,1,1,default);

-- Verificamos que se agrego el registro con el valor por defecto
SELECT * FROM Habitacion;

-- Agregar columna en tabla Hotel en este caso le puse representante y es de tipo TEXT
ALTER TABLE Hotel ADD representante text null;

-- Verificamos que se agrego la nueva columna a la tabla Hotel
SELECT * FROM Hotel;

-- Modificar columna creada anteriormente cambiandole el tipo de dato
ALTER TABLE Hotel ALTER COLUMN representante varchar(50) null;

-- Eliminar columna
ALTER TABLE Hotel DROP COLUMN representante;

-- Verificamos que se elimino la columna representante de la tabla Hotel
SELECT * FROM Hotel; 

-- Estructura DDL (restricciones check) lo aplicare utilizando ALTER TABLE para no volver a crear la tabla}
-- Campo telefono de HOTEL debe tener el formato:

-- Debe incluir el identificador de pais +503 
ALTER TABLE Hotel 
ADD CONSTRAINT check_identificador   
CHECK (prefijo_telefono = '+503'); 

-- El comando left lo que hace es retornar el caracter que nosotros indiquemos de un campo en este caso lo que hago es obtener el caracter 1
-- y validar si es igual a uno de los numeros con los que debe comenzar osea 2, 6 o 7

-- El numero de telefono actual tiene 8 digitos de longitud.
ALTER TABLE Hotel 
ADD CONSTRAINT check_longitud
CHECK (LEN(numero_telefono) = 8); 

-- El comando LEN retorna la longitud de un registro ingresado en un campo

-- Campo numero de HABITACION debe tener el formato:

-- Numero mayor que 0
ALTER TABLE Habitacion 
ADD CONSTRAINT check_numero_habitacion
CHECK (numero > 0)

/*
	create table Hotel(
	id int not null primary key,
	region int not null references Categoria_Hotel(id),
	nombre varchar(50),
	prefijo_telefono varchar(4),
	numero_telefono varchar(8),
	categoria int not null references Categoria_Hotel(id),
	id_hotel_coordinador int null references Hotel(id),
	direccion varchar(100),
	CHECK (prefijo_telefono = '+503'),
	CHECK (LEN(numero_telefono) = 8)
	);

	create table Habitacion(
	id int not null primary key,
	numero smallint,
	tipo int not null references Tipo_Habitacion(id),
	id_hotel int not null references Hotel(id),
	precio money,
	CHECK (numero > 0)
);
*/

-- Verificamos que las restricciones CHECK funcionen intentare ingresar registros que violen las restricciones

-- Primero verificamos que el numero de habitacion no sea 0 o menor 
INSERT INTO Habitacion (id,numero,tipo,id_hotel,precio) values (3,0,1,1,60);

-- Ahora verificamos los del Hotel prefijo y numero telefonico

-- Primero que se valide que el codigo del pais sea +503
INSERT INTO Hotel (id,region,nombre,prefijo_telefono,numero_telefono,categoria,id_hotel_coordinador,direccion) 
values (2,2,'Sheraton Presidente','+502','70654595',3,null,'Calle las amapolas, San Salvador');

-- El numero de telefono actual tiene 8 digitos de longitud.
INSERT INTO Hotel (id,region,nombre,prefijo_telefono,numero_telefono,categoria,id_hotel_coordinador,direccion) 
values (2,2,'Sheraton Presidente','+503','2065459',3,null,'Calle las amapolas, San Salvador');

