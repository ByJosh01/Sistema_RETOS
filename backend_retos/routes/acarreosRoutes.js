// routes/acarreosRoutes.js
const express = require('express');
const router = express.Router();
const acarreosController = require('../controllers/acarreosController');

// Ruta POST para recibir el viaje
router.post('/acarreos', acarreosController.registrarAcarreo);

module.exports = router;