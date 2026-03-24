const express = require('express');
const router = express.Router();
const catalogosController = require('../controllers/catalogosController');

router.get('/catalogos', catalogosController.obtenerCatalogos);

module.exports = router;