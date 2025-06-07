-- Verificar si la base de datos existe y, si no, crearla
CREATE DATABASE IF NOT EXISTS bd_kym;
USE bd_kym;


-- Log para categoria
CREATE TABLE IF NOT EXISTS categoria_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para cliente
CREATE TABLE IF NOT EXISTS cliente_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para contrato
CREATE TABLE IF NOT EXISTS contrato_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes TEXT,
    ValorDespues TEXT,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para producto
CREATE TABLE IF NOT EXISTS producto_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes TEXT,
    ValorDespues TEXT,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para stock
CREATE TABLE IF NOT EXISTS stock_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para stock_detalle
CREATE TABLE IF NOT EXISTS stock_detalle_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para usuario
CREATE TABLE IF NOT EXISTS usuario_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para ventas
CREATE TABLE IF NOT EXISTS ventas_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log para ventas_detalle
CREATE TABLE IF NOT EXISTS ventas_detalle_Log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1),
    Tabla VARCHAR(50),
    Registro INT,
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de logs para registrar cambios en la tabla comprasusuario
CREATE TABLE IF NOT EXISTS comprasusuario_log (
    Id_log INT PRIMARY KEY AUTO_INCREMENT,
    Tipo CHAR(1), -- 'I' = Insert, 'U' = Update, 'D' = Delete
    Tabla VARCHAR(50),
    Registro INT, -- id_comprasusuario
    Campo VARCHAR(50),
    ValorAntes VARCHAR(255),
    ValorDespues VARCHAR(255),
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Estructura de tabla para la tabla `categoria`
CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` INT(11) NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER trCategoriaInsert
AFTER INSERT ON categoria
FOR EACH ROW
BEGIN
    INSERT INTO categoria_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'categoria', NEW.id_categoria, 'id_categoria', NULL, CAST(NEW.id_categoria AS CHAR), NOW()),
    ('I', 'categoria', NEW.id_categoria, 'categoria', NULL, NEW.categoria, NOW());
END $$

CREATE TRIGGER trCategoriaUpdate
AFTER UPDATE ON categoria
FOR EACH ROW
BEGIN
    INSERT INTO categoria_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'categoria', OLD.id_categoria, 'id_categoria', CAST(OLD.id_categoria AS CHAR), CAST(NEW.id_categoria AS CHAR), NOW()),
    ('U', 'categoria', OLD.id_categoria, 'categoria', OLD.categoria, NEW.categoria, NOW());
END $$

CREATE TRIGGER trCategoriaDelete
AFTER DELETE ON categoria
FOR EACH ROW
BEGIN
    INSERT INTO categoria_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'categoria', OLD.id_categoria, 'id_categoria', CAST(OLD.id_categoria AS CHAR), NULL, NOW()),
    ('D', 'categoria', OLD.id_categoria, 'categoria', OLD.categoria, NULL, NOW());
END $$

DELIMITER ;

-- Insertar datos en `categoria`
INSERT INTO `categoria` (`id_categoria`, `categoria`) VALUES
(1, 'Estudiantil'),
(2, 'Deportiva'),
(3, 'Personalizada'),
(4, 'Casual'),
(5, 'Gala');

CREATE TABLE IF NOT EXISTS `cliente` (
  `id_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(50) DEFAULT NULL,
  `apellidos` VARCHAR(50) DEFAULT NULL,
  `telefono` VARCHAR(9) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `dni` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

-- Trigger para Insertar un nuevo cliente
CREATE TRIGGER trClienteInsert
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'cliente', NEW.id_cliente, 'id_cliente', NULL, CAST(NEW.id_cliente AS CHAR), NOW()),
    ('I', 'cliente', NEW.id_cliente, 'nombres', NULL, NEW.nombres, NOW()),
    ('I', 'cliente', NEW.id_cliente, 'apellidos', NULL, NEW.apellidos, NOW()),
    ('I', 'cliente', NEW.id_cliente, 'telefono', NULL, NEW.telefono, NOW()),
    ('I', 'cliente', NEW.id_cliente, 'direccion', NULL, NEW.direccion, NOW()),
    ('I', 'cliente', NEW.id_cliente, 'dni', NULL, NEW.dni, NOW());
