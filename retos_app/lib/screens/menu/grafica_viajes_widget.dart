import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GraficaViajesSemanal extends StatefulWidget {
  const GraficaViajesSemanal({super.key});

  @override
  State<GraficaViajesSemanal> createState() => _GraficaViajesSemanalState();
}

class _GraficaViajesSemanalState extends State<GraficaViajesSemanal> {
  // 1. Empezamos con los datos en 0 para que la animación se vea al "crecer"
  List<double> datosGrafica = [0, 0, 0, 0, 0, 0, 0];
  final List<double> datosReales = [35, 42, 18, 48, 25, 30, 15];

  @override
  void initState() {
    super.initState();
    // 2. Disparamos la animación después de que se dibuje el primer frame
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          datosGrafica = datosReales;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Productividad Semanal (Viajes)",
          style: TextStyle(
            color: Color(0xFF2B3674),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 55,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF111C44),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.round()} viajes',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = [
                        'Lun',
                        'Mar',
                        'Mie',
                        'Jue',
                        'Vie',
                        'Sab',
                        'Dom',
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          days[value.toInt()],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: _generarGrupos(),
            ),
            // --- AQUÍ ESTÁ EL CONTROL DE LA ANIMACIÓN ---
            swapAnimationDuration: const Duration(
              milliseconds: 1000,
            ), // 1 segundo de duración
            swapAnimationCurve:
                Curves.elasticOut, // Efecto de rebote al llegar arriba
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _generarGrupos() {
    return List.generate(datosGrafica.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: datosGrafica[i],
            color: const Color(0xFF4318FF),
            width: 24,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            // Sombra interna o fondo de la barra
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 55,
              color: const Color(0xFFF4F7FE),
            ),
          ),
        ],
      );
    });
  }
}
