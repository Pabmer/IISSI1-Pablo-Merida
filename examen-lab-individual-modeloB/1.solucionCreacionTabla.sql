DROP TABLE IF EXISTS Pagos;

CREATE TABLE Pagos(
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedidoId INT NOT NULL,
    fecha_pago DATE NOT NULL,
    cantidad_pagada DECIMAL(10, 2) NOT NULL CHECK (cantidad_pagada > 0),
    revisado BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (pedidoId) REFERENCES Pedidos(id)
);
