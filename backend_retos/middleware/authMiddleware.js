const jwt = require('jsonwebtoken');

const verificarToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ exito: false, mensaje: "Acceso denegado. Token no proporcionado." });
    }

    try {
        const decodificado = jwt.verify(token, process.env.JWT_SECRET || 'ClaveSecretaRetos2026SaaS');
        req.usuarioSeguro = decodificado;
        next();
    } catch (error) {
        return res.status(403).json({ exito: false, mensaje: "Token inválido o expirado." });
    }
};

module.exports = verificarToken;