const db = require("../config/database");
const upload = require("../config/multer"); // Asegúrate de importar multer.js

// Crear contrato
exports.createContrato = [
  // Usar el middleware de Multer para cargar el archivo (solo una imagen)
  upload.single("referencia_diseño"), // 'referencia_diseño' es el nombre del campo del formulario que contiene el archivo
  async (req, res) => {
    
    console.log(req.body); // Verifica los datos del formulario
    console.log(req.file); // Verifica el archivo subido
    const { descripcion, id_usuario, estado, fecha_inicio } = req.body;

    // Validar que los campos obligatorios estén presentes
    if (!descripcion || !id_usuario || !estado || !fecha_inicio) {
      return res.status(400).json({ error: "Todos los campos son obligatorios" });
    }

    // Si hay un archivo, obtener el nombre del archivo (referencia_diseño)
    let referencia_diseño = null;
    if (req.file) {
      referencia_diseño = req.file.filename; // Aquí guardamos el nombre único del archivo
    }

    try {
      // Insertar el contrato en la base de datos, incluyendo la referencia_diseño (si se subió una imagen)
      const [result] = await db.query(
        "INSERT INTO contrato (descripcion, id_usuario, referencia_diseño, estado, fecha_inicio) VALUES (?, ?, ?, ?, ?)",
        [descripcion, id_usuario, referencia_diseño, estado, fecha_inicio]
      );
      res.status(201).json({ message: "Contrato creado", id: result.insertId });
    } catch (err) {
      res.status(500).json({ error: "Error en la base de datos", detalles: err.message });
    }
  },
];

// Obtener contratos
exports.getContratos = async (_req, res) => {
  try {
    const results = await db.query("SELECT * FROM contrato");
    res.status(200).json(results);
  } catch (err) {
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Actualizar contrato
exports.updateContrato = async (req, res) => {
  const { id } = req.params;
  const { estado } = req.body;

  if (!estado) return res.status(400).json({ error: "El campo 'estado' es obligatorio" });

  try {
    await db.query(
      "UPDATE contrato SET estado = ? WHERE id_contrato = ?",
      [estado, id]
    );
    res.status(200).json({ message: "Estado del contrato actualizado" });
  } catch (err) {
    res.status(500).json({ error: "Error al actualizar el estado del contrato" });
  }
};
