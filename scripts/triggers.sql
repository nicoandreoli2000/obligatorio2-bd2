SET serveroutput ON;

-- 1. Todo usuario registrado debe ser mayor a 18 años
CREATE OR REPLACE TRIGGER VALIDAR_EDAD_USUARIO
BEFORE INSERT OR UPDATE ON USUARIO
FOR EACH ROW
DECLARE
    VEdad Number;
BEGIN
    VEdad := MONTHS_BETWEEN(SYSDATE, :NEW.fechaNacimiento)/12; 
    IF VEdad < 18  THEN
        DBMS_OUTPUT.PUT_LINE ('El usuario debe ser mayor de edad');
        RAISE_APPLICATION_ERROR(-20001,'El usuario debe ser mayor de edad, actualmente posee ' || TO_CHAR(VEdad) || ' años') ;
    END IF;
END;

-- Test 
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('nicolasandreoli2@gmail.com', 'Nicolás2', 'Andreoli2', TO_DATE('24/01/2020', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2020', 'dd/mm/yyyy'), 0991234567, NULL);
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('nicolasandreoli2@gmail.com', 'Nicolás2', 'Andreoli2', TO_DATE('24/12/2004', 'dd/mm/yyyy'), 1, TO_DATE('24/01/2020', 'dd/mm/yyyy'), 0991234567, NULL);

UPDATE Usuario SET fechaNacimiento = TO_DATE('24/01/2008', 'dd/mm/yyyy') WHERE email='nicolasandreoli@gmail.com';

-- 2. La factura debe tener el mismo codigoMedioPago que el de usuario que se relaciona con la factura

CREATE OR REPLACE TRIGGER VALIDAR_MEDIO_PAGO_ES_EL_MISMO
BEFORE INSERT OR UPDATE ON FACTURA
FOR EACH ROW
DECLARE
    VUsuarioMedioPago MedioPago.codigo%TYPE;
BEGIN
    SELECT codigo INTO VUsuarioMedioPago  
    FROM MedioPago M
    WHERE :NEW.emailUsuario = M.emailUsuario;
    IF :NEW.codigoMedioPago != VUsuarioMedioPago  THEN
        RAISE_APPLICATION_ERROR(-20001, 'La factura debe tener el mismo medio de pago que el usuario que paga la factura') ;
    END IF;
END;

-- Test
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (7, 700, TO_DATE('17/10/2021', 'dd/mm/yyyy'), 'josemaria@gmail.com', '123456');

UPDATE Factura SET codigoMedioPago = '123456' WHERE id=1;

-- 3. Al realizar una venta de un producto se debe chequear que el mismo tenga stock suficiente 
CREATE OR REPLACE TRIGGER VALIDAR_STOCK
BEFORE INSERT ON Venta
FOR EACH ROW
DECLARE
    VProductoStock Producto.stock%TYPE;
    VNombreProducto Producto.nombre%TYPE;
BEGIN
    SELECT P.stock, P.nombre INTO VProductoStock, VNombreProducto 
    FROM Producto P
    WHERE :NEW.idProducto = P.id;
    IF VProductoStock < :NEW.cantidad  THEN
        RAISE_APPLICATION_ERROR(-20001, 'No hay suficiente stock del producto ' || TO_CHAR(VNombreProducto) ||' El stock actual es de ' || TO_CHAR(VProductoStock)) ;
    END IF;
END;

-- Test
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 2, 6, 600, null);

-- HACER UN TRIGGER PARA UPDATE

-- 4. El atributo subtotal de la tabla Venta debe ser igual a la cantidad * precio del producto
CREATE OR REPLACE TRIGGER VALIDAR_SUBTOTAL
BEFORE INSERT OR UPDATE ON Venta
FOR EACH ROW
DECLARE
    VProductoPrecio Producto.precio%TYPE;
BEGIN
    SELECT P.precio INTO VProductoPrecio 
    FROM Producto P
    WHERE :NEW.idProducto= P.id;
    
    IF :NEW.cantidad * VProductoPrecio != :NEW.subtotal THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el calculo del subtotal. Precio del producto es: ' || TO_CHAR(VProductoPrecio)) ;
    END IF;
END;

-- Test
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 2, 2, 150, null);

UPDATE Venta SET subtotal = 700 WHERE idFactura=3 and idProducto=2;


-- 5. El numeroDeSerie de la tabla Venta debe ser nulo a menos que el producto con el que se relacione sea un automóvil.
CREATE OR REPLACE TRIGGER VALIDAR_NUMERO_SERIE_AUTOMOVIL
BEFORE INSERT OR UPDATE ON Venta
FOR EACH ROW
DECLARE
    VEsAuto Number;
    VNoEsAuto Number;
BEGIN
    SELECT COUNT(1) INTO VEsAuto 
    FROM Producto P, Automovil A
    WHERE :NEW.idProducto= P.id
    AND P.id = A.id; 
    
    IF VEsAuto > 0 and :NEW.numeroDeSerie IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'El automovil debe tener un numeros de serie'); 
    
    END IF;

    SELECT COUNT(1) INTO VNoEsAuto 
    FROM Producto P, PanelSolar PS, Vestimenta V
    WHERE :NEW.idProducto= P.id
    AND (P.id = PS.id 
    OR P.id = V.id);
    
    IF VNoEsAuto > 0 and :NEW.numeroDeSerie IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Las vestimentas o paneles solares no debe tener un numeros de serie') ;
    END IF;
