DELIMITER //

CREATE PROCEDURE actualizar_precio_producto(
    IN p_productoId INT,
    IN p_nuevoPrecio DECIMAL(10, 2)
)
BEGIN
    DECLARE v_precio_actual DECIMAL(10,2);
    
    -- Manejo de errores y control transaccional
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al actualizar el precio del producto.';
    END;

    START TRANSACTION;
    
    -- Obtener el precio actual del producto
    SELECT precio INTO v_precio_actual 
    FROM Productos 
    WHERE id = p_productoId;
    
    -- Comprobar si el nuevo precio es más de un 50% inferior
    IF p_nuevoPrecio < v_precio_actual * 0.5 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite rebajar el precio más del 50%.';
    END IF;

    -- Actualizar el precio del producto
    UPDATE Productos 
    SET precio = p_nuevoPrecio 
    WHERE id = p_productoId;
    
    -- Actualizar precios en las líneas de pedido de pedidos NO enviados
    UPDATE LineasPedido lp
    JOIN Pedidos p ON lp.pedidoId = p.id
    SET lp.precio = p_nuevoPrecio
    WHERE lp.productoId = p_productoId 
      AND p.fechaEnvio IS NULL;

    COMMIT;
END //

DELIMITER ;
