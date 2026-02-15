import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/indicator.dart';

class IndicatorPanel extends StatelessWidget {
  final List<StochasticValue> stochastic;

  const IndicatorPanel({
    Key? key,
    required this.stochastic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stochastic Oscillator',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (stochastic.isNotEmpty)
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      if (value == 20 || value == 80) {
                        return FlLine(
                          color: Colors.orange,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      }
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: stochastic.length.toDouble() - 1,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    // %K line
                    LineChartBarData(
                      spots: List.generate(
                        stochastic.length,
                        (index) => FlSpot(index.toDouble(), stochastic[index].k),
                      ),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // %D line
                    LineChartBarData(
                      spots: List.generate(
                        stochastic.length,
                        (index) => FlSpot(index.toDouble(), stochastic[index].d),
                      ),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            )
          else
            const Center(
              child: Text('No stochastic data available'),
            ),
          const SizedBox(height: 16),
          if (stochastic.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '%K: ${stochastic.last.k.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '%D: ${stochastic.last.d.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
