-- Originales
-- 1. Todo usuario registrado debe ser mayor a 18 años
-- 2. La factura debe tener el mismo codigoMedioPago que el de usuario que se relaciona con la factura
-- 3. Al realizar una venta de un producto se debe chequear que el mismo tenga stock suficiente 
-- 4. El atributo subtotal de la tabla Venta debe ser igual a la cantidad * precio del producto
-- 5. El numeroDeSerie de la tabla Venta debe ser nulo a menos que el producto con el que se relacione sea un automóvil.
-- 6. Solo un usuario que haya comprado un automóvil puede comprar vestimenta

-- Agregados por la correción
-- 7. Checkear que los mails del codigo de fact y el medio de pago sean iguales
-- 8. El registro en Venta para el caso de automóvil se debería asegurar que la cantidad = 1


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

UPDATE Usuario
SET fechaNacimiento = TO_DATE('24/01/2008', 'dd/mm/yyyy')
WHERE email='nicolasandreoli@gmail.com';

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

-- test
INSERT INTO Factura (id, total, fecha, emailusuario, codigoMedioPago) VALUES (7, 700, TO_DATE('17/10/2021', 'dd/mm/yyyy'), 'josemaria@gmail.com', '123456');

UPDATE Factura
SET codigoMedioPago = '123456'
WHERE id=1;

-- 3. Al realizar una venta de un producto se debe chequear que el mismo tenga stock suficiente 


-- test
INSERT INTO Venta (idFactura, idProducto, cantidad, subtotal, numeroDeSerie) VALUES (3, 2, 6, 500, null);



-- 4. El atributo subtotal de la tabla Venta debe ser igual a la cantidad * precio del producto