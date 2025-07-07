-- 2.1
SELECT DISTINCT
    pr.nombre AS nombre_producto,
    lp.precio AS precio_unitario,
    lp.unidades AS unidades_compradas
FROM LineasPedido lp
JOIN Productos pr ON lp.productoId = pr.id
ORDER BY lp.unidades DESC
LIMIT 5;

-- 2.2
SELECT 
    u.nombre AS nombre_empleado,
    p.fechaRealizacion AS fecha_realizacion,
    SUM(lp.unidades * lp.precio) AS precio_total,
    SUM(lp.unidades) AS unidades_compradas
FROM Pedidos p 
LEFT JOIN Empleados e ON e.id = p.empleadoId
LEFT JOIN Usuarios u ON u.id = e.usuarioId
JOIN LineasPedido lp ON lp.pedidoId = p.id
GROUP BY p.id
HAVING TIMESTAMPDIFF(DAY, p.fechaRealizacion, CURDATE()) > 7;