-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.30 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para idgs804_galletas
CREATE DATABASE IF NOT EXISTS `idgs804_galletas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `idgs804_galletas`;

-- Volcando estructura para procedimiento idgs804_galletas.consultarTodos
DELIMITER //
CREATE PROCEDURE `consultarTodos`()
SELECT*FROM productos//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.envios
CREATE TABLE IF NOT EXISTS `envios` (
  `id_envio` int NOT NULL AUTO_INCREMENT,
  `id_venta` int DEFAULT NULL,
  `direccion` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_envio`),
  KEY `FK_envios_ventas` (`id_venta`),
  CONSTRAINT `FK_envios_ventas` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.envios: ~2 rows (aproximadamente)
INSERT INTO `envios` (`id_envio`, `id_venta`, `direccion`) VALUES
	(1, 1, 'miksasita'),
	(3, 22, 'mi kasita');

-- Volcando estructura para procedimiento idgs804_galletas.enviosInsert
DELIMITER //
CREATE PROCEDURE `enviosInsert`(
	IN `dir` VARCHAR(50)
)
INSERT INTO envios
(id_venta,direccion)
VALUES
((select MAX(id_venta) FROM ventas ),dir)//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.insumos
CREATE TABLE IF NOT EXISTS `insumos` (
  `id_insumo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `cantidad_min` int DEFAULT NULL,
  `medida` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `caducidad` date DEFAULT NULL,
  PRIMARY KEY (`id_insumo`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.insumos: ~13 rows (aproximadamente)
INSERT INTO `insumos` (`id_insumo`, `nombre`, `cantidad`, `cantidad_min`, `medida`, `caducidad`) VALUES
	(1, 'arina', 9500, 5, 'ml', '2023-03-29'),
	(2, 'leche', 9000, 5, 'ml', '2023-03-29'),
	(3, 'chocolate (polvo)', 1600, 500, 'g', '2023-03-29'),
	(4, 'nueces picadas', 1500, 500, 'g', '1111-11-11'),
	(5, 'levadura', 800, 500, 'g', '2023-03-29'),
	(7, 'huevo', 120, 100, 'pza', '2023-03-29'),
	(8, 'canela (polvo)', 800, 500, 'g', '2023-03-29'),
	(9, 'coco (rallado)', 500, 500, 'g', '2023-03-29'),
	(10, 'miel', 500, 500, 'ml', '2023-03-29'),
	(11, 'mantequilla', 2000, 1000, 'g', '2023-03-29'),
	(12, 'ralladura de naranaja', 1000, 500, 'g', '2023-03-29'),
	(13, 'ralladura de limon', 1000, 500, 'g', '2023-03-29'),
	(14, 'Fresas', 1501, 1000, 'g', '2023-03-29');

-- Volcando estructura para procedimiento idgs804_galletas.InsumosCocinar
DELIMITER //
CREATE PROCEDURE `InsumosCocinar`(
	IN `id_pro` INT,
	IN `can` INT
)
BEGIN

	UPDATE insumos AS i
		INNER JOIN resetas AS r ON i.id_insumo = r.id_insumo
		
		SET i.cantidad = i.cantidad - r.cantidad*can
		WHERE r.id_producto = id_pro;
		
	UPDATE productos
		SET cantidad = cantidad+can
		WHERE id_producto = id_pro;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.InsumosCocinarValidar
DELIMITER //
CREATE PROCEDURE `InsumosCocinarValidar`(
	IN `id_pro` INT,
	IN `can` INT
)
BEGIN

SELECT
	i.nombre,
	if(i.cantidad > (r.cantidad * can),'ok','no')AS 'SePuede?',
	(i.cantidad - (r.cantidad * can))*-1 AS 'faltan',
	i.medida
FROM resetas AS r INNER JOIN insumos AS i ON r.id_insumo = i.id_insumo
WHERE id_producto = id_pro;

end//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.InsumosDelete
DELIMITER //
CREATE PROCEDURE `InsumosDelete`(
	IN `id` INT
)
BEGIN

DELETE FROM resetas WHERE id_insumo = id;
DELETE FROM insumos WHERE id_insumo = id;

end//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.InsumosInsert
DELIMITER //
CREATE PROCEDURE `InsumosInsert`(
	IN `nom` VARCHAR(32),
	IN `can` INT,
	IN `can_min` INT,
	IN `med` VARCHAR(8),
	IN `cad` DATE
)
INSERT INTO
insumos(nombre,cantidad,cantidad_min, medida,caducidad)
VALUES (nom, can, can_min,med,cad)//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.InsumosSelectTodos
DELIMITER //
CREATE PROCEDURE `InsumosSelectTodos`()
SELECT*FROM insumos//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.InsumosUpdate
DELIMITER //
CREATE PROCEDURE `InsumosUpdate`(
	IN `id` INT,
	IN `nom` VARCHAR(32),
	IN `can` INT,
	IN `can_min` INT,
	IN `med` VARCHAR(8),
	IN `cad` DATE
)
UPDATE insumos SET
nombre = nom,
cantidad = can,
cantidad_min = can_min,
medida = med,
caducidad = cad
WHERE id_insumo = id//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.productos
CREATE TABLE IF NOT EXISTS `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(32) DEFAULT NULL,
  `cantidad` int NOT NULL DEFAULT '0',
  `cantidad_min` int NOT NULL DEFAULT '0',
  `precio_U` int NOT NULL DEFAULT '0',
  `precio_M` int NOT NULL DEFAULT '0',
  `proceso` varchar(250) DEFAULT NULL,
  `img` varchar(250) DEFAULT NULL,
  `descripcion` varchar(64) DEFAULT NULL,
  `estado` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pendientes` int DEFAULT NULL,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.productos: ~5 rows (aproximadamente)
INSERT INTO `productos` (`id_producto`, `nombre`, `cantidad`, `cantidad_min`, `precio_U`, `precio_M`, `proceso`, `img`, `descripcion`, `estado`, `pendientes`) VALUES
	(1, 'galletas de nuez', 70, 4, 14, 10, 'aquí se describe el proceso de como elaborar las galletas de nuez', 'nuez.png', 'Contenido:50 gramos, 6 piezas', 'ok', 0),
	(2, 'galletas de fresa', 98, 10, 14, 10, 'aquí se describe el proceso de como elaborar las galletas de fresa', '2_galletas de fresa.png', 'Contenido:50 gramos, 6 piezas', 'ok', 0),
	(3, 'galletas clasicas', 86, 10, 14, 10, 'aquí va el proceso que describe como se preparan las galletas clasicas', '3_galletas clasicas.webp', 'Contenido:50 gramos, 6 piezas', 'ok', 0),
	(4, 'galletas mini (coco)', 64, 10, 10, 5, 'aquí se describe el proceso de como elaborar las galletas de coco', '4_wey no2.jpg', 'una breva desprincion2', 'no', 0),
	(5, 'Galletas de naranja', 6, 3, 10, 8, 'aquí se describe el proceso de como elaborar las galletas de naranja', '5_Galletas de naranja.png', 'Contenido 6 piezas de 20 gramos', 'ok', 0);

-- Volcando estructura para procedimiento idgs804_galletas.ProductosDelete
DELIMITER //
CREATE PROCEDURE `ProductosDelete`(
	IN `id` INT
)
BEGIN
	UPDATE productos SET
		estado = 'no'
		WHERE id_producto = id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ProductosInsert
DELIMITER //
CREATE PROCEDURE `ProductosInsert`(
	IN `nom` VARCHAR(32),
	IN `can` INT,
	IN `can_min` INT,
	IN `pre_U` INT,
	IN `pre_M` INT,
	IN `pro` VARCHAR(250),
	IN `img` VARCHAR(250),
	IN `des` VARCHAR(64)
)
BEGIN

INSERT INTO productos
(nombre,cantidad,cantidad_min,precio_U,precio_M,proceso,img,descripcion) VALUES
(nom,can,can_min,pre_U,pre_M,pro,img,des);

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ProductosSelectReseta
DELIMITER //
CREATE PROCEDURE `ProductosSelectReseta`(
	IN `id` INT
)
SELECT
	i.nombre AS 'Ingrediente',
	r.cantidad AS Cantidad,
	i.medida AS Medida,
	i.id_insumo
	FROM productos AS p
INNER JOIN resetas AS r ON p.id_producto = r.id_producto
INNER JOIN insumos AS i ON r.id_insumo = i.id_insumo
WHERE p.id_producto = id//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ProductosSelectTodos
DELIMITER //
CREATE PROCEDURE `ProductosSelectTodos`()
SELECT*FROM productos//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ProductosSelectUno
DELIMITER //
CREATE PROCEDURE `ProductosSelectUno`(
	IN `id` INT
)
SELECT*FROM productos WHERE id_producto = id//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ProductosUpdate
DELIMITER //
CREATE PROCEDURE `ProductosUpdate`(
	IN `id` INT,
	IN `nom` VARCHAR(32),
	IN `can` INT,
	IN `can_min` INT,
	IN `pre_U` INT,
	IN `pre_M` INT,
	IN `pro` VARCHAR(250),
	IN `i` VARCHAR(250),
	IN `des` VARCHAR(50)
)
BEGIN

	UPDATE productos SET
		nombre = nom,
		cantidad = can,
		cantidad_min = can_min,
		precio_U = pre_U,
		precio_M = pre_M,
		proceso = pro,
		img = if(i = '', img ,i),
		descripcion = des
		
		WHERE id_producto = id;

END//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.resetas
CREATE TABLE IF NOT EXISTS `resetas` (
  `id_producto` int DEFAULT NULL,
  `id_insumo` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  KEY `FK_resetas_productos` (`id_producto`),
  KEY `FK_resetas_insumos` (`id_insumo`),
  CONSTRAINT `FK_resetas_insumos` FOREIGN KEY (`id_insumo`) REFERENCES `insumos` (`id_insumo`),
  CONSTRAINT `FK_resetas_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.resetas: ~7 rows (aproximadamente)
INSERT INTO `resetas` (`id_producto`, `id_insumo`, `cantidad`) VALUES
	(1, 1, 100),
	(1, 2, 100),
	(2, 2, 300),
	(4, 1, 255),
	(4, 3, 100),
	(5, 1, 500),
	(5, 2, 1000),
	(5, 8, 200),
	(5, 11, 150),
	(5, 12, 50);

-- Volcando estructura para procedimiento idgs804_galletas.resetasDelete
DELIMITER //
CREATE PROCEDURE `resetasDelete`(
	IN `id_pro` INT
)
BEGIN

	DELETE FROM resetas WHERE id_producto = id_pro;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.resetasInsert
DELIMITER //
CREATE PROCEDURE `resetasInsert`(
	IN `id_pro` INT,
	IN `id_ins` INT,
	IN `can` INT
)
BEGIN

INSERT INTO resetas
(id_producto, id_insumo, cantidad)VALUES
(id_pro, id_ins, can);

END//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(64) DEFAULT NULL,
  `apellidoP` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `apellidoM` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `correo` varchar(64) DEFAULT NULL,
  `contrasena` varchar(250) DEFAULT NULL,
  `rol` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.usuarios: ~3 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `nombre`, `apellidoP`, `apellidoM`, `correo`, `contrasena`, `rol`) VALUES
	(1, 'juanito', 'juarez', 'herrera', 'admin@gmail.com', 'sha256$lqivPCz7Xsd6lWPg$284c90365494dfe246f1e1d6d9a0279bc0dd7cfead573bd95c88065d469f88d1', 'admin'),
	(2, 'juan', 'juarez', 'juarez', 'admin2@gmail.com', 'sha256$AVo0KEJEIQKlvDLV$1680cda786b3d3c9b008e530c0b5a4c9ed51edcd5d5498b2aa685ac195c8360c', 'comun'),
	(3, 'juan', 'ape P', 'ape M', 'nombre@gmail.com', 'sha256$GtI2znCgYyx8DnwR$94c8305576842018d9c0eaf5c64482887754e5039ad0cabea639cffc1a53167a', 'admin');

-- Volcando estructura para procedimiento idgs804_galletas.usuariosDelete
DELIMITER //
CREATE PROCEDURE `usuariosDelete`(
	IN `idU` INT
)
BEGIN

	UPDATE usuarios SET
		rol = 'banneado'
		WHERE id = idU;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.usuariosNuevaContrasena
DELIMITER //
CREATE PROCEDURE `usuariosNuevaContrasena`(
	IN `idU` INT,
	IN `pass` VARCHAR(250)
)
BEGIN

UPDATE usuarios SET
contrasena = pass
WHERE id = idU;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.usuariosRol
DELIMITER //
CREATE PROCEDURE `usuariosRol`(
	IN `id` INT,
	IN `rol` VARCHAR(8)
)
BEGIN

	UPDATE usuarios AS u
	SET u.rol = rol
	WHERE u.id = id;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.usuariosSelectTodo
DELIMITER //
CREATE PROCEDURE `usuariosSelectTodo`()
BEGIN
	SELECT id, concat(nombre,' ',apellidoP,' ',apellidoM) AS 'nom', correo, rol FROM usuarios WHERE rol = 'admin';
	SELECT id, concat(nombre,' ',apellidoP,' ',apellidoM) AS 'nom', correo, rol FROM usuarios WHERE rol = 'empleado';
	SELECT id, concat(nombre,' ',apellidoP,' ',apellidoM) AS 'nom', correo, rol FROM usuarios WHERE rol = 'comun';
	SELECT id, concat(nombre,' ',apellidoP,' ',apellidoM) AS 'nom', correo, rol FROM usuarios WHERE rol = 'baneado';
