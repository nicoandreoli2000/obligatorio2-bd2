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
