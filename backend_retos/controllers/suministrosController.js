// controllers/suministrosController.js
const dbPool = require('../config/database');

const registrarSuministro = async (req, res) => {
    const { 
        id_checador, id_banco, id_material, id_destino, 
        id_unidad, cantidad_m3, id_empresa, id_residente, id_sindicato 
    } = req.body;
    
    try {
        const folioGenerado = 'GYB-' + Math.floor(1000 + Math.random() * 9000);
        const fechaHoraActual = new Date().toISOString().slice(0, 19).replace('T', ' ');

        const [resultado] = await dbPool.query(
            `INSERT INTO registro_suministros 
            (folio_suministro, id_empresa, fecha_hora, id_checador, id_banco, id_material, 
             id_destino, id_residente, id_sindicato, id_unidad, cantidad_m3, estatus) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'En tránsito')`,
            [
                folioGenerado, id_empresa || 1, fechaHoraActual, id_checador || 1, 
                id_banco, id_material, id_destino, id_residente, id_sindicato, id_unidad, cantidad_m3
            ]
        );

        if (resultado.affectedRows > 0) {
            res.json({ exito: true, folio_qr: folioGenerado });
        } else {
            res.status(500).json({ exito: false, mensaje: 'No se pudo insertar en la base de datos' });
        }
    } catch (error) {
        console.error('Error al guardar suministro en MySQL:', error);
        res.status(500).json({ exito: false, mensaje: 'Error interno al guardar en BD' });
    }
};

// --- AQUI ESTA LA MAGIA NUEVA ---
const buscarTicket = async (req, res) => {
    const { folio } = req.params; 

    try {
        const [viajes] = await dbPool.query(`
            SELECT 
                rs.folio_suministro,
                b.nombre_banco,
                m.nombre_material,
                d.nombre_destino,
                u.placas_o_num as unidad,
                r.nombre_completo as residente,
                s.nombre_sindicato
            FROM registro_suministros rs
            LEFT JOIN cat_bancos b ON rs.id_banco = b.id_banco
            LEFT JOIN cat_materiales m ON rs.id_material = m.id_material
            LEFT JOIN cat_destinos d ON rs.id_destino = d.id_destino
            LEFT JOIN cat_unidades u ON rs.id_unidad = u.id_unidad
            LEFT JOIN cat_usuarios r ON rs.id_residente = r.id_usuario
            LEFT JOIN cat_sindicatos s ON rs.id_sindicato = s.id_sindicato
            WHERE rs.folio_suministro = ?
        `, [folio]);

        if (viajes.length > 0) {
            // Mandamos todo el objeto 'viaje' de regreso a Flutter
            res.json({ exito: true, viaje: viajes[0] });
        } else {
            res.status(404).json({ exito: false, mensaje: 'El folio no existe' });
        }
    } catch (error) {
        console.error('Error al buscar ticket:', error);
        res.status(500).json({ exito: false, mensaje: 'Error del servidor' });
    }
};

const obtenerHistorial = async (req, res) => {
    try {
        const [historial] = await dbPool.query(`
            SELECT 
                rs.folio_suministro, rs.fecha_hora, rs.cantidad_m3, rs.estatus,
                b.nombre_banco, m.nombre_material, d.nombre_destino, u.placas_o_num as unidad
            FROM registro_suministros rs
            LEFT JOIN cat_bancos b ON rs.id_banco = b.id_banco
            LEFT JOIN cat_materiales m ON rs.id_material = m.id_material
            LEFT JOIN cat_destinos d ON rs.id_destino = d.id_destino
            LEFT JOIN cat_unidades u ON rs.id_unidad = u.id_unidad
            ORDER BY rs.fecha_hora DESC
        `);
        res.json({ exito: true, datos: historial });
    } catch (error) {
        console.error('Error al obtener el historial:', error);
        res.status(500).json({ exito: false, mensaje: 'Error al cargar las consultas' });
    }
};

module.exports = { registrarSuministro, buscarTicket, obtenerHistorial };