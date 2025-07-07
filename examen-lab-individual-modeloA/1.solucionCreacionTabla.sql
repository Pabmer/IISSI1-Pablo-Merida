DROP TABLE IF EXISTS Garantias;

CREATE TABLE Garantias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    productoId INT,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    extendida BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (productoId) REFERENCES Productos(id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT  fecha CHECK (fechaInicio < fechaFin),
    UNIQUE (productoId)
)