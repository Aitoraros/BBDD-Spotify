-- Active: 1763398402893@@127.0.0.1@3306@spotify
DROP DATABASE IF EXISTS spotify;
CREATE DATABASE spotify;
USE spotify;

-- CREACIÓN DE TABLAS
-- Tabla artista. Almacena el ID autonumérico, nombre, genero principal, nacionalidad y biografía
CREATE TABLE artistas (
    id_artista INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(50) NOT NULL, 
    genero_principal VARCHAR(50) NOT NULL, 
    nacionalidad VARCHAR(50), 
    biografia TEXT
);

-- Tabla cancion. Almacena el ID autonumérico, titulo, duracion, reproducciones y el género.
-- Además, al tratarse de una relación 1:N, la canción almacena el ID del artista autor.
-- En este modelo la cancion solo puede ser creada por un artista principal
CREATE TABLE canciones (
    id_cancion INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    duracion INT NOT NULL,
    reproducciones INT DEFAULT 0,
    genero VARCHAR(50),
    id_artista INT NOT NULL -- Referencia al id del autor
);

-- Tabla usuario. Se almacena el ID autonumérico, nombre, email, tipo de suscripción y la fecha de creación de la cuenta.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    tipo_sub ENUM('Gratis', 'Premium') DEFAULT 'Gratis',
    fecha_registro DATETIME NOT NULL
);

-- Tabla playlist. Se almacena el ID autonumérico, nombre, fecha de creación, si es privada y el número de canciones.
-- Además, como una playlist solo puede ser creada por un usuario (no se contemplan playlists colaborativas) 
-- y un usuario puede crear muchas, se almacena aquí el ID del usuario.
CREATE TABLE playlists (
    id_playlist INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_creacion DATE NOT NULL,
    es_privada BOOLEAN DEFAULT 0,
    num_canciones INT DEFAULT 0,
    id_usuario INT NOT NULL -- Relación 1:N, se almacena el ID del usuario creador
);

-- Tabla album. Almacena el ID autonumerio, titulo, fecha de lanzamiento, genero musical y el num de canciones.
-- Además, debido a que un albúm solo puede ser de un artista, pero este puede tener múltiples albumes, 
-- el ID del artista creador se propaga a esta tabla
CREATE TABLE albumes (
    id_album INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    fecha_lanzamiento DATE NOT NULL,
    genero VARCHAR(50),
    num_canciones INT NOT NULL,
    id_artista INT NOT NULL -- Relación 1:N, se almacena el ID del artista creador
);


-- TABLA PARA MANEJA LA RELACIÓN N:M DE PLAYLIST - CANCIONES
-- Requerimos de una tabla para manejar las relaciones N:M
-- Esta contiene las 2 claves primarias, la fecha de introduccion de una cancion en la playlist,
-- el orden de reproduccion y las veces que se ha escuchado la canción en la playlist.
CREATE TABLE agrega (
    id_playlist INT NOT NULL,
    id_cancion INT NOT NULL,
    fecha_agregacion DATETIME NOT NULL,
    orden_reproduccion INT, 
    veces_escuchada_en_playlist INT DEFAULT 0,
    PRIMARY KEY (id_playlist, id_cancion)
);

