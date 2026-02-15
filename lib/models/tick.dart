/// Tick data model representing bid/ask price data
class Tick {
  final DateTime time;
  final double bid;
  final double ask;

  Tick({
    required this.time,
    required this.bid,
    required this.ask,
  });

  /// Create Tick from JSON
  factory Tick.fromJson(Map<String, dynamic> json) {
    return Tick(
      time: DateTime.parse(json['time'] as String),
      bid: (json['bid'] as num).toDouble(),
      ask: (json['ask'] as num).toDouble(),
    );
  }

  /// Convert Tick to JSON
  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'bid': bid,
    'ask': ask,
  };

  /// Get mid price (average of bid and ask)
  double get mid => (bid + ask) / 2;

  @override
  String toString() => 'Tick(time: $time, bid: $bid, ask: $ask)';
}
