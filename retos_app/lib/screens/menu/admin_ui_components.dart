// lib/screens/menu/admin_ui_components.dart
import 'package:flutter/material.dart';

// 1. Botón del Menú Lateral Animado
class BotonLateralAnimado extends StatefulWidget {
  final IconData icono;
  final String titulo;
  final bool estaSeleccionado;
  final VoidCallback onTap;

  const BotonLateralAnimado({
    super.key,
    required this.icono,
    required this.titulo,
    required this.estaSeleccionado,
    required this.onTap,
  });

  @override
  State<BotonLateralAnimado> createState() => _BotonLateralAnimadoState();
}

class _BotonLateralAnimadoState extends State<BotonLateralAnimado> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          transform: Matrix4.identity()
            ..translate(
              _isHovering && !widget.estaSeleccionado ? 5.0 : 0.0,
              0.0,
            ),
          decoration: BoxDecoration(
            color: widget.estaSeleccionado
                ? const Color(0xFF4318FF)
                : _isHovering
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              widget.icono,
              color: widget.estaSeleccionado || _isHovering
                  ? Colors.white
                  : Colors.white54,
            ),
            title: Text(
              widget.titulo,
              style: TextStyle(
                color: widget.estaSeleccionado || _isHovering
                    ? Colors.white
                    : Colors.white54,
                fontWeight: widget.estaSeleccionado
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 2. Tarjeta de Estadísticas Animada
class TarjetaEstadisticaAnimada extends StatefulWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color colorIcono;

  const TarjetaEstadisticaAnimada({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.colorIcono,
  });

  @override
  State<TarjetaEstadisticaAnimada> createState() =>
      _TarjetaEstadisticaAnimadaState();
}

class _TarjetaEstadisticaAnimadaState extends State<TarjetaEstadisticaAnimada> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovering ? -8.0 : 0.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovering
                    ? Colors.black.withOpacity(0.15)
                    : Colors.black12,
                blurRadius: _isHovering ? 20 : 10,
                offset: _isHovering ? const Offset(0, 10) : const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: widget.colorIcono.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icono, color: widget.colorIcono, size: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.valor,
                    style: const TextStyle(
                      color: const Color(0xFF2B3674),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
