// controllers/suministrosController.js
const dbPool = require('../config/database');

const registrarSuministro = async (req, res) => {
    // 1. Ya NO extraemos id_empresa ni id_checador de aquí
    const { 
        id_banco, id_material, id_destino, 
        id_unidad, cantidad_m3, id_residente, id_sindicato 
    } = req.body;
    
    // 2. Extraemos los datos sensibles directamente del token de seguridad
    const id_empresa = req.usuarioSeguro.id_empresa;
    const id_checador = req.usuarioSeguro.id_usuario;
    
    try {
        const folioGenerado = 'GYB-' + Math.floor(1000 + Math.random() * 9000);
        const fechaHoraActual = new Date().toISOString().slice(0, 19).replace('T', ' ');

        const [resultado] = await dbPool.query(
            `INSERT INTO registro_suministros 
            (folio_suministro, id_empresa, fecha_hora, id_checador, id_banco, id_material, 
             id_destino, id_residente, id_sindicato, id_unidad, cantidad_m3, estatus) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'En tránsito')`,
            [
                // Usamos los IDs extraídos del token
                folioGenerado, id_empresa, fechaHoraActual, id_checador, 
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

const buscarTicket = async (req, res) => {
    const { folio } = req.params; 
    const id_empresa = req.usuarioSeguro.id_empresa; // <-- Seguridad SaaS

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
            WHERE rs.folio_suministro = ? AND rs.id_empresa = ? 
        `, [folio, id_empresa]); // <-- Condición vital: Folio Y Empresa

        if (viajes.length > 0) {
            res.json({ exito: true, viaje: viajes[0] });
        } else {
            // El mensaje es genérico para no darle pistas a quien intente adivinar folios de otras empresas
            res.status(404).json({ exito: false, mensaje: 'El folio no existe o pertenece a otra empresa' });
        }
    } catch (error) {
        console.error('Error al buscar ticket:', error);
        res.status(500).json({ exito: false, mensaje: 'Error del servidor' });
    }
};

const obtenerHistorial = async (req, res) => {
    const id_empresa = req.usuarioSeguro.id_empresa; // <-- Seguridad SaaS

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
            WHERE rs.id_empresa = ? 
            ORDER BY rs.fecha_hora DESC
        `, [id_empresa]); // <-- Aislamos los datos, el usuario solo ve su historial
        
        res.json({ exito: true, datos: historial });
    } catch (error) {
        console.error('Error al obtener el historial:', error);
        res.status(500).json({ exito: false, mensaje: 'Error al cargar las consultas' });
    }
};

module.exports = { registrarSuministro, buscarTicket, obtenerHistorial };