const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Ruta a la carpeta 'uploads' que está al mismo nivel que 'config'
const uploadDir = path.join(__dirname, '..', 'uploads');  // Subir un nivel para acceder a 'uploads'

// Asegurarse de que la carpeta exista
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Configuración del almacenamiento en disco
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Guardar los archivos en la carpeta 'uploads'
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    // Generar un nombre único para evitar sobreescritura
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname)); // Mantener la extensión original
  }
});

// Función para validar el tipo de archivo (solo imágenes)
const fileFilter = (req, file, cb) => {
  const fileTypes = /jpeg|jpg|png/;
  const extname = fileTypes.test(path.extname(file.originalname).toLowerCase());
  const mimeType = fileTypes.test(file.mimetype);

  if (extname && mimeType) {
    return cb(null, true); // Acepta el archivo
  } else {
    return cb(new Error("Solo se permiten archivos de tipo JPG, JPEG y PNG"), false); // Rechaza el archivo
  }
};

// Configuración de Multer
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: { fileSize: 10 * 1024 * 1024 } // Limitar el tamaño a 10 MB por archivo
});

module.exports = upload;