END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.usuariosUpdate
DELIMITER //
CREATE PROCEDURE `usuariosUpdate`(
	IN `idU` INT,
	IN `nom` VARCHAR(50),
	IN `apeP` VARCHAR(50),
	IN `apeM` VARCHAR(50),
	IN `cor` VARCHAR(50)
)
BEGIN

	IF (SELECT COUNT(*) FROM usuarios WHERE correo = cor AND id != idU) > 0 THEN
			SELECT 'El correo ya esta en uso por otro usuario';
	ELSE
		UPDATE usuarios SET
			nombre = nom,
			apellidoP = apeP,
			apellidoM = apeM,
			correo = cor
			WHERE id = idU;
		SELECT 'Los datos se actualizaron con exito';
	END IF;
	
END//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.ventas
CREATE TABLE IF NOT EXISTS `ventas` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `entrega` int DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `FK_ventas_usuarios` (`id_usuario`) USING BTREE,
  CONSTRAINT `FK_ventas_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.ventas: ~8 rows (aproximadamente)
INSERT INTO `ventas` (`id_venta`, `id_usuario`, `fecha`, `entrega`) VALUES
	(1, 1, '2023-03-27', 1),
	(14, 1, '2023-04-04', 0),
	(15, 1, '2023-04-04', 0),
	(16, 1, '2023-04-04', 0),
	(17, 1, '2023-04-04', 0),
	(18, 1, '2023-04-04', 0),
	(19, 1, '2023-04-04', 0),
	(22, 1, '2023-04-04', 0);

-- Volcando estructura para procedimiento idgs804_galletas.ventasInsert
DELIMITER //
CREATE PROCEDURE `ventasInsert`(
	IN `id_us` INT
)
INSERT INTO
ventas(id_usuario,fecha,entrega)
VALUES (id_us,CURDATE(),0)//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ventasSelectMes
DELIMITER //
CREATE PROCEDURE `ventasSelectMes`(
	IN `fecha` VARCHAR(10)
)
BEGIN

	SELECT
		v.id_venta, p.nombre, p.descripcion, vp.cantidad,vp.precio,
		concat(v.fecha,'') AS fecha,
		e.direccion,v.entrega, CONCAT(s.nombre, ' ',s.apellidoP,' (',s.correo,')') AS cliente
	FROM ventas AS v
	INNER JOIN venta_producto AS vp ON v.id_venta = vp.id_venta
	INNER JOIN productos AS p ON vp.id_producto = p.id_producto
	left JOIN envios AS e ON e.id_venta = v.id_venta
	inner JOIN usuarios AS s ON v.id_usuario = s.id
	WHERE DATE_FORMAT(v.fecha, '%Y-%m') = fecha
	ORDER BY v.id_venta DESC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ventasSelectPendientes
DELIMITER //
CREATE PROCEDURE `ventasSelectPendientes`()
BEGIN

SELECT
	v.id_venta, p.nombre, p.descripcion, vp.cantidad,vp.precio,
	concat(v.fecha,'') AS fecha,
	e.direccion,v.entrega, CONCAT(s.nombre, ' ',s.apellidoP,' (',s.correo,')') AS cliente
FROM ventas AS v
INNER JOIN venta_producto AS vp ON v.id_venta = vp.id_venta
INNER JOIN productos AS p ON vp.id_producto = p.id_producto
left JOIN envios AS e ON e.id_venta = v.id_venta
inner JOIN usuarios AS s ON v.id_usuario = s.id
WHERE v.entrega = 0
ORDER BY v.id_venta DESC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ventasSelectTodo
DELIMITER //
CREATE PROCEDURE `ventasSelectTodo`()
BEGIN

SELECT
	v.id_venta, p.nombre, p.descripcion, vp.cantidad,vp.precio,
	concat(v.fecha,'') AS fecha,
	e.direccion,v.entrega
FROM ventas AS v
INNER JOIN venta_producto AS vp ON v.id_venta = vp.id_venta
INNER JOIN productos AS p ON vp.id_producto = p.id_producto
left JOIN envios AS e ON e.id_venta = v.id_venta
ORDER BY v.id_venta DESC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento idgs804_galletas.ventasSelectUsuario
DELIMITER //
CREATE PROCEDURE `ventasSelectUsuario`(
	IN `id_us` INT
)
SELECT
	v.id_venta, p.nombre, p.descripcion, vp.cantidad,vp.precio,
	concat(v.fecha,'') AS fecha,
	e.direccion,v.entrega
FROM ventas AS v
INNER JOIN venta_producto AS vp ON v.id_venta = vp.id_venta
INNER JOIN productos AS p ON vp.id_producto = p.id_producto
left JOIN envios AS e ON e.id_venta = v.id_venta
WHERE v.id_usuario = id_us
ORDER BY v.id_venta desc//
DELIMITER ;

-- Volcando estructura para tabla idgs804_galletas.venta_producto
CREATE TABLE IF NOT EXISTS `venta_producto` (
  `id_venta` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `precio` int DEFAULT NULL,
  KEY `FK_venta_producto_ventas` (`id_venta`),
  KEY `FK_venta_producto_productos` (`id_producto`),
  CONSTRAINT `FK_venta_producto_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  CONSTRAINT `FK_venta_producto_ventas` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla idgs804_galletas.venta_producto: ~14 rows (aproximadamente)
INSERT INTO `venta_producto` (`id_venta`, `id_producto`, `cantidad`, `precio`) VALUES
	(1, 1, 2, 8),
	(1, 2, 1, 8),
	(14, 1, 10, 100),
	(14, 3, 1, 14),
	(14, 2, 1, 14),
	(15, 1, 10, 100),
	(15, 3, 1, 14),
	(15, 2, 1, 14),
	(16, 2, 2, 28),
	(16, 3, 5, 70),
	(17, 3, 5, 70),
	(18, 1, 5, 70),
	(19, 3, 2, 28),
	(22, 1, 5, 70);

-- Volcando estructura para procedimiento idgs804_galletas.venta_productoInsert
DELIMITER //
CREATE PROCEDURE `venta_productoInsert`(
	IN `id_pro` INT,
	IN `can` INT,
	IN `pre` INT
)
begin
INSERT INTO venta_producto
(id_venta, id_producto, cantidad, precio)
VALUES
((select MAX(id_venta) FROM ventas ),id_pro,can,pre);

UPDATE productos SET cantidad = (cantidad - can) WHERE id_producto = id_pro;
end//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
