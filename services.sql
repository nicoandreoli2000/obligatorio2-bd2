-- Requerimiento 1
-- Proveer un servicio que, dado un rango de fechas y un usuario, retorne la cantidad de compras realizadas por el
-- usuario y el monto total para el periodo.

CREATE OR REPLACE TYPE TIPO_RETURN_REQUERIMIENTO_1 AS OBJECT(cantidad NUMBER, total Producto.precio%TYPE);

CREATE OR REPLACE FUNCTION REQUERIMIENTO_1(emailUsuario Usuario.email%TYPE, desde DATE, hasa DATE)
RETURN TIPO_RETURN_REQUERIMIENTO_1 AS
    CANTIDAD_COMPRAS NUMBER;
    PRECIO_TOTAL Producto.precio%TYPE;
BEGIN
    SELECT SUM(v.cantidad), SUM(f.total) INTO CANTIDAD_COMPRAS, PRECIO_TOTAL
    FROM Factura f, Venta v
    WHERE f.emailUsuario = email
    AND v.idFactura = f.id;
    

    RETURN new TIPO_RETURN_REQUERIMIENTO_1(CANTIDAD_COMPRAS, PRECIO_TOTAL);
END;

-- Test
-- TODO

-- Requerimiento 2
-- Proveer un servicio que reciba por parámetro una cantidad X y retorne el top X de productos más vendidos. Para
-- el caso específico de los vehículos, interesa agrupar por modelo. Para el resto de los productos interesa
-- agruparlo por tipo.

-- CREATE OR REPLACE FUNCTION REQUERIMIENTO_2(...)
-- RETURN ... AS
-- BEGIN
-- END;

-- Test
-- TODO



-- Requerimiento 3
-- Proveer un servicio que al final del día genere los pedidos correspondientes a los productos cuyo stock no llegue
-- a su stock mínimo. Dicho pedido debe quedar almacenado en la base de datos y debe incluir el producto, la
-- fecha y la cantidad a solicitar (cantidad necesaria para superar el stock mínimo).

-- CREATE OR REPLACE FUNCTION PROCEDURE(...) AS
-- BEGIN
-- END;

-- Test
-- TODO