END;

-- Test
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 1, 1, 100, null);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 2, 1, 100, 50);

-- 6. Solo un usuario que haya comprado un automóvil puede comprar vestimenta
CREATE OR REPLACE TRIGGER USUARIO_PUEDE_COMPRAR_ROPA
BEFORE INSERT OR UPDATE ON Venta
FOR EACH ROW
DECLARE
     VEsVestimenta Number;
     VEmailUsuarioDelaCompra Usuario.email%TYPE;
     VPoseeAutomovil Number;
BEGIN
    SELECT COUNT(1) INTO VEsVestimenta 
    FROM Producto P,  Vestimenta V
    WHERE :NEW.idProducto= P.id
    AND P.id = V.id;
    
    SELECT F.emailUsuario INTO VEmailUsuarioDelaCompra 
    FROM Factura F
    WHERE :NEW.idFactura= F.id;
    
    SELECT COUNT(1) INTO VPoseeAutomovil 
    FROM Factura F, Venta V, Automovil A
    WHERE F.emailUsuario = VEmailUsuarioDelaCompra
    AND F.id = V.idFactura
    AND V.idProducto = A.id;
    
    IF VEsVestimenta > 0 and VPoseeAutomovil = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Es necesario haber comprado un automovil para poder comprar ropa') ;
    END IF;
END;

-- TEST
INSERT INTO Usuario (email, nombre, apellido, fechaNacimiento, idMercado, fechaCreacion, telefonoRecuperarCuenta, emailRecuperarCuenta) VALUES ('andres@gmail.com', 'andres', 'María', TO_DATE('24/01/1950', 'dd/mm/yyyy'), 3, TO_DATE('24/01/2021', 'dd/mm/yyyy'), NULL, 'andres@gmail.com');
INSERT INTO MedioPago (codigo, tipo, emailUsuario) VALUES ('123456789', 'CRYPTO', 'andres@gmail.com');
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (7, 500, TO_DATE('01/01/2022', 'dd/mm/yyyy'), 'andres@gmail.com', '123456789');
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (7, 3, 1, 100, null);

INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (7, 1, 1, 100, 15);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (7, 3, 1, 100, null);


-- 7. Checkear que los mails del codigo de fact y el medio de pago sean iguales
CREATE OR REPLACE TRIGGER VALIDAR_EMAIL_FACTURA_Y_MEDIO_PAGO_IGUALES
BEFORE INSERT OR UPDATE ON Factura
FOR EACH ROW
DECLARE
     VMedioPagoEmailUsuario Usuario.email%TYPE;
BEGIN
    SELECT M.emailUsuario INTO VMedioPagoEmailUsuario 
    FROM MedioPago M
    WHERE :NEW.codigoMedioPago = M.codigo;
    
    IF VMedioPagoEmailUsuario != :NEW.emailUsuario THEN
            RAISE_APPLICATION_ERROR(-20001, 'El email del usuario de la factura ' ||  TO_CHAR(:NEW.emailUsuario) || ' no coincide con el del medio de pago de ese usuario ' || TO_CHAR(VMedioPagoEmailUsuario) ) ;
    END IF;
END; 


INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (6, 500, TO_DATE('01/01/2022', 'dd/mm/yyyy'), 'nicolasandreoli@gmail.com', 'ABCDEF');



-- 8. El registro en Venta para el caso de automóvil se debería asegurar que la cantidad = 1
CREATE OR REPLACE TRIGGER VENTA_UNICA_AUTOMOVIL
BEFORE INSERT OR UPDATE ON Venta
FOR EACH ROW
DECLARE
     EsAutomovil Number;
BEGIN
    SELECT COUNT(1) INTO EsAutomovil 
    FROM Producto P, Automovil A
    WHERE :NEW.idProducto= P.id
    AND P.id = A.id;
    
    IF EsAutomovil > 0 and :NEW.cantidad != 1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Solo se puede registrar una Venta de cantidad 1 para los automoviles') ;
    END IF;
END;

-- Test
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 4, 2, 200, 50);
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 1, 3, 300, 50);

-- trigger para actualizar stock
CREATE OR REPLACE TRIGGER ACTUALIZAR_STOCK
AFTER INSERT ON Venta
FOR EACH ROW
DECLARE
BEGIN
    UPDATE Producto P 
    SET P.stock = P.stock - :NEW.cantidad 
    WHERE P.id = :NEW.idProducto;
END;

-- TEST
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 3, 3, 300, null);


CREATE OR REPLACE TRIGGER ACTUALIZAR_STOCK_WHEN_DELETE_VENTA
AFTER DELETE ON Venta
FOR EACH ROW
DECLARE
BEGIN
    UPDATE Producto P 
    SET P.stock = P.stock + :OLD.cantidad 
    WHERE P.id = :OLD.idProducto;
END;


-- HACER UNO PARA UPDATE -> no lo puedo probar nose porque. 

CREATE OR REPLACE TRIGGER ACTUALIZAR_STOCK_UPDATE
AFTER UPDATE ON Venta
FOR EACH ROW
DECLARE
BEGIN
    UPDATE Producto P 
    SET P.stock = P.stock - :NEW.cantidad + :OLD.cantidad
    WHERE P.id = :NEW.idProducto;
END;


-- EN LOS REQUERIMIENTO MANEJAR EXCEPCIONES
