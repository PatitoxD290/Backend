const db = require("../config/database");
const uploadCatalogo = require("../config/multercatalogo"); // Usar el middleware de Multer para cargar archivos en el catálogo
const fs = require("fs");
const path = require("path"); // Importar 'path' para trabajar con las rutas de archivos

// Crear producto
exports.createProducto = [
  // Usar el middleware de Multer para cargar un archivo (solo un archivo para el catálogo)
  uploadCatalogo, // Multer middleware (usando uploadCatalogo.single() para permitir un solo archivo)

  async (req, res) => {
    console.log(req.body); // Verifica los datos del formulario
    console.log(req.file); // Verifica el archivo subido

    const { producto, descripcion, precio, costo, id_categoria, material, estado, genero, edad } = req.body;

    // Validar que los campos obligatorios estén presentes
    if (!producto || !descripcion || !precio || !costo || !id_categoria || !material || !estado || !genero || !edad) {
      return res.status(400).json({ error: "Todos los campos son obligatorios" });
    }

    try {
      // Insertar el producto en la base de datos sin el archivo (aún no tenemos el ID)
      const [result] = await db.query(
        `INSERT INTO producto (producto, descripcion, precio, costo, id_categoria, material, estado, genero, edad)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          producto, descripcion, precio, costo, id_categoria, material, estado, genero, edad
        ]
      );

      // Obtener el ID del producto recién creado
      const idProducto = result.insertId;

      // Si se subió un archivo, renombrarlo usando el ID del producto
      if (req.file) {
        const extension = path.extname(req.file.originalname); // Obtener la extensión original
        const nuevoNombre = `ID_Producto_${idProducto}${extension}`; // Crear el nuevo nombre del archivo

        // Renombrar el archivo en el sistema de archivos
        const oldPath = path.join(req.file.destination, req.file.filename); // Ruta original del archivo
        const newPath = path.join(req.file.destination, nuevoNombre); // Nueva ruta con el nombre del archivo

        // Renombrar el archivo
        fs.renameSync(oldPath, newPath);

        // **Aquí no actualizamos la base de datos** porque no necesitas esa columna.
        // Si quieres devolver el nombre del archivo en la respuesta, lo puedes hacer aquí:
        return res.status(201).json({
          message: "Producto agregado",
          id: idProducto,
          imagen: nuevoNombre, // Nombre del archivo renombrado
        });
      }

      // Si no se subió un archivo, solo responder con el producto creado
      res.status(201).json({
        message: "Producto agregado",
        id: idProducto,
      });
    } catch (err) {
      // Manejo de errores
      res.status(500).json({ error: "Error en la base de datos", detalles: err.message });
    }
  }
];


// Actualizar producto
exports.updateProducto = async (req, res) => {
  const { id } = req.params;
  const { producto, descripcion, precio, costo, id_categoria, material, estado, genero, edad } = req.body;

  if (!producto || !descripcion || !precio || !costo || !id_categoria || !material || !estado || !genero || !edad) {
    return res.status(400).json({ error: "Todos los campos son obligatorios" });
  }

  const query = `
    UPDATE producto 
    SET producto = ?, descripcion = ?, precio = ?, costo = ?, id_categoria = ?, material = ?, estado = ?, genero = ?, edad = ?
    WHERE id_producto = ?
  `;

  try {
    await db.query(query, [
      producto, descripcion, precio, costo, id_categoria, material, estado, genero, edad, id
    ]);
    res.status(200).json({ message: "Producto actualizado" });
  } catch (err) {
    res.status(500).json({ error: "Error en la base de datos" });
  }
};

// Obtener todos los productos
exports.getAllProductos = async (req, res) => {
  const query = `
    SELECT 
      p.id_producto,
      p.producto,
      p.descripcion,
      p.precio,
      p.costo,
      p.id_categoria,
      c.categoria,
      p.material,
      p.estado,
      p.genero,
      p.edad
    FROM producto p
    JOIN categoria c ON p.id_categoria = c.id_categoria
    ORDER BY p.id_producto DESC
  `;

  try {
    const [results] = await db.query(query);
    res.status(200).json(results);
  } catch (err) {
    res.status(500).json({ error: "Error al obtener productos" });
  }
};

// Obtener un producto por ID
exports.getProductoById = async (req, res) => {
  const { id } = req.params;

  const query = `
    SELECT 
      p.id_producto,
      p.producto,
      p.descripcion,
      p.precio,
      p.costo,
      p.id_categoria,
      c.categoria,
      p.material,
      p.estado
    FROM producto p
    JOIN categoria c ON p.id_categoria = c.id_categoria
    WHERE p.id_producto = ?
    LIMIT 1
  `;

  try {
    const [results] = await db.query(query, [id]);
    if (results.length === 0) {
      return res.status(404).json({ error: "Producto no encontrado" });
    }
    res.status(200).json(results[0]);
  } catch (err) {
    res.status(500).json({ error: "Error al obtener el producto" });
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

// Catálogo de productos con filtros por género y edad
exports.getCatalogoProductos = async (req, res) => {
  const { genero, edad } = req.query;  // Recibiendo los parámetros desde la query string

  // Construir la parte de la consulta para filtrar por género y edad (si están presentes)
  let filterQuery = '';
  
  if (genero) {
    filterQuery += ` AND p.genero = '${genero}'`;  // Filtro por género
  }

  if (edad) {
    filterQuery += ` AND p.edad = '${edad}'`;  // Filtro por edad
  }

  const query = `
    SELECT 
      p.id_producto,
      p.producto,
      p.descripcion,
      p.precio,
      p.material,
      c.categoria,
      p.estado,
      p.genero,
      p.edad
    FROM producto p
    JOIN categoria c ON p.id_categoria = c.id_categoria
    WHERE 1=1 ${filterQuery}  -- Condición básica, con los filtros dinámicos
    ORDER BY p.producto
  `;

  try {
    const [results] = await db.query(query);
    res.status(200).json(results);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al obtener catálogo" });
  }
};

