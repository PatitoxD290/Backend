const express = require("express");
const router = express.Router();
const contratoController = require("../controllers/contrato.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Ruta para crear contrato
// Aquí se utiliza `upload.single('referencia_diseño')` en el controlador
router.post("/contratos", verifyToken, contratoController.createContrato);

// Ruta para obtener todos los contratos
router.get("/contratos", verifyToken, contratoController.getContratos);

// Ruta para actualizar el estado de un contrato
router.put("/contratos/:id", verifyToken, contratoController.updateContrato);

module.exports = router;