-- Inserciones de datos para las consultas
INSERT INTO artistas (nombre, genero_principal, nacionalidad, biografia) VALUES
('Luna Nova', 'Pop', 'España', 'Artista pop emergente con influencias electrónicas.'),
('Río Salvaje', 'Rock', 'Argentina', 'Banda de rock alternativo formada en 2015.'),
('Neon Pulse', 'Electrónica', 'Alemania', 'Productor de música electrónica y techno.'),
('Kaito', 'Hip Hop', 'Japón', 'Rapero urbano con letras introspectivas.'),
('Sol Andino', 'Folk', 'Perú', 'Proyecto musical inspirado en sonidos andinos.');
INSERT INTO albumes (titulo, fecha_lanzamiento, genero, num_canciones, id_artista) VALUES
('Ciclos', '2021-05-10', 'Pop', 10, 1),
('Horizonte', '2023-02-18', 'Pop', 8, 1),
('Fuego Interior', '2020-09-12', 'Rock', 12, 2),
('Rutas', '2022-06-01', 'Rock', 9, 2),
('Neon Dreams', '2019-11-22', 'Electrónica', 11, 3),
('Night Drive', '2024-01-15', 'Electrónica', 10, 3),
('Reflejos', '2021-03-30', 'Hip Hop', 8, 4),
('Tokyo Streets', '2023-08-20', 'Hip Hop', 10, 4),
('Raíces', '2018-07-07', 'Folk', 9, 5),
('Montaña Viva', '2022-04-14', 'Folk', 7, 5),
('Silent Waves', '2020-10-01', 'Indie', 11, 6),
('Last Light', '2023-12-05', 'Indie', 9, 6),
('Solar Nights', '2019-06-18', 'House', 10, 7);
INSERT INTO canciones (titulo, duracion, reproducciones, genero, id_artista) VALUES
('Latidos', 210, 1500000, 'Pop', 1),
('Eclipse', 195, 900000, 'Pop', 1),
('Caer', 230, 400000, 'Rock', 2),
('Cenizas', 250, 300000, 'Rock', 2),
('Pulse', 320, 1200000, 'Electrónica', 3),
('Neon Sky', 305, 800000, 'Electrónica', 3),
('Mirror Mind', 200, 500000, 'Hip Hop', 4),
('Concrete', 215, 650000, 'Hip Hop', 4),
('Senderos', 240, 200000, 'Folk', 5),
('Viento Sur', 260, 180000, 'Folk', 5),
('Fade Away', 225, 700000, 'Indie', 6),
('Night Bloom', 245, 620000, 'Indie', 6),
('Sunrise Beat', 330, 950000, 'House', 7),
('Deep Flow', 340, 870000, 'House', 7),
('Mar Calmo', 210, 1100000, 'Latino', 8),
('Arena', 220, 980000, 'Latino', 8),
('Street Life', 205, 1300000, 'Trap', 9),
('Fast Lane', 215, 1400000, 'Trap', 9),
('Frozen Air', 400, 300000, 'Ambient', 10),
('Soft Glow', 420, 280000, 'Ambient', 10);
INSERT INTO usuarios (nombre, email, tipo_sub, fecha_registro) VALUES
('ana23', 'ana@gmail.com', 'Premium', '2023-01-10 12:30:00'),
('carlos_music', 'carlos@gmail.com', 'Gratis', '2022-06-18 09:15:00'),
('laura_sound', 'laura@gmail.com', 'Premium', '2024-02-01 18:45:00'),
('david90', 'david@gmail.com', 'Gratis', '2021-11-22 10:00:00'),
('maria_vibes', 'maria@gmail.com', 'Premium', '2023-07-07 21:20:00'),
('alex', 'alex@gmail.com', 'Gratis', '2020-03-14 08:00:00');
INSERT INTO playlists (nombre, fecha_creacion, es_privada, num_canciones, id_usuario) VALUES
('Pop Diario', '2024-01-01', 0, 5, 1),
('Rock Clásico', '2023-06-10', 0, 4, 2),
('Electro Nights', '2024-02-20', 1, 6, 3),
('Chill Vibes', '2022-08-15', 0, 5, 4),
('Latino Hits', '2023-07-07', 0, 6, 5),
('Trap Mode', '2024-03-03', 1, 4, 6),
('Indie Mood', '2022-11-11', 0, 5, 7);
INSERT INTO agrega (id_playlist, id_cancion, fecha_agregacion, orden_reproduccion, veces_escuchada_en_playlist) VALUES
(1, 1, '2024-01-01 10:00:00', 1, 120),
(1, 21, '2024-01-01 10:05:00', 2, 95),
(2, 3, '2023-06-10 12:00:00', 1, 80),
(2, 27, '2023-06-10 12:04:00', 2, 60),
(3, 5, '2024-02-20 22:00:00', 1, 150),
(4, 12, '2022-08-15 09:30:00', 1, 70);