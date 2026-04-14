import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../suministro/suministro_screen.dart';
import '../suministro/impresion_ticket_screen.dart';
import '../consulta/consulta_screen.dart';
import '../acarreo/acarreo_screen.dart';
import 'admin_dashboard_screen.dart'; // <-- NUEVO: Importamos el panel web

class MainMenuScreen extends StatelessWidget {
  final String nombre;
  final String rol;

  const MainMenuScreen({super.key, required this.nombre, required this.rol});

  @override
  Widget build(BuildContext context) {
    final String rolMin = rol.toLowerCase();

    // --- 1. EL AGENTE DE TRÁNSITO SAAS ---
    // Si el usuario es de oficina/gerencia, lo mandamos al Dashboard Web
    if (rolMin.contains('residente') ||
        rolMin.contains('admin') ||
        rolMin.contains('gerencia')) {
      return AdminDashboardScreen(nombre: nombre, rol: rol);
    }

    // --- 2. SI ES CHECADOR (CAMPO), LE MOSTRAMOS LA APP MÓVIL ---
    final bool esObra = rolMin.contains('obra');
    final String tituloPantalla = esObra
        ? 'Acarreo Material'
        : 'Suministro Material';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFF1C2229),
              child: Text(
                'Bienvenido, $nombre',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    esObra ? Icons.local_shipping : Icons.construction,
                    size: 40,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    tituloPantalla,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Icon(Icons.business, size: 24, color: Colors.red[700]),
                      const Text(
                        'GYBSA',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Botones exclusivos de Banco
                    if (rolMin.contains('banco')) ...[
                      _buildMenuButton(
                        context,
                        'Registro de Suministro',
                        Icons.edit_document,
                        Colors.orange[700]!,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuministroScreen(),
                          ),
                        ),
                      ),
                      _buildMenuButton(
                        context,
                        'Impresión de Ticket',
                        Icons.print,
                        Colors.green[700]!,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ImpresionTicketScreen(),
                          ),
                        ),
                      ),
                    ],
                    // Botones exclusivos de Obra
                    if (esObra) ...[
                      _buildMenuButton(
                        context,
                        'Registro de Acarreo',
                        Icons.handshake,
                        Colors.teal[700]!,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AcarreoScreen(),
                          ),
                        ),
                      ),
                    ],
                    // Botones generales
                    _buildMenuButton(
                      context,
                      'Consulta',
                      Icons.manage_search,
                      Colors.purple[700]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsultaScreen(),
                        ),
                      ),
                    ),
                    _buildMenuButton(
                      context,
                      'Salir',
                      Icons.logout,
                      Colors.blue[700]!,
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                '© 2026 Gybsa Construcciones. Todos los derechos reservados',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 160,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
