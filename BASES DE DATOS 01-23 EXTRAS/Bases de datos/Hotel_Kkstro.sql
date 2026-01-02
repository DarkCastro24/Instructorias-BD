create database hotel;
use hotel;
go

create table Cliente(
dui int not null primary key,
nombre varchar(30),
pais_origen varchar(30),
telefono varchar(20)
);

create table Correo(
id int not null primary key,
dui int not null references Cliente(dui),
correo varchar(50)
);


create table Hotel(
id int not null primary key,
nombre varchar(30),
direccion varchar(100),
telefono char(8),
categoria varchar(30)
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
cliente int not null references Cliente(dui),
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

