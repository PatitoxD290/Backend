-- Verificar si la base de datos existe y, si no, crearla
CREATE DATABASE IF NOT EXISTS bd_kym;
USE bd_kym;

-- Estructura de tabla para la tabla `categoria`
CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` INT(11) NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en `categoria`
INSERT INTO `categoria` (`id_categoria`, `categoria`) VALUES
(1, 'Estudiantil'),
(2, 'Deportiva'),
(3, 'Personalizada'),
(4, 'Casual'),
(5, 'Gala');

-- Estructura de tabla para la tabla `cliente`
CREATE TABLE IF NOT EXISTS `cliente` (
  `id_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(50) DEFAULT NULL,
  `apellidos` VARCHAR(50) DEFAULT NULL,
  `telefono` VARCHAR(9) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Estructura de tabla para la tabla `contrato`
CREATE TABLE IF NOT EXISTS `contrato` (
  `id_contrato` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` TEXT NOT NULL,
  `id_cliente` INT(11) DEFAULT NULL,
  `referencia_diseño` VARCHAR(50) DEFAULT NULL,
  `estado` ENUM('Activo','Pendiente','Finalizado','Rechazado') DEFAULT NULL,
  `fecha_inicio` DATE NOT NULL,
  PRIMARY KEY (`id_contrato`),
  FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Estructura de tabla para la tabla `producto`
CREATE TABLE IF NOT EXISTS `producto` (
  `id_producto` INT(11) NOT NULL AUTO_INCREMENT,
  `producto` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `costo` DECIMAL(10,2) NOT NULL,
  `id_categoria` INT(11) DEFAULT NULL,
  `material` VARCHAR(100) DEFAULT NULL,
  `estado` ENUM('Disponible','Agotado') DEFAULT 'Disponible',
  PRIMARY KEY (`id_producto`),
  FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insertar datos en `producto`
INSERT INTO `producto` (`id_producto`, `producto`, `descripcion`, `precio`, `costo`, `id_categoria`, `material`, `estado`) VALUES
(1, 'Short Deportivo', 'Ideal para entrenamientos y actividades físicas. Confeccionado en tela liviana, transpirable y de secado rápido para máxima comodidad.', 25.00, 20.00, 2, 'Algodón', 'Disponible'),
(2, 'Polo Deportivo', 'Diseñado para el deporte y la movilidad. Hecho con materiales elásticos que permiten libertad de movimiento y absorción del sudor.', 35.00, 30.00, 2, 'Algodón', 'Disponible'),
(3, 'Conjunto Deportivo', 'Conjunto completo de polo y short, perfecto para deportes o actividades escolares. Comodidad y estilo en una sola prenda.', 55.00, 50.00, 2, 'Algodón', 'Disponible'),
(4, 'Short De Vestir', 'Corte moderno y elegante, perfecto para eventos formales o escolares. Tela resistente con acabado fino.', 20.00, 15.00, 4, 'Algodón', 'Disponible'),
(5, 'Polo De Vestir', 'Estilo clásico para uniformes escolares o institucionales. Su tejido suave garantiza comodidad durante todo el día.', 30.00, 25.00, 4, 'Algodón', 'Disponible'),
(6, 'Polo Estudiantil', 'Prenda básica para el uniforme escolar, con cuello clásico y costuras reforzadas. Resistente al uso diario y fácil de lavar.', 40.00, 30.00, 1, 'Algodón', 'Disponible'),
(7, 'Camisa Estudiantil', 'Camisa formal para uniforme escolar. Corte estructurado y tela fresca, ideal para mantener una apariencia pulcra.', 45.00, 35.00, 1, 'Algodón', 'Disponible'),
(8, 'Polo Personalizado', 'Polo personalizable con el logo o diseño de tu institución o evento. Disponible en varios colores, materiales y tallas.', 50.00, 40.00, 3, 'Algodón', 'Disponible'),
(9, 'Vestido De Gala', 'Diseño elegante para eventos especiales o presentaciones. Confección fina y acabado detallado para un look distinguido.', 80.00, 70.00, 5, 'Algodón', 'Disponible');

-- Estructura de tabla para la tabla `stock`
CREATE TABLE IF NOT EXISTS `stock` (
  `id_stock` INT(11) NOT NULL AUTO_INCREMENT,
  `fecha_actualizacion` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_stock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- Estructura de tabla para la tabla `ventas`
CREATE TABLE IF NOT EXISTS `ventas` (
  `id_ventas` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) DEFAULT NULL,
  `lugar_entrega` VARCHAR(255) DEFAULT NULL,
  `total` DECIMAL(10,2) DEFAULT NULL,
  `fecha` DATE DEFAULT CURDATE(),
  `hora` TIME DEFAULT CURTIME(),
  PRIMARY KEY (`id_ventas`),
  FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Estructura de tabla para la tabla `ventas_detalle`
CREATE TABLE IF NOT EXISTS `ventas_detalle` (
  `id_ventas_detalle` INT(11) NOT NULL AUTO_INCREMENT,
  `id_ventas` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  PRIMARY KEY (`id_ventas_detalle`),
  FOREIGN KEY (`id_ventas`) REFERENCES `ventas` (`id_ventas`),
  FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
