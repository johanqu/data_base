--CREAMOS TABLAS

--Tabla Clientes
CREATE TABLE Clientes (
ID INTEGER PRIMARY KEY,
Nombre TEXT NOT NULL,
Ciudad TEXT NOT NULL,
Email TEXT NOT NULL 
);


--Tabla Productos
CREATE TABLE Productos ( 
ID INTEGER PRIMARY KEY, 
Nombre TEXT NOT NULL,
Precio INTEGER NOT NULL,
IDProveedores INTEGER,
FOREIGN KEY (IDProveedores) REFERENCES Proveedores(ID)
);


--Tabla Pedidos
CREATE TABLE Pedidos ( 
ID INTEGER PRIMARY KEY, 
IDCliente INTEGER,
IDProducto INTEGER,
FOREIGN KEY (IDCliente) REFERENCES Clientes(ID),
FOREIGN KEY (IDProducto) REFERENCES Productos(ID)
);


--Tabla Facturas
CREATE TABLE Facturas (
ID INTEGER PRIMARY KEY, 
IDPedido INTEGER,
Total INTEGER NOT NULL,
FOREIGN KEY (IDPedido) REFERENCES Pedidos(ID)
);


--Tabla Proveedores
CREATE TABLE Proveedores (
ID INTEGER PRIMARY KEY, 
Nombre TEXT NOT NULL,
Ciudad TEXT NOT NULL
);



-- INSERTAMOS DATOS


--Clientes
INSERT INTO Clientes (ID,Nombre,Ciudad,Email) VALUES
(1, 'Carlos', 'Madrid', 'carlos@mail.com'),
(2, 'Laura', 'Barcelona', 'laura@mail.com'),
(3, 'Ana', 'Valencia', 'ana@mail.com');


--Productos
INSERT INTO Productos (ID,Nombre,Precio,IDProveedores) VALUES
(1, 'Lavadora', 500, 1),
(2, 'Televisor', 800, 2),
(3, 'Microondas', 150, 1);


--Pedidos
INSERT INTO Pedidos (ID,IDCliente,IDProducto) VALUES
(1, 1 ,1),
(2, 2, 2),
(3, 1, 3);


--Facturas
INSERT INTO Facturas (ID,IDPedido,Total) VALUES
(1, 1, 500),
(2, 2, 800),
(3, 3, 150);


--Proveedores
INSERT INTO Proveedores (ID,Nombre,Ciudad) VALUES
(1, 'Proveedor1', 'Madrid'),
(2, 'Proveedor2', 'Barcelona');



--CONSULTAS SIMPLES


--1. Selecciona todos los clientes y sus correos electrónicos
SELECT Nombre, Email FROM Clientes;

--2. Selecciona el nombre de todos los productos.
SELECT Nombre FROM Productos;

--3. Selecciona todos los pedidos y los ID de los productos asociados
SELECT * FROM Pedidos;

--4. Selecciona todos los pedidos realizados por el cliente con ID 1. 
SELECT * FROM Pedidos WHERE IDCliente = 1;

--5. Selecciona todas las facturas con un total mayor a 400.
SELECT * FROM Facturas WHERE Total > 400;

--6. Selecciona todos los productos cuyo precio sea menor a 600.
SELECT * FROM Productos WHERE Precio < 600; 

--7. Selecciona el nombre del cliente que realizo el pedido con ID 2. 
SELECT c.Nombre
FROM Clientes c 
WHERE c.ID = (SELECT IDCliente FROM Pedidos WHERE ID = 2);

--8. Selecciona todos los proveedores en la ciudad de Madrid. 
SELECT * FROM Proveedores WHERE Ciudad = 'Madrid';

--9. Selecciona todas las facturas con un total igual a 800.
SELECT * FROM Facturas WHERE Total = 800;

--10. Selecciona todos los productos con un precio superior a 200. 
SELECT * FROM Productos WHERE Precio > 200;

