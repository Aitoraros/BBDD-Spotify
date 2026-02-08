-- Active: 1763398402893@@127.0.0.1@3306@spotify
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
-- Calcular el número total de reproducciones agrupadas por género musical.
SELECT genero, SUM(reproducciones) AS reproducciones_totales
FROM canciones
GROUP BY genero;

-- Consulta 4 --
-- Nombre de los álbumes con su correspondiente artista de género 'Pop'
SELECT al.titulo, ar.nombre
FROM albumes al JOIN artistas ar ON al.id_artista = ar.id_artista
WHERE ar.genero_principal LIKE 'Pop';

-- Consulta 5 --
-- Nombre de los artistas que tienen más de una canción y cuántas tienen en total
SELECT ar.nombre, COUNT(c.id_cancion) AS total_canciones
FROM artistas ar JOIN canciones c ON ar.id_artista = c.id_artista
GROUP BY ar.id_artista
HAVING total_canciones > 1;

-- Consulta 6 --
-- Nombre de los artistas que tengan al menos 3 álbumes registrados
SELECT nombre FROM artistas
WHERE id_artista IN (
    SELECT id_artista FROM albumes
    GROUP BY id_artista
    HAVING COUNT(*) >= 3
);

-- Consulta 7 --
-- Nombre de los usuarios que tienen la canción 'Latidos' en alguna de sus playlists
SELECT nombre FROM usuarios
WHERE id_usuario IN (
    SELECT id_usuario FROM playlists
    WHERE id_playlist IN (
        SELECT id_playlist FROM agrega
        WHERE id_cancion IN (
            SELECT id_cancion FROM canciones
            WHERE titulo LIKE Latidos
        )
    )
);

-- Consulta 8 --
-- Mostrar el promedio de reproducciones de las canciones de cada artista.
-- Nota: Como en tu BD las canciones cuelgan del artista y no del álbum directamente, 
-- calculamos el éxito promedio por artista.
SELECT ar.nombre AS artista, ROUND(AVG(c.reproducciones), 2) AS promedio_reproducciones
FROM artistas ar
JOIN canciones c ON ar.id_artista = c.id_artista
GROUP BY ar.nombre;

-- Consulta 9 --
-- Obtener el título y las reproducciones de la canción o canciones menos escuchadas de la plataforma.
-- Se utiliza una subconsulta para encontrar el valor mínimo global.
SELECT titulo, reproducciones
FROM canciones
WHERE reproducciones = (
    SELECT MIN(reproducciones) 
    FROM canciones
);

-- Consulta 10 --
-- Mostrar el nombre del artista y el título de la canción que tiene el récord de reproducciones 
SELECT a.nombre AS artista, c.titulo AS cancion_top, c.reproducciones
FROM artistas a
JOIN canciones c ON a.id_artista = c.id_artista
WHERE c.reproducciones = (
    SELECT MAX(reproducciones) 
    FROM canciones
);