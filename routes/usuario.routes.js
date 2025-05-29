const express = require("express");
const router = express.Router();
const usuarioController = require("../controllers/usuario.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Autenticación
router.post("/register", usuarioController.createUsuario);
// Recuperación de contraseña
router.post("/recuperar-contrase", usuarioController.recuperarContraseña);

// Usuarios
router.get("/usuarios", verifyToken, usuarioController.getUsuarios);
router.get("/usuarios/:id", verifyToken, usuarioController.getUsuarioByCorreo);
router.put("/usuarios/:id", verifyToken, usuarioController.updateUsuario);


module.exports = router;