--11. Selecciona todos los pedidos realizados por el cliente con ID 2. 
SELECT * FROM Pedidos WHERE IDCliente = 2;

--12. Selecciona todos los pedidos que incluyan  el producto con ID 3. 
SELECT * FROM Pedidos WHERE IDProducto = 3; 




-- CONSULTAS CON JOIN

--1. Selecciona el nombre de cada cliente y el nombre del producto que compró.
SELECT c.Nombre AS Cliente, p.Nombre AS Producto
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Productos p ON pe.IDProducto = p.ID

--2. Selecciona el nombre de cada cliente y el total de su factura. 
SELECT c.Nombre AS Cliente, f.Total AS TotalFactura
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Facturas f ON pe.ID = f.IDPedido;

--3. Selecciona el nombre de cada producto y el nombre del proveedor en la misma ciudad.
SELECT p.Nombre AS Producto, pr.Nombre AS Proveedor
FROM Productos p 
JOIN Proveedores pr ON p.IDProveedores = pr.ID
WHERE pr.Ciudad = (SELECT Ciudad FROM Proveedores WHERE ID = pr.ID);

--4. Selecciona el nombre de cada cliente, el producto comprado y el total de la factura
SELECT c.Nombre AS Cliente, p.Nombre AS Producto, f.Total AS TotalFactura
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Productos p ON pe.IDProducto = p.ID 
JOIN Facturas f ON pe.ID = f.IDPedido 

--5. Selecciona el nombre del cliente y el total de todos sus pedidos. 
SELECT c.Nombre AS Cliente, SUM(f.Total) AS TotalPedidos
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Facturas f  ON pe.ID = f.IDPedido 
GROUP BY c.ID;

--6. Selecciona el nombre del producto y el nombre del cliente que lo compro
SELECT p.Nombre AS Producto, c.Nombre AS Cliente
FROM Productos p 
JOIN Pedidos pe ON p.ID = pe.IDProducto 
JOIN Clientes c ON pe.IDCliente = c.ID;

--7. Selecciona el nombre del proveedor y los productos qeu suministra en la misma ciudad.
SELECT pr.Nombre AS Proveedor, p.Nombre AS Producto
FROM Proveedores pr
JOIN Productos p ON pr.ID = p.IDProveedores 
WHERE pr.Ciudad = (SELECT Ciudad FROM Proveedores WHERE ID = pr.ID);

--8. Selecciona el nombre de cada cliente y el numero de pedidos que ha realizado.
SELECT c.Nombre AS Clientes, COUNT(pe.ID) AS NumeroPedidos
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
GROUP BY c.Nombre;

--9. Selecciona el nombre de cada cliente y el nombre de cada proveedor en la misma ciudad. 
SELECT c.Nombre AS Cliente, pr.Nombre AS NombreProveedor
FROM Clientes c 
JOIN Proveedores pr ON c.Ciudad = pr.Ciudad;

--10. Selecciona el nombre del producto y el nombre del cliente que realizo el pedido mayor a 600
SELECT p.Nombre AS Producto, c.Nombre AS Cliente
FROM Productos p 
JOIN Pedidos pe ON p.ID = pe.IDProducto 
JOIN Clientes c ON pe.IDCliente = c.ID 
JOIN Facturas f ON pe.ID = f.IDPedido 
WHERE f.Total > 600;

--11. Selecciona el nombre de cada cliente y el total combinado de todas sus facturas
SELECT c.Nombre AS Cliente, SUM(f.Total) AS TotalFacturas
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Facturas f ON pe.ID = f.IDPedido 
GROUP BY c.Nombre;

--12. Selecciona el nombre de cada proveedor y los productos que suministra a diferentes ciudades
SELECT pr.Nombre AS Proveedor, p.Nombre AS Producto
FROM Proveedores pr
JOIN Productos p ON pr.ID = p.IDProveedores 
GROUP BY pr.Nombre, p.Nombre;




