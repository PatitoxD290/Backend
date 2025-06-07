const db = require("../config/database");
const upload = require("../config/multer"); 

// Crear contrato
exports.createContrato = [
  // Usar el middleware de Multer para cargar los archivos (múltiples imágenes)
  upload, // Multer middleware (usando upload.array() para permitir varios archivos)
  
  async (req, res) => {
    console.log(req.body); // Verifica los datos del formulario
    console.log(req.files); // Verifica los archivos subidos

    const { descripcion, id_usuario, estado, fecha_inicio } = req.body;

    // Validar que los campos obligatorios estén presentes
    if (!descripcion || !id_usuario || !estado || !fecha_inicio) {
      return res.status(400).json({ error: "Todos los campos son obligatorios" });
    }

    // Si hay archivos, obtener los nombres de los archivos (referencia)
    let referencia = [];
    if (req.files && req.files.length > 0) {
      // Guardar los nombres de los archivos subidos
      referencia = req.files.map(file => file.filename); // Mapeamos los nombres de los archivos
    }

    try {
      // Insertar el contrato en la base de datos, incluyendo la referencia (si se subieron imágenes)
      const [result] = await db.query(
        "INSERT INTO contrato (descripcion, id_usuario, referencia_diseño, estado, fecha_inicio) VALUES (?, ?, ?, ?, ?)",
        [descripcion, id_usuario, JSON.stringify(referencia), estado, fecha_inicio] // Guardar los nombres de los archivos como un array JSON
      );
      
      // Responder al cliente con éxito
      res.status(201).json({ message: "Contrato creado", id: result.insertId });
    } catch (err) {
      // Manejo de errores
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
