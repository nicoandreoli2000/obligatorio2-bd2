-- Requerimiento 1
-- Proveer un servicio que, dado un rango de fechas y un usuario, retorne la cantidad de compras realizadas por el
-- usuario y el monto total para el periodo.

-- Decidimos hacer cantidad de facturas (recibos) y no cantidad de ventas (articulos) en cada compra. 
CREATE OR REPLACE PROCEDURE GetCompras(usuario IN Usuario.email%TYPE, desde IN Factura.fecha%TYPE, hasta IN Factura.fecha%TYPE, 
        numCompras OUT Number, montoTotal OUT Number) AS
BEGIN
     SELECT COUNT(*), SUM(F.total) into numCompras, montoTotal
     FROM Factura F
     WHERE f.emailUsuario = usuario
     AND f.fecha BETWEEN desde AND hasta;
END;


     
     
SET serveroutput ON;
DECLARE 
    VUserEmail Usuario.email%TYPE := 'nicolasandreoli@gmail.com';
    VDesde DATE := TO_DATE('17/10/2021', 'dd/mm/yyyy');
    VHasta DATE := TO_DATE('19/10/2021', 'dd/mm/yyyy');
    numCompras NUMBER; 
    montoTotal NUMBER;
BEGIN
    GetCompras(VUserEmail, VDesde, VHasta, numCompras, montoTotal);
    DBMS_OUTPUT.PUT_LINE('El usuario con email ' || TO_CHAR(VUserEmail) || ' entre las fechas ' || TO_CHAR(VDesde) || ' y ' ||  TO_CHAR(VHasta) || ' realizo ' || TO_CHAR(numCompras) || ' compras y gasto un monto total de ' || TO_CHAR(montoTotal) || ' pesos');
    DBMS_OUTPUT.PUT_LINE('Numero de compras: ' || TO_CHAR(numCompras));
    DBMS_OUTPUT.PUT_LINE('Monto total: ' || TO_CHAR(montoTotal));
END;


-- Test
-- TODO

-- Requerimiento 2
-- Proveer un servicio que reciba por parámetro una cantidad X y retorne el top X de productos más vendidos. Para
-- el caso específico de los vehículos, interesa agrupar por modelo. Para el resto de los productos interesa
-- agruparlo por tipo.

CREATE OR REPLACE PROCEDURE topXProductosCant(VCantidadVendidos IN Number) AS
    CURSOR cur_topX is SELECT *
    FROM (SELECT 'Panel Solar' AS nombreProducto, sum(V.cantidad) AS cantidad
        FROM Venta V, Producto P, PanelSolar PS
        WHERE V.idProducto = P.id
        AND P.id = PS.id 
        UNION
        SELECT 'Vestimenta' AS nombreProducto, sum(V.cantidad) AS cantidad
        FROM Venta V, Producto P, Vestimenta Vest
        WHERE V.idProducto = P.id
        AND P.id = Vest.id    
        UNION
        SELECT A.modelo AS nombreProducto, sum(V.cantidad) AS cantidad 
        FROM Venta V, Producto P, Automovil A
        WHERE V.idProducto = P.id
        AND P.id = A.id
        GROUP BY A.modelo)
    ORDER BY cantidad DESC
    FETCH FIRST VCantidadVendidos ROWS ONLY;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('El top ' || TO_CHAR(VCantidadVendidos) || ' de productos mas vendidos es: ');
    FOR registro IN cur_topX LOOP
         DBMS_OUTPUT.PUT_LINE('Producto ' || TO_CHAR(registro.nombreProducto) || ' se vendieron ' || TO_CHAR(registro.cantidad) || ' unidades' );

    END LOOP;
END;


-- Test
SET serveroutput ON;
DECLARE 
    VCantidadVendidos NUMBER := 3;
BEGIN
    topXProductosCant(VCantidadVendidos);
END;

SET serveroutput ON;
DECLARE 
    VCantidadVendidos NUMBER := 2;
BEGIN
    topXProductosCant(VCantidadVendidos);
END;

-- CREATE OR REPLACE PROCEDURE REQUERIMIENTO_2(...) AS
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




-- 3 
-- Crear tabla pedido, actualizar stock producto y despues commit
-- En la tabla producto agregar stock minimo