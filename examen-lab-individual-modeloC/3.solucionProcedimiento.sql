DELIMITER //

CREATE PROCEDURE bonificar_pedido_retrasado(IN p_pedidoId INT)
-- incluya su solución a continuación
BEGIN
  DECLARE n_empleadoId INT;
  DECLARE v_empleadoId INT;

  -- Manejo de errores
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al registrar cliente premium';
  END;

  -- Iniciar transacción
  START TRANSACTION;
  
  -- Seleccionar al gestor de pedido dado
  SELECT e.id INTO v_empleadoId 
  FROM Pedidos p 
  JOIN Empleados e ON p.empleadoId = e.id
  WHERE p.id = p_pedidoId;

  IF v_empleadoId IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no tiene gestor';
  END IF;

  -- Asignar un nuevo empleado
  SELECT e.id INTO n_empleadoId
  FROM Empleados e 
  WHERE e.id != v_empleadoId
  LIMIT 1;

  -- Actualizar el valor del pedido
  UPDATE Pedidos 
  SET empleadoId = n_empleadoId
  WHERE id = p_pedidoId;

  -- Actualizar lineas de pedido
  UPDATE LineasPedido 
  SET precio = precio * 0.8
  WHERE pedidoId = p_pedidoId;

  -- Confirmar transacción
  COMMIT;
  
END//

-- fin de su solución
DELIMITER ;