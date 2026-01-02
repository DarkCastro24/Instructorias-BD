SELECT p.id,p.id_tablero,fecha_inicio,fecha_fin,(select dbo.obtenerJugador1(p.id)) 'Jugador 1',(select dbo.obtenerJugador2(p.id)) 'Jugador 2'
FROM Partida p
INNER JOIN Detalle_partida d ON d.id_partida = p.id
WHERE d.cantidad_desbanque IS NOT NULL
GROUP BY p.id,p.id_tablero,fecha_inicio,fecha_fin
ORDER BY fecha_inicio DESC

SELECT * FROM Partida INNER JOIN Detalle_partida d ON d.id_partida = Partida.id

CREATE OR ALTER FUNCTION obtenerJugador1(@id_partida int)
RETURNS VARCHAR(32)
AS 
BEGIN
	RETURN (SELECT TOP 1 j.nickname FROM Detalle_partida d INNER JOIN Jugador j ON j.id = d.id_jugador WHERE d.id_partida = @id_partida ORDER BY d.id ASC);
END

CREATE OR ALTER FUNCTION obtenerJugador2(@id_partida int)
RETURNS VARCHAR(32)
AS 
BEGIN
	RETURN (SELECT TOP 1 j.nickname FROM Detalle_partida d INNER JOIN Jugador j ON j.id = d.id_jugador WHERE d.id_partida = @id_partida ORDER BY d.id DESC);
END

select dbo.obtenerJugador1(59) 'Jugador 1'
select dbo.obtenerJugador2(59) 'Jugador 2'