import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketAcarreoScreen extends StatelessWidget {
  final Map<String, dynamic> datosViaje;
  final String folioAcarreo;
  final double kmReales;
  final double m3Reales;

  const TicketAcarreoScreen({
    super.key,
    required this.datosViaje,
    required this.folioAcarreo,
    required this.kmReales,
    required this.m3Reales,
  });

  Widget _buildFila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              etiqueta,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                valor.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
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
    final String fechaHoy =
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ticket Acarreo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C2229),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text(
              'Ticket Acarreo Material',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Fecha: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  color: Colors.grey[200],
                  child: Text(
                    fechaHoy,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Folio Suministro:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.grey[300],
                  child: Text(
                    datosViaje['folio_suministro'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Text(
                  'Folio Acarreo:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.grey[300],
                  child: Text(
                    folioAcarreo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFila('Banco:', datosViaje['nombre_banco'] ?? ''),
            _buildFila('Material:', datosViaje['nombre_material'] ?? ''),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                  child: Text(
                    'Cantidad:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  color: Colors.grey[200],
                  child: Text(
                    m3Reales.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Distancia (km):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  color: Colors.grey[200],
                  child: Text(
                    kmReales.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            _buildFila('Unidad:', datosViaje['unidad'] ?? ''),
            _buildFila('Sindicato:', datosViaje['nombre_sindicato'] ?? ''),
            _buildFila('Destino:', datosViaje['nombre_destino'] ?? ''),
            _buildFila('Residente:', datosViaje['residente'] ?? ''),
            const SizedBox(height: 30),
            QrImageView(
              data: folioAcarreo,
              version: QrVersions.auto,
              size: 120.0,
            ),
            Text(
              folioAcarreo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5D6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
