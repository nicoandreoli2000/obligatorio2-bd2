-- Requerimiento 1
-- Proveer un servicio que, dado un rango de fechas y un usuario, retorne la cantidad de compras realizadas por el
-- usuario y el monto total para el periodo.

-- Decidimos hacer cantidad de facturas (recibos) y no cantidad de ventas (articulos) en cada compra. 
CREATE OR REPLACE PROCEDURE GetCompras(usuario IN Usuario.email%TYPE, desde IN Factura.fecha%TYPE, hasta IN Factura.fecha%TYPE, 
        numCompras OUT Number, montoTotal OUT Producto.precio%TYPE) AS
BEGIN
     SELECT COUNT(*), SUM(F.total) into numCompras, montoTotal
     FROM Factura F
     WHERE f.emailUsuario = usuario
     AND f.fecha BETWEEN desde AND hasta;
     
END;
     
-- Test
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

-- Test si la fecha de hasta coincide con la de desde 
DECLARE 
    VUserEmail Usuario.email%TYPE := 'nicolasandreoli@gmail.com';
    VDesde DATE := TO_DATE('18/10/2021', 'dd/mm/yyyy');
    VHasta DATE := TO_DATE('18/10/2021', 'dd/mm/yyyy');
    numCompras NUMBER; 
    montoTotal NUMBER;
BEGIN
    GetCompras(VUserEmail, VDesde, VHasta, numCompras, montoTotal);
    DBMS_OUTPUT.PUT_LINE('El usuario con email ' || TO_CHAR(VUserEmail) || ' entre las fechas ' || TO_CHAR(VDesde) || ' y ' ||  TO_CHAR(VHasta) || ' realizo ' || TO_CHAR(numCompras) || ' compras y gasto un monto total de ' || TO_CHAR(montoTotal) || ' pesos');
    DBMS_OUTPUT.PUT_LINE('Numero de compras: ' || TO_CHAR(numCompras));
    DBMS_OUTPUT.PUT_LINE('Monto total: ' || TO_CHAR(montoTotal));
END;

-- Test si la fecha de desde es posterior a la de hasta:
DECLARE 
    VUserEmail Usuario.email%TYPE := 'nicolasandreoli@gmail.com';
    VDesde DATE := TO_DATE('18/10/2021', 'dd/mm/yyyy');
    VHasta DATE := TO_DATE('10/10/2021', 'dd/mm/yyyy');
    numCompras NUMBER; 
    montoTotal NUMBER;
BEGIN
    GetCompras(VUserEmail, VDesde, VHasta, numCompras, montoTotal);
    DBMS_OUTPUT.PUT_LINE('El usuario con email ' || TO_CHAR(VUserEmail) || ' entre las fechas ' || TO_CHAR(VDesde) || ' y ' ||  TO_CHAR(VHasta) || ' realizo ' || TO_CHAR(numCompras) || ' compras y gasto un monto total de ' || TO_CHAR(montoTotal) || ' pesos');
    DBMS_OUTPUT.PUT_LINE('Numero de compras: ' || TO_CHAR(numCompras));
    DBMS_OUTPUT.PUT_LINE('Monto total: ' || TO_CHAR(montoTotal));
END;


-- test con usuario no existente 
DECLARE 
    VUserEmail Usuario.email%TYPE := 'usuarioNoExistente@gmail.com';
    VDesde DATE := TO_DATE('11/10/2021', 'dd/mm/yyyy');
    VHasta DATE := TO_DATE('19/10/2021', 'dd/mm/yyyy');
    numCompras NUMBER; 
    montoTotal NUMBER;
BEGIN
    GetCompras(VUserEmail, VDesde, VHasta, numCompras, montoTotal);
    DBMS_OUTPUT.PUT_LINE('El usuario con email ' || TO_CHAR(VUserEmail) || ' entre las fechas ' || TO_CHAR(VDesde) || ' y ' ||  TO_CHAR(VHasta) || ' realizo ' || TO_CHAR(numCompras) || ' compras y gasto un monto total de ' || TO_CHAR(montoTotal) || ' pesos');
    DBMS_OUTPUT.PUT_LINE('Numero de compras: ' || TO_CHAR(numCompras));
    DBMS_OUTPUT.PUT_LINE('Monto total: ' || TO_CHAR(montoTotal));
END;

-- Requerimiento 2
-- Proveer un servicio que reciba por par??metro una cantidad X y retorne el top X de productos m??s vendidos. Para
-- el caso espec??fico de los veh??culos, interesa agrupar por modelo. Para el resto de los productos interesa
-- agruparlo por tipo.

CREATE OR REPLACE PROCEDURE topXProductosCant(VCantidadVendidos IN Number) AS
    CURSOR cur_topX IS SELECT *
    FROM (SELECT 'Panel Solar' AS nombreProducto, SUM(V.cantidad) AS cantidad
        FROM Venta V, Producto P, PanelSolar PS
        WHERE V.idProducto = P.id
        AND P.id = PS.id 
        UNION
        SELECT 'Vestimenta' AS nombreProducto, SUM(V.cantidad) AS cantidad
        FROM Venta V, Producto P, Vestimenta Vest
        WHERE V.idProducto = P.id
        AND P.id = Vest.id    
        UNION
        SELECT A.modelo AS nombreProducto, SUM(V.cantidad) AS cantidad 
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



-- Requerimiento 3
-- Proveer un servicio que al final del d??a genere los pedidos correspondientes a los productos cuyo stock no llegue
-- a su stock m??nimo. Dicho pedido debe quedar almacenado en la base de datos y debe incluir el producto, la
-- fecha y la cantidad a solicitar (cantidad necesaria para superar el stock m??nimo).


ALTER TABLE Producto
ADD minimoStock NUMBER;

-- el minimos de stock es 12 para cada producto
UPDATE Producto SET minimoStock = 12;

-- creo la tabla de pedidos
CREATE TABLE Pedidos (
    fecha DATE,
    idProducto NUMBER(10),
    catidadSolicitada NUMBER(5),
    PRIMARY KEY (fecha, idProducto),
    FOREIGN KEY (idProducto) REFERENCES Producto (id)
);


CREATE OR REPLACE PROCEDURE pedirStock AS
    dia DATE; 
    CURSOR cursorProductos is 
        SELECT id, stock, minimoStock
        FROM Producto;
    productoYaProcesado NUMBER;
    cantidadSolicitada Pedidos.catidadSolicitada%TYPE;
BEGIN     
    dia := SYSDATE;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(dia));
    FOR registro IN cursorProductos LOOP
        -- chequeo si ya procese el producto
        SELECT COUNT(*) INTO productoYaProcesado
        FROM Pedidos P
        WHERE P.idProducto = registro.id
        AND TO_CHAR(P.fecha, 'DD Month YYYY') = TO_CHAR(dia, 'DD Month YYYY');
        
        IF productoYaProcesado = 0 THEN
            cantidadSolicitada := registro.minimoStock - registro.stock;
            IF cantidadSolicitada > 0 THEN
                INSERT INTO Pedidos (fecha, idProducto, catidadSolicitada) VALUES (dia, registro.id, cantidadSolicitada + 1);
                UPDATE Producto P 
                    SET P.stock = cantidadSolicitada + 1 + P.stock 
                    WHERE P.id = registro.id;
                COMMIT; 
                DBMS_OUTPUT.PUT_LINE('Actualizo el producto ' || TO_CHAR(registro.id));
            END IF;
        END IF;   
     END LOOP;
     EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
END;


