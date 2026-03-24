// routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Cuando alguien haga POST a /login, mandarlo al controlador
router.post('/login', authController.login);

module.exports = router;