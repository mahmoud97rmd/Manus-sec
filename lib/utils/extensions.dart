import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Format datetime to readable string
  String toReadableString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  /// Format datetime to short string
  String toShortString() {
    return DateFormat('HH:mm:ss').format(this);
  }

  /// Format datetime to date only
  String toDateString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Check if datetime is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if datetime is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get time difference in human readable format
  String getTimeDifference() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return toDateString();
    }
  }
}

extension DoubleExtensions on double {
  /// Format double to currency string
  String toCurrency() {
    return '\$${toStringAsFixed(2)}';
  }

  /// Format double to percentage string
  String toPercentage() {
    return '${toStringAsFixed(2)}%';
  }

  /// Format double to price string (5 decimal places)
  String toPrice() {
    return toStringAsFixed(5);
  }

  /// Check if number is positive
  bool isPositive() {
    return this > 0;
  }

  /// Check if number is negative
  bool isNegative() {
    return this < 0;
  }

  /// Check if number is zero
  bool isZero() {
    return this == 0;
  }

  /// Round to specific decimal places
  double roundTo(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Convert pips to price
  double pipsToPrice(double pipValue) {
    return this * pipValue;
  }
}

extension IntExtensions on int {
  /// Format int to currency string
  String toCurrency() {
    return '\$$this';
  }

  /// Format int to percentage string
  String toPercentage() {
    return '$this%';
  }

  /// Check if number is positive
  bool isPositive() {
    return this > 0;
  }

  /// Check if number is negative
  bool isNegative() {
    return this < 0;
  }

  /// Check if number is zero
  bool isZero() {
    return this == 0;
  }
}

extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isEmpty => this.isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => this.isNotEmpty;

  /// Convert string to double
  double toDouble() {
    return double.tryParse(this) ?? 0.0;
  }

  /// Convert string to int
  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Check if string is valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
}

extension ListExtensions<T> on List<T> {
  /// Get last element or null
  T? getLastOrNull() {
    return isEmpty ? null : last;
  }

  /// Get first element or null
  T? getFirstOrNull() {
    return isEmpty ? null : first;
  }

  /// Check if list contains any element
  bool get hasElements => isNotEmpty;

  /// Get average of numeric list
  double getAverage() {
    if (isEmpty) return 0;
    double sum = 0;
    for (var item in this) {
      if (item is num) {
        sum += item.toDouble();
      }
    }
    return sum / length;
  }

  /// Get sum of numeric list
  double getSum() {
    double sum = 0;
    for (var item in this) {
      if (item is num) {
        sum += item.toDouble();
      }
    }
    return sum;
  }

  /// Get max of numeric list
  double getMax() {
    if (isEmpty) return 0;
    double max = double.negativeInfinity;
    for (var item in this) {
      if (item is num) {
        final value = item.toDouble();
        if (value > max) max = value;
      }
    }
    return max;
  }

  /// Get min of numeric list
  double getMin() {
    if (isEmpty) return 0;
    double min = double.infinity;
    for (var item in this) {
      if (item is num) {
        final value = item.toDouble();
        if (value < min) min = value;
      }
    }
    return min;
  }
}
