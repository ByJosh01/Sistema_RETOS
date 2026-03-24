// controllers/authController.js
const dbPool = require('../config/database'); // Importamos la base de datos

const login = async (req, res) => {
    const { username, password } = req.body;

    try {
        const [rows] = await dbPool.query(
            'SELECT * FROM cat_usuarios WHERE username = ? AND password = ? AND estatus_activo = 1',
            [username, password]
        );

        if (rows.length > 0) {
            res.json({ exito: true, usuario: rows[0] });
        } else {
            res.status(401).json({ exito: false, mensaje: 'Usuario o contraseña incorrectos' });
        }
    } catch (error) {
        console.error('Error en el login:', error);
        res.status(500).json({ exito: false, mensaje: 'Error interno del servidor' });
    }
};

// Exportamos la función para que las rutas la puedan usar
module.exports = {
    login
};