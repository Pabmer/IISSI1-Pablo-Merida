DELIMITER //

CREATE TRIGGER t_limitar_importe_pedidos_de_menores
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE edadCliente INT;
    DECLARE totalPedido DECIMAL(10, 2);

    -- Obtener la edad del cliente del pedido
    SELECT TIMESTAMPDIFF(YEAR, u.fechaNacimiento, CURDATE()) INTO edadCliente
    FROM Pedidos p
    JOIN Clientes c ON p.clienteId = c.id
    JOIN Usuarios u ON c.usuarioId = u.id
    WHERE p.id = NEW.pedidoId;

    IF edadCliente < 18 THEN
        -- Calcular el total acumulado del pedido (antes de insertar la nueva línea)
        SELECT IFNULL(SUM(lp.precio * lp.unidades), 0) INTO totalPedido
        FROM LineasPedido lp
        WHERE lp.pedidoId = NEW.pedidoId;

        SET totalPedido = totalPedido + (NEW.precio * NEW.unidades);

        IF totalPedido > 500 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El pedido realizado por un menor de edad supera los 500€';
        END IF;
    END IF;
END //

DELIMITER ;
