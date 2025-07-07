-- 2.1
SELECT 
    p.nombre AS nombre_producto, 
    tp.nombre AS nombre_tipo_producto,
    lp.precio AS precio_unitario
FROM Productos p
JOIN TiposProducto tp ON p.tipoProductoId = tp.id
JOIN LineasPedido lp ON lp.productoId = p.id
WHERE tp.nombre = 'Digitales';

-- 2.2
SELECT 
    u.nombre AS nombre_empleado,
    COUNT(p.id) AS numero_pedidos_mas_500,
    SUM(p.importe) AS importe_total_gestionado
FROM Empleados e
JOIN Usuarios u ON u.id = e.usuarioId
LEFT JOIN (
    SELECT 
        p1.id,
        p1.empleadoId,
        SUM(lp.precio * lp.unidades) AS importe
    FROM Pedidos p1
    JOIN LineasPedido lp ON lp.pedidoId = p1.id
    WHERE YEAR(p.fechaRealizacion) = YEAR(CURDATE())
    GROUP BY p1.id
    HAVING importe > 500
) p ON p.empleadoId = e.id
GROUP BY u.nombre
ORDER BY importe_total_gestionado DESC;
