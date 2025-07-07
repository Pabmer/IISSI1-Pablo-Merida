DELIMITER //

CREATE PROCEDURE insertar_producto_y_regalos(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_tipoProductoId INT,
    IN p_esParaRegalo BOOLEAN
)
-- incluya su solución a continuación
BEGIN

  DECLARE v_clienteId INT;
  DECLARE v_direccionEnvio VARCHAR(255);
  DECLARE v_pedidoId INT;
  DECLARE v_regaloId INT;

  -- Manejo de errores
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al registrar nuevo producto';
      
  END;

  -- Iniciar transacción
  START TRANSACTION;

 -- Crear el producto
  INSERT INTO Productos (nombre, descripcion, precio, tipoProductoId)
  VALUES (p_nombre, p_descripcion, p_precio, p_tipoProductoId);

  SET v_regaloId = LAST_INSERT_ID();

 IF p_esParaRegalo THEN

    -- COmprobar que el precio del regalo no sea mayor a 50€
    IF p_precio > 50 THEN
      DELETE FROM Productos WHERE id = v_regaloId;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear un producto para regalo de más de 50€';
    END IF;

    -- Seleccionar la id de cliente ganador del regalo
    SELECT id INTO v_clienteId
    FROM Clientes
    ORDER BY fechaNacimiento ASC
    LIMIT 1;

    -- Seleccionar la direccion de envio 
    SELECT c.direccionEnvio INTO v_direccionEnvio
    FROM Clientes c 
    WHERE c.id = v_clienteId

    -- Crear el pedido por defecto
    INSERT INTO Pedidos (clienteId, direccionEntrega, fechaRealizacion)
    VALUES (v_clienteId, v_direccionEnvio, CURDATE());

    SET v_pedidoId = LAST_INSERT_ID();

    -- Insertar la línea de pedido con precio 0
    INSERT INTO LineasPedido (pedidoId, productoId, unidades, precio)
    VALUES (v_pedidoId, v_regaloId, 1, 0);

END IF;

-- Confirmar transacción
  COMMIT;
END // 

-- fin de su solución
DELIMITER ;