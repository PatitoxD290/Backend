const db = require("../config/database");

// Crear stock y sus detalles
exports.createStock = async (req, res) => {
  const { fecha, detalles } = req.body;

  // Validar campos obligatorios
  if (!fecha || !Array.isArray(detalles) || detalles.length === 0) {
    return res.status(400).json({ error: "Fecha y al menos un detalle de producto son obligatorios" });
  }

  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();  // Iniciar una transacción

    // Insertar en tabla `stock`
    const [stockResult] = await connection.query("INSERT INTO stock (fecha_ingreso) VALUES (?)", [fecha]);
    const idStock = stockResult.insertId;

    // Insertar múltiples detalles en `stock_detalle`
    const detalleQuery = "INSERT INTO stock_detalle (id_stock, id_producto, cantidad) VALUES ?";
    const values = detalles.map(det => [idStock, det.id_producto, det.cantidad]);

    await connection.query(detalleQuery, [values]);

    await connection.commit();  // Confirmar la transacción
    res.status(201).json({ message: "Stock y detalles creados correctamente", id_stock: idStock });
  } catch (err) {
    await connection.rollback();  // Si ocurre un error, revertir la transacción
    console.error("Error al crear stock:", err);
    res.status(500).json({ error: "Error al crear stock" });
  } finally {
    connection.release();  // Liberar la conexión
  }
};

// Obtener todos los stocks
exports.getStocks = async (_req, res) => {
  const sql = `
    SELECT s.id_stock, s.fecha_ingreso, sd.id_producto, p.producto, sd.cantidad
    FROM stock s
    LEFT JOIN stock_detalle sd ON s.id_stock = sd.id_stock
    LEFT JOIN producto p ON sd.id_producto = p.id_producto
    ORDER BY s.fecha_ingreso DESC, s.id_stock DESC
  `;

  try {
    const [results] = await db.query(sql);
    res.status(200).json(results);
  } catch (err) {
    console.error("Error al obtener stocks:", err);
    res.status(500).json({ error: "Error al obtener stocks" });
  }
};
