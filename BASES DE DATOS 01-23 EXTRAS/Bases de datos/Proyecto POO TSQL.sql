-- TRANSACT SQL FUNCTIONES Y PROCEDIMIENTOS ALMACENADOS

-- LAS FUNCIONES CUMPLEN EL OBJETIVO DE OBTENER UN DATO ESPECIFICO MEDIANTE UN PARAMETRO

/*create function obtenerContrincante(@idPartida int,@idJugador int)
 returns varchar(64)
 as 
 begin
 return (select j.nickname as contricante 
 from Detalle_partida d 
 inner join Jugador j on j.id  = d.id_jugador
 where id_partida = @idPartida and id_jugador != @idJugador);
 end*/

 --select dbo.obtenerContrincante(2,1) as contrincante;

 /*create function obtenerIdJugador(@nickname varchar(32))
 returns int 
 as 
 begin
 return (select id from Jugador where nickname = @nickname);
 end
 */

 --select dbo.obtenerIdJugador('Castroll') as id_jugador;

-- LAS CONSULTAS LAS INCLUYO SIN VIEW YA QUE NO ADMITE LA FUNCION ORDER BY 

-- a) Listado de jugadores registrados en la base de datos
select nombre,nickname,partidas_jugadas 'partidas jugadas',partidas_ganadas 'partidas ganadas', (partidas_jugadas - partidas_ganadas) 'partidas perdidas'
from Jugador
order by partidas_jugadas

-- 1.1 b) Listado de juegos individuales por cada jugador
select p.fecha_inicio,j.nombre,j.nickname,f.nombre_ficha, t.nombre_tablero, d.cantidad_tiros,d.cantidad_escalera,d.cantidad_serpiente
from Detalle_partida d
inner join Ficha f ON f.id = d.id_ficha
inner join Jugador j ON j.id = d.id_jugador
inner join Resultado_partida r ON r.id = d.id_resultado_partida
inner join Partida p ON p.id = d.id_partida
inner join Tablero t ON t.id = p.id_tablero
where nickname = 'Castroll' and (d.cantidad_desbanque is null);

-- 1.2 b) Listado de competencias por cada jugador mostrando el resultado y contrincante
select p.fecha_inicio,j.nombre,j.nickname,f.nombre_ficha, t.nombre_tablero, d.cantidad_tiros,
d.cantidad_escalera,d.cantidad_serpiente,  r.resultado_partida, (select dbo.obtenerContrincante(p.id,j.id)) as contrincante
from Detalle_partida d
inner join Ficha f ON f.id = d.id_ficha
inner join Jugador j ON j.id = d.id_jugador
inner join Resultado_partida r ON r.id = d.id_resultado_partida
inner join Partida p ON p.id = d.id_partida
inner join Tablero t ON t.id = p.id_tablero
where nickname = 'Castroll' and (d.cantidad_desbanque is not null);

-- c) Listado de tableros que se encuentran almacenados. Mostrando las imagenes de los tableros (Lo abriremos con su ruta)
select id, nombre_tablero, ruta_tablero 
from Tablero
order by id asc

-- Listado de fichas para mostrarlas antes de iniciar la partida. Mostrando las imagenes de los tableros (Lo abriremos con su ruta)
select id,nombre_ficha,ruta_ficha 
from Ficha 
order by id asc

-- d) Listado de los tres mejores jugadores en competencia (Mostraremos los 3 jugadores con mas victorias)
select TOP 3 j.nickname ,COUNT(r.resultado_partida) as victorias 
from Detalle_partida d
inner join Jugador j on j.id = d.id_jugador
inner join Resultado_partida r on r.id = d.id_resultado_partida
where r.resultado_partida = 'Victoria' 
group by j.nickname,d.cantidad_desbanque
having d.cantidad_desbanque IS NOT NULL
order by victorias desc

-- LOS PROCEDIMIENTOS ALMACENADOS SERVIRAN PARA OPTIMIZAR EL FLUJO DE DATOS DEL JUEGO (SE DIVIDE EN DOS SECCIONES) 