END $$

-- Trigger para Actualizar los datos de un cliente
CREATE TRIGGER trClienteUpdate
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'cliente', OLD.id_cliente, 'id_cliente', CAST(OLD.id_cliente AS CHAR), CAST(NEW.id_cliente AS CHAR), NOW()),
    ('U', 'cliente', OLD.id_cliente, 'nombres', OLD.nombres, NEW.nombres, NOW()),
    ('U', 'cliente', OLD.id_cliente, 'apellidos', OLD.apellidos, NEW.apellidos, NOW()),
    ('U', 'cliente', OLD.id_cliente, 'telefono', OLD.telefono, NEW.telefono, NOW()),
    ('U', 'cliente', OLD.id_cliente, 'direccion', OLD.direccion, NEW.direccion, NOW()),
    ('U', 'cliente', OLD.id_cliente, 'dni', OLD.dni, NEW.dni, NOW()); 
END $$

-- Trigger para Eliminar un cliente
CREATE TRIGGER trClienteDelete
AFTER DELETE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'cliente', OLD.id_cliente, 'id_cliente', CAST(OLD.id_cliente AS CHAR), NULL, NOW()),
    ('D', 'cliente', OLD.id_cliente, 'nombres', OLD.nombres, NULL, NOW()),
    ('D', 'cliente', OLD.id_cliente, 'apellidos', OLD.apellidos, NULL, NOW()),
    ('D', 'cliente', OLD.id_cliente, 'telefono', OLD.telefono, NULL, NOW()),
    ('D', 'cliente', OLD.id_cliente, 'direccion', OLD.direccion, NULL, NOW()),
    ('D', 'cliente', OLD.id_cliente, 'dni', OLD.dni, NULL, NOW());
END $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `producto` (
  `id_producto` INT(11) NOT NULL AUTO_INCREMENT,
  `producto` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `costo` DECIMAL(10,2) NOT NULL,
  `id_categoria` INT(11) DEFAULT NULL,
  `material` VARCHAR(100) DEFAULT NULL,
  `genero` ENUM('Mujer', 'Hombre') DEFAULT NULL,  -- Género del producto
  `edad` ENUM('Niños', 'Adolescentes', 'Adultos') DEFAULT NULL,  -- Edad recomendada para el producto
  `estado` ENUM('Disponible','Agotado') DEFAULT 'Disponible',
  PRIMARY KEY (`id_producto`),
  FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER trProductoInsert
AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'producto', NEW.id_producto, 'id_producto', NULL, CAST(NEW.id_producto AS CHAR), NOW()),
    ('I', 'producto', NEW.id_producto, 'producto', NULL, NEW.producto, NOW()),
    ('I', 'producto', NEW.id_producto, 'descripcion', NULL, NEW.descripcion, NOW()),
    ('I', 'producto', NEW.id_producto, 'precio', NULL, CAST(NEW.precio AS CHAR), NOW()),
    ('I', 'producto', NEW.id_producto, 'costo', NULL, CAST(NEW.costo AS CHAR), NOW()),
    ('I', 'producto', NEW.id_producto, 'id_categoria', NULL, CAST(NEW.id_categoria AS CHAR), NOW()),
    ('I', 'producto', NEW.id_producto, 'material', NULL, NEW.material, NOW()),
    ('I', 'producto', NEW.id_producto, 'genero', NULL, NEW.genero, NOW()),  -- Registro del género
    ('I', 'producto', NEW.id_producto, 'edad', NULL, NEW.edad, NOW()),  -- Registro de la edad
    ('I', 'producto', NEW.id_producto, 'estado', NULL, NEW.estado, NOW());
END $$

