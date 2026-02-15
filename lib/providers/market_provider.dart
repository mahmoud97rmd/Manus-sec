import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/indicator.dart';
import '../models/tick.dart';
import '../services/candle_aggregator.dart';
import '../services/indicator_calculator.dart';
import '../services/oanda_service.dart';
import '../services/service_locator.dart';

class MarketProvider extends ChangeNotifier {
  final Logger logger = Logger();
  
  late final OandaService _oandaService;
  late final CandleAggregator _candleAggregator;
  late final IndicatorCalculator _indicatorCalculator;

  List<Candle> _candles = [];
  List<IndicatorValue> _ema50 = [];
  List<IndicatorValue> _ema150 = [];
  List<StochasticValue> _stochastic = [];
  
  String _selectedInstrument = 'XAU_USD';
  String _selectedTimeframe = 'M1';
  double _currentPrice = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Candle> get candles => [..._candles];
  List<IndicatorValue> get ema50 => [..._ema50];
  List<IndicatorValue> get ema150 => [..._ema150];
  List<StochasticValue> get stochastic => [..._stochastic];
  String get selectedInstrument => _selectedInstrument;
  String get selectedTimeframe => _selectedTimeframe;
  double get currentPrice => _currentPrice;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MarketProvider() {
    _initializeServices();
  }

  void _initializeServices() {
    _oandaService = getIt<OandaService>();
    _candleAggregator = getIt<CandleAggregator>();
    _indicatorCalculator = getIt<IndicatorCalculator>();
  }

  /// Load historical candles
  Future<void> loadCandles({
    required String instrument,
    required String timeframe,
    int count = 500,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedInstrument = instrument;
      _selectedTimeframe = timeframe;

      final candles = await _oandaService.fetchCandles(
        instrument: instrument,
        granularity: timeframe,
        count: count,
      );

      _candles = candles;
      _candleAggregator.initialize(candles);
      
      // Calculate indicators
      _updateIndicators();

      if (candles.isNotEmpty) {
        _currentPrice = candles.last.close;
      }

      _isLoading = false;
      logger.i('Loaded ${candles.length} candles for $instrument ($timeframe)');
    } catch (e) {
      _error = 'Failed to load candles: $e';
      _isLoading = false;
      logger.e(_error);
    }

    notifyListeners();
  }

  /// Process incoming tick
  void processTick(Tick tick) {
    _currentPrice = tick.mid;

    final closedCandle = _candleAggregator.processTick(tick);
    if (closedCandle != null) {
      _candles.add(closedCandle);
      _updateIndicators();
    } else {
      // Update the current candle in the list if it exists
      final currentCandle = _candleAggregator.getCurrentCandle();
      if (currentCandle != null && _candles.isNotEmpty) {
        _candles[_candles.length - 1] = currentCandle;
      }
    }

    notifyListeners();
  }

  /// Update all indicators
  void _updateIndicators() {
    if (_candles.isEmpty) return;

    _ema50 = _indicatorCalculator.calculateEMA(_candles, 50);
    _ema150 = _indicatorCalculator.calculateEMA(_candles, 150);
    _stochastic = _indicatorCalculator.calculateStochastic(_candles);
  }

  /// Change selected instrument
  void setInstrument(String instrument) {
    if (_selectedInstrument != instrument) {
      _selectedInstrument = instrument;
      loadCandles(
        instrument: instrument,
        timeframe: _selectedTimeframe,
      );
    }
  }

  /// Change selected timeframe
  void setTimeframe(String timeframe) {
    if (_selectedTimeframe != timeframe) {
      _selectedTimeframe = timeframe;
      loadCandles(
        instrument: _selectedInstrument,
        timeframe: timeframe,
      );
    }
  }

  /// Get price range for chart
  Map<String, double> getPriceRange() {
    if (_candles.isEmpty) {
      return {'min': 0, 'max': 100};
    }

    double minPrice = _candles.first.low;
    double maxPrice = _candles.first.high;

    for (final candle in _candles) {
      if (candle.low < minPrice) minPrice = candle.low;
      if (candle.high > maxPrice) maxPrice = candle.high;
    }

    final padding = (maxPrice - minPrice) * 0.1;
    return {
      'min': minPrice - padding,
      'max': maxPrice + padding,
    };
  }

  /// Get time range for chart
  Map<String, DateTime> getTimeRange() {
    if (_candles.isEmpty) {
      return {
        'min': DateTime.now().subtract(const Duration(days: 1)),
        'max': DateTime.now(),
      };
    }

    return {
      'min': _candles.first.time,
      'max': _candles.last.time,
    };
  }

  /// Clear all data
  void clear() {
    _candles.clear();
    _ema50.clear();
    _ema150.clear();
    _stochastic.clear();
    _currentPrice = 0;
    _error = null;
    notifyListeners();
  }
}