-- 1- INICIO DE PARTIDA

-- Procedimiento almacenado para iniciar partida competencia (Los parametros son datos previamente ingresados u obtenidos en el programa) 
CREATE PROCEDURE iniciarPartidaCompetencia
    @id_tablero int,
	@id_ficha1 int,
	@id_jugador1 int,
	@id_ficha2 int,
	@id_jugador2 int
AS   
	insert into Partida (id_tablero,fecha_inicio,fecha_fin) values(@id_tablero,default,null);
	declare @id_partida int  = (select max(id) from Partida);

	insert into Detalle_partida (id_ficha,id_partida,id_jugador,id_resultado_partida,cantidad_tiros,cantidad_escalera,cantidad_serpiente,cantidad_desbanque)
	values (@id_ficha1,@id_partida,@id_jugador1,null,default,default,default,default),(@id_ficha2,@id_partida,@id_jugador2,null,default,default,default,default);
GO

-- Procedimiento almacenado para iniciar partida individual (el valor nulo en cantidad_desbanque sirve para identificar que es una partida individual)
CREATE PROCEDURE iniciarPartidaIndividual
    @id_tablero int,
	@id_ficha int,
	@id_jugador int
AS   
	insert into Partida (id_tablero,fecha_inicio,fecha_fin) values(@id_tablero,default,null);
	declare @id_partida int  = (select max(id) from Partida);

	insert into Detalle_partida (id_ficha,id_partida,id_jugador,id_resultado_partida,cantidad_tiros,cantidad_escalera,cantidad_serpiente,cantidad_desbanque)
	values (@id_ficha,@id_partida,@id_jugador,null,default,default,default,null);
GO

-- 2- FIN DE PARTIDA

-- Procedimiento almacenado para finalizar la partida competencia (Los parametros son datos previamente ingresados u obtenidos en el programa) 
CREATE PROCEDURE finalizarPartidaCompetencia
    @id_resultado int,
	@id_jugador int,
	@cantidad_tiros int,
	@cantidad_escalera int,
	@cantidad_serpiente int,
	@cantidad_desbanque int
AS  
	-- Obtenemos la ultima partida ingresada en la tabla
	declare @id_partida int = (select max(id) from Partida);
    declare @fechaFin date = (select fecha_fin from Partida where id = @id_partida);

	-- Actualizando los resultados del jugador 1 
	update Detalle_partida set id_resultado_partida = @id_resultado , cantidad_tiros = @cantidad_tiros, cantidad_escalera = @cantidad_escalera, cantidad_serpiente = @cantidad_serpiente,
	cantidad_desbanque = @cantidad_desbanque where id_partida = @id_partida and id_jugador = @id_jugador; 
	
	-- Lo coloco en un IF para que solo se actualice una vez porque el procedimiento se mandara a llamar dos veces una para cada jugador
	IF @fechaFin is null  
	-- Actualizamos la fecha de fin de la partida
	update Partida set fecha_fin = default where id = @id_partida;
GO

-- Procedimiento almacenado para finalizar la partida individual (el valor nulo en cantidad_desbanque sirve para identificar que es una partida individual)
CREATE PROCEDURE finalizarPartidaIndividual
    @id_resultado int,
	@id_jugador int,
	@cantidad_tiros int,
	@cantidad_escalera int,
	@cantidad_serpiente int
AS  
	-- Obtenemos la ultima partida ingresada en la tabla
	declare @id_partida int = (select max(id) from Partida);
    -- Actualizamos la fecha de fin de la partida
	update Partida set fecha_fin = default where id = @id_partida;
	-- Actualizando los resultados del jugador 1 
	update Detalle_partida set id_resultado_partida = @id_resultado , cantidad_tiros = @cantidad_tiros, cantidad_escalera = @cantidad_escalera, cantidad_serpiente = @cantidad_serpiente
	where id_partida = @id_partida and id_jugador = @id_jugador; 
GO


