const express = require("express");
const router = express.Router();
const contratoController = require("../controllers/contrato.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Ruta para crear contrato
// Aquí se utiliza `upload.single('referencia_diseño')` en el controlador
router.post("/contratos", contratoController.createContrato);

// Ruta para actualizar el estado de un contrato
router.put("/contratos/:id", contratoController.updateContrato);

//Aceptar contratos
router.put("/contratos/:id/aceptar", contratoController.aceptarContrato);

module.exports = router;
