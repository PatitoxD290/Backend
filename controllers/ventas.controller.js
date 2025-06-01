const db = require("../config/database");

// Crear venta junto con su detalle
exports.createVenta = async (req, res) => {
  const { id_cliente, lugar_entrega, total, forma_pago, fecha, hora, detalles } = req.body;

  // Verificar que los campos requeridos estén presentes, excepto id_cliente que ahora puede ser null
  if (!lugar_entrega || !total || !forma_pago || !fecha || !hora || !Array.isArray(detalles) || detalles.length === 0) {
      return res.status(400).json({ error: "Todos los campos son obligatorios y debe incluir al menos un detalle" });
  }

  const connection = await db.getConnection(); // Obtener una conexión
  try {
      await connection.beginTransaction(); // Iniciar la transacción

      // Insertar la venta en la tabla ventas, ahora id_cliente puede ser null
      const [result] = await connection.query(
          "INSERT INTO ventas (id_cliente, lugar_entrega, total, forma_pago, fecha, hora) VALUES (?, ?, ?, ?, ?, ?)",
          [id_cliente || null, lugar_entrega, total, forma_pago, fecha, hora] // Usamos null si id_cliente no se pasa
      );

      const id_ventas = result.insertId;

      // Preparar los valores para los detalles de la venta
      const valoresDetalle = detalles.map(({ id_producto, cantidad }) => [id_ventas, id_producto, cantidad]);

      // Insertar los detalles de la venta
      await connection.query(
          "INSERT INTO ventas_detalle (id_ventas, id_producto, cantidad) VALUES ?",
          [valoresDetalle]
      );

      // Confirmar la transacción
      await connection.commit();

      res.status(201).json({ message: "Venta registrada con detalles", id_ventas });
  } catch (err) {
      // En caso de error, revertir la transacción
      await connection.rollback();
      console.error("Error al registrar venta o detalles:", err);
      res.status(500).json({ error: "Error al registrar la venta y detalles", detalle: err.message });
  } finally {
      connection.release(); // Liberar la conexión
  }
};



// Obtener todas las ventas
exports.getVentas = async (_req, res) => {
  try {
    const [results] = await db.query("SELECT * FROM ventas");
    res.status(200).json(results);
  } catch (err) {
    console.error("Error al obtener ventas:", err);
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Obtener detalle de venta por ID ventas
exports.getVentaDetalleById = async (req, res) => {
  const { id } = req.params;

  try {
    const [results] = await db.query(`
      WITH numerados AS (
        SELECT 
          p.producto,
          vd.cantidad,
          ROW_NUMBER() OVER (ORDER BY vd.id_producto) AS numero
        FROM ventas_detalle vd
        JOIN producto p ON vd.id_producto = p.id_producto
        WHERE vd.id_ventas = ?
      )
      SELECT GROUP_CONCAT(
        CONCAT('Producto ', numero, ': ', producto, '\nCantidad: ', cantidad)
        SEPARATOR '\n\n'
      ) AS detalles
      FROM numerados;
    `, [id]);

    const detalle = results[0]?.detalles;

    if (!detalle) {
      return res.status(404).json({ error: "Detalle de venta no encontrado" });
    }

    res.status(200).json({ detalle });
  } catch (err) {
    console.error("Error al obtener detalle de venta por ID:", err);
    res.status(500).json({ error: "Error en la base de datos", detalle: err.message });
  }
};


// Obtener ventas por mes (para gráficos)
exports.obtenerVentasPorMes = async (_req, res) => {
  const sql = `
    SELECT 
      MONTH(fecha) AS mes, 
      SUM(total) AS total
    FROM 
      ventas
    GROUP BY 
      MONTH(fecha)
    ORDER BY 
      MONTH(fecha)`;

  try {
    const [resultados] = await db.query(sql);
    res.status(200).json(resultados);
  } catch (err) {
    console.error("Error al obtener ventas por mes:", err);
    res.status(500).json({ error: "Error al obtener ventas por mes" });
  }
};

// Obtener productos más vendidos (para gráficos)
exports.obtenerProductosMasVendidos = async (_req, res) => {
  const sql = `
    SELECT 
      p.producto, 
      SUM(vd.cantidad) AS cantidad_total
    FROM 
      ventas_detalle vd
    JOIN 
      producto p ON vd.id_producto = p.id_producto
    GROUP BY 
      vd.id_producto
    ORDER BY 
      cantidad_total DESC
    LIMIT 10`;

  try {
    const [resultados] = await db.query(sql);
    res.status(200).json(resultados);
  } catch (err) {
    console.error("Error al obtener productos más vendidos:", err);
    res.status(500).json({ error: "Error al obtener productos más vendidos" });
  }
};