-- CONSULTAS EXTRA


--SIMPLES EXTRA

--1. Selecciona todos los productos cuyo precio sea superior a 700
SELECT * FROM Productos WHERE Precio > 700;

--2. Selecciona todos los pedidos con un ID mayor a 2.
SELECT * FROM Pedidos WHERE ID > 2;

--3. Selecciona todos los clientes cuyo nombre comiencen con A.
SELECT * FROM Clientes WHERE Nombre LIKE 'A%'

--4. Selecciona todas las facturas cuyo total sea inferior a 200.
SELECT * FROM Facturas WHERE Total < 200;

--5. Selecciona todos los productos ordenados por su precio de forma descendente.
SELECT * FROM Productos ORDER BY Precio DESC;

--6. Selecciona todas las facturas cuyo total sea mayor a 100 pero menor a 600.
SELECT * FROM Facturas WHERE Total > 100 AND Total < 600;

--7. Selecciona todos los proveedores que no etan en Barcelona
SELECT * FROM Proveedores WHERE Ciudad != 'Barcelona';

--8. Selecciona el ID y el nombre de todos los productos ordenados alfabéticamente.
SELECT ID, Nombre FROM Productos ORDER BY Nombre ASC;



-- JOIN EXTRA

--1. Selecciona el nombre del cliente, el nombre del producto, y el total de su pedido si el total es mayor a 500.
SELECT c.Nombre AS Cliente, p.Nombre AS Producto, f.Total AS TotalPedido
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Productos p ON pe.IDProducto = p.ID 
JOIN Facturas f ON pe.ID = f.IDPedido 
WHERE f.Total > 500;

--2. Selecciona el nombre de cada cliente y el nombre del proveedor en su misma ciudad
SELECT c.Nombre AS Cliente, pr.Nombre AS Proveedor
FROM Clientes c 
JOIN Proveedores pr ON c.Ciudad = pr.Ciudad;

--3. Selecciona el nombre de los clientes que han realizado mas de un pedido.
SELECT c.Nombre AS Nombrecliente
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
GROUP BY c.Nombre 
HAVING COUNT(pe.ID) > 1; 

--4. Selecciona el nombre del producto y el nombre del proveedor, si ambos estan en Barcelona.
SELECT p.Nombre AS Producto, pr.Nombre AS Proveedor
FROM Productos p 
JOIN Proveedores pr ON p.IDProveedores = pr.ID 
WHERE pr.Ciudad = 'Barcelona';

--5. Selecciona el nombre del cliente y el número total de facturas que ha generado.
SELECT c.Nombre AS Cliente, COUNT(f.ID) AS NumeroFacturas
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Facturas f ON pe.ID = f.IDPedido 
GROUP BY c.Nombre;

--6. Selecciona el nombre del proveedor y el numero de productos que ha suministrado.
SELECT pr.Nombre AS Proveedor, COUNT(p.ID) AS NumeroProductos
FROM Proveedores pr
JOIN Productos p ON pr.ID = p.IDProveedores 
GROUP BY pr.Nombre;

--7. Selecciona el nombre del cliente y el nombre del producto si el pedido contiene mas de un producto
SELECT c.Nombre AS Cliente, p.Nombre AS Producto
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Productos p ON pe.IDProducto = p.ID 
GROUP BY c.Nombre, p.Nombre 
HAVING COUNT(pe.IDProducto) > 1; 

--8. Selecciona el nombre del cliente, el nombre del producto, y el total de la factura si el cliente esta en Madrid
SELECT c.Nombre AS Cliente, p.Nombre AS Producto, f.Total AS TotalFactura
FROM Clientes c 
JOIN Pedidos pe ON c.ID = pe.IDCliente 
JOIN Productos p ON pe.IDProducto = p.ID 
JOIN Facturas f ON pe.ID = f.IDPedido 
WHERE c.Ciudad = 'Madrid';












