const express = require("express");
const router = express.Router();
const compraUsuarioController = require("../controllers/comprausuario.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Obtener todas las compras de usuario
router.get("/compras_usuario", verifyToken, compraUsuarioController.getComprasUsuario);

module.exports = router;
