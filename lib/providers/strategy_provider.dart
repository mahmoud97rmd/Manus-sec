import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/position.dart';
import '../services/service_locator.dart';
import '../services/strategy_engine.dart';
import '../services/virtual_exchange.dart';

class StrategyProvider extends ChangeNotifier {
  final Logger logger = Logger();
  
  late final StrategyEngine _strategyEngine;
  late final VirtualExchange _exchange;

  bool _isActive = false;
  TradeSignal _lastSignal = TradeSignal.none;
  List<Position> _openPositions = [];
  List<Position> _closedPositions = [];

  // Strategy parameters
  int _ema50Period = 50;
  int _ema150Period = 150;
  int _stochKPeriod = 14;
  double _stochOversold = 20;
  double _stochOverbought = 80;
  double _lotSize = 0.1;
  double? _takeProfitPips = 50;
  double? _stopLossPips = 20;

  // Getters
  bool get isActive => _isActive;
  TradeSignal get lastSignal => _lastSignal;
  List<Position> get openPositions => [..._openPositions];
  List<Position> get closedPositions => [..._closedPositions];
  
  int get ema50Period => _ema50Period;
  int get ema150Period => _ema150Period;
  int get stochKPeriod => _stochKPeriod;
  double get stochOversold => _stochOversold;
  double get stochOverbought => _stochOverbought;
  double get lotSize => _lotSize;
  double? get takeProfitPips => _takeProfitPips;
  double? get stopLossPips => _stopLossPips;

  double get totalProfit {
    double total = 0;
    for (final position in _closedPositions) {
      total += position.profitLoss;
    }
    return total;
  }

  double get floatingPL {
    double total = 0;
    for (final position in _openPositions) {
      total += position.profitLoss;
    }
    return total;
  }

  StrategyProvider() {
    _initializeServices();
  }

  void _initializeServices() {
    _strategyEngine = getIt<StrategyEngine>();
    _exchange = getIt<VirtualExchange>();
    _syncState();
  }

  void _syncState() {
    _isActive = _strategyEngine.isActive;
    _lastSignal = _strategyEngine.lastSignal;
    _openPositions = _exchange.openPositions;
    _closedPositions = _exchange.closedPositions;
  }

  /// Toggle strategy on/off
  void toggleStrategy() {
    _isActive = !_isActive;
    _strategyEngine.setActive(_isActive);
    logger.i('Strategy toggled: $_isActive');
    notifyListeners();
  }

  /// Check for signals and execute trades
  void checkAndExecuteTrade(List<Candle> candles, double currentPrice) {
    if (!_isActive || candles.isEmpty) return;

    _strategyEngine.updateIndicators(candles);
    final signal = _strategyEngine.checkSignal(candles);

    if (signal != TradeSignal.none) {
      _lastSignal = signal;
      _strategyEngine.executeTrade(signal, currentPrice, _exchange);
      _syncState();
      logger.i('Trade executed: $signal');
    }

    notifyListeners();
  }

  /// Update price for all positions
  void updatePrice(double currentPrice) {
    _exchange.updatePrice(currentPrice);
    _syncState();
    notifyListeners();
  }

  /// Update strategy parameters
  void updateParameters({
    int? ema50Period,
    int? ema150Period,
    int? stochKPeriod,
    double? stochOversold,
    double? stochOverbought,
    double? lotSize,
    double? takeProfitPips,
    double? stopLossPips,
  }) {
    if (ema50Period != null) {
      _ema50Period = ema50Period;
      _strategyEngine.ema50Period = ema50Period;
    }
    if (ema150Period != null) {
      _ema150Period = ema150Period;
      _strategyEngine.ema150Period = ema150Period;
    }
    if (stochKPeriod != null) {
      _stochKPeriod = stochKPeriod;
      _strategyEngine.stochKPeriod = stochKPeriod;
    }
    if (stochOversold != null) {
      _stochOversold = stochOversold;
      _strategyEngine.stochOversold = stochOversold;
    }
    if (stochOverbought != null) {
      _stochOverbought = stochOverbought;
      _strategyEngine.stochOverbought = stochOverbought;
    }
    if (lotSize != null) {
      _lotSize = lotSize;
      _strategyEngine.lotSize = lotSize;
    }
    if (takeProfitPips != null) {
      _takeProfitPips = takeProfitPips;
      _strategyEngine.takeProfitPips = takeProfitPips;
    }
    if (stopLossPips != null) {
      _stopLossPips = stopLossPips;
      _strategyEngine.stopLossPips = stopLossPips;
    }

    logger.i('Strategy parameters updated');
    notifyListeners();
  }

  /// Close a specific position
  void closePosition(String positionId, double closePrice) {
    _exchange.closePosition(positionId, closePrice);
    _syncState();
    logger.i('Position closed: $positionId');
    notifyListeners();
  }

  /// Close all positions
  void closeAllPositions(double closePrice) {
    _exchange.closeAllPositions(closePrice);
    _syncState();
    logger.i('All positions closed');
    notifyListeners();
  }

  /// Reset strategy and account
  void reset() {
    _exchange.reset();
    _strategyEngine.reset();
    _syncState();
    logger.i('Strategy and account reset');
    notifyListeners();
  }

  /// Get account statistics
  Map<String, dynamic> getStatistics() {
    return _exchange.getStatistics();
  }
}
