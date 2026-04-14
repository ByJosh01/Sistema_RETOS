// routes/suministrosRoutes.js
const express = require('express');
const router = express.Router();
const suministrosController = require('../controllers/suministrosController');
const verificarToken = require('../middleware/authMiddleware'); // <-- Importamos al guardia

// Protegemos absolutamente todas las rutas de suministros exigiendo el token
router.post('/suministros', verificarToken, suministrosController.registrarSuministro);
router.get('/suministros', verificarToken, suministrosController.obtenerHistorial); 
router.get('/suministros/:folio', verificarToken, suministrosController.buscarTicket); 

module.exports = router;