/// Position type enum
enum PositionType { buy, sell }

/// Position data model representing an open or closed trading position
class Position {
  final String id;
  final PositionType type;
  final double entryPrice;
  final double currentPrice;
  final double lots;
  final double? takeProfit;
  final double? stopLoss;
  final DateTime openTime;
  final DateTime? closeTime;
  final double? closePrice;
  final bool isClosed;

  Position({
    required this.id,
    required this.type,
    required this.entryPrice,
    required this.currentPrice,
    required this.lots,
    this.takeProfit,
    this.stopLoss,
    required this.openTime,
    this.closeTime,
    this.closePrice,
    this.isClosed = false,
  });

  /// Create Position from JSON
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] as String,
      type: PositionType.values.byName(json['type'] as String),
      entryPrice: (json['entryPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      lots: (json['lots'] as num).toDouble(),
      takeProfit: json['takeProfit'] != null ? (json['takeProfit'] as num).toDouble() : null,
      stopLoss: json['stopLoss'] != null ? (json['stopLoss'] as num).toDouble() : null,
      openTime: DateTime.parse(json['openTime'] as String),
      closeTime: json['closeTime'] != null ? DateTime.parse(json['closeTime'] as String) : null,
      closePrice: json['closePrice'] != null ? (json['closePrice'] as num).toDouble() : null,
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }

  /// Convert Position to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'entryPrice': entryPrice,
    'currentPrice': currentPrice,
    'lots': lots,
    'takeProfit': takeProfit,
    'stopLoss': stopLoss,
    'openTime': openTime.toIso8601String(),
    'closeTime': closeTime?.toIso8601String(),
    'closePrice': closePrice,
    'isClosed': isClosed,
  };

  /// Get profit/loss in currency
  double get profitLoss {
    final price = closePrice ?? currentPrice;
    if (type == PositionType.buy) {
      return (price - entryPrice) * lots * 100;
    } else {
      return (entryPrice - price) * lots * 100;
    }
  }

  /// Get profit/loss in percentage
  double get profitLossPercent {
    if (type == PositionType.buy) {
      return ((currentPrice - entryPrice) / entryPrice) * 100;
    } else {
      return ((entryPrice - currentPrice) / entryPrice) * 100;
    }
  }

  /// Check if position is profitable
  bool get isProfit => profitLoss > 0;

  Position copyWith({
    String? id,
    PositionType? type,
    double? entryPrice,
    double? currentPrice,
    double? lots,
    double? takeProfit,
    double? stopLoss,
    DateTime? openTime,
    DateTime? closeTime,
    double? closePrice,
    bool? isClosed,
  }) {
    return Position(
      id: id ?? this.id,
      type: type ?? this.type,
      entryPrice: entryPrice ?? this.entryPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      lots: lots ?? this.lots,
      takeProfit: takeProfit ?? this.takeProfit,
      stopLoss: stopLoss ?? this.stopLoss,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      closePrice: closePrice ?? this.closePrice,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  String toString() {
    return 'Position(id: $id, type: $type, entryPrice: $entryPrice, currentPrice: $currentPrice, lots: $lots, profitLoss: $profitLoss)';
  }
}
