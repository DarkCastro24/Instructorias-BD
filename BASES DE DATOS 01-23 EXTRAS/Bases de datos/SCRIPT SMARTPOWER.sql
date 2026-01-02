create table Profesion(
Id_Profesion serial not null primary key,
Profesion varchar(30) not null
);

create table Cargo_Laboral(
Id_Cargo serial not null primary key,
Cargo varchar(40) not null
);

create table Area_Laboral(
Id_AreaLaboral serial not null primary key,
Area_Laboral varchar(40)
);

create table Usuario(
Id_Usuario serial not null primary key,
Estado boolean not null default true,
Profesion int not null references Profesion(Id_Profesion),
Cargo int not null references Cargo_Laboral(Id_Cargo),
Area int not null references Area_Laboral(Id_AreaLaboral),
Usuario varchar(40) not null,
Clave varchar(75) not null,
DUI char(10) not null,
Telefono char(9) null,
Correo_Electronico varchar(75) not null,
Fecha_Contratacion DATE null
);

create table Tipo_Empresa(
Id_TipoEmpresa serial not null primary key,
Tipo_Empresa varchar(30)
);

create table Empresa(
Id_Empresa serial not null primary key,
Tipo int not null references Tipo_Empresa(Id_TipoEmpresa),
Nombre_Empresa VARCHAR(40) not null,
Ubicacion_Empresa VARCHAR(75),
Telefono char(9),
Correo_Empresa VARCHAR(60),
Telefono2 char(9)
);

create table Personal(
Id_Personal serial not null primary key,
Nombre varchar(50) not null,
Apellido varchar(50) not null,
Telefono char(9) not null,
DUI char(10) not null,
Profesion int not null references Profesion(Id_Profesion),
Cargo int not null references Cargo_Laboral(Id_Cargo),
Estado boolean not null default true,
Area int not null references Area_Laboral(Id_AreaLaboral),
Sueldo numeric(8,2) not null,
Empresa int not null references Empresa(Id_Empresa)
);

create table Cliente(
Id_Cliente serial not null primary key,
Empresa int not null references Empresa(Id_Empresa),
Nombre varchar(40) not null,
Apellido varchar(40) not null,
Telefono char(9) not null,
DUI char(10) not null,
Correo_Electronico varchar(50) not null
);

CREATE TABLE Tipo_Proyecto(
Id_tipoProyecto serial not null primary key,
Tipo_Proyecto varchar(30) not null
);

create table Proyecto(
Id_Proyecto serial not null primary key,
Estado boolean not null default false,
Cliente int not null REFERENCES Cliente(Id_cliente),
Supervisor int not null REFERENCES Usuario(Id_Usuario),
Tipo_Proyecto int not null REFERENCES Tipo_Proyecto(Id_tipoProyecto),
Nombre_Proyecto varchar(40) null,
Ubicacion varchar(100) null,
Descripcion_Proyecto varchar(150) null,
FechaInicio date null,
FechaFin date null
);

create table Fotografias(
Id_Fotografia serial not null primary key,
Proyecto int not null references Proyecto(Id_Proyecto),
Fotografia bytea
);

create table Asignaciones_Proyecto(
Id_Asignaciones serial not null primary key,
Proyecto int not null REFERENCES Proyecto(Id_Proyecto),
Asignacion varchar(70),
Estado_Asignacion boolean not null default false,
Encargado int not null references Personal(Id_Personal),
Fecha_Incio date,
Fecha_Fin date,
SueldoTotal numeric(8,2)
);

create table Unidad_Medida(
Id_UnidadMedida serial not null primary key,
Unidad_Medida varchar(20)
);

CREATE TABLE Materiales(
Id_Material serial not null primary key,
Estado boolean not null default false,
Unidad int not null REFERENCES Unidad_Medida(Id_UnidadMedida),
Nombre_Material varchar(30),
Cantidad_Disponible smallint default 0,
Descripcion varchar(40),
Foto_Material bytea
);

CREATE TABLE Compras_Materiales(
Id_Compra serial not null primary key,
Material int not null references Materiales(Id_Material),
Encargado int not null references Usuario(Id_Usuario),
Cantidad_Comprada smallint,
Precio_Unitario numeric(7,2),
Monto_Total numeric(7,2),
Fecha_Compra timestamp default current_timestamp
);

CREATE TABLE Presupuesto_Proyecto(
Id_Presupuesto serial not null primary key,
Proyecto int not null REFERENCES Proyecto(Id_Proyecto) UNIQUE,
Gastos_Preliminares numeric(10,2) null,
Instalaciones numeric(10,2) null,
Mano_Obra numeric(10,2) null, 
Precio_Materiales numeric(10,2) null,
SubTotal numeric(10,2) null,
Impuestos numeric(10,2) null,
Monto_Total numeric(12,2) null,
Fecha_Modificacion timestamp default current_timestamp
);

CREATE TABLE Gastos_Inicial(
Id_GastoInicial serial not null primary key,
Gasto_Inicial varchar(40) not null,
Precio_Unitario numeric(8,2),
Descripcion varchar(60),
Foto bytea null
);

CREATE TABLE Gastos_Preliminares(
Id_GastoPreliminar serial not null primary key,
Presupuesto int not null references Presupuesto_Proyecto(Id_Presupuesto),
Gasto int not null references Gastos_Inicial(Id_GastoInicial),
Cantidad numeric(6) not null,
Precio_Total numeric(9,2) not null,
Fecha_Modificacion timestamp default current_timestamp
);

CREATE TABLE Gastos_Instalaciones(
Id_GastoInstalaciones serial not null primary key,
Presupuesto int not null references Presupuesto_Proyecto(Id_Presupuesto),
Instalacion varchar(50),
Cantidad numeric(3),
Descripcion varchar(150),
Precio_Total numeric(9,2),
Precio_Unitario numeric(8,2),
Fecha_Modificacion timestamp not null default current_timestamp
);

CREATE TABLE Gastos_Materiales(
Id_GastoMateriales serial not null primary key,
Presupuesto int not null references Presupuesto_Proyecto(Id_Presupuesto),
Material int not null references Materiales(Id_Material),
Cantidad smallint,
Precio_Total numeric(9,2),
Fecha_Modificacion timestamp default current_timestamp
);