CREATE TRIGGER trProductoUpdate
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'producto', OLD.id_producto, 'id_producto', CAST(OLD.id_producto AS CHAR), CAST(NEW.id_producto AS CHAR), NOW()),
    ('U', 'producto', OLD.id_producto, 'producto', OLD.producto, NEW.producto, NOW()),
    ('U', 'producto', OLD.id_producto, 'descripcion', OLD.descripcion, NEW.descripcion, NOW()),
    ('U', 'producto', OLD.id_producto, 'precio', CAST(OLD.precio AS CHAR), CAST(NEW.precio AS CHAR), NOW()),
    ('U', 'producto', OLD.id_producto, 'costo', CAST(OLD.costo AS CHAR), CAST(NEW.costo AS CHAR), NOW()),
    ('U', 'producto', OLD.id_producto, 'id_categoria', CAST(OLD.id_categoria AS CHAR), CAST(NEW.id_categoria AS CHAR), NOW()),
    ('U', 'producto', OLD.id_producto, 'material', OLD.material, NEW.material, NOW()),
    ('U', 'producto', OLD.id_producto, 'genero', OLD.genero, NEW.genero, NOW()),  -- Actualización del género
    ('U', 'producto', OLD.id_producto, 'edad', OLD.edad, NEW.edad, NOW()),  -- Actualización de la edad
    ('U', 'producto', OLD.id_producto, 'estado', OLD.estado, NEW.estado, NOW());
END $$

CREATE TRIGGER trProductoDelete
AFTER DELETE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'producto', OLD.id_producto, 'id_producto', CAST(OLD.id_producto AS CHAR), NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'producto', OLD.producto, NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'descripcion', OLD.descripcion, NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'precio', CAST(OLD.precio AS CHAR), NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'costo', CAST(OLD.costo AS CHAR), NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'id_categoria', CAST(OLD.id_categoria AS CHAR), NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'material', OLD.material, NULL, NOW()),
    ('D', 'producto', OLD.id_producto, 'genero', OLD.genero, NULL, NOW()),  -- Eliminación del género
    ('D', 'producto', OLD.id_producto, 'edad', OLD.edad, NULL, NOW()),  -- Eliminación de la edad
    ('D', 'producto', OLD.id_producto, 'estado', OLD.estado, NULL, NOW());
END $$

DELIMITER ;

-- Insertar datos en `producto`
INSERT INTO `producto` 
(`id_producto`, `producto`, `descripcion`, `precio`, `costo`, `id_categoria`, `material`, `genero`, `edad`, `estado`) 
VALUES
(1, 'Short Deportivo', 'Ideal para entrenamientos y actividades físicas. Confeccionado en tela liviana, transpirable y de secado rápido para máxima comodidad.', 25.00, 20.00, 2, 'Algodón', 'Hombre', 'Adolescentes', 'Disponible'),
(2, 'Polo Deportivo', 'Diseñado para el deporte y la movilidad. Hecho con materiales elásticos que permiten libertad de movimiento y absorción del sudor.', 35.00, 30.00, 2, 'Algodón', 'Mujer', 'Adolescentes', 'Disponible'),
(3, 'Conjunto Deportivo', 'Conjunto completo de polo y short, perfecto para deportes o actividades escolares. Comodidad y estilo en una sola prenda.', 55.00, 50.00, 2, 'Algodón', 'Hombre', 'Niños', 'Disponible'),
(4, 'Short De Vestir', 'Corte moderno y elegante, perfecto para eventos formales o escolares. Tela resistente con acabado fino.', 22.00, 15.00, 4, 'Algodón', 'Hombre', 'Adultos', 'Disponible'),
(5, 'Polo De Vestir', 'Estilo clásico para uniformes escolares o institucionales. Su tejido suave garantiza comodidad durante todo el día.', 30.00, 25.00, 4, 'Algodón', 'Mujer', 'Adultos', 'Disponible'),
(6, 'Polo Estudiantil', 'Prenda básica para el uniforme escolar, con cuello clásico y costuras reforzadas. Resistente al uso diario y fácil de lavar.', 40.00, 30.00, 1, 'Algodón', 'Hombre', 'Niños', 'Disponible'),
(7, 'Camisa Estudiantil', 'Camisa formal para uniforme escolar. Corte estructurado y tela fresca, ideal para mantener una apariencia pulcra.', 45.00, 35.00, 1, 'Algodón', 'Hombre', 'Adolescentes', 'Disponible'),
(8, 'Polo Personalizado', 'Polo personalizable con el logo o diseño de tu institución o evento. Disponible en varios colores, materiales y tallas.', 50.00, 40.00, 3, 'Algodón', 'Mujer', 'Adultos', 'Disponible'),
(9, 'Vestido De Gala', 'Diseño elegante para eventos especiales o presentaciones. Confección fina y acabado detallado para un look distinguido.', 80.00, 70.00, 5, 'Algodón', 'Mujer', 'Adultos', 'Disponible');

-- Estructura de tabla para la tabla `stock`
CREATE TABLE IF NOT EXISTS `stock` (
  `id_stock` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha_actualizacion` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_stock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER trStockInsert
AFTER INSERT ON stock
FOR EACH ROW
BEGIN
    INSERT INTO stock_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'stock', NEW.id_stock, 'id_stock', NULL, CAST(NEW.id_stock AS CHAR), NOW()),
    ('I', 'stock', NEW.id_stock, 'fecha_actualizacion', NULL, CAST(NEW.fecha_actualizacion AS CHAR), NOW());
END $$

CREATE TRIGGER trStockUpdate
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
    INSERT INTO stock_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'stock', OLD.id_stock, 'id_stock', CAST(OLD.id_stock AS CHAR), CAST(NEW.id_stock AS CHAR), NOW()),
    ('U', 'stock', OLD.id_stock, 'fecha_actualizacion', CAST(OLD.fecha_actualizacion AS CHAR), CAST(NEW.fecha_actualizacion AS CHAR), NOW());
END $$

CREATE TRIGGER trStockDelete
AFTER DELETE ON stock
FOR EACH ROW
BEGIN
    INSERT INTO stock_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'stock', OLD.id_stock, 'id_stock', CAST(OLD.id_stock AS CHAR), NULL, NOW()),
    ('D', 'stock', OLD.id_stock, 'fecha_actualizacion', CAST(OLD.fecha_actualizacion AS CHAR), NULL, NOW());
END $$

DELIMITER ;

-- Insertar datos en `stock`
INSERT INTO `stock` (`id_stock`, `fecha_actualizacion`) VALUES
(1, '2025-05-07 05:00:00');

-- Estructura de tabla para la tabla `stock_detalle`
CREATE TABLE IF NOT EXISTS `stock_detalle` (
  `id_stock_detalle` INT(11) NOT NULL AUTO_INCREMENT,
  `id_stock` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_stock_detalle`),
  FOREIGN KEY (`id_stock`) REFERENCES `stock` (`id_stock`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER trStockDetalleInsert
AFTER INSERT ON stock_detalle
FOR EACH ROW
BEGIN
    INSERT INTO stock_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'stock_detalle', NEW.id_stock_detalle, 'id_stock_detalle', NULL, CAST(NEW.id_stock_detalle AS CHAR), NOW()),
    ('I', 'stock_detalle', NEW.id_stock_detalle, 'id_stock', NULL, CAST(NEW.id_stock AS CHAR), NOW()),
    ('I', 'stock_detalle', NEW.id_stock_detalle, 'id_producto', NULL, CAST(NEW.id_producto AS CHAR), NOW()),
    ('I', 'stock_detalle', NEW.id_stock_detalle, 'cantidad', NULL, CAST(NEW.cantidad AS CHAR), NOW());
END $$

CREATE TRIGGER trStockDetalleUpdate
AFTER UPDATE ON stock_detalle
FOR EACH ROW
BEGIN
    INSERT INTO stock_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'stock_detalle', OLD.id_stock_detalle, 'id_stock_detalle', CAST(OLD.id_stock_detalle AS CHAR), CAST(NEW.id_stock_detalle AS CHAR), NOW()),
    ('U', 'stock_detalle', OLD.id_stock_detalle, 'id_stock', CAST(OLD.id_stock AS CHAR), CAST(NEW.id_stock AS CHAR), NOW()),
    ('U', 'stock_detalle', OLD.id_stock_detalle, 'id_producto', CAST(OLD.id_producto AS CHAR), CAST(NEW.id_producto AS CHAR), NOW()),
    ('U', 'stock_detalle', OLD.id_stock_detalle, 'cantidad', CAST(OLD.cantidad AS CHAR), CAST(NEW.cantidad AS CHAR), NOW());
END $$

CREATE TRIGGER trStockDetalleDelete
AFTER DELETE ON stock_detalle
FOR EACH ROW
BEGIN
    INSERT INTO stock_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'stock_detalle', OLD.id_stock_detalle, 'id_stock_detalle', CAST(OLD.id_stock_detalle AS CHAR), NULL, NOW()),
    ('D', 'stock_detalle', OLD.id_stock_detalle, 'id_stock', CAST(OLD.id_stock AS CHAR), NULL, NOW()),
    ('D', 'stock_detalle', OLD.id_stock_detalle, 'id_producto', CAST(OLD.id_producto AS CHAR), NULL, NOW()),
    ('D', 'stock_detalle', OLD.id_stock_detalle, 'cantidad', CAST(OLD.cantidad AS CHAR), NULL, NOW());
END $$

DELIMITER ;

-- Insertar datos en `stock_detalle`
INSERT INTO `stock_detalle` (`id_stock_detalle`, `id_stock`, `id_producto`, `cantidad`) VALUES
(1, 1, 1, 100),
(2, 1, 2, 100),
(3, 1, 3, 100),
(4, 1, 4, 100),
(5, 1, 5, 100),
(6, 1, 6, 100),
(7, 1, 7, 100),
(8, 1, 8, 100),
(9, 1, 9, 100);

-- Estructura de tabla para la tabla `usuario`
CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) DEFAULT NULL,
  `user` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  `updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

-- INSERT
CREATE TRIGGER trUsuarioInsert
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO usuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'usuario', NEW.id_usuario, 'id_usuario', NULL, CAST(NEW.id_usuario AS CHAR), NOW()),
    ('I', 'usuario', NEW.id_usuario, 'id_cliente', NULL, CAST(NEW.id_cliente AS CHAR), NOW()),
    ('I', 'usuario', NEW.id_usuario, 'user', NULL, NEW.user, NOW()),
    ('I', 'usuario', NEW.id_usuario, 'email', NULL, NEW.email, NOW()),
    ('I', 'usuario', NEW.id_usuario, 'password', NULL, NEW.password, NOW());
END $$

-- UPDATE
CREATE TRIGGER trUsuarioUpdate
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO usuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'usuario', OLD.id_usuario, 'id_usuario', CAST(OLD.id_usuario AS CHAR), CAST(NEW.id_usuario AS CHAR), NOW()),
    ('U', 'usuario', OLD.id_usuario, 'id_cliente', CAST(OLD.id_cliente AS CHAR), CAST(NEW.id_cliente AS CHAR), NOW()),
    ('U', 'usuario', OLD.id_usuario, 'user', OLD.user, NEW.user, NOW()),
    ('U', 'usuario', OLD.id_usuario, 'email', OLD.email, NEW.email, NOW()),
    ('U', 'usuario', OLD.id_usuario, 'password', OLD.password, NEW.password, NOW());
END $$

-- DELETE
CREATE TRIGGER trUsuarioDelete
AFTER DELETE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO usuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'usuario', OLD.id_usuario, 'id_usuario', CAST(OLD.id_usuario AS CHAR), NULL, NOW()),
    ('D', 'usuario', OLD.id_usuario, 'id_cliente', CAST(OLD.id_cliente AS CHAR), NULL, NOW()),
    ('D', 'usuario', OLD.id_usuario, 'user', OLD.user, NULL, NOW()),
    ('D', 'usuario', OLD.id_usuario, 'email', OLD.email, NULL, NOW()),
    ('D', 'usuario', OLD.id_usuario, 'password', OLD.password, NULL, NOW());
END $$

DELIMITER ;

-- Estructura de tabla para la tabla `contrato`
CREATE TABLE IF NOT EXISTS `contrato` (
  `id_contrato` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` TEXT NOT NULL,
  `id_usuario` INT(11) DEFAULT NULL,
  `referencia_diseño` VARCHAR(1000) DEFAULT NULL,
  `estado` ENUM('Activo','Pendiente','Finalizado','Rechazado') NOT NULL DEFAULT 'Pendiente',
  `fecha_inicio` DATE NOT NULL,
  PRIMARY KEY (`id_contrato`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

CREATE TRIGGER trContratoInsert
AFTER INSERT ON contrato
FOR EACH ROW
BEGIN
    INSERT INTO contrato_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'contrato', NEW.id_contrato, 'id_contrato', NULL, CAST(NEW.id_contrato AS CHAR), NOW()),
    ('I', 'contrato', NEW.id_contrato, 'descripcion', NULL, NEW.descripcion, NOW()),
    ('I', 'contrato', NEW.id_contrato, 'id_usuario', NULL, CAST(NEW.id_usuario AS CHAR), NOW()),
    ('I', 'contrato', NEW.id_contrato, 'referencia_diseño', NULL, NEW.referencia_diseño, NOW()),
    ('I', 'contrato', NEW.id_contrato, 'estado', NULL, NEW.estado, NOW()),
    ('I', 'contrato', NEW.id_contrato, 'fecha_inicio', NULL, CAST(NEW.fecha_inicio AS CHAR), NOW());
END $$

CREATE TRIGGER trContratoUpdate
AFTER UPDATE ON contrato
FOR EACH ROW
BEGIN
    INSERT INTO contrato_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'contrato', OLD.id_contrato, 'id_contrato', CAST(OLD.id_contrato AS CHAR), CAST(NEW.id_contrato AS CHAR), NOW()),
    ('U', 'contrato', OLD.id_contrato, 'descripcion', OLD.descripcion, NEW.descripcion, NOW()),
    ('U', 'contrato', OLD.id_contrato, 'id_usuario', CAST(OLD.id_usuario AS CHAR), CAST(NEW.id_usuario AS CHAR), NOW()),
    ('U', 'contrato', OLD.id_contrato, 'referencia_diseño', OLD.referencia_diseño, NEW.referencia_diseño, NOW()),
    ('U', 'contrato', OLD.id_contrato, 'estado', OLD.estado, NEW.estado, NOW()),
    ('U', 'contrato', OLD.id_contrato, 'fecha_inicio', CAST(OLD.fecha_inicio AS CHAR), CAST(NEW.fecha_inicio AS CHAR), NOW());
END $$

CREATE TRIGGER trContratoDelete
AFTER DELETE ON contrato
FOR EACH ROW
BEGIN
    INSERT INTO contrato_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'contrato', OLD.id_contrato, 'id_contrato', CAST(OLD.id_contrato AS CHAR), NULL, NOW()),
    ('D', 'contrato', OLD.id_contrato, 'descripcion', OLD.descripcion, NULL, NOW()),
    ('D', 'contrato', OLD.id_contrato, 'id_usuario', CAST(OLD.id_usuario AS CHAR), NULL, NOW()),
    ('D', 'contrato', OLD.id_contrato, 'referencia_diseño', OLD.referencia_diseño, NULL, NOW()),
    ('D', 'contrato', OLD.id_contrato, 'estado', OLD.estado, NULL, NOW()),
    ('D', 'contrato', OLD.id_contrato, 'fecha_inicio', CAST(OLD.fecha_inicio AS CHAR), NULL, NOW());
END $$

DELIMITER ;

-- Estructura de tabla para la tabla `ventas`
CREATE TABLE IF NOT EXISTS `ventas` (
  `id_ventas` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) DEFAULT NULL,
  `lugar_entrega` VARCHAR(255) DEFAULT NULL,
  `total` DECIMAL(10,2) DEFAULT NULL,
  `forma_pago` VARCHAR(50) DEFAULT NULL,
  `fecha` DATE DEFAULT CURDATE(),
  `hora` TIME DEFAULT CURTIME(),
  PRIMARY KEY (`id_ventas`),
  FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Trigger para INSERT
DELIMITER $$

CREATE TRIGGER trVentasInsert
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO ventas_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'ventas', NEW.id_ventas, 'id_ventas', NULL, NEW.id_ventas, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'id_cliente', NULL, NEW.id_cliente, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'lugar_entrega', NULL, NEW.lugar_entrega, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'total', NULL, NEW.total, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'forma_pago', NULL, NEW.forma_pago, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'fecha', NULL, NEW.fecha, NOW()),
    ('I', 'ventas', NEW.id_ventas, 'hora', NULL, NEW.hora, NOW());
END $$

-- Trigger para UPDATE
CREATE TRIGGER trVentasUpdate
AFTER UPDATE ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO ventas_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'ventas', OLD.id_ventas, 'id_ventas', OLD.id_ventas, NEW.id_ventas, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'id_cliente', OLD.id_cliente, NEW.id_cliente, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'lugar_entrega', OLD.lugar_entrega, NEW.lugar_entrega, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'total', OLD.total, NEW.total, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'forma_pago', OLD.forma_pago, NEW.forma_pago, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'fecha', OLD.fecha, NEW.fecha, NOW()),
    ('U', 'ventas', OLD.id_ventas, 'hora', OLD.hora, NEW.hora, NOW());
END $$

-- Trigger para DELETE
CREATE TRIGGER trVentasDelete
AFTER DELETE ON ventas
FOR EACH ROW
BEGIN
    INSERT INTO ventas_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'ventas', OLD.id_ventas, 'id_ventas', OLD.id_ventas, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'id_cliente', OLD.id_cliente, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'lugar_entrega', OLD.lugar_entrega, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'total', OLD.total, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'forma_pago', OLD.forma_pago, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'fecha', OLD.fecha, NULL, NOW()),
    ('D', 'ventas', OLD.id_ventas, 'hora', OLD.hora, NULL, NOW());
END $$

DELIMITER ;

-- Estructura de tabla para la tabla `ventas_detalle`
CREATE TABLE IF NOT EXISTS `ventas_detalle` (
  `id_ventas_detalle` INT(11) NOT NULL AUTO_INCREMENT,
  `id_ventas` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `tallas` VARCHAR(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`id_ventas_detalle`),
  FOREIGN KEY (`id_ventas`) REFERENCES `ventas` (`id_ventas`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

DELIMITER $$

-- 🔵 AFTER INSERT
CREATE TRIGGER trVentasDetalleInsert
AFTER INSERT ON ventas_detalle
FOR EACH ROW
BEGIN
    INSERT INTO ventas_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'ventas_detalle', NEW.id_ventas_detalle, 'id_ventas_detalle', NULL, CAST(NEW.id_ventas_detalle AS CHAR), NOW()),
    ('I', 'ventas_detalle', NEW.id_ventas_detalle, 'id_ventas', NULL, CAST(NEW.id_ventas AS CHAR), NOW()),
    ('I', 'ventas_detalle', NEW.id_ventas_detalle, 'id_producto', NULL, CAST(NEW.id_producto AS CHAR), NOW()),
    ('I', 'ventas_detalle', NEW.id_ventas_detalle, 'tallas', NULL, NEW.tallas, NOW()),
    ('I', 'ventas_detalle', NEW.id_ventas_detalle, 'cantidad', NULL, CAST(NEW.cantidad AS CHAR), NOW());
END $$

-- 🟠 AFTER UPDATE
CREATE TRIGGER trVentasDetalleUpdate
AFTER UPDATE ON ventas_detalle
FOR EACH ROW
BEGIN
    INSERT INTO ventas_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('U', 'ventas_detalle', OLD.id_ventas_detalle, 'id_ventas_detalle', CAST(OLD.id_ventas_detalle AS CHAR), CAST(NEW.id_ventas_detalle AS CHAR), NOW()),
    ('U', 'ventas_detalle', OLD.id_ventas_detalle, 'id_ventas', CAST(OLD.id_ventas AS CHAR), CAST(NEW.id_ventas AS CHAR), NOW()),
    ('U', 'ventas_detalle', OLD.id_ventas_detalle, 'id_producto', CAST(OLD.id_producto AS CHAR), CAST(NEW.id_producto AS CHAR), NOW()),
    ('U', 'ventas_detalle', OLD.id_ventas_detalle, 'tallas', OLD.tallas, NEW.tallas, NOW()),
    ('U', 'ventas_detalle', OLD.id_ventas_detalle, 'cantidad', CAST(OLD.cantidad AS CHAR), CAST(NEW.cantidad AS CHAR), NOW());
END $$

-- 🔴 AFTER DELETE
CREATE TRIGGER trVentasDetalleDelete
AFTER DELETE ON ventas_detalle
FOR EACH ROW
BEGIN
    INSERT INTO ventas_detalle_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'ventas_detalle', OLD.id_ventas_detalle, 'id_ventas_detalle', CAST(OLD.id_ventas_detalle AS CHAR), NULL, NOW()),
    ('D', 'ventas_detalle', OLD.id_ventas_detalle, 'id_ventas', CAST(OLD.id_ventas AS CHAR), NULL, NOW()),
    ('D', 'ventas_detalle', OLD.id_ventas_detalle, 'id_producto', CAST(OLD.id_producto AS CHAR), NULL, NOW()),
    ('D', 'ventas_detalle', OLD.id_ventas_detalle, 'tallas', OLD.tallas, NULL, NOW()),
    ('D', 'ventas_detalle', OLD.id_ventas_detalle, 'cantidad', CAST(OLD.cantidad AS CHAR), NULL, NOW());
