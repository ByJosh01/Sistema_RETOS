import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- 1. Importamos la memoria
import 'registro_imagenes_acarreo_screen.dart';

class RecepcionFormularioScreen extends StatefulWidget {
  final Map<String, dynamic> datosViaje;

  const RecepcionFormularioScreen({super.key, required this.datosViaje});

  @override
  State<RecepcionFormularioScreen> createState() =>
      _RecepcionFormularioScreenState();
}

class _RecepcionFormularioScreenState extends State<RecepcionFormularioScreen> {
  final TextEditingController _m3Controller = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  // --- NUEVA VARIABLE DE SESIÓN ---
  String _nombreChecador = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _cargarDatosMemoria();
  }

  // --- LEER EL NOMBRE DE LA MEMORIA ---
  Future<void> _cargarDatosMemoria() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreChecador = prefs.getString('nombre_completo') ?? 'Checador Obra';
    });
  }

  void _irAFotos() {
    if (_m3Controller.text.isEmpty || _kmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor ingrese distancia y cantidad',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroImagenesAcarreoScreen(
          datosViaje: widget.datosViaje,
          distanciaKm: double.parse(_kmController.text),
          cantidadM3: double.parse(_m3Controller.text),
        ),
      ),
    );
  }

  Widget _buildCampoLectura(String etiqueta, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              etiqueta,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                valor?.toUpperCase() ?? 'N/A',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final datos = widget.datosViaje;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Acarreo Material',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1C2229),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // --- AHORA MUESTRA EL NOMBRE REAL ---
                Text(
                  _nombreChecador,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Text(
                  'Distancia: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(
                  width: 60,
                  height: 35,
                  child: TextField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Cantidad: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(
                  width: 60,
                  height: 35,
                  child: TextField(
                    controller: _m3Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.qr_code, size: 40, color: Colors.grey[800]),
                const Spacer(),
                const Text(
                  'Origen (Folio Banco): ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    datos['folio_suministro'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildCampoLectura('Banco:', datos['nombre_banco']),
            _buildCampoLectura('Material:', datos['nombre_material']),
            _buildCampoLectura('Residente:', datos['residente']),
            _buildCampoLectura('Destino:', datos['nombre_destino']),
            _buildCampoLectura('Sindicato:', datos['nombre_sindicato']),
            _buildCampoLectura('Unidad:', datos['unidad']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5D6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _irAFotos,
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
