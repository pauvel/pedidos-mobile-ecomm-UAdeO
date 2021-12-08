CREATE TABLE productos(
    id INT PRIMARY KEY AUTOINCREMENT,
    producto_id INT,
    cantidad INT
)

CREATE TABLE extras(
    id INT PRIMARY KEY AUTOINCREMENT,
    producto_id INT,
    extra_id INT,
    FOREIGN KEY(producto_id) REFERENCES productos(id)
)

CREATE TABLE ingredientes(
    id int PRIMARY KEY AUTOINCREMENT,
    producto_id INT,
    ingrediente_id INT,
    FOREIGN KEY(producto_id) REFERENCES productos(id)
)