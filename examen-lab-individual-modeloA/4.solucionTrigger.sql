DELIMITER //

CREATE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE tipo_nuevo_producto INT;
    DECLARE num_productos_distintos INT;

    -- Obtener el tipo del producto que se está insertando
    SELECT tipoProductoId INTO tipo_nuevo_producto
    FROM Productos
    WHERE id = NEW.productoId;

    -- Contar cuántos productos en ese pedido tienen tipo distinto
    SELECT COUNT(*) INTO num_productos_distintos
    FROM LineasPedido lp
    JOIN Productos p ON lp.productoId = p.id
    WHERE lp.pedidoId = NEW.pedidoId
      AND p.tipoProductoId != tipo_nuevo_producto;

    -- Si hay alguno, lanzar error
    IF num_productos_distintos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden mezclar productos de distintos tipos en un mismo pedido.';
    END IF;
END //

DELIMITER ;
