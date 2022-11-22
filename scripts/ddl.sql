
-- Mercado
-- OK
INSERT INTO Mercado (id, pais, idioma) VALUES (1, 'México', 'Español');
INSERT INTO Mercado (id, pais, idioma) VALUES (2, 'México', 'Portugés');
INSERT INTO Mercado (id, pais, idioma) VALUES (3, 'Brasil', 'Portugés');

-- Usuario
-- OK
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('nicolasandreoli@gmail.com', 'Nicolás', 'Andreoli', TO_DATE('24/01/2000', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2020', 'dd/mm/yyyy'), 0991234567, NULL);
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('josemaria@gmail.com', 'José', 'María', TO_DATE('24/01/1950', 'dd/mm/yyyy'), 3, TO_DATE('24/01/2021', 'dd/mm/yyyy'), NULL, 'josemaria@gmail.com');

-- FAIL --> edad menor a 18 --> trigger
-- INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('josemaria@gmail1.com', 'José', 'María', TO_DATE('24/01/1999', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2021', 'dd/mm/yyyy'), NULL, 'josemaria@gmail.com');

-- FAIL --> telefonoRecuperarCuenta, emailRecuperarCuenta ambos nulos
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('josemaria2@gmail.com', 'José', 'María', TO_DATE('24/01/1950', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2021', 'dd/mm/yyyy'), NULL, NULL);

-- FAIL --> telefonoRecuperarCuenta, emailRecuperarCuenta ambos con valor
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('josemaria3@gmail.com', 'José', 'María', TO_DATE('24/01/1950', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2021', 'dd/mm/yyyy'), 0991234567, 'josemaria@gmail.com');


-- MedioPago
-- OK
INSERT INTO MedioPago (codigo, tipo, emailUsuario) VALUES ('123456', 'CRYPTO', 'nicolasandreoli@gmail.com');
INSERT INTO MedioPago (codigo, tipo, emailUsuario) VALUES ('ABCDEF', 'CREDITO', 'josemaria@gmail.com');

-- FAIL --> tipo no valido
INSERT INTO MedioPago (codigo, tipo, emailUsuario) VALUES ('1234567', 'TEST', 'josemaria@gmail.com');



-- Producto
-- OK
INSERT INTO Producto (id, nombre, precio, stock) VALUES (1, 'Tesla Prime', 100, 10);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (2, 'Panel 360 para casa', 100, 5);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (3, 'Vestido Azul', 100, 10);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (4, 'Tesla 2', 1000, 10);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (5, 'Tesla 3', 1000, 10);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (6, 'Tesla 3', 1000, 10);
INSERT INTO Producto (id, nombre, precio, stock) VALUES (7, 'Tesla 3', 1000, 10);

-- Automovil
-- OK
INSERT INTO Automovil (id, modelo, color, anoDeLanzamiento, autonomiaHoras, potenciaEnAmperiosHora) VALUES (1, 'Tesla Prime 3rd edition', 'Negro', 2000, 50, 10);
INSERT INTO Automovil (id, modelo, color, anoDeLanzamiento, autonomiaHoras, potenciaEnAmperiosHora) VALUES (4, 'S', 'azul', 2021, 50, 10);
INSERT INTO Automovil (id, modelo, color, anoDeLanzamiento, autonomiaHoras, potenciaEnAmperiosHora) VALUES (5, 'S', 'azul', 2020, 50, 10);
INSERT INTO Automovil (id, modelo, color, anoDeLanzamiento, autonomiaHoras, potenciaEnAmperiosHora) VALUES (6, 'S3', 'azul', 2021, 50, 10);
INSERT INTO Automovil (id, modelo, color, anoDeLanzamiento, autonomiaHoras, potenciaEnAmperiosHora) VALUES (7, 'S', 'azul', 2021, 50, 10);

-- PanelSolar
-- OK
INSERT INTO PanelSolar (id, largo, ancho, voltaje) VALUES (2, 5, 5, 24);

-- FAIL -> voltaje invalido
INSERT INTO PanelSolar (id, largo, ancho, voltaje) VALUES (3, 5, 5, 23);

-- Vestimenta
-- FAIL --> talle invalido
INSERT INTO Vestimenta (id, tipo, color, talle) VALUES (3, 'PANTALON', 'Azul', 'XS');

-- FAIL --> tipo invalido
INSERT INTO Vestimenta (id, tipo, color, talle) VALUES (3, 'BUZO', 'Azul', 'XL');

-- OK
INSERT INTO Vestimenta (id, tipo, color, talle) VALUES (3, 'PANTALON', 'Azul', 'XL');


-- Factura
-- OK
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (1, 700, TO_DATE('17/10/2021', 'dd/mm/yyyy'), 'josemaria@gmail.com', 'ABCDEF');
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (2, 500, TO_DATE('18/10/2021', 'dd/mm/yyyy'), 'nicolasandreoli@gmail.com', '123456');
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (3, 500, TO_DATE('18/10/2021', 'dd/mm/yyyy'), 'nicolasandreoli@gmail.com', '123456');
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (5, 500, TO_DATE('18/10/2021', 'dd/mm/yyyy'), 'josemaria@gmail.com', 'ABCDEF');
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (6, 500, TO_DATE('01/01/2022', 'dd/mm/yyyy'), 'nicolasandreoli@gmail.com', '123456');

-- Venta
-- OK
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (1, 1, 5, 500, 24);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (1, 2, 2, 200, NULL);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (2, 3, 5, 500, NULL);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 4, 5, 5000, 59);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (5, 4, 5, 5000, 60);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (6, 7, 1, 1000, 62);
