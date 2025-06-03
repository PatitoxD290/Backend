const db = require("../config/database");

// Obtener todas las compras de usuario
exports.getComprasUsuario = async (_req, res) => {
  try {
    const [compras] = await db.query(`
      SELECT cu.id_comprasusuario,
             u.user AS nombre_usuario,
             v.id_ventas,
             v.fecha,
             v.total
      FROM comprasusuario cu
      JOIN usuario u ON cu.id_usuario = u.id_usuario
      JOIN ventas v ON cu.id_ventas = v.id_ventas
      ORDER BY v.fecha DESC
    `);

    res.status(200).json(compras);
  } catch (error) {
    console.error("Error al obtener las compras del usuario:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};
