import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../models/position.dart';

class VirtualExchange {
  final Logger logger = Logger();
  
  double _balance;
  double _initialBalance;
  final List<Position> _positions = [];
  final List<Position> _closedPositions = [];
  
  double _margin = 0;
  double _equity = 0;
  double _marginLevel = 0;
  
  static const double LEVERAGE = 100;
  static const double LOT_SIZE = 100000;

  VirtualExchange({required double initialBalance})
      : _balance = initialBalance,
        _initialBalance = initialBalance,
        _equity = initialBalance;

  // Getters
  double get balance => _balance;
  double get equity => _equity;
  double get margin => _margin;
  double get marginLevel => _marginLevel;
  double get floatingPL => _calculateFloatingPL();
  List<Position> get openPositions => [..._positions];
  List<Position> get closedPositions => [..._closedPositions];

  /// Open a new position
  Position? openPosition({
    required PositionType type,
    required double entryPrice,
    required double lots,
    double? takeProfit,
    double? stopLoss,
  }) {
    // Calculate required margin
    final requiredMargin = (lots * LOT_SIZE * entryPrice) / LEVERAGE;
    
    if (requiredMargin > _balance) {
      logger.w('Insufficient balance to open position. Required: $requiredMargin, Available: $_balance');
      return null;
    }

    final position = Position(
      id: const Uuid().v4(),
      type: type,
      entryPrice: entryPrice,
      currentPrice: entryPrice,
      lots: lots,
      takeProfit: takeProfit,
      stopLoss: stopLoss,
      openTime: DateTime.now(),
    );

    _positions.add(position);
    _margin += requiredMargin;
    _updateEquity();

    logger.i('Position opened: $position');
    return position;
  }

  /// Update current price for all positions
  void updatePrice(double currentPrice) {
    for (int i = 0; i < _positions.length; i++) {
      final position = _positions[i];
      
      // Check if TP or SL is hit
      if (position.type == PositionType.buy) {
        if (position.takeProfit != null && currentPrice >= position.takeProfit!) {
          closePosition(position.id, currentPrice);
          continue;
        }
        if (position.stopLoss != null && currentPrice <= position.stopLoss!) {
          closePosition(position.id, currentPrice);
          continue;
        }
      } else {
        if (position.takeProfit != null && currentPrice <= position.takeProfit!) {
          closePosition(position.id, currentPrice);
          continue;
        }
        if (position.stopLoss != null && currentPrice >= position.stopLoss!) {
          closePosition(position.id, currentPrice);
          continue;
        }
      }

      // Update current price
      _positions[i] = position.copyWith(currentPrice: currentPrice);
    }

    _updateEquity();
  }

  /// Close a specific position
  bool closePosition(String positionId, double closePrice) {
    final index = _positions.indexWhere((p) => p.id == positionId);
    if (index == -1) return false;

    final position = _positions[index];
    final closedPosition = position.copyWith(
      closePrice: closePrice,
      closeTime: DateTime.now(),
      isClosed: true,
    );

    _closedPositions.add(closedPosition);
    _positions.removeAt(index);

    // Update balance with profit/loss
    _balance += closedPosition.profitLoss;
    
    // Update margin
    final requiredMargin = (position.lots * LOT_SIZE * position.entryPrice) / LEVERAGE;
    _margin -= requiredMargin;

    _updateEquity();
    logger.i('Position closed: $closedPosition, P/L: ${closedPosition.profitLoss}');

    return true;
  }

  /// Close all positions at a given price
  void closeAllPositions(double closePrice) {
    final positionIds = _positions.map((p) => p.id).toList();
    for (final id in positionIds) {
      closePosition(id, closePrice);
    }
  }

  /// Get position by ID
  Position? getPosition(String positionId) {
    try {
      return _positions.firstWhere((p) => p.id == positionId);
    } catch (e) {
      return null;
    }
  }

  /// Update position's TP/SL
  bool updatePositionTPSL({
    required String positionId,
    double? takeProfit,
    double? stopLoss,
  }) {
    final position = getPosition(positionId);
    if (position == null) return false;

    final index = _positions.indexWhere((p) => p.id == positionId);
    _positions[index] = position.copyWith(
      takeProfit: takeProfit ?? position.takeProfit,
      stopLoss: stopLoss ?? position.stopLoss,
    );

    logger.i('Position TP/SL updated: ${_positions[index]}');
    return true;
  }

  /// Reset account to initial state
  void reset() {
    _balance = _initialBalance;
    _positions.clear();
    _closedPositions.clear();
    _margin = 0;
    _updateEquity();
    logger.i('Virtual exchange reset');
  }

  /// Get account statistics
  Map<String, dynamic> getStatistics() {
    double totalProfit = 0;
    int winningTrades = 0;
    int losingTrades = 0;
    double maxDrawdown = 0;
    double currentDrawdown = 0;

    for (final position in _closedPositions) {
      if (position.profitLoss > 0) {
        winningTrades++;
      } else if (position.profitLoss < 0) {
        losingTrades++;
      }
      totalProfit += position.profitLoss;
    }

    final winRate = _closedPositions.isEmpty
        ? 0
        : (winningTrades / _closedPositions.length) * 100;

    return {
      'totalProfit': totalProfit,
      'winRate': winRate,
      'winningTrades': winningTrades,
      'losingTrades': losingTrades,
      'totalTrades': _closedPositions.length,
      'balance': _balance,
      'equity': _equity,
      'margin': _margin,
      'marginLevel': _marginLevel,
      'floatingPL': floatingPL,
    };
  }

  // Private helper methods

  double _calculateFloatingPL() {
    double pl = 0;
    for (final position in _positions) {
      pl += position.profitLoss;
    }
    return pl;
  }

  void _updateEquity() {
    _equity = _balance + floatingPL;
    if (_margin > 0) {
      _marginLevel = (_equity / _margin) * 100;
    } else {
      _marginLevel = 0;
    }
  }
}
