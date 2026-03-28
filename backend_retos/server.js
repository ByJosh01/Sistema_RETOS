// server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

// 1. IMPORTAR RUTAS
const authRoutes = require('./routes/authRoutes');
const catalogosRoutes = require('./routes/catalogosRoutes'); 
const suministrosRoutes = require('./routes/suministrosRoutes'); 
const acarreosRoutes = require('./routes/acarreosRoutes'); // <--- AÑADE ESTO

const app = express();

// 2. MIDDLEWARES
app.use(cors());
app.use(express.json());

// 3. USAR LAS RUTAS
app.use('/api', authRoutes); 
app.use('/api', catalogosRoutes);
app.use('/api', suministrosRoutes);
app.use('/api', acarreosRoutes); // <--- AÑADE ESTO

// 4. ENCENDER EL SERVIDOR
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor RETOS corriendo en el puerto ${PORT}`);
});
