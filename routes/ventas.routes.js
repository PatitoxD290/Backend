const express = require("express");
const router = express.Router();
const ventaController = require("../controllers/ventas.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Rutas para ventas
router.post("/ventas", verifyToken, ventaController.createVenta); // Crea venta (con detalles)
router.get("/ventas", verifyToken, ventaController.getVentas);    // Obtener todas las ventas
router.get("/comprasusser", verifyToken, ventaController.getComprasUsuario);    // Obtener todas las ventas
router.get("/ventas-detalle/:id", verifyToken, ventaController.getVentaDetalleById); // Obtener detalles de una venta

// Rutas para gráficos y análisis
router.get("/ventas-mes", verifyToken, ventaController.obtenerVentasPorMes);               // Total por mes
router.get("/ventas-productos-mas-vendidos", verifyToken, ventaController.obtenerProductosMasVendidos); // Más vendidos

module.exports = router;
