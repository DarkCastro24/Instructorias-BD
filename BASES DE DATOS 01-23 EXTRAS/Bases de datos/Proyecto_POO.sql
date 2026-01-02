create database Proyecto_POO;
use Proyecto_POO;

create table Ficha(
id int not null primary key,
nombre_ficha varchar(36) not null unique, -- Ficha roja / Ficha Azul
ruta_ficha varchar(64) not null default '/recursos/ficha_default.jpg'
);

-- Aca igualmente debemos pensar en los nombres de las fichas y su ruta dentro de la carpeta del proyecto 
insert into Ficha (id,nombre_ficha,ruta_ficha) values (1,'Ficha1','/recursos/ficha1.jpg'),(2,'Ficha2','/recursos/ficha2.jpg'),
(3,'Ficha3','/recursos/ficha3.jpg'),(4,'Ficha4','/recursos/ficha4.jpg');

create table Tablero(
id int not null primary key,
nombre_tablero varchar(36) not null unique, -- Tablero 1 / Tablero 2 / Tablero 3 
ruta_tablero varchar(64) not null default '/recursos/tablero_default.jpg'
);

-- alter table Tablero add ruta_tablero varchar(64) not null default '/recursos/tablero_default.jpg'

-- Aca debemos pensar en los nombres de los tableros
insert into Tablero (id, nombre_tablero) values (1,'Tablero 1'),(2,'Tablero 2'),(3,'Tablero 3');

create table Tipo_casilla (
id int not null primary key,
tipo_casilla varchar(12) not null unique -- Serpiente / Escalera
);

-- Solo hay dos tipos de casilla especial Serpiente o Escalera
insert into Tipo_casilla (id, tipo_casilla) values (1,'Serpiente'),(2,'Escalera');

create table Casillas_tablero(
id int not null primary key identity(1,1),
id_tablero int not null references Tablero(id),
id_tipo_casilla int not null references Tipo_casilla(id),
posicion_inicial tinyint not null, -- Posicion donde se encuentra la casilla
posicion_final tinyint not null, --  Posicion donde termina el jugador
check(posicion_inicial > 0),
check(posicion_final > 0)
);

-- Basado en el tablero del ejemplo del lic Guillermo
insert into Casillas_Tablero (id_tablero,id_tipo_casilla,posicion_inicial,posicion_final) values 
(1,2,6,14),(1,1,16,3),(1,2,17,23),(1,2,27,33),(1,1,29,10),(1,2,38,43),(1,1,39,20),(1,2,45,34);

-- PD partidas perdidas se puede calcular restando partidas_jugadas - partidas_ganadas
create table Jugador(
id int not null primary key identity(1,1),
nombre varchar(64) not null,
nickname varchar(64) not null unique,
partidas_jugadas smallint not null default 0,
partidas_ganadas smallint not null default 0,
check (partidas_jugadas >= 0),
check (partidas_ganadas >= 0)
);

insert into Jugador (nombre,nickname,partidas_jugadas,partidas_ganadas) values ('Diego Castro','Castroll',0,0),
('Alexandra Aguilar','AlexEagle',0,0);

create table Partida(
id int not null primary key identity(1,1),
id_tablero int not null references Tablero(id),
fecha_inicio datetime not null default getDate(), -- Se obtendra por default al ingresar la partida 
fecha_fin datetime null default getDate(), -- Se hara un UPDATE al registro con default
CHECK (fecha_fin > fecha_inicio)
);

-- Aca registramos la informacion especifica de la partida asignaremos el id al detalle con el objetivo de normalizar 
insert into Partida (id_tablero,fecha_inicio,fecha_fin) values (1,'2023-05-09 12:30:51.447','2023-05-09 12:40:35.141'),
(2,'2023-05-09 12:59:51.447',default); 

create table Resultado_partida(
id int not null primary key,
resultado_partida varchar(20) not null unique -- victoria / derrota / En proceso
);

-- Hay 2 resultados de partida: Victoria y Derrota en caso de ser NULL significa que la partida esta en curso 
insert into Resultado_partida (id,resultado_partida) values (1,'Victoria'),(2,'Derrota');

-- El detalle se actualiza al finalizar la partida
create table Detalle_partida(
id int not null primary key identity(1,1),
id_ficha int not null references Ficha(id),
id_partida int not null references Partida(id),
id_jugador int not null references Jugador(id),
id_resultado_partida int null references Resultado_Partida(id) default null, -- Si el resultado es NULL significa que la partida sigue en curso
cantidad_tiros smallint not null default 0,
cantidad_escalera smallint not null default 0,
cantidad_serpiente smallint not null default 0,
cantidad_desbanque smallint null default 0, -- Si queda NULL significa que la partida es Individual (NULL nos da informacion) / Si es Competencia ingresamos con el valor default
CHECK (cantidad_tiros >= 0),
CHECK (cantidad_escalera >= 0),
CHECK (cantidad_serpiente >= 0)
);

-- Sin duda la tabla mas dificil de entender pero basicamente aca termina toda la informacion de las demas tablas 
insert into Detalle_partida (id_ficha,id_partida,id_jugador,id_resultado_partida,cantidad_tiros,cantidad_escalera,cantidad_serpiente,cantidad_desbanque)
values (1,1,1,1,15,2,3,null),(2,2,1,2,20,1,4,2),(3,2,2,1,17,4,1,2);

