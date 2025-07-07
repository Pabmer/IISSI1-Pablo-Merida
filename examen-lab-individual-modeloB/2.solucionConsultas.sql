-- 2.1
SELECT 
    ue.nombre AS nombre_empleado,
    p.fechaRealizacion,
    uc.nombre AS nombre_cliente
FROM Pedidos p
JOIN Empleados e ON p.empleadoId = e.id
JOIN Usuarios ue ON e.usuarioId = ue.id
JOIN Clientes c ON p.clienteId = c.id
JOIN Usuarios uc ON c.usuarioId = uc.id
WHERE MONTH(p.fechaRealizacion) = MONTH(CURDATE())
  AND YEAR(p.fechaRealizacion) = YEAR(CURDATE());

-- 2.2
SELECT 
    u.nombre AS nombre,
    SUM(lp.unidades) AS unidades_totales,
    SUM(lp.unidades * lp.precio) AS importe_total
FROM Usuarios u
JOIN Clientes c ON c.usuarioId = u.id
JOIN Pedidos p ON p.clienteId = c.id
JOIN LineasPedido lp ON lp.pedidoId = p.id
WHERE p.fechaRealizacion >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY u.id
HAVING COUNT(DISTINCT p.id) > 5;
