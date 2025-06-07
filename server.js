require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');

// Obtengo mis rutas
const authRoutes = require("./routes/auth.routes");
const usuarioRoutes = require("./routes/usuario.routes");
const clienteRoutes = require("./routes/cliente.routes");
const ventasRoutes = require("./routes/ventas.routes");
const productoRoutes = require("./routes/producto.routes");
const contratoRoutes = require("./routes/contrato.routes");
const stockRoutes = require("./routes/stock.routes");
const logsRoutes = require("./routes/logs.routes");
const millerRoutes = require("./routes/miller.routes.js");

const app = express();

// Configuración de seguridad
app.use(helmet());

// Configuración CORS más estricta
const corsOptions = {
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
};

// Aplica la configuración CORS globalmente
app.use(cors(corsOptions));

// Validar variables de entorno requeridas
const requiredEnvVars = ['JWT_SECRET', 'DB_HOST', 'DB_USER', 'DB_NAME'];
requiredEnvVars.forEach(envVar => {
  if (!process.env[envVar]) {
    console.error(`Error: La variable de entorno ${envVar} no está definida`);
    process.exit(1);
  }
});

app.use(express.json());

// Ruta default
app.get("/", (_req, res) => {
  res.json({
    message: "BACKEND KYM",
    version: "15.9.85"
  });
});

// Rutas
app.use("/api/v1", authRoutes);
app.use("/api/v1", usuarioRoutes);
app.use("/api/v1", clienteRoutes);
app.use("/api/v1", ventasRoutes);
app.use("/api/v1", productoRoutes);
app.use("/api/v1", contratoRoutes);
app.use("/api/v1", stockRoutes);
app.use("/api/v1", logsRoutes);
app.use("/api/v1", millerRoutes);

// Ruta para archivos estáticos (imagenes, PDFs, etc.) en /catalogo
app.use('/cata', express.static(path.join(__dirname, 'catalogo')));

// Rutas CORS específicamente para las imágenes en /cata
app.use('/cata', (req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', process.env.FRONTEND_URL || 'http://localhost:3000');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  next();
}, express.static(path.join(__dirname, 'catalogo')));

// Manejo de rutas no encontradas
app.use((_req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT} 🥵`);
});
