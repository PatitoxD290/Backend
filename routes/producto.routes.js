const express = require("express");
const router = express.Router();
const productoController = require("../controllers/producto.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Rutas CRUD básicas
router.post("/productos", verifyToken, productoController.createProducto);
router.put("/productos/:id", verifyToken, productoController.updateProducto);

// Obtener stock total por producto
router.get("/productos-stock/:id", verifyToken, productoController.getProductoConTotalStock);

// Catálogo de productos
router.get("/productos-catalogo", productoController.getCatalogoProductos);

module.exports = router;
