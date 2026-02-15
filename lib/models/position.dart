import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

enum PositionType { buy, sell }

@JsonSerializable()
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

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);

  double get profitLoss {
    final price = closePrice ?? currentPrice;
    if (type == PositionType.buy) {
      return (price - entryPrice) * lots * 100;
    } else {
      return (entryPrice - price) * lots * 100;
    }
  }

  double get profitLossPercent {
    if (type == PositionType.buy) {
      return ((currentPrice - entryPrice) / entryPrice) * 100;
    } else {
      return ((entryPrice - currentPrice) / entryPrice) * 100;
    }
  }

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
