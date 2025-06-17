require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');

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

// Seguridad
app.use(helmet());

// CORS
const corsOptions = {
  origin: process.env.FRONTEND_URL || 'http://localhost:3001',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
};
app.use(cors(corsOptions));

// Validación de variables
const requiredEnvVars = ['JWT_SECRET', 'DB_HOST', 'DB_USER', 'DB_NAME'];
requiredEnvVars.forEach(envVar => {
  if (!process.env[envVar]) {
    console.error(`Error: La variable de entorno ${envVar} no está definida`);
    process.exit(1);
  }
});

app.use(express.json());

// Ruta base
app.get("/", (_req, res) => {
  res.json({ message: "BACKEND KYM", version: "15.9.85" });
});

// Rutas API
app.use("/api/v1", authRoutes);
app.use("/api/v1", usuarioRoutes);
app.use("/api/v1", clienteRoutes);
app.use("/api/v1", ventasRoutes);
app.use("/api/v1", productoRoutes);
app.use("/api/v1", contratoRoutes);
app.use("/api/v1", stockRoutes);
app.use("/api/v1", logsRoutes);
app.use("/api/v1", millerRoutes);

// 🔥 Rutas para servir imágenes con encabezados seguros
app.use('/cata', (req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', process.env.FRONTEND_URL || 'http://localhost:5173');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin'); // 🔥 ESTE ES EL QUE FALTABA
  next();
}, express.static(path.join(__dirname, 'catalogo')));

app.use('/imgrefe', (req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', process.env.FRONTEND_URL || 'http://localhost:5173');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin'); // 🔥 ESTE ES EL QUE FALTABA
  next();
}, express.static(path.join(__dirname, 'uploads')));

// Ruta 404
app.use((_req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

// Puerto
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT} 🥵`);
});
