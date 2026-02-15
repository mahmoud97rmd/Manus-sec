import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/tick.dart';

class CandleAggregator {
  final Logger logger = Logger();
  
  Candle? _currentCandle;
  final List<Candle> _candles = [];
  final Duration _candleDuration;
  
  DateTime? _lastCandleTime;

  CandleAggregator({Duration? candleDuration})
      : _candleDuration = candleDuration ?? const Duration(minutes: 1);

  /// Initialize with historical candles
  void initialize(List<Candle> historicalCandles) {
    _candles.clear();
    _candles.addAll(historicalCandles);
    if (historicalCandles.isNotEmpty) {
      _lastCandleTime = historicalCandles.last.time;
      _currentCandle = historicalCandles.last.copyWith();
    }
    logger.i('CandleAggregator initialized with ${historicalCandles.length} candles');
  }

  /// Process incoming tick and update current candle
  Candle? processTick(Tick tick) {
    if (_currentCandle == null) {
      _initializeCandle(tick);
      return null;
    }

    // Check if we need to close current candle and start a new one
    if (_shouldCloseCandle(tick.time)) {
      final closedCandle = _currentCandle!;
      _candles.add(closedCandle);
      logger.d('Candle closed: $closedCandle');
      
      _initializeCandle(tick);
      return closedCandle;
    }

    // Update current candle with new tick
    _updateCurrentCandle(tick);
    return null;
  }

  /// Get all candles including current incomplete one
  List<Candle> getAllCandles() => [..._candles];

  /// Get only closed candles
  List<Candle> getClosedCandles() => [..._candles];

  /// Get current candle (may not be closed yet)
  Candle? getCurrentCandle() => _currentCandle;

  /// Get last N candles
  List<Candle> getLastCandles(int count) {
    if (_candles.length <= count) {
      return [..._candles];
    }
    return _candles.sublist(_candles.length - count);
  }

  /// Private helper methods

  void _initializeCandle(Tick tick) {
    _currentCandle = Candle(
      time: _roundTimeToCandle(tick.time),
      open: tick.mid,
      high: tick.mid,
      low: tick.mid,
      close: tick.mid,
      volume: 1,
    );
    _lastCandleTime = _currentCandle!.time;
  }

  void _updateCurrentCandle(Tick tick) {
    if (_currentCandle == null) return;

    _currentCandle = _currentCandle!.copyWith(
      high: _currentCandle!.high > tick.mid ? _currentCandle!.high : tick.mid,
      low: _currentCandle!.low < tick.mid ? _currentCandle!.low : tick.mid,
      close: tick.mid,
      volume: _currentCandle!.volume + 1,
    );
  }

  bool _shouldCloseCandle(DateTime tickTime) {
    if (_lastCandleTime == null) return false;
    
    final timeDiff = tickTime.difference(_lastCandleTime!);
    return timeDiff >= _candleDuration;
  }

  DateTime _roundTimeToCandle(DateTime time) {
    final minutes = _candleDuration.inMinutes;
    final roundedMinutes = (time.minute ~/ minutes) * minutes;
    return DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      roundedMinutes,
      0,
      0,
    );
  }

  /// Reset the aggregator
  void reset() {
    _currentCandle = null;
    _candles.clear();
    _lastCandleTime = null;
    logger.i('CandleAggregator reset');
  }
}
