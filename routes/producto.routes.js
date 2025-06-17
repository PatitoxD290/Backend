const express = require("express");
const router = express.Router();
const productoController = require("../controllers/producto.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Crear y actualizar productos
router.post("/productos", verifyToken, productoController.createProducto);
router.put("/productos/:id", verifyToken, productoController.updateProducto);

// Obtener todos los productos y por ID
router.get("/productos",  productoController.getAllProductos);
router.get("/productos/:id",  productoController.getProductoById);

// Obtener stock total por producto
router.get("/productos-stock/:id", verifyToken, productoController.getProductoConTotalStock);

// Catálogo público
router.get("/productos-catalogo", productoController.getCatalogoProductos);

module.exports = router;
