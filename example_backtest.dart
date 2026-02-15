/// Example: How to use the Backtest Engine
/// 
/// This file demonstrates how to run backtests and optimize strategies
/// using the Flutter Trading App's backtest engine.

import 'lib/models/candle.dart';
import 'lib/services/backtest_engine.dart';
import 'lib/services/strategy_engine.dart';
import 'lib/services/virtual_exchange.dart';

void main() async {
  // ignore: avoid_print
  print('=== Flutter Trading App - Backtest Examples ===\n');
  
  // Example 1: Simple Backtest
  await runSimpleBacktest();

  // Example 2: Strategy Optimization
  await optimizeStrategy();

  // Example 3: Multiple Backtests Comparison
  await compareStrategies();
}

/// Example 1: Run a simple backtest
Future<void> runSimpleBacktest() async {
  // ignore: avoid_print
  print('=== Example 1: Simple Backtest ===\n');

  // Create services
  final strategyEngine = StrategyEngine();
  final exchange = VirtualExchange(initialBalance: 10000);
  final backtestEngine = BacktestEngine(
    strategyEngine: strategyEngine,
    exchange: exchange,
  );

  // Generate sample candles (in real app, fetch from OANDA)
  final candles = _generateSampleCandles(500);

  // Run backtest
  try {
    final result = await backtestEngine.runBacktest(
      candles,
      startDate: candles.first.time,
      endDate: candles.last.time,
      verbose: true,
    );

    // Print results
    // ignore: avoid_print
    print('\n${result.toString()}');
    // ignore: avoid_print
    print('Equity Curve Points: ${result.equityCurve.length}');
    // ignore: avoid_print
    print('Max Equity: ${result.equityCurve.reduce((a, b) => a > b ? a : b)}');
    // ignore: avoid_print
    print('Min Equity: ${result.equityCurve.reduce((a, b) => a < b ? a : b)}');
  } catch (e) {
    // ignore: avoid_print
    print('Error running backtest: $e');
  }
}

/// Example 2: Optimize strategy parameters
Future<void> optimizeStrategy() async {
  // ignore: avoid_print
  print('\n=== Example 2: Strategy Optimization ===\n');

  // Create services
  final strategyEngine = StrategyEngine();
  final exchange = VirtualExchange(initialBalance: 10000);
  final backtestEngine = BacktestEngine(
    strategyEngine: strategyEngine,
    exchange: exchange,
  );

  // Generate sample candles
  final candles = _generateSampleCandles(1000);

  // Optimize parameters
  try {
    final bestParams = await backtestEngine.optimizeStrategy(
      candles,
      ema50Periods: [30, 40, 50],
      ema150Periods: [100, 150, 200],
      lotSizes: [0.1, 0.2],
    );

    // ignore: avoid_print
    print('Best Parameters Found:');
    // ignore: avoid_print
    print('EMA50 Period: ${bestParams["ema50"]}');
    // ignore: avoid_print
    print('EMA150 Period: ${bestParams["ema150"]}');
    // ignore: avoid_print
    print('Lot Size: ${bestParams["lotSize"]}');
    // ignore: avoid_print
    print('Total Profit: \$${bestParams["totalProfit"]}');
    // ignore: avoid_print
    print('Win Rate: ${bestParams["winRate"]}%');
  } catch (e) {
    // ignore: avoid_print
    print('Error optimizing strategy: $e');
  }
}

/// Example 3: Compare different strategies
Future<void> compareStrategies() async {
  // ignore: avoid_print
  print('\n=== Example 3: Compare Strategies ===\n');

  // Generate sample candles
  final candles = _generateSampleCandles(500);

  // Test different parameter combinations
  final strategies = [
    {"ema50": 20, "ema150": 50, "name": "Fast"},
    {"ema50": 50, "ema150": 150, "name": "Medium"},
    {"ema50": 100, "ema150": 200, "name": "Slow"},
  ];

  // ignore: avoid_print
  print('Strategy Comparison Results:\n');

  for (final strategy in strategies) {
    final strategyEngine = StrategyEngine();
    final exchange = VirtualExchange(initialBalance: 10000);
    final backtestEngine = BacktestEngine(
      strategyEngine: strategyEngine,
      exchange: exchange,
    );

    // Set parameters
    strategyEngine.ema50Period = strategy["ema50"] as int;
    strategyEngine.ema150Period = strategy["ema150"] as int;

    try {
      final result = await backtestEngine.runBacktest(candles);

      // ignore: avoid_print
      print('${strategy["name"]} Strategy:');
      // ignore: avoid_print
      print('  Total Profit: \$${result.totalProfit.toStringAsFixed(2)}');
      // ignore: avoid_print
      print('  Win Rate: ${result.winRate.toStringAsFixed(2)}%');
      // ignore: avoid_print
      print('  Max Drawdown: ${result.maxDrawdown.toStringAsFixed(2)}%');
      // ignore: avoid_print
      print('  Total Trades: ${result.totalTrades}');
      // ignore: avoid_print
      print('');
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e\n');
    }
  }
}

/// Generate sample candles for testing
List<Candle> _generateSampleCandles(int count) {
  final candles = <Candle>[];
  var price = 2000.0;
  var now = DateTime.now().subtract(Duration(minutes: count));

  for (int i = 0; i < count; i++) {
    // Generate random price movement
    final change = (DateTime.now().millisecond % 10 - 5) * 0.01;
    final open = price;
    price += change;
    final close = price;
    final high = [open, close].reduce((a, b) => a > b ? a : b) + 0.05;
    final low = [open, close].reduce((a, b) => a < b ? a : b) - 0.05;

    candles.add(Candle(
      time: now.add(Duration(minutes: i)),
      open: open,
      high: high,
      low: low,
      close: close,
      volume: 1000 + (i % 500),
    ));
  }

  return candles;
}

/// Example: Custom strategy implementation
class CustomStrategy {
  /// Implement your own trading logic
  /// 
  /// Example: RSI-based strategy
  /// - Buy when RSI < 30 (oversold)
  /// - Sell when RSI > 70 (overbought)
  
  static bool checkBuySignal(List<double> rsiValues) {
    if (rsiValues.isEmpty) return false;
    return rsiValues.last < 30;
  }

  static bool checkSellSignal(List<double> rsiValues) {
    if (rsiValues.isEmpty) return false;
    return rsiValues.last > 70;
  }
}

/// Example: Performance metrics calculation
class PerformanceMetrics {
  /// Calculate Sharpe Ratio
  /// Measures risk-adjusted returns
  static double calculateSharpeRatio(
    List<double> returns, {
    double riskFreeRate = 0.02,
  }) {
    if (returns.isEmpty) return 0;

    // Calculate average return
    final avgReturn = returns.fold<double>(0, (a, b) => a + b) / returns.length;

    // Calculate standard deviation
    double variance = 0;
    for (final ret in returns) {
      variance += (ret - avgReturn) * (ret - avgReturn);
    }
    final stdDev = _calculateSquareRoot(variance / returns.length);

    if (stdDev == 0) return 0;
    return (avgReturn - riskFreeRate) / stdDev;
  }

  /// Calculate Profit Factor
  /// Ratio of gross profit to gross loss
  static double calculateProfitFactor(
    List<double> profits,
    List<double> losses,
  ) {
    final totalProfit = profits.fold<double>(0, (a, b) => a + b);
    final totalLoss = losses.fold<double>(0, (a, b) => a + b).abs();

    if (totalLoss == 0) return 0;
    return totalProfit / totalLoss;
  }

  /// Calculate Recovery Factor
  /// Net profit divided by maximum drawdown
  static double calculateRecoveryFactor(
    double netProfit,
    double maxDrawdown,
  ) {
    if (maxDrawdown == 0) return 0;
    return netProfit / maxDrawdown;
  }
}

/// Helper method to calculate square root using Newton's method
double _calculateSquareRoot(double value) {
  if (value.isNaN || value < 0) return 0;
  if (value == 0) return 0;
  
  double x = value;
  double prev = 0;
  
  while ((x - prev).abs() > 1e-10) {
    prev = x;
    x = (x + value / x) / 2;
  }
  
  return x;
}
