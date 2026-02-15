class IndicatorValue {
  final DateTime time;
  final double value;

  IndicatorValue({
    required this.time,
    required this.value,
  });

  @override
  String toString() => 'IndicatorValue(time: $time, value: $value)';
}

class StochasticValue {
  final DateTime time;
  final double k;
  final double d;

  StochasticValue({
    required this.time,
    required this.k,
    required this.d,
  });

  @override
  String toString() => 'StochasticValue(time: $time, k: $k, d: $d)';
}
