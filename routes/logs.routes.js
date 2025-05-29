const express = require("express");
const router = express.Router();
const logsController = require("../controllers/logs.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Obtener logs por tabla (y opcionalmente por tipo)
router.get("/logs", verifyToken, logsController.obtenerLog);

// (Opcional) Ruta para obtener todos los logs sin filtro, si deseas mantenerla separada
router.get("/logs/todos", verifyToken, logsController.obtenerTodosLogs);

module.exports = router;
