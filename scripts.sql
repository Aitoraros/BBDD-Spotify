-- Active: 1763398402893@@127.0.0.1@3306@spotify
DELIMITER $$

-- Trigger 1. Cálculo del año de registro en base de la fecha de registro.
CREATE OR REPLACE TRIGGER calculo_año_registro BEFORE INSERT ON usuarios
FOR EACH ROW 
BEGIN
    -- Si hay fecha de registro
    IF NEW.fecha_registro IS NOT NULL THEN
        SET NEW.año_registro = YEAR(NEW.fecha_registro);
    -- Si no hay fecha de registro
    ELSE
        SET NEW.fecha_registro = NOW();
        SET NEW.año_registro = YEAR(NOW());
    END IF;
END $$
INSERT INTO usuarios (nombre, email, tipo_sub, fecha_registro) VALUES
('ana22', 'ana2@gmail.com', 'Premium', '2023-01-10 12:30:00') $$
SELECT * FROM usuarios $$

-- Trigger 2. Validación de título y duración de una canción.
CREATE TRIGGER tr_validar_cancion BEFORE INSERT ON canciones
FOR EACH ROW
BEGIN
    -- Cancelación de operación si la duración es negativa
    IF NEW.duracion <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La duración de la canción debe ser mayor a 0 segundos.';
    END IF;
    -- Cancelación si el título es demasiado corto
    IF LENGTH(NEW.titulo) < 2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El título de la canción es demasiado corto.';
    END IF;
END $$
INSERT INTO canciones (titulo, duracion, reproducciones, genero, id_artista) VALUES
('abc', 0, 1500000, 'Pop', 1) $$

-- Function 1

/*
 * Crea una función que reciba el email de un usuario y devuelve el número total
 * de playlists que ha creado en la plataforma. 
 * Si el usuario no existe, la función debe cancelar la operación.
 */
CREATE FUNCTION contar_playlists(email_usuario VARCHAR(100))
RETURNS INT
BEGIN
    DECLARE total INT;
    DECLARE v_id_usuario INT;

    -- Obtiene id del usuario
    SELECT id_usuario INTO v_id_usuario
    FROM usuarios
    WHERE email = email_usuario;

    -- Cancela si no existe
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;

    -- Contador de playlists
    SELECT COUNT(*) INTO total
    FROM playlists
    WHERE id_usuario = v_id_usuario;

    RETURN total;
END $$

SELECT contar_playlists('david@gmail.com')$$

-- Function 2

/*
 * Crea una función que reciba el email de un usuario y devuelve el número total
 * de canciones de sus playlists que tengan más de 3 canciones 
 * Si el usuario no existe, la función debe cancelar la operación.
 */
CREATE FUNCTION canciones_playlists(email_usuario VARCHAR(100))
RETURNS INT
BEGIN
    DECLARE total INT;
    DECLARE v_id_usuario INT;

    -- Obtiene el id del usuario
    SELECT id_usuario INTO v_id_usuario
    FROM usuarios
    WHERE email = email_usuario;

    -- Cancela si el usuario no existe
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no encontrado';
    END IF;

    -- Contador de canciones (con condición)
    SELECT SUM(num_canciones) INTO total
    FROM playlists
    WHERE id_usuario = v_id_usuario
    AND num_canciones > 3;

    RETURN IFNULL(total, 0);
END $$

SELECT canciones_playlists('david@gmail.com')$$

-- Procedure 1. Calcula las stats de los artistas de un género
CREATE OR REPLACE PROCEDURE reporte_popularidad_genero(IN p_genero VARCHAR(50))
BEGIN
    -- variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_nombre_artista VARCHAR(50);
    DECLARE v_id_artista INT;
    DECLARE v_total_reps INT;
    
    -- declaracion del cursor, se seleccionan los artistas del genero pasado
    DECLARE cur_artistas CURSOR FOR 
        SELECT id_artista, nombre FROM artistas WHERE genero_principal = p_genero;
    
    -- declare handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_artistas;

    read_loop: LOOP
        FETCH cur_artistas INTO v_id_artista, v_nombre_artista;
        
        -- si el cursor no tiene más filas salimo del bucle
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- sumas de las repros de las canciones
        SELECT IFNULL(SUM(reproducciones), 0) 
        INTO v_total_reps
        FROM canciones 
        WHERE id_artista = v_id_artista;

        SELECT v_nombre_artista AS artista, v_total_reps AS total_reproducciones;
        
    END LOOP;

    CLOSE cur_artistas;
END $$

-- Ejemplo de ejecución. Se le pasa rock de género
CALL reporte_popularidad_genero('Rock')$$

-- Procedure 2
/*
 * Crea un procedimiento que registre un álbum para un artista existente y,
 * mediante un bucle, inserte automáticamente el número de canciones
 * indicado en los parámetros, asignándoles un título genérico y
 * una duración predeterminada.
 */
CREATE PROCEDURE registrar_album_con_canciones(
    IN p_id_artista INT,
    IN p_titulo_alb VARCHAR(150),
    IN p_genero VARCHAR(50),
    IN p_num_canciones INT
)
BEGIN
    -- Declaración de variables
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_id_album INT;

    -- Se inserta el álbum
    INSERT INTO albumes (titulo, fecha_lanzamiento, genero, num_canciones, id_artista)
    VALUES (p_titulo_alb, CURDATE(), p_genero, p_num_canciones, p_id_artista);
    
    -- Se obtiene el ID del álbum recién creado
    -- Se busca el ID más alto de la tabla álbumes para este artista
    SELECT MAX(id_album) INTO v_id_album 
    FROM albumes 
    WHERE id_artista = p_id_artista;

    -- Bucle WHILE para insertar las canciones
    WHILE v_contador <= p_num_canciones DO
        INSERT INTO canciones (titulo, duracion, genero, id_artista)
        VALUES (
            CONCAT('Canción ', v_contador, ' de ', p_titulo_alb), 
            180, 
            p_genero, 
            p_id_artista
        );
        
        -- Incremento de la variable contador
        SET v_contador = v_contador + 1;
    END WHILE;

    SELECT CONCAT('Álbum ID ', v_id_album, ' y sus canciones han sido registrados.') AS Resultado;
END $$

-- Ejemplo de llamada al procedimiento
CALL registrar_album_con_canciones(1, 'Discovery', 'Electrónica', 14);


DELIMITER ;
