-- Listar las multimedias de la tabla multimedia que cumplan que su fecha de estreno es 2016
SELECT m.nombre FROM multimedias m 
JOIN estrenos e ON m.id = e.multimediaid
WHERE YEAR(e.fechaLanzamiento) = YEAR('2016-07-15');

-- Listar las series de la tabla series que cumplan que su número de temporadas es mayor que 3
SELECT m.nombre FROM multimedias m
JOIN series s ON m.id = s.multimediaId
WHERE s.numTemporadas > 3;

-- Listar los atributos de los usarios de un país determinado
SELECT u.nombre 
FROM usuarios u 
WHERE u.nacionalidad = 'España' 
AND u.activo = TRUE;

-- Listar todos los actores que participan en una película española
SELECT DISTINCT a.nombre 
FROM Artistas a
JOIN PersonajePelicula pp ON a.id = pp.artistaId
JOIN Peliculas p ON pp.peliculaId = p.id
JOIN Multimedias m ON p.multimediaId = m.id
WHERE m.paisOrigen = 'España';

-- Películas recomendadas en base a géneros favoritos
SELECT DISTINCT m.nombre FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id
	RIGHT JOIN peliculas p ON p.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=p.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosusuarios gu ON gu.usuarioId=u.id
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id
	WHERE (e.estado='No empezado' AND u.id=1 AND gu.generoId=gm.generoId)
	ORDER BY m.valoracion
	LIMIT 0,5;
	
-- Series recomendadas en base a géneros favoritos
SELECT DISTINCT m.nombre FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id
	RIGHT JOIN series s ON s.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=s.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosusuarios gu ON gu.usuarioId=u.id
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id
	WHERE (e.estado='No empezado' AND u.id=1 AND gu.generoId=gm.generoId)
	ORDER BY m.valoracion
	LIMIT 0,5;

-- Dado un id de una pelicula mostrar sus atributos, las plataformas en las que esta disponible y los artitas que participan en ellos
SELECT m.*, p.nombre AS plataforma, a.nombre FROM multimedias m
JOIN personajepelicula pp ON m.id = pp.peliculaid
JOIN estrenos e ON m.id = e.multimediaId
JOIN plataformas p ON e.plataformaId = p.id
JOIN artistas a ON pp.artistaid = a.id
WHERE m.id=2;

-- Dado un id de una series mostrar sus atributos, las plataformas en las que esta disponible y los artitas que participan en ellos
SELECT m.*, p.nombre AS plataforma, a.nombre AS nombre_actor FROM multimedias m
JOIN series s ON s.multimediaId = m.id
JOIN temporadas t ON t.seriesId = s.id
JOIN capitulos c ON c.temporadasId = t.id
JOIN personajecapitulo pc ON c.id = pc.capituloId
JOIN estrenos e ON m.id = e.multimediaId
JOIN plataformas p ON e.plataformaId = p.id
JOIN artistas a ON pc.artistaid = a.id
WHERE m.id=4;

-- Películas recomendadas en base a los géneros de las visualizaciones previas
SELECT DISTINCT m.nombre FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id
	RIGHT JOIN peliculas p ON p.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=p.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id
	WHERE (e.estado='No empezado' AND u.id=1 AND gm.generoId IN (SELECT gm.generoId FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id 
	RIGHT JOIN peliculas p ON p.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=p.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id 
	WHERE (u.id=1 AND e.estado='Terminado')))
	ORDER BY m.valoracion
	LIMIT 0, 5;
	
-- Series recomendadas en base a los géneros de las visualizaciones previas
SELECT DISTINCT m.nombre FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id
	RIGHT JOIN series s ON s.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=s.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id
	WHERE (e.estado='No empezado' AND u.id=1 AND gm.generoId IN (SELECT gm.generoId FROM usuarios u  
	RIGHT JOIN visualizaciones v ON v.usuarioId=u.id 
	RIGHT JOIN series s ON s.multimediaId=v.multimediaId 
	RIGHT JOIN multimedias m ON m.id=s.multimediaId 
	RIGHT JOIN estados e ON e.id=v.estadoId 
	RIGHT JOIN generosmultimedias gm ON gm.multimediaId=m.id 
	WHERE (u.id=1 AND e.estado='Terminado')))
	ORDER BY m.valoracion
	LIMIT 0, 5;
