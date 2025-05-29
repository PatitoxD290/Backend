require("dotenv").config();
const nodemailer = require("nodemailer");

const verificationCodes = {}; // Objeto para almacenar los códigos de verificación
const codigosPago = {}; // Objeto separado para almacenar los códigos de pago


// Función para enviar el código de verificación al correo
const sendVerificationEmail = async (req, res) => {
  const { email } = req.body;

  if (!email || !/\S+@\S+\.\S+/.test(email)) {
    return res.status(400).json({ message: "Correo electrónico inválido" });
  }

  const verificationCode = Math.floor(1000 + Math.random() * 9000); // Generamos un código aleatorio de 4 dígitos

  // Almacenamos el código en el objeto de verificación con la clave como el correo
  verificationCodes[email] = verificationCode;

  // Imprimimos el código almacenado para depuración
  console.log("Código almacenado para el correo:", email, verificationCodes[email]);
  console.log("Códigos de verificación almacenados en memoria:", verificationCodes);

  // Establecemos un tiempo de expiración para el código (5 minutos)
  setTimeout(() => {
    delete verificationCodes[email];
    console.log("Código expirado y eliminado para el correo:", email);
    console.log("Códigos de verificación restantes:", verificationCodes);
  }, 5 * 60 * 1000); // El código expira en 5 minutos

  // Configuración del servicio de correo electrónico
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: "Código de verificación",
    text: `Tu código de verificación es: ${verificationCode}`,
    html: `<h1>Tu código de verificación es: ${verificationCode}</h1>`,
  };

  try {
    // Enviamos el correo con el código de verificación
    await transporter.sendMail(mailOptions);
    console.log("Correo enviado:", email);
    res.status(200).json({ message: "Correo enviado correctamente" });
  } catch (error) {
    console.error("Error al enviar el correo:", error);
    res.status(500).json({ message: "Error al enviar el correo" });
  }
};

// Función para verificar el código de seguridad
const verifyCode = (req, res) => {
  const { code } = req.body;  // Solo requerimos el código en la solicitud

  if (!code) {
    return res.status(400).json({ message: "Falta el código de verificación" });
  }

  // Imprimimos los códigos almacenados antes de la verificación para depuración
  console.log("Códigos de verificación almacenados antes de la verificación:", verificationCodes);

  // Comprobamos si el código existe y es válido
  const email = Object.keys(verificationCodes).find(email => verificationCodes[email] === parseInt(code));

  if (email) {
    // Si el código es correcto, eliminamos el código de la memoria
    delete verificationCodes[email];
    console.log("Código verificado correctamente para el correo:", email);
    console.log("Códigos de verificación restantes después de la verificación:", verificationCodes);

    return res.status(200).json({ message: "Código verificado correctamente", success: true });
  } else {
    console.log("Código incorrecto o expirado:", code);
    return res.status(400).json({ message: "Código incorrecto o expirado", success: false });
  }
};

// Función para enviar el código de pago al correo
const codigoPago = async (req, res) => {
  const { email } = req.body;

  if (!email || !/\S+@\S+\.\S+/.test(email)) {
    return res.status(400).json({ message: "Correo electrónico inválido" });
  }

  const codigo = Math.floor(1000 + Math.random() * 9000);
  codigosPago[email] = codigo;

  console.log("Código de pago generado para:", email, "->", codigo);

  // Código expira en 5 minutos
  setTimeout(() => {
    delete codigosPago[email];
    console.log("Código de pago expirado para:", email);
  }, 5 * 60 * 1000);

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: "Código de pago simulado",
    text: `Tu código de pago es: ${codigo}`,
    html: `<h1>Tu código de pago es: <strong>${codigo}</strong></h1>`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Correo de pago enviado a:", email);
    res.status(200).json({ message: "Código de pago enviado correctamente" });
  } catch (error) {
    console.error("Error al enviar el código de pago:", error);
    res.status(500).json({ message: "Error al enviar el código de pago" });
  }
};

// Función para verificar el código de pago
const verificarPago = (req, res) => {
  const { code } = req.body;

  if (!code) {
    return res.status(400).json({ message: "Falta el código de pago" });
  }

  const email = Object.keys(codigosPago).find(email => codigosPago[email] === parseInt(code));

  if (email) {
    delete codigosPago[email];
    console.log("Código de pago verificado para:", email);
    return res.status(200).json({ message: "Pago verificado correctamente", success: true });
  } else {
    console.log("Código de pago incorrecto o expirado:", code);
    return res.status(400).json({ message: "Código de pago incorrecto o expirado", success: false });
  }
};


module.exports = {
  sendVerificationEmail,
  verifyCode,
  codigoPago,
  verificarPago,
};
