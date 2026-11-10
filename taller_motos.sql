CREATE DATABASE IF NOT EXISTS taller_motos
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE taller_motos;
CREATE TABLE CLIENTE (
    id_cliente   INT          NOT NULL AUTO_INCREMENT,
    cedula       VARCHAR(10)  NOT NULL,
    nombres      VARCHAR(60)  NOT NULL,
    apellidos    VARCHAR(60)  NOT NULL,
    telefono     VARCHAR(15),
    correo       VARCHAR(80),
    direccion    VARCHAR(120),
    PRIMARY KEY (id_cliente),
    UNIQUE (cedula)
);

CREATE TABLE MOTO (
    id_moto      INT          NOT NULL AUTO_INCREMENT,
    placa        VARCHAR(8)   NOT NULL,
    marca        VARCHAR(30)  NOT NULL,
    modelo       VARCHAR(40)  NOT NULL,
    anio         SMALLINT     NOT NULL,
    cilindraje   SMALLINT     NOT NULL,
    color        VARCHAR(20),
    id_cliente   INT          NOT NULL,
    PRIMARY KEY (id_moto),
    UNIQUE (placa),
    CHECK (anio >= 1990),
    CHECK (cilindraje > 0),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE MECANICO (
    id_mecanico    INT          NOT NULL AUTO_INCREMENT,
    cedula         VARCHAR(10)  NOT NULL,
    nombres        VARCHAR(60)  NOT NULL,
    apellidos      VARCHAR(60)  NOT NULL,
    especialidad   VARCHAR(50)  NOT NULL,
    fecha_ingreso  DATE         NOT NULL,
    PRIMARY KEY (id_mecanico),
    UNIQUE (cedula)
);

CREATE TABLE PROVEEDOR (
    id_proveedor INT          NOT NULL AUTO_INCREMENT,
    ruc          VARCHAR(13)  NOT NULL,
    nombre       VARCHAR(80)  NOT NULL,
    telefono     VARCHAR(15),
    ciudad       VARCHAR(40),
    PRIMARY KEY (id_proveedor),
    UNIQUE (ruc)
);

CREATE TABLE REPUESTO (
    id_repuesto     INT           NOT NULL AUTO_INCREMENT,
    codigo          VARCHAR(10)   NOT NULL,
    nombre          VARCHAR(80)   NOT NULL,
    stock           INT           NOT NULL DEFAULT 0,
    precio_unitario DECIMAL(8,2)  NOT NULL,
    id_proveedor    INT           NOT NULL,
    PRIMARY KEY (id_repuesto),
    UNIQUE (codigo),
    CHECK (stock >= 0),
    CHECK (precio_unitario > 0),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor)
);

CREATE TABLE SERVICIO (
    id_servicio       INT           NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(80)   NOT NULL,
    tipo              VARCHAR(12)   NOT NULL,
    precio_mano_obra  DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (id_servicio),
    UNIQUE (nombre),
    CHECK (tipo IN ('Preventivo', 'Correctivo')),
    CHECK (precio_mano_obra > 0)
);

CREATE TABLE ORDEN_SERVICIO (
    id_orden       INT          NOT NULL AUTO_INCREMENT,
    fecha_ingreso  DATE         NOT NULL,
    fecha_entrega  DATE,
    estado         VARCHAR(12)  NOT NULL DEFAULT 'Pendiente',
    observaciones  VARCHAR(150),
    id_moto        INT          NOT NULL,
    id_mecanico    INT          NOT NULL,
    PRIMARY KEY (id_orden),
    CHECK (estado IN ('Pendiente', 'En proceso', 'Entregada')),
    CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_ingreso),
    FOREIGN KEY (id_moto)     REFERENCES MOTO(id_moto),
    FOREIGN KEY (id_mecanico) REFERENCES MECANICO(id_mecanico)
);

CREATE TABLE DETALLE_SERVICIO (
    id_orden        INT           NOT NULL,
    id_servicio     INT           NOT NULL,
    precio_aplicado DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (id_orden, id_servicio),
    FOREIGN KEY (id_orden)    REFERENCES ORDEN_SERVICIO(id_orden),
    FOREIGN KEY (id_servicio) REFERENCES SERVICIO(id_servicio)
);

CREATE TABLE DETALLE_REPUESTO (
    id_orden        INT           NOT NULL,
    id_repuesto     INT           NOT NULL,
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (id_orden, id_repuesto),
    CHECK (cantidad > 0),
    FOREIGN KEY (id_orden)    REFERENCES ORDEN_SERVICIO(id_orden),
    FOREIGN KEY (id_repuesto) REFERENCES REPUESTO(id_repuesto)
);
