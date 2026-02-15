import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/indicator.dart';

class IndicatorCalculator {
  final Logger logger = Logger();

  /// Calculate Exponential Moving Average (EMA)
  List<IndicatorValue> calculateEMA(
    List<Candle> candles,
    int period,
  ) {
    if (candles.isEmpty || period <= 0) return [];

    final result = <IndicatorValue>[];
    double? ema;
    final multiplier = 2.0 / (period + 1);

    for (int i = 0; i < candles.length; i++) {
      if (i < period - 1) {
        continue;
      }

      if (i == period - 1) {
        // Calculate SMA for the first EMA value
        double sum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          sum += candles[j].close;
        }
        ema = sum / period;
      } else {
        // Calculate EMA using the recursive formula
        ema = (candles[i].close - ema!) * multiplier + ema;
      }

      result.add(IndicatorValue(
        time: candles[i].time,
        value: ema!,
      ));
    }

    return result;
  }

  /// Calculate Stochastic Oscillator
  List<StochasticValue> calculateStochastic(
    List<Candle> candles, {
    int kPeriod = 14,
    int dPeriod = 3,
    int slowPeriod = 3,
  }) {
    if (candles.isEmpty || kPeriod <= 0) return [];

    final result = <StochasticValue>[];
    final kValues = <double>[];

    for (int i = kPeriod - 1; i < candles.length; i++) {
      // Find highest high and lowest low in the period
      double highestHigh = candles[i - kPeriod + 1].high;
      double lowestLow = candles[i - kPeriod + 1].low;

      for (int j = i - kPeriod + 1; j <= i; j++) {
        if (candles[j].high > highestHigh) {
          highestHigh = candles[j].high;
        }
        if (candles[j].low < lowestLow) {
          lowestLow = candles[j].low;
        }
      }

      // Calculate %K
      final range = highestHigh - lowestLow;
      final k = range == 0
          ? 50.0
          : ((candles[i].close - lowestLow) / range) * 100;

      kValues.add(k);
    }

    // Calculate %D (SMA of %K)
    for (int i = 0; i < kValues.length; i++) {
      if (i < dPeriod - 1) {
        continue;
      }

      double dSum = 0;
      for (int j = i - dPeriod + 1; j <= i; j++) {
        dSum += kValues[j];
      }
      final d = dSum / dPeriod;

      result.add(StochasticValue(
        time: candles[kPeriod - 1 + i].time,
        k: kValues[i],
        d: d,
      ));
    }

    return result;
  }

  /// Calculate Simple Moving Average (SMA)
  List<IndicatorValue> calculateSMA(
    List<Candle> candles,
    int period,
  ) {
    if (candles.isEmpty || period <= 0) return [];

    final result = <IndicatorValue>[];

    for (int i = period - 1; i < candles.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += candles[j].close;
      }
      final sma = sum / period;

      result.add(IndicatorValue(
        time: candles[i].time,
        value: sma,
      ));
    }

    return result;
  }

  /// Calculate Relative Strength Index (RSI)
  List<IndicatorValue> calculateRSI(
    List<Candle> candles,
    int period,
  ) {
    if (candles.isEmpty || period <= 0 || candles.length < period + 1) {
      return [];
    }

    final result = <IndicatorValue>[];
    double avgGain = 0;
    double avgLoss = 0;

    // Calculate initial average gain and loss
    for (int i = 1; i <= period; i++) {
      final change = candles[i].close - candles[i - 1].close;
      if (change > 0) {
        avgGain += change;
      } else {
        avgLoss += change.abs();
      }
    }

    avgGain /= period;
    avgLoss /= period;

    for (int i = period + 1; i < candles.length; i++) {
      final change = candles[i].close - candles[i - 1].close;
      final gain = change > 0 ? change : 0;
      final loss = change < 0 ? change.abs() : 0;

      avgGain = (avgGain * (period - 1) + gain) / period;
      avgLoss = (avgLoss * (period - 1) + loss) / period;

      final rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
      final rsi = 100 - (100 / (1 + rs));

      result.add(IndicatorValue(
        time: candles[i].time,
        value: rsi,
      ));
    }

    return result;
  }

  /// Calculate MACD (Moving Average Convergence Divergence)
  List<Map<String, double>> calculateMACD(
    List<Candle> candles, {
    int fastPeriod = 12,
    int slowPeriod = 26,
    int signalPeriod = 9,
  }) {
    if (candles.isEmpty) return [];

    final fastEMA = calculateEMA(candles, fastPeriod);
    final slowEMA = calculateEMA(candles, slowPeriod);

    if (fastEMA.isEmpty || slowEMA.isEmpty) return [];

    final macdLine = <double>[];
    final startIndex = slowPeriod - fastPeriod;

    for (int i = 0; i < fastEMA.length; i++) {
      macdLine.add(fastEMA[i + startIndex].value - slowEMA[i].value);
    }

    // Calculate signal line (EMA of MACD)
    final signalLine = <double>[];
    double? signalEMA;
    final multiplier = 2.0 / (signalPeriod + 1);

    for (int i = 0; i < macdLine.length; i++) {
      if (i < signalPeriod - 1) {
        continue;
      }

      if (i == signalPeriod - 1) {
        double sum = 0;
        for (int j = 0; j < signalPeriod; j++) {
          sum += macdLine[j];
        }
        signalEMA = sum / signalPeriod;
      } else {
        signalEMA = (macdLine[i] - signalEMA!) * multiplier + signalEMA;
      }

      signalLine.add(signalEMA!);
    }

    // Create result
    final result = <Map<String, double>>[];
    final startIdx = slowPeriod + signalPeriod - 2;

    for (int i = startIdx; i < candles.length; i++) {
      final idx = i - startIdx;
      if (idx < macdLine.length && idx < signalLine.length) {
        result.add({
          'macd': macdLine[idx],
          'signal': signalLine[idx],
          'histogram': macdLine[idx] - signalLine[idx],
        });
      }
    }

    return result;
  }

  /// Calculate Bollinger Bands
  List<Map<String, double>> calculateBollingerBands(
    List<Candle> candles, {
    int period = 20,
    double stdDevMultiplier = 2.0,
  }) {
    if (candles.isEmpty || period <= 0) return [];

    final result = <Map<String, double>>[];

    for (int i = period - 1; i < candles.length; i++) {
      // Calculate SMA
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += candles[j].close;
      }
      final sma = sum / period;

      // Calculate standard deviation
      double variance = 0;
      for (int j = i - period + 1; j <= i; j++) {
        variance += (candles[j].close - sma) * (candles[j].close - sma);
      }
      variance /= period;
      final stdDev = variance.isNaN ? 0 : stdDev = variance.sqrt();

      result.add({
        'middle': sma,
        'upper': sma + (stdDev * stdDevMultiplier),
        'lower': sma - (stdDev * stdDevMultiplier),
      });
    }

    return result;
  }
}
