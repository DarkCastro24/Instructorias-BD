create database hotel_esteroides;
use hotel_esteroides;
go

create table Cliente(
dui char(10) not null primary key,
nombre varchar(30),
pais_origen varchar(30),
telefono varchar(20)
);

create table Correo(
id int not null primary key,
dui char(10) not null references Cliente(dui),
correo varchar(50)
);

create table Hotel(
id int not null primary key,
nombre varchar(30),
direccion varchar(100),
telefono char(8),
categoria varchar(30),
region varchar(40),
tipo varchar(40)
);

create table Empleado(
documento char(10) not null primary key,
nombre varchar(30),
numero_pension int,
numero_salud int,
fecha_nacimiento date,
fotografia image,
telefono char(9),
salario float,
tipo_empleado varchar(30),
correo varchar(50),
hotel int not null references Hotel(id)
);

create table Habitacion(
id int not null primary key,
numero_habitacion int,
precio float,
tipo varchar(30),
hotel int not null references Hotel(id)
);

create table Reserva(
id int not null primary key,
check_in date,
check_out date,
canal_pago varchar(30),
cliente char(10) not null references Cliente(dui),
habitacion int not null references Habitacion(id)
);

create table Servicio(
id int not null primary key,
servicio varchar(30),
precio float,
descripcion varchar(100),
reserva int not null references Reserva(id)
);

create table Fotografia(
id int not null primary key,
servicio int not null references Servicio(id),
fotografia image
);

create table Comentario(
fotografia image,
comentario varchar(50),
calificacion int,
cliente char(10) not null references Cliente(dui)
);

create table Cancelacion(
razon_cancelacion varchar(50),
fecha date,
hora time,
reserva int not null references Reserva(id)
);

create table Representante(
empleado char(10) not null references Empleado(documento),
fecha_inicio date,
fecha_fin date
);