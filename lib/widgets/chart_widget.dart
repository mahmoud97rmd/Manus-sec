import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/candle.dart';
import '../models/indicator.dart';

class ChartWidget extends StatelessWidget {
  final List<Candle> candles;
  final List<IndicatorValue> ema50;
  final List<IndicatorValue> ema150;

  const ChartWidget({
    Key? key,
    required this.candles,
    required this.ema50,
    required this.ema150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getHorizontalInterval(),
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
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
              interval: _getXInterval(),
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
              interval: _getYInterval(),
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(2),
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
        maxX: candles.length.toDouble() - 1,
        minY: _getMinPrice(),
        maxY: _getMaxPrice(),
        lineBarsData: [
          // EMA 50
          LineChartBarData(
            spots: _getEMASpots(ema50),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // EMA 150
          LineChartBarData(
            spots: _getEMASpots(ema150),
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Close prices
          LineChartBarData(
            spots: _getCloseSpots(),
            isCurved: true,
            color: Colors.grey[400]!,
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < candles.length) {
                  final candle = candles[index];
                  return LineTooltipItem(
                    'O: ${candle.open.toStringAsFixed(5)}\nH: ${candle.high.toStringAsFixed(5)}\nL: ${candle.low.toStringAsFixed(5)}\nC: ${candle.close.toStringAsFixed(5)}',
                    const TextStyle(color: Colors.black),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getCloseSpots() {
    return List.generate(
      candles.length,
      (index) => FlSpot(index.toDouble(), candles[index].close),
    );
  }

  List<FlSpot> _getEMASpots(List<IndicatorValue> indicators) {
    if (indicators.isEmpty) return [];

    final offset = candles.length - indicators.length;
    return List.generate(
      indicators.length,
      (index) => FlSpot((index + offset).toDouble(), indicators[index].value),
    );
  }

  double _getMinPrice() {
    double min = candles.first.low;
    for (final candle in candles) {
      if (candle.low < min) min = candle.low;
    }
    return min * 0.99;
  }

  double _getMaxPrice() {
    double max = candles.first.high;
    for (final candle in candles) {
      if (candle.high > max) max = candle.high;
    }
    return max * 1.01;
  }

  double _getHorizontalInterval() {
    final range = _getMaxPrice() - _getMinPrice();
    return range / 10;
  }

  double _getYInterval() {
    final range = _getMaxPrice() - _getMinPrice();
    return range / 5;
  }

  double _getXInterval() {
    return candles.length / 10;
  }
}
