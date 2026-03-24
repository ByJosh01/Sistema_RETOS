const express = require('express');
const router = express.Router();
const suministrosController = require('../controllers/suministrosController');

router.post('/suministros', suministrosController.registrarSuministro);
router.get('/suministros', suministrosController.obtenerHistorial); 
router.get('/suministros/:folio', suministrosController.buscarTicket); 

module.exports = router;