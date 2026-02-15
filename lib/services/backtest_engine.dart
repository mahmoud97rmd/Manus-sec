import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/position.dart';
import 'virtual_exchange.dart';
import 'strategy_engine.dart';

class BacktestResult {
  final double initialBalance;
  final double finalBalance;
  final double totalProfit;
  final double profitPercent;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double maxDrawdown;
  final List<double> equityCurve;
  final List<Position> trades;
  final DateTime startDate;
  final DateTime endDate;

  BacktestResult({
    required this.initialBalance,
    required this.finalBalance,
    required this.totalProfit,
    required this.profitPercent,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.maxDrawdown,
    required this.equityCurve,
    required this.trades,
    required this.startDate,
    required this.endDate,
  });

  @override
  String toString() {
    return '''
BacktestResult:
  Initial Balance: \$${initialBalance.toStringAsFixed(2)}
  Final Balance: \$${finalBalance.toStringAsFixed(2)}
  Total Profit: \$${totalProfit.toStringAsFixed(2)} (${profitPercent.toStringAsFixed(2)}%)
  Total Trades: $totalTrades
  Winning Trades: $winningTrades
  Losing Trades: $losingTrades
  Win Rate: ${winRate.toStringAsFixed(2)}%
  Max Drawdown: ${maxDrawdown.toStringAsFixed(2)}%
  Period: $startDate to $endDate
    ''';
  }
}

class BacktestEngine {
  final Logger logger = Logger();
  final StrategyEngine strategyEngine;
  final VirtualExchange exchange;

  BacktestEngine({
    required this.strategyEngine,
    required this.exchange,
  });

  /// Run backtest on historical candles
  Future<BacktestResult> runBacktest(
    List<Candle> candles, {
    DateTime? startDate,
    DateTime? endDate,
    bool verbose = false,
  }) async {
    if (candles.isEmpty) {
      throw Exception('No candles provided for backtest');
    }

    logger.i('Starting backtest with ${candles.length} candles');

    // Filter candles by date range
    final filteredCandles = _filterCandlesByDate(candles, startDate, endDate);
    if (filteredCandles.isEmpty) {
      throw Exception('No candles in the specified date range');
    }

    // Reset exchange and strategy
    exchange.reset();
    strategyEngine.reset();
    strategyEngine.setActive(true);

    final equityCurve = <double>[exchange.equity];
    double maxEquity = exchange.equity;
    double maxDrawdown = 0;

    // Process each candle
    for (int i = 0; i < filteredCandles.length; i++) {
      final candle = filteredCandles[i];

      // Update indicators
      final candlesUpToNow = filteredCandles.sublist(0, i + 1);
      strategyEngine.updateIndicators(candlesUpToNow);

      // Check for signals
      final signal = strategyEngine.checkSignal(candlesUpToNow);

      // Execute trade if signal
      if (signal != TradeSignal.none) {
        strategyEngine.executeTrade(signal, candle.close, exchange);
      }

      // Update prices for open positions
      exchange.updatePrice(candle.close);

      // Record equity
      equityCurve.add(exchange.equity);

      // Calculate drawdown
      if (exchange.equity > maxEquity) {
        maxEquity = exchange.equity;
      }
      final drawdown = ((maxEquity - exchange.equity) / maxEquity) * 100;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }

      if (verbose && i % 100 == 0) {
        logger.d('Backtest progress: ${(i / filteredCandles.length * 100).toStringAsFixed(2)}%');
      }
    }

    // Close any remaining open positions at the last price
    if (exchange.openPositions.isNotEmpty) {
      exchange.closeAllPositions(filteredCandles.last.close);
    }

    // Calculate results
    final stats = exchange.getStatistics();
    final result = BacktestResult(
      initialBalance: exchange.balance - stats['totalProfit'],
      finalBalance: exchange.balance,
      totalProfit: stats['totalProfit'],
      profitPercent: ((stats['totalProfit']) / (exchange.balance - stats['totalProfit'])) * 100,
      totalTrades: stats['totalTrades'],
      winningTrades: stats['winningTrades'],
      losingTrades: stats['losingTrades'],
      winRate: stats['winRate'],
      maxDrawdown: maxDrawdown,
      equityCurve: equityCurve,
      trades: exchange.closedPositions,
      startDate: filteredCandles.first.time,
      endDate: filteredCandles.last.time,
    );

    logger.i('Backtest completed: $result');
    return result;
  }

  /// Optimize strategy parameters
  Future<Map<String, dynamic>> optimizeStrategy(
    List<Candle> candles, {
    List<int>? ema50Periods,
    List<int>? ema150Periods,
    List<double>? lotSizes,
  }) async {
    logger.i('Starting strategy optimization');

    ema50Periods ??= [30, 40, 50, 60, 70];
    ema150Periods ??= [100, 150, 200];
    lotSizes ??= [0.05, 0.1, 0.2];

    BacktestResult? bestResult;
    Map<String, dynamic> bestParams = {};

    int totalTests = ema50Periods.length * ema150Periods.length * lotSizes.length;
    int currentTest = 0;

    for (final ema50 in ema50Periods) {
      for (final ema150 in ema150Periods) {
        for (final lotSize in lotSizes) {
          currentTest++;

          // Skip invalid combinations
          if (ema50 >= ema150) continue;

          // Update strategy parameters
          strategyEngine.ema50Period = ema50;
          strategyEngine.ema150Period = ema150;
          strategyEngine.lotSize = lotSize;

          try {
            final result = await runBacktest(candles);

            if (bestResult == null || result.totalProfit > bestResult.totalProfit) {
              bestResult = result;
              bestParams = {
                'ema50': ema50,
                'ema150': ema150,
                'lotSize': lotSize,
                'totalProfit': result.totalProfit,
                'winRate': result.winRate,
              };
            }

            logger.d('Test $currentTest/$totalTests - EMA50: $ema50, EMA150: $ema150, LotSize: $lotSize - Profit: ${result.totalProfit.toStringAsFixed(2)}');
          } catch (e) {
            logger.e('Error in optimization test: $e');
          }
        }
      }
    }

    logger.i('Optimization completed. Best params: $bestParams');
    return bestParams;
  }

  // Private helper methods

  List<Candle> _filterCandlesByDate(
    List<Candle> candles,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return candles.where((candle) {
      if (startDate != null && candle.time.isBefore(startDate)) return false;
      if (endDate != null && candle.time.isAfter(endDate)) return false;
      return true;
    }).toList();
  }
}

// Enum for trade signals (moved here for convenience)
enum TradeSignal { buy, sell, none }
