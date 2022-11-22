
-- DROPS

-- DROP TABLE Venta;
-- DROP TABLE Factura;
-- DROP TABLE Vestimenta;
-- DROP TABLE PanelSolar;
-- DROP TABLE Automovil;
-- DROP TABLE Producto;
-- DROP TABLE MedioPago;
-- DROP TABLE Usuario;
-- DROP TABLE Mercado;


-- TABLES

CREATE TABLE Mercado (
	id NUMBER(10) PRIMARY KEY,
	pais VARCHAR(50) NOT NULL,
	idioma VARCHAR(50) NOT NULL,
    UNIQUE (pais, idioma)
);

CREATE TABLE Usuario (
	email VARCHAR(50) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    idMercado NUMBER(10) NOT NULL REFERENCES Mercado (id),
    fechaCreacion DATE NOT NULL,
    telefonoRecuperarCuenta NUMBER(10),
    emailRecuperarCuenta VARCHAR(50),
	CHECK ((telefonoRecuperarCuenta IS NULL AND emailRecuperarCuenta IS NOT NULL) OR (telefonoRecuperarCuenta IS NOT NULL AND emailRecuperarCuenta IS NULL))
);

CREATE TABLE MedioPago (
    codigo VARCHAR(50) PRIMARY KEY,
    tipo VARCHAR(7) NOT NULL CHECK (tipo IN ('CREDITO', 'CRYPTO')),
    emailUsuario VARCHAR(50) NOT NULL REFERENCES Usuario (email)
);

CREATE TABLE Producto (
	id NUMBER(10) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	precio NUMBER(8) NOT NULL,
	stock NUMBER(5) NOT NULL
);


CREATE TABLE Automovil (
    id NUMBER(10) PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    anoDeLanzamiento NUMBER(4) NOT NULL,
    autonomiaHoras NUMBER(5) NOT NULL,
    potenciaEnAmperiosHora NUMBER(5) NOT NULL,
    FOREIGN KEY (id) REFERENCES Producto (id)
);

CREATE TABLE PanelSolar (
    id NUMBER(10) PRIMARY KEY,
    largo NUMBER(2) NOT NULL,
    ancho NUMBER(2) NOT NULL,
    voltaje NUMBER(3) NOT NULL CHECK (voltaje IN (12, 24, 110, 230)),
    FOREIGN KEY (id) REFERENCES Producto (id)
);

CREATE TABLE Vestimenta (
    id NUMBER(10) PRIMARY KEY,
    tipo VARCHAR(8) NOT NULL CHECK (tipo IN ('PANTALON', 'REMERA', 'CAMPERA')),
    color VARCHAR(50) NOT NULL,
    talle VARCHAR(3) NOT NULL CHECK (talle IN ('S', 'M', 'XL', 'XXL')),
    FOREIGN KEY (id) REFERENCES Producto (id)
);

CREATE TABLE Factura (
	id NUMBER(10) PRIMARY KEY,
	total NUMBER(10) NOT NULL,
    fecha DATE NOT NULL,
	emailUsuario VARCHAR(50) NOT NULL REFERENCES Usuario (email),
	codigoMedioPago VARCHAR(50) NOT NULL REFERENCES MedioPago (codigo)
);

CREATE TABLE Venta (
	idFactura NUMBER(10) REFERENCES Factura (id),
	idProducto NUMBER(10) REFERENCES Producto (id),
    cantidad NUMBER(5) NOT NULL,
	subtotal NUMBER(8) NOT NULL,
	numeroDeSerie VARCHAR(50),
	PRIMARY KEY (idFactura, idProducto)
);
