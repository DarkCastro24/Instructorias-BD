create database tienda;
use tienda;
go

/* EXPLICACION DE CIERTOS CONCEPTOS BASICOS
	 
	 !!!ACLARACION EL CODIGO ESTA HECHO EN BASE AL DIAGRAMA PRESENTADO EN CLASES (NO ES LA FORMA MAS OPTIMA DE HACERLO MAS QUE TODO ES PARA VER COMO SE HACEN LAS COSAS)!!!

	TIPOS DE DATOS
	CHAR(X) X= numero de caracteres (fijo siempre debe tener ese numero de caracteres)
	VARCHAR(X) X= numero maximo de caracteres (puede tener menos de x pero no mas)
	INT tipo de dato para numeros enteros
	Float/Double tipo de dato para decimales 
	Date tipo de dato para almacenar fechas 

	LLAVES 
	PRIMARY KEY: campo que identifica una tabla debe ser unico (no se debe repetir)
	FOREIGN KEY: campo que hace referencia a la llave primaria de una tabla con la que se tenga relacion

	RESTRICCIONES 
	NOT NULL: significa que el campo no puede quedar vacio a la hora de ingresar un registro
	UNIQUE: no pueden haber dos registros iguales dentro de un campo unique
*/

create table Categoria(
id int not null primary key,
nombre varchar(30),
descripcion varchar(100)
);

create table Proveedor(
nit char(17) not null primary key,
nombre varchar(40),
direccion varchar(100),
telefono char(9),
correo_electronico varchar(50),
pagina_web varchar(100)
);

create table Producto(
codigo int not null primary key,
nombre varchar(30),
precio_actual float,
stock int default 0,  /*Si se ingresa nulo el valor del campo sera 0*/
proveedor char(17) not null references Proveedor(nit),
categoria int not null references Categoria(id)
);

create table Cliente(
dui char(10) not null primary key,
nombre varchar(50),
telefono char(9) 
);

create table Compra(
codigo int not null primary key,
fecha date,
monto_total float,
cliente char(10) not null references Cliente(dui),
producto int not null references Producto(codigo)
);

create table Direccion(
cliente char(10) not null references Cliente(dui),
colonia varchar(50),
calle int,
numero_casa int,
municipio varchar(30),
departamento varchar(30)
);
