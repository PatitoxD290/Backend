const db = require("../config/database");

// Obtener logs por tabla y tipo
exports.obtenerLog = async (req, res) => {
  const { tabla, tipo } = req.query;

  if (!tabla) {
    return res.status(400).json({ error: "El parámetro 'tabla' es obligatorio." });
  }

  let sql = `SELECT * FROM ??`;
  const params = [tabla];

  if (tipo) {
    sql += ` WHERE Tipo = ?`;
    params.push(tipo);
  }

  try {
    const [results] = await db.query(sql, params);
    res.status(200).json(results);
  } catch (err) {
    console.error("Error al obtener logs:", err);
    res.status(500).json({ error: "Error en la base de datos." });
  }
};

// Obtener todos los logs de una tabla
exports.obtenerTodosLogs = async (req, res) => {
  const { tabla } = req.query;

  if (!tabla) {
    return res.status(400).json({ error: "El parámetro 'tabla' es obligatorio." });
  }

  const sql = `SELECT * FROM ??`;

  try {
    const [results] = await db.query(sql, [tabla]);
    res.status(200).json(results);
  } catch (err) {
    console.error("Error al obtener todos los logs:", err);
    res.status(500).json({ error: "Error en la base de datos." });
  }
};
