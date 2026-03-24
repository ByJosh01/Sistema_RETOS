import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Importamos la memoria
import 'registro_imagenes_screen.dart';

class SuministroScreen extends StatefulWidget {
  const SuministroScreen({super.key});

  @override
  State<SuministroScreen> createState() => _SuministroScreenState();
}

class _SuministroScreenState extends State<SuministroScreen> {
  // Variables de datos
  List<dynamic> _bancos = [];
  List<dynamic> _materiales = [];
  List<dynamic> _destinos = [];
  List<dynamic> _unidades = [];
  List<dynamic> _residentes = [];
  List<dynamic> _sindicatos = [];

  int? _selectedBanco;
  int? _selectedMaterial;
  int? _selectedDestino;
  int? _selectedUnidad;
  int? _selectedResidente;
  int? _selectedSindicato;

  final TextEditingController _cantidadController = TextEditingController();

  bool _isLoadingCatalogos = true;
  bool _isSubmitting = false;

  // --- NUEVAS VARIABLES DE SESIÓN ---
  int _idEmpresa = 1;
  String _nombreChecador = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  // --- FUNCIÓN PARA LEER LA MEMORIA ANTES DE CARGAR CATÁLOGOS ---
  Future<void> _inicializarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idEmpresa = prefs.getInt('id_empresa') ?? 1;
      _nombreChecador = prefs.getString('nombre_completo') ?? 'Checador';
    });

    // Ahora que ya sabemos de qué empresa es, bajamos sus catálogos
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    try {
      final String ipServidor = kIsWeb
          ? 'http://localhost:3000'
          : 'http://10.0.2.2:3000';

      // AHORA USA EL ID DE LA EMPRESA REAL
      final url = Uri.parse('$ipServidor/api/catalogos?id_empresa=$_idEmpresa');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['exito'] == true) {
        setState(() {
          _bancos = data['datos']['bancos'];
          _materiales = data['datos']['materiales'];
          _destinos = data['datos']['destinos'];
          _unidades = data['datos']['unidades'];
          _residentes = data['datos']['residentes'] ?? [];
          _sindicatos = data['datos']['sindicatos'] ?? [];
          _isLoadingCatalogos = false;
        });
      }
    } catch (e) {
      _mostrarMensaje('Error al conectar con el servidor', Colors.red);
      setState(() {
        _isLoadingCatalogos = false;
      });
    }
  }

  void _irAPantallaFotos() {
    if (_selectedBanco == null ||
        _selectedMaterial == null ||
        _selectedDestino == null ||
        _selectedUnidad == null ||
        _selectedResidente == null ||
        _selectedSindicato == null ||
        _cantidadController.text.isEmpty) {
      _mostrarMensaje('Por favor, completa todos los campos', Colors.orange);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroImagenesScreen(
          idBanco: _selectedBanco!,
          idMaterial: _selectedMaterial!,
          idResidente: _selectedResidente!,
          idDestino: _selectedDestino!,
          idSindicato: _selectedSindicato!,
          idUnidad: _selectedUnidad!,
          cantidadM3: double.tryParse(_cantidadController.text) ?? 0,
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Registro de Suministro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1C2229),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoadingCatalogos
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF4A5D6A)),
                  SizedBox(height: 15),
                  Text(
                    'Cargando catálogos...',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TARJETA DE CABECERA (Info del Checador) ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF4A5D6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // AHORA MUESTRA EL NOMBRE REAL DEL CHECADOR
                              Text(
                                _nombreChecador,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Origen: BANCO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Text(
                      'Datos del Viaje',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2229),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- TARJETA DEL FORMULARIO ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildAnimatedInput(
                            'Cantidad m3',
                            Icons.straighten,
                            TextField(
                              controller: _cantidadController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _cleanInputDecoration('Ej. 14.5'),
                            ),
                          ),
                          const Divider(height: 30, color: Colors.black12),
                          _buildAnimatedInput(
                            'Banco',
                            Icons.landscape,
                            _buildDropdown(
                              _selectedBanco,
                              _bancos,
                              'id_banco',
                              'nombre_banco',
                              (val) => setState(() => _selectedBanco = val),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedInput(
                            'Material',
                            Icons.layers,
                            _buildDropdown(
                              _selectedMaterial,
                              _materiales,
                              'id_material',
                              'nombre_material',
                              (val) => setState(() => _selectedMaterial = val),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedInput(
                            'Residente',
                            Icons.person,
                            _buildDropdown(
                              _selectedResidente,
                              _residentes,
                              'id_residente',
                              'nombre_completo',
                              (val) => setState(() => _selectedResidente = val),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedInput(
                            'Destino',
                            Icons.place,
                            _buildDropdown(
                              _selectedDestino,
                              _destinos,
                              'id_destino',
                              'nombre_destino',
                              (val) => setState(() => _selectedDestino = val),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedInput(
                            'Sindicato',
                            Icons.group,
                            _buildDropdown(
                              _selectedSindicato,
                              _sindicatos,
                              'id_sindicato',
                              'nombre_sindicato',
                              (val) => setState(() => _selectedSindicato = val),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildAnimatedInput(
                            'Unidad',
                            Icons.local_shipping,
                            _buildDropdown(
                              _selectedUnidad,
                              _unidades,
                              'id_unidad',
                              'placas_o_num',
                              (val) => setState(() => _selectedUnidad = val),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- BOTÓN FLOTANTE ESTILO MODERNO ---
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isSubmitting ? null : _irAPantallaFotos,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Continuar a Evidencia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAnimatedInput(String label, IconData icon, Widget inputField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: inputField,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    int? value,
    List<dynamic> items,
    String idKey,
    String nameKey,
    Function(int?) onChanged,
  ) {
    return DropdownButtonFormField<int>(
      decoration: _cleanInputDecoration('Seleccionar...'),
      value: value,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.blueGrey,
      ),
      isExpanded: true,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      items: items
          .map(
            (item) => DropdownMenuItem<int>(
              value: item[idKey],
              child: Text(
                item[nameKey].toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _cleanInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }
}
