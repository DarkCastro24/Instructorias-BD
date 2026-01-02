update Casillas_tablero set posicion_final = 1

update Casillas_tablero set id_tipo_casilla = 3

update Casillas_tablero set posicion_x = '310', posicion_y = '490' where id = 3;

select * from Casillas_tablero

insert into Casillas_tablero (id_tablero,id_tipo_casilla,numero_casilla,posicion_x,posicion_y,posicion_final) 
values (1,3,4, 370, 500 , null),(1,3,5, 430, 500 , null),(1,3,6, 490, 500 , 2)
,(1,3,7, 550, 500 , null);

select * from Tipo_casilla

update Casillas_tablero set id_tipo_casilla = 2 where id = 6

SELECT* FROM Tipo_casilla

SELECT COUNT(*) FROM Casillas_tablero WHERE id_tablero = 1

SELECT * FROM Casillas_tablero

SELECT * FROM Resultado_partida

INSERT INTO  Casillas_tablero (id_tablero,id_tipo_casilla,numero_casilla,posicion_x,posicion_y,posicion_final)  values (1,3,8, 610,500,null);