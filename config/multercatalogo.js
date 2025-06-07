const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Ruta a la carpeta 'catalogo' que está al mismo nivel que 'config'
const uploadCatDir = path.join(__dirname, '..', 'catalogo');

// Asegurarse de que la carpeta exista
if (!fs.existsSync(uploadCatDir)) {
  fs.mkdirSync(uploadCatDir);
}

// Configuración del almacenamiento en disco para catalogo (ahora solo un archivo)
const storageCatalogo = multer.diskStorage({
  destination: (req, file, cb) => {
    // Guardar los archivos en la carpeta 'catalogo'
    cb(null, uploadCatDir);
  },
  filename: (req, file, cb) => {
    // Guardar el nombre del archivo de manera temporal para renombrarlo después con el id_producto
    cb(null, file.originalname); // Se mantiene el nombre original por ahora
  }
});

// Función para validar el tipo de archivo (solo imágenes)
const fileFilterCatalogo = (req, file, cb) => {
  const fileTypes = /jpeg|jpg|png/;
  const extname = fileTypes.test(path.extname(file.originalname).toLowerCase());
  const mimeType = fileTypes.test(file.mimetype);

  if (extname && mimeType) {
    return cb(null, true); // Acepta el archivo
  } else {
    return cb(new Error("Solo se permiten archivos de tipo JPG, JPEG y PNG"), false); // Rechaza el archivo
  }
};

// Configuración de Multer para aceptar un solo archivo para catalogo
const uploadCatalogo = multer({
  storage: storageCatalogo,
  fileFilter: fileFilterCatalogo,
  limits: { fileSize: 10 * 1024 * 1024 }, // Limitar el tamaño a 10 MB por archivo
}).single("catalogo"); // Solo aceptamos un archivo

module.exports = uploadCatalogo;
