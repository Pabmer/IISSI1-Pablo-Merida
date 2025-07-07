DROP TABLE IF EXISTS Valoraciones;

CREATE TABLE Valoraciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    productoId INT NOT NULL,
    clienteId INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion>0 AND puntuacion<6),
    fechaRealizacion DATE NOT NULL,
    FOREIGN KEY (productoId) REFERENCES Productos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (clienteId) REFERENCES Clientes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE(productoId,clienteId)
);