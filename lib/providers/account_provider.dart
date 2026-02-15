import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../services/service_locator.dart';
import '../services/virtual_exchange.dart';

class AccountProvider extends ChangeNotifier {
  final Logger logger = Logger();
  
  late final VirtualExchange _exchange;

  double _initialBalance = 10000;
  bool _isLoading = false;
  String? _error;

  // Getters
  double get balance => _exchange.balance;
  double get equity => _exchange.equity;
  double get margin => _exchange.margin;
  double get marginLevel => _exchange.marginLevel;
  double get floatingPL => _exchange.floatingPL;
  double get initialBalance => _initialBalance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AccountProvider() {
    _initializeServices();
  }

  void _initializeServices() {
    _exchange = getIt<VirtualExchange>();
  }

  /// Set initial balance and reset account
  void setInitialBalance(double balance) {
    _initialBalance = balance;
    
    // Create new exchange with new balance
    getIt.unregister<VirtualExchange>();
    getIt.registerSingleton<VirtualExchange>(
      VirtualExchange(initialBalance: balance),
    );
    _exchange = getIt<VirtualExchange>();
    
    logger.i('Initial balance set to: $balance');
    notifyListeners();
  }

  /// Reset account to initial balance
  void resetAccount() {
    _exchange.reset();
    logger.i('Account reset');
    notifyListeners();
  }

  /// Get account statistics
  Map<String, dynamic> getStatistics() {
    return _exchange.getStatistics();
  }

  /// Get account summary
  Map<String, String> getAccountSummary() {
    return {
      'balance': balance.toStringAsFixed(2),
      'equity': equity.toStringAsFixed(2),
      'margin': margin.toStringAsFixed(2),
      'marginLevel': marginLevel.toStringAsFixed(2),
      'floatingPL': floatingPL.toStringAsFixed(2),
    };
  }

  /// Format currency
  String formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  /// Get margin percentage
  double getMarginPercentage() {
    if (equity == 0) return 0;
    return (margin / equity) * 100;
  }

  /// Check if account is in margin call
  bool isInMarginCall() {
    return marginLevel < 100;
  }

  /// Get available balance for trading
  double getAvailableBalance() {
    return equity - margin;
  }
}
