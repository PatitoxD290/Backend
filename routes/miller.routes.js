const express = require("express");
const router = express.Router();
const {
  sendVerificationEmail,
  verifyCode,
  codigoPago,
  verificarPago
} = require("../controllers/miller.controller");
const { verifyToken } = require("../middlewares/auth.middleware");

// Ruta para enviar un correo de verificación
router.post("/send-verification-email", sendVerificationEmail);

// Ruta para verificar el código de verificación
router.post("/verify-code", verifyCode);

// ✅ Nueva ruta para enviar el código de pago simulado
router.post("/codigo-pago",verifyToken, codigoPago);

// ✅ Nueva ruta para verificar el código de pago simulado
router.post("/verificar-pago", verifyToken, verificarPago);

module.exports = router;
