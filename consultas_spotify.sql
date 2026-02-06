-- Active: 1763398454688@@127.0.0.1@3306@spotify
-- Consulta 1 --
-- Mostrar el título de cada canción junto con el nombre del artista que la ha creado y las reproducciones totales. 
-- Se ordena por el número de reproducciones de forma descendente.

SELECT c.titulo AS cancion, a.nombre AS artista, c.reproducciones AS reproducciones_totales
FROM canciones c
JOIN artistas a ON c.id_artista = a.id_artista
ORDER BY c.reproducciones DESC;

-- Consulta 2 --
-- Obtener el número total de canciones que tiene cada artista en la plataforma, 
-- incluyendo aquellos que no tengan ninguna canción.

SELECT a.nombre AS artista, COUNT(c.id_cancion) AS total_canciones
FROM artistas a
LEFT JOIN canciones c ON a.id_artista = c.id_artista
GROUP BY a.nombre;

-- Consulta 3 --
-- Calcular el número total de reproducciones agrupadas por género musical. --

SELECT genero, SUM(reproducciones) AS reproducciones_totales
FROM canciones
GROUP BY genero;

-- Consulta 4 --
-- Mostrar la duración media de las canciones de cada artista. --



-- Consulta 5 --
-- Listar todas las playlists indicando su nombre, el nombre del usuario que la creó y si es privada o no. --



-- Consulta 6 --
-- Obtener la canción o canciones cuya duración sea la máxima registrada en la plataforma. --



-- Consulta 7 --
-- Mostrar los artistas que tengan más de tres canciones publicadas, indicando el número total de canciones. --



-- Consulta 8 --
-- Listar las canciones que forman parte de alguna playlist, mostrando el nombre de la playlist
-- y el título de la canción, ordenadas por el orden de reproducción.



-- Consulta 9 --
-- Mostrar los nombres de los usuarios que han creado al menos una playlist. --



-- Consulta 10 --
-- Obtener el artista cuya suma total de reproducciones de todas sus canciones sea la más alta de la plataforma. --