END $$

DELIMITER ;


-- Tabla principal: relación de usuarios con ventas
CREATE TABLE IF NOT EXISTS `comprasusuario` (
  `id_comprasusuario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` INT(11),
  `id_ventas` INT(11),
  PRIMARY KEY (`id_comprasusuario`),
  FOREIGN KEY (`id_ventas`) REFERENCES `ventas` (`id_ventas`),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Cambio de delimitador para definir triggers
DELIMITER $$

-- Trigger para INSERT
CREATE TRIGGER trComprasUsuarioInsert
AFTER INSERT ON comprasusuario
FOR EACH ROW
BEGIN
    INSERT INTO comprasusuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('I', 'comprasusuario', NEW.id_comprasusuario, 'id_comprasusuario', NULL, CAST(NEW.id_comprasusuario AS CHAR), NOW()),
    ('I', 'comprasusuario', NEW.id_comprasusuario, 'id_usuario', NULL, CAST(NEW.id_usuario AS CHAR), NOW()),
    ('I', 'comprasusuario', NEW.id_comprasusuario, 'id_ventas', NULL, CAST(NEW.id_ventas AS CHAR), NOW());
END$$

-- Trigger para UPDATE
CREATE TRIGGER trComprasUsuarioUpdate
AFTER UPDATE ON comprasusuario
FOR EACH ROW
BEGIN
    IF OLD.id_comprasusuario <> NEW.id_comprasusuario THEN
        INSERT INTO comprasusuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha)
        VALUES ('U', 'comprasusuario', OLD.id_comprasusuario, 'id_comprasusuario', 
                CAST(OLD.id_comprasusuario AS CHAR), CAST(NEW.id_comprasusuario AS CHAR), NOW());
    END IF;

    IF OLD.id_usuario <> NEW.id_usuario THEN
        INSERT INTO comprasusuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha)
        VALUES ('U', 'comprasusuario', OLD.id_comprasusuario, 'id_usuario', 
                CAST(OLD.id_usuario AS CHAR), CAST(NEW.id_usuario AS CHAR), NOW());
    END IF;

    IF OLD.id_ventas <> NEW.id_ventas THEN
        INSERT INTO comprasusuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha)
        VALUES ('U', 'comprasusuario', OLD.id_comprasusuario, 'id_ventas', 
                CAST(OLD.id_ventas AS CHAR), CAST(NEW.id_ventas AS CHAR), NOW());
    END IF;
END$$

-- Trigger para DELETE
CREATE TRIGGER trComprasUsuarioDelete
AFTER DELETE ON comprasusuario
FOR EACH ROW
BEGIN
    INSERT INTO comprasusuario_log (Tipo, Tabla, Registro, Campo, ValorAntes, ValorDespues, Fecha) VALUES
    ('D', 'comprasusuario', OLD.id_comprasusuario, 'id_comprasusuario', CAST(OLD.id_comprasusuario AS CHAR), NULL, NOW()),
    ('D', 'comprasusuario', OLD.id_comprasusuario, 'id_usuario', CAST(OLD.id_usuario AS CHAR), NULL, NOW()),
    ('D', 'comprasusuario', OLD.id_comprasusuario, 'id_ventas', CAST(OLD.id_ventas AS CHAR), NULL, NOW());
END$$

-- Restaurar delimitador
DELIMITER ;

