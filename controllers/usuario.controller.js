const db = require("../config/database");
const bcrypt = require("bcrypt");

// Crear usuario
exports.createUsuario = async (req, res) => {
  const { user, email, password } = req.body;

  if (!user || !email || !password) {
    return res.status(400).json({ error: "Todos los campos son obligatorios" });
  }

  try {
    // Verificar si el usuario ya existe
    const [userExists] = await db.query("SELECT * FROM usuario WHERE email = ?", [email]);
    if (userExists.length > 0) {
      return res.status(400).json({ error: "El correo ya está registrado" });
    }

    // Encriptar la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insertar el nuevo usuario
    const [result] = await db.query(
      "INSERT INTO usuario (user, email, password) VALUES (?, ?, ?)",
      [user, email, hashedPassword]
    );

    res.status(201).json({
      message: "Usuario creado exitosamente",
      user: {
        id: result.insertId,
        email,
        user,
      },
    });
  } catch (error) {
    console.error("Error al crear usuario:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};

// Recuperar o restablecer la contraseña
exports.recuperarContraseña = async (req, res) => {
  const { email, newPassword } = req.body;

  if (!email || !newPassword) {
    return res.status(400).json({ error: "El correo y la nueva contraseña son obligatorios" });
  }

  try {
    // Verificar si el correo existe en la base de datos
    const [rows] = await db.query("SELECT * FROM usuario WHERE email = ?", [email]);
    if (rows.length === 0) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    // Hashear la nueva contraseña
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Actualizar la contraseña en la base de datos
    const [updateResult] = await db.query(
      "UPDATE usuario SET password = ? WHERE email = ?",
      [hashedPassword, email]
    );

    if (updateResult.affectedRows === 0) {
      return res.status(400).json({ error: "No se pudo actualizar la contraseña" });
    }

    res.status(200).json({ message: "Contraseña actualizada correctamente" });
  } catch (error) {
    console.error("Error al recuperar la contraseña:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};

// Obtener todos los usuarios
exports.getUsuarios = async (_req, res) => {
  try {
    const [results] = await db.query("SELECT id_usuario, user, email FROM usuario");
    res.status(200).json(results);
  } catch (err) {
    console.error("Error al obtener usuarios:", err);
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Obtener usuario por ID
exports.getUsuarioByCorreo = async (req, res) => {
  const { id } = req.params;

  try {
    const [results] = await db.query(
      "SELECT id_usuario, user, email FROM usuario WHERE id_usuario = ?",
      [id]
    );
    if (results.length === 0) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }
    res.status(200).json(results[0]);
  } catch (err) {
    console.error("Error al obtener el usuario:", err);
    res.status(500).json({ error: "Error en la base de datos" });
  }
};


// Actualizar usuario (nombre o contraseña)
exports.updateUsuario = async (req, res) => {
  const { id } = req.params;
  const { user, password } = req.body;

  if (!user && !password) {
    return res.status(400).json({ error: "Debes enviar al menos un campo para actualizar" });
  }

  try {
    // Verificar si el usuario existe
    const [results] = await db.query("SELECT * FROM usuario WHERE id_usuario = ?", [id]);
    if (results.length === 0) {
      return res.status(404).json({ error: "Usuario no encontrado" });
    }

    const usuarioActual = results[0];
    const nuevoUser = user || usuarioActual.user;
    const nuevaPassword = password ? await bcrypt.hash(password, 10) : usuarioActual.password;

    const [updateResult] = await db.query(
      "UPDATE usuario SET user = ?, password = ? WHERE id_usuario = ?",
      [nuevoUser, nuevaPassword, id]
    );

    if (updateResult.affectedRows === 0) {
      return res.status(400).json({ error: "No se pudo actualizar el usuario" });
    }

    res.status(200).json({ message: "Usuario actualizado correctamente" });
  } catch (error) {
    console.error("Error al actualizar usuario:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};
