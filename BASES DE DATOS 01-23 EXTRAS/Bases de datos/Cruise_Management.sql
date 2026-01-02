--****************************************************
-- Bases de datos: Base de datos de reserva de cruceros
-- Autor: Brian Carranza, Erick Varela
-- Correspondencia: 00136020@uca.edu.sv, evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

CREATE DATABASE Cruise_ManagementV1;
Go
USE Cruise_ManagementV1;				
SET LANGUAGE us_english;
GO

----1.Crear las tablas.
--Tabla pais
CREATE TABLE PAIS(
	id INT PRIMARY KEY,
	nombre VARCHAR(50)
);
--Tabla ciudad
CREATE TABLE CIUDAD(
	id INT PRIMARY KEY,
	nombre VARCHAR(50)
);
--Tabla fabricante
CREATE TABLE FABRICANTE(
	id INT PRIMARY KEY,
	nombre VARCHAR (50)
);
--Tabla modelo
CREATE TABLE MODELO(
	id INT PRIMARY KEY,
	nombre VARCHAR (50),
	id_fabricante INT NOT NULL
);
--Tabla ciudad
CREATE TABLE CAPITAN(
	id INT PRIMARY KEY,
	nombre VARCHAR(50)
);
--Tabla tipo cabina
CREATE TABLE TIPO_CABINA(
	id INT PRIMARY KEY,
	tipo_cabina VARCHAR(15)
);
--Tabla servicio
CREATE TABLE SERVICIO (
	id INT PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL, 
	precio MONEY NOT NULL
);
--Tabla pasajero
CREATE TABLE PASAJERO(
	id INT PRIMARY KEY,
	pasaporte VARCHAR(15) NOT NULL,
	nombre VARCHAR(50)NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	correo_electronico VARCHAR(50) NOT NULL,
	telefono VARCHAR(15) NOT NULL,
	id_pais INT NOT NULL
);
--Tabla puerto maritimo
CREATE TABLE PUERTO_MARITIMO(
	id INT PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	gps VARCHAR(75) NOT NULL,
	id_ciudad INT NOT NULL,
	id_pais INT NOT NULL
);
--Tabla barco
CREATE TABLE BARCO(
	id INT PRIMARY KEY,
	matricula VARCHAR(11),
	capacidad INT NOT NULL,
	id_modelo INT NOT NULL
);

--Tabla viaje
CREATE TABLE VIAJE (
    id INT PRIMARY KEY,
    fecha_salida DATETIME,
    fecha_llegada DATETIME,
    duracion INT NULL DEFAULT NULL,
    id_puerto_maritimo_origen INT NOT NULL,
    id_puerto_maritimo_destino INT NOT NULL,
    id_barco INT NOT NULL,
    id_capitan INT NOT NULL
);

--Tabla reserva
CREATE TABLE RESERVA (
	id INT PRIMARY KEY,
	precio MONEY NOT NULL,
	fecha DATE NOT NULL,
	id_pasajero INT NOT NULL,
	id_viaje INT NOT NULL,
	id_tipo_cabina INT NOT NULL
);

--Tabla servicioxreserva
CREATE TABLE SERVICIOXRESERVA(
	id_servicio INT NOT NULL,
	id_reserva INT NOT NULL
);

--1.1
--Calcular duracion de viaje
Go
CREATE TRIGGER calcular_duracion_viaje
ON VIAJE
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE VIAJE
    SET duracion = CEILING(DATEDIFF(MINUTE, fecha_salida, fecha_llegada) / 60.0)
    WHERE duracion IS NULL;
END;

----2.Crear las llaves primarias (PK) y foráneas (FK) correspondientes a cada tabla.
--Tabla servicioxreserva
-- PK Definition 
ALTER TABLE SERVICIOXRESERVA ADD PRIMARY KEY (id_servicio, id_reserva);
-- FK Definition
ALTER TABLE SERVICIOXRESERVA ADD FOREIGN KEY (id_servicio) REFERENCES SERVICIO(id);
ALTER TABLE SERVICIOXRESERVA ADD FOREIGN KEY (id_reserva) REFERENCES RESERVA(id);

--Tabla reserva
-- FK Definition
ALTER TABLE RESERVA ADD FOREIGN KEY (id_tipo_cabina) REFERENCES TIPO_CABINA(id);
ALTER TABLE RESERVA ADD FOREIGN KEY (id_pasajero) REFERENCES PASAJERO(id);
ALTER TABLE RESERVA ADD FOREIGN KEY (id_viaje) REFERENCES VIAJE(id);

--Tabla pasajero
-- FK Definition
ALTER TABLE PASAJERO ADD FOREIGN KEY (id_pais) REFERENCES PAIS(id);

--Tabla puerto_maritimo
-- FK Definition
ALTER TABLE PUERTO_MARITIMO ADD FOREIGN KEY (id_pais) REFERENCES PAIS(id);
ALTER TABLE PUERTO_MARITIMO ADD FOREIGN KEY (id_ciudad) REFERENCES CIUDAD(id);

--Tabla modelo
-- FK Definition
ALTER TABLE MODELO ADD FOREIGN KEY (id_fabricante) REFERENCES FABRICANTE(id);

--Tabla barco
-- FK Definition
ALTER TABLE BARCO ADD FOREIGN KEY (id_modelo) REFERENCES MODELO(id);

--Tabla viaje
ALTER TABLE VIAJE ADD FOREIGN KEY (id_barco) REFERENCES BARCO(id);
ALTER TABLE VIAJE ADD FOREIGN KEY (id_capitan) REFERENCES CAPITAN(id);
ALTER TABLE VIAJE ADD FOREIGN KEY (id_puerto_maritimo_destino) REFERENCES PUERTO_MARITIMO(id);
ALTER TABLE VIAJE ADD FOREIGN KEY (id_puerto_maritimo_origen) REFERENCES PUERTO_MARITIMO(id);