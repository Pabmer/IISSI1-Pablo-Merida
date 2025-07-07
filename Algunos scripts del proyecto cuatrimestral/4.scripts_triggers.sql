DROP TRIGGER IF EXISTS tUnicoNombreMultimediaI;
DROP TRIGGER IF EXISTS tUnicoNombreMultimediaU;
DROP TRIGGER IF EXISTS tFechaLanzamientoMultimediaI;
DROP TRIGGER IF EXISTS tFechaLanzamientoMultimediaU;
DROP TRIGGER IF EXISTS tUsuarioEdadMinimaI;
DROP TRIGGER IF EXISTS tUsuarioEdadMinimaU;
DROP TRIGGER IF EXISTS tComentarioPuntuacionUsuarioI;
DROP TRIGGER IF EXISTS tComentarioPuntuacionUsuarioU;
DROP TRIGGER IF EXISTS tCorreoYContraseñaI;
DROP TRIGGER IF EXISTS tCorreoYContraseñaU;
DELIMITER //

-- Restriccion si ya existe una multimedia con el mismo nombre y sinopsis
CREATE TRIGGER tUnicoNombreMultimediaI
BEFORE INSERT ON Multimedias
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM multimedias m 
           WHERE m.nombre = new.nombre AND m.sinopsis = new.sinopsis 
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ya existe una multimedia con el mismo nombre y sinopsis';
    END IF;
END//

CREATE TRIGGER tUnicoNombreMultimediaU
BEFORE UPDATE ON Multimedias
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM multimedias m 
           WHERE m.nombre = new.nombre AND m.sinopsis = new.sinopsis 
    ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ya existe una multimedia con el mismo nombre y sinopsis';
    END IF;
END//

-- Restricción fecha de estreno sea anterior a la fecha actual
CREATE TRIGGER tFechaLanzamientoMultimediaI
BEFORE INSERT ON Estrenos
FOR EACH ROW
BEGIN   
    IF NEW.fechaLanzamiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de lanzamiento no puede ser mayor a la fecha actual';
    END IF;
END//

CREATE TRIGGER tFechaLanzamientoMultimediaU
BEFORE UPDATE ON Estrenos
FOR EACH ROW
BEGIN   
    IF NEW.fechaLanzamiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de lanzamiento no puede ser mayor a la fecha actual';
    END IF;
END//

-- Restricción de edad mínima 12 años en usuarios
CREATE TRIGGER tUsuarioEdadMinimaI
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fechaNacimiento, CURDATE()) < 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario debe tener más de 12 años.';
    END IF;
END //

CREATE TRIGGER tUsuarioEdadMinimaU
BEFORE UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fechaNacimiento, CURDATE()) < 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario debe tener más de 12 años.';
    END IF;
END //

-- El usuario no puede poner un comentario o puntuación sin haber empezado o terminado el contenido
CREATE TRIGGER tComentarioPuntuacionUsuarioI
BEFORE INSERT ON Visualizaciones
FOR EACH ROW
BEGIN
    IF (NEW.comentario IS NOT NULL OR NEW.puntuacion IS NOT NULL) 
       AND NOT (NEW.estadoId IN (2,3)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no puede poner un comentario o puntuación sin haber empezado o terminado el contenido';
    END IF;
END //

CREATE TRIGGER tComentarioPuntuacionUsuarioU
BEFORE UPDATE ON Visualizaciones
FOR EACH ROW
BEGIN
    IF (NEW.comentario IS NOT NULL OR NEW.puntuacion IS NOT NULL) 
       AND NOT (NEW.estadoId IN (2,3)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no puede poner un comentario o puntuación sin haber empezado o terminado el contenido';
    END IF;
END //

-- Comprueba que el correo electrónico y la contraseña sean sean validos
CREATE TRIGGER tCorreoYContraseñaI
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN
    IF NEW.correoElectronico NOT LIKE ('%@%') OR CHAR_LENGTH(NEW.contraseña) < 10
    THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo debe contener el carácter "@" y la contraseña debe tener al menos 10 caracteres ';
    END IF;
END//

CREATE TRIGGER tCorreoYContraseñaU
BEFORE UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    IF NEW.correoElectronico NOT LIKE ('%@%') OR CHAR_LENGTH(NEW.contraseña) < 10
    THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo debe contener el carácter "@" y la contraseña debe tener al menos 10 caracteres ';
     END IF;
END//
DELIMITER ;
