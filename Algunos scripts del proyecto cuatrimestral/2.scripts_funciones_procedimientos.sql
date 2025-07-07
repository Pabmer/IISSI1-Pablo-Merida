DROP PROCEDURE IF EXISTS pActualizarFavorito;
DROP PROCEDURE IF EXISTS pInsertarValoracion;
DROP FUNCTION IF EXISTS fMediaValoraciones;
DROP FUNCTION IF EXISTS fPlataformasDisponibles;
DROP FUNCTION IF EXISTS fMultimediasMasVistasPorPlataforma;
DROP FUNCTION if EXISTS fGeneroMasVisto;
DROP FUNCTION IF EXISTS fListarUsuarios;
DROP FUNCTION IF EXISTS fListarMultimedias;

-- Actualizar el valor de una serie a un favorito
DELIMITER //
CREATE PROCEDURE pActualizarFavorito(us_id INT, mul_id INT)
BEGIN 
    UPDATE Visualizaciones SET esFavorito = TRUE 
    WHERE (usuarioId=us_id AND multimediaId=mul_id);
END//

-- Procedimiento para agregar una valoración
CREATE PROCEDURE pInsertarValoracion (usuario_id INT, multimedia_id INT, coment TEXT, punt INT)
BEGIN
    UPDATE Visualizaciones SET puntuacion = punt, comentario = coment
    WHERE usuarioId = usuario_id AND multimediaId = multimedia_id;
END //

-- Funcion que devuelve la valoracion media de un multimedia dado el id concreto 
CREATE FUNCTION fMediaValoraciones (mul_id INT) RETURNS FLOAT
BEGIN 
    DECLARE promedio FLOAT;
    SELECT AVG(v.puntuacion) INTO promedio
    FROM Multimedias m
    JOIN Visualizaciones v ON m.id = v.multimediaId
	 WHERE m.id=mul_id;
    RETURN promedio;
END //

-- Funcion que devuelve un listado de las plataformas en las que está displonible un multimedia
CREATE FUNCTION fPlataformasDisponibles(multId INT) RETURNS TEXT
BEGIN
    DECLARE plataformas TEXT;
    
    SELECT GROUP_CONCAT(p.nombre SEPARATOR ', ') INTO plataformas
    FROM plataformas p
    JOIN estrenos e ON p.id = e.plataformaId
    WHERE e.multimediaId = multId;

    RETURN plataformas;
END //

-- Concatenar los resultados en formato "nombre (visualizaciones)"
CREATE FUNCTION fMultimediasMasVistasPorPlataforma(plat_Id INT) RETURNS TEXT
BEGIN
   DECLARE resultado TEXT;

   SELECT GROUP_CONCAT(CONCAT(m.nombre, ' (', sub.cuenta, ')') ORDER BY sub.cuenta DESC, m.nombre ASC SEPARATOR ', ')
   INTO resultado
   FROM (
       SELECT m.id AS multimediaId, m.nombre, COUNT(v.id) AS cuenta
       FROM Visualizaciones v
       JOIN Multimedias m ON v.multimediaId = m.id
       JOIN Estrenos es ON m.id = es.multimediaId
       WHERE es.plataformaId = plat_Id AND v.estadoId = 2
       GROUP BY m.id, m.nombre
   ) AS sub
   JOIN Multimedias m ON sub.multimediaId = m.id;

   RETURN resultado;
END //

	
-- Devolver el genero mas visto de un usuario
CREATE FUNCTION fGeneroMasVisto(usrId INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE genero_mas_visto VARCHAR(255);

    SELECT g.nombre INTO genero_mas_visto
    FROM Visualizaciones v
    JOIN generosmultimedias gm ON gm.multimediaId=v.multimediaId
    JOIN generos g ON gm.generoId=g.id
    WHERE v.usuarioId=usrId
    GROUP BY g.nombre
    ORDER BY COUNT(g.id) DESC
    LIMIT 1;

    RETURN genero_mas_visto;
END //

-- Listar los usuarios según uno o varios de sus atributos
CREATE FUNCTION fListarUsuarios(usr_id INT, nom VARCHAR(255), fecha DATE, pais VARCHAR(255), act BOOLEAN) 
RETURNS TEXT
BEGIN
    DECLARE lista_usuarios TEXT;

    SELECT GROUP_CONCAT(u.nombre SEPARATOR ', ') 
    INTO lista_usuarios
    FROM usuarios u 
    WHERE 
        (usr_id IS NULL OR usr_id = u.id) AND 
        (nom IS NULL OR nom = u.nombre) AND 
        (fecha IS NULL OR fecha = u.fechaNacimiento) AND 
        (pais IS NULL OR pais = u.nacionalidad) AND
        (act IS NULL OR act = u.activo);

    RETURN lista_usuarios;
END //

-- Listar las multimedias según uno o varios de sus atributos
CREATE FUNCTION fListarMultimedias(mult_id INT, nom VARCHAR(255), val FLOAT, edad INT, spinoff BOOLEAN, pais VARCHAR(255)) 
RETURNS TEXT
BEGIN
    DECLARE lista_multimedias TEXT;

    SELECT GROUP_CONCAT(m.nombre SEPARATOR ', ') 
    INTO lista_multimedias
    FROM multimedias m
    WHERE
        (mult_id IS NULL OR mult_id = m.id) AND 
        (nom IS NULL OR nom = m.nombre) AND 
        (val IS NULL OR val = m.valoracion) AND
        (edad IS NULL OR edad = m.edadRecomendada) AND
        (spinoff IS NULL OR spinoff = m.spinOff) AND
        (pais IS NULL OR pais = m.paisOrigen);

    RETURN lista_multimedias;
END //

DELIMITER ;

-- Pruebas para los procedimientos y funciones
# CALL pActualizarFavorito(3, 2);
# CALL pInsertarValoracion(2, 2, 'Chachi', 4);
# SELECT fMediaValoraciones(3);
# SELECT fPlataformasDisponibles(2);
# SELECT fMultimediasMasVistasPorPlataforma(1);
# SELECT fGeneroMasVisto(1);
# SELECT fListarUsuarios(NULL, NULL, NULL, 'España', TRUE) AS usuarios;
# SELECT fListarMultimedias(NULL, NULL, NULL, NULL, TRUE, 'España') AS multimedias;
