-- Active: 1763398402893@@127.0.0.1@3306@spotify
DELIMITER $$

-- Trigger 1. Cálculo del año de registro en base de la fecha de registro.
CREATE TRIGGER calculo_año_registro BEFORE INSERT ON usuarios
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

-- Function 1


-- Function 2


-- Procedure 1


-- Procedure 2



DELIMITER ;