const db = require("../config/database");

// Obtener todos los clientes
exports.getClientes = async (_req, res) => {
  try {
    const [results] = await db.query("SELECT * FROM cliente");
    res.status(200).json(results);
  } catch (err) {
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Actualizar cliente directamente por ID
exports.updateCliente = async (req, res) => {
  const { id } = req.params;
  const { nombres, apellidos, telefono, direccion } = req.body;

  try {
    await db.query(
      "UPDATE cliente SET nombres = ?, apellidos = ?, telefono = ?, direccion = ? WHERE id_cliente = ?",
      [nombres, apellidos, telefono, direccion, id]
    );
    res.status(200).json({ message: "Cliente actualizado" });
  } catch (err) {
    res.status(500).json({ error: "Error al actualizar" });
  }
};

// Crear o actualizar cliente asociado al usuario
exports.createOrUpdateCliente = async (req, res) => {
  const { id_usuario, nombres, apellidos, telefono, direccion, dni } = req.body;

  try {
    const [[usuario]] = await db.query(
      "SELECT id_cliente FROM usuario WHERE id_usuario = ?",
      [id_usuario]
    );
    if (!usuario) return res.status(404).json({ error: "Usuario no encontrado" });

    let clienteId = usuario.id_cliente;

    if (clienteId) {
      await db.query(
        `UPDATE cliente 
         SET nombres = ?, apellidos = ?, telefono = ?, direccion = ?, dni = ?
         WHERE id_cliente = ?`,
        [nombres, apellidos, telefono, direccion, dni, clienteId]
      );
    } else {
      const [result] = await db.query(
        `INSERT INTO cliente 
         (nombres, apellidos, telefono, direccion, dni) 
         VALUES (?, ?, ?, ?, ?)`,
        [nombres, apellidos, telefono, direccion, dni]
      );
      clienteId = result.insertId;

      await db.query(
        "UPDATE usuario SET id_cliente = ? WHERE id_usuario = ?",
        [clienteId, id_usuario]
      );
    }

    const [[cliente]] = await db.query(
      "SELECT * FROM cliente WHERE id_cliente = ?",
      [clienteId]
    );
    res.status(200).json(cliente);
  } catch (error) {
    res.status(500).json({ error: "Error interno del servidor" });
  }
};

// Listar todos los contratos
exports.listarTodosContratos = async (_req, res) => {
  const sql = `
    SELECT 
      c.ID_Contrato,
      CONCAT(cl.nombres, ' ', cl.apellidos) AS Nombre_Completo,
      cl.telefono,
      c.Contrato,
      c.Estado
    FROM 
      Contratos c
    INNER JOIN 
      cliente cl ON c.ID_Cliente = cl.id_cliente
  `;

  try {
    const resultados = await db.query(sql);
    res.status(200).json({ exito: true, datos: resultados });
  } catch (err) {
    res.status(500).json({ error: "Error al listar contratos" });
  }
};

// Obtener datos para boleta
exports.datosBoletaCliente = async (req, res) => {
  const { id } = req.params;
  const sql = `
    SELECT 
      cl.nombres,
      cl.apellidos,
      cl.telefono,
      cl.direccion
    FROM cliente cl
    WHERE cl.id_cliente = ?
  `;

  try {
    const resultados = await db.query(sql, [id]);
    if (resultados.length === 0) {
      return res.status(404).json({ error: "Cliente no encontrado" });
    }
    res.status(200).json({ exito: true, datos: resultados[0] });
  } catch (err) {
    res.status(500).json({ error: "Error al obtener datos para boleta" });
  }
};
