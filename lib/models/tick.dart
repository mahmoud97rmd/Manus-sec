import 'package:json_annotation/json_annotation.dart';

part 'tick.g.dart';

@JsonSerializable()
class Tick {
  final DateTime time;
  final double bid;
  final double ask;

  Tick({
    required this.time,
    required this.bid,
    required this.ask,
  });

  factory Tick.fromJson(Map<String, dynamic> json) => _$TickFromJson(json);
  Map<String, dynamic> toJson() => _$TickToJson(this);

  double get mid => (bid + ask) / 2;

  @override
  String toString() => 'Tick(time: $time, bid: $bid, ask: $ask)';
}
