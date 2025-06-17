const express = require("express");
const router = express.Router();
const ventaController = require("../controllers/ventas.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Rutas para ventas
router.post("/ventas", verifyToken, ventaController.createVenta); // Crea venta (con detalles)
router.get("/ventas", ventaController.getVentas);    // Obtener todas las ventas
router.get("/ventas-detalle/:id",  ventaController.getVentaDetalleById); // Obtener detalles de una venta

router.get("/compras_usuario/:id",  ventaController.getComprasUsuario);//obtener las compras del usuario

// Rutas para gráficos y análisis
router.get("/ventas-mes",  ventaController.obtenerVentasPorMes);               // Total por mes
router.get("/ventas-productos-mas-vendidos", ventaController.obtenerProductosMasVendidos); // Más vendidos

module.exports = router;
