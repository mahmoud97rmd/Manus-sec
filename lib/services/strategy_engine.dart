import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/indicator.dart';
import '../models/position.dart';
import 'virtual_exchange.dart';
import 'indicator_calculator.dart';

enum TradeSignal { buy, sell, none }

class StrategyEngine {
  final Logger logger = Logger();
  final IndicatorCalculator indicatorCalculator = IndicatorCalculator();
  
  bool _isActive = false;
  TradeSignal _lastSignal = TradeSignal.none;
  
  // Strategy parameters
  int ema50Period = 50;
  int ema150Period = 150;
  int stochKPeriod = 14;
  int stochDPeriod = 3;
  double stochOverbought = 80;
  double stochOversold = 20;
  double lotSize = 0.1;
  double? takeProfitPips = 50;
  double? stopLossPips = 20;

  // Strategy state
  List<IndicatorValue> _ema50 = [];
  List<IndicatorValue> _ema150 = [];
  List<StochasticValue> _stochastic = [];

  bool get isActive => _isActive;
  TradeSignal get lastSignal => _lastSignal;

  /// Activate/deactivate strategy
  void setActive(bool active) {
    _isActive = active;
    logger.i('Strategy ${active ? 'activated' : 'deactivated'}');
  }

  /// Update indicators based on candles
  void updateIndicators(List<Candle> candles) {
    if (candles.isEmpty) return;

    _ema50 = indicatorCalculator.calculateEMA(candles, ema50Period);
    _ema150 = indicatorCalculator.calculateEMA(candles, ema150Period);
    _stochastic = indicatorCalculator.calculateStochastic(
      candles,
      kPeriod: stochKPeriod,
      dPeriod: stochDPeriod,
    );
  }

  /// Check for trading signals
  TradeSignal checkSignal(List<Candle> candles) {
    if (!_isActive || candles.isEmpty) {
      _lastSignal = TradeSignal.none;
      return TradeSignal.none;
    }

    if (_ema50.isEmpty || _ema150.isEmpty || _stochastic.isEmpty) {
      _lastSignal = TradeSignal.none;
      return TradeSignal.none;
    }

    // Get the latest values
    final latestEMA50 = _ema50.last.value;
    final latestEMA150 = _ema150.last.value;
    final latestStoch = _stochastic.last;
    
    // Get previous stochastic value if available
    double? prevStochK;
    if (_stochastic.length > 1) {
      prevStochK = _stochastic[_stochastic.length - 2].k;
    }

    // Buy Signal: EMA50 > EMA150 AND Stoch crosses above oversold
    if (latestEMA50 > latestEMA150 &&
        prevStochK != null &&
        prevStochK < stochOversold &&
        latestStoch.k > stochOversold) {
      _lastSignal = TradeSignal.buy;
      logger.i('BUY signal generated');
      return TradeSignal.buy;
    }

    // Sell Signal: EMA50 < EMA150 AND Stoch crosses below overbought
    if (latestEMA50 < latestEMA150 &&
        prevStochK != null &&
        prevStochK > stochOverbought &&
        latestStoch.k < stochOverbought) {
      _lastSignal = TradeSignal.sell;
      logger.i('SELL signal generated');
      return TradeSignal.sell;
    }

    _lastSignal = TradeSignal.none;
    return TradeSignal.none;
  }

  /// Execute trade based on signal
  Position? executeTrade(
    TradeSignal signal,
    double currentPrice,
    VirtualExchange exchange,
  ) {
    if (signal == TradeSignal.none) return null;

    final type = signal == TradeSignal.buy ? PositionType.buy : PositionType.sell;
    
    double? tp;
    double? sl;

    if (signal == TradeSignal.buy) {
      if (takeProfitPips != null) {
        tp = currentPrice + takeProfitPips!;
      }
      if (stopLossPips != null) {
        sl = currentPrice - stopLossPips!;
      }
    } else {
      if (takeProfitPips != null) {
        tp = currentPrice - takeProfitPips!;
      }
      if (stopLossPips != null) {
        sl = currentPrice + stopLossPips!;
      }
    }

    final position = exchange.openPosition(
      type: type,
      entryPrice: currentPrice,
      lots: lotSize,
      takeProfit: tp,
      stopLoss: sl,
    );

    if (position != null) {
      logger.i('Trade executed: ${signal.name} at $currentPrice');
    }

    return position;
  }

  /// Get indicator values
  List<IndicatorValue> getEMA50() => [..._ema50];
  List<IndicatorValue> getEMA150() => [..._ema150];
  List<StochasticValue> getStochastic() => [..._stochastic];

  /// Reset strategy
  void reset() {
    _isActive = false;
    _lastSignal = TradeSignal.none;
    _ema50.clear();
    _ema150.clear();
    _stochastic.clear();
    logger.i('Strategy engine reset');
  }
}
