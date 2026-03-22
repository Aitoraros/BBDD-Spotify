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
('a', 0, 1500000, 'Pop', 1) $$

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
-- Procedure 1


-- Procedure 2



DELIMITER ;
