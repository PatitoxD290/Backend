const db = require("../config/database");

// Crear producto
exports.createProducto = async (req, res) => {
  const { producto, descripcion, precio, costo, id_categoria, material, estado } = req.body;

  if (!producto || !descripcion || !precio || !costo || !id_categoria || !material || !estado) {
    return res.status(400).json({ error: "Todos los campos son obligatorios" });
  }

  const query = `
    INSERT INTO producto (producto, descripcion, precio, costo, id_categoria, material, estado)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  try {
    const [result] = await db.query(query, [producto, descripcion, precio, costo, id_categoria, material, estado]);
    res.status(201).json({ message: "Producto agregado", id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Actualizar producto
exports.updateProducto = async (req, res) => {
  const { id } = req.params;
  const { producto, descripcion, precio, costo, id_categoria, material, estado } = req.body;

  const query = `
    UPDATE producto 
    SET producto = ?, descripcion = ?, precio = ?, costo = ?, id_categoria = ?, material = ?, estado = ?
    WHERE id_producto = ?
  `;

  try {
    await db.query(query, [producto, descripcion, precio, costo, id_categoria, material, estado, id]);
    res.status(200).json({ message: "Producto actualizado" });
  } catch (err) {
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Obtener el total en stock del producto
exports.getProductoConTotalStock = async (req, res) => {
  const { id } = req.params;

  const query = `
    SELECT 
      p.producto,
      IFNULL(SUM(sd.cantidad), 0) AS cantidad_total
    FROM 
      producto p
    LEFT JOIN 
      stock_detalle sd ON p.id_producto = sd.id_producto
    WHERE
      p.id_producto = ?
    GROUP BY 
      p.producto
    ORDER BY 
      p.producto;
  `;

  try {
    const [results] = await db.query(query, [id]);
    res.status(200).json(results);
  } catch (err) {
    res.status(500).json({ error: "Error al obtener productos con stock" });
  }
};

// Catálogo de productos
exports.getCatalogoProductos = async (req, res) => {
  const query = `
    SELECT 
      p.id_producto,
      p.producto,
      p.descripcion,
      p.precio,
      p.material,
      c.categoria,
      p.estado
    FROM producto p
    JOIN categoria c ON p.id_categoria = c.id_categoria
    ORDER BY p.producto
  `;

  try {
    const [results] = await db.query(query);
    res.status(200).json(results);
  } catch (err) {
    res.status(500).json({ error: "Error al obtener catálogo" });
  }
};
