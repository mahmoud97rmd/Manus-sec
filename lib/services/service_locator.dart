import 'package:get_it/get_it.dart';
import 'oanda_service.dart';
import 'candle_aggregator.dart';
import 'indicator_calculator.dart';
import 'virtual_exchange.dart';
import 'strategy_engine.dart';
import 'backtest_engine.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register OANDA service
  getIt.registerSingleton<OandaService>(
    OandaService(
      apiToken: 'YOUR_OANDA_API_TOKEN', // Replace with actual token
      accountId: 'YOUR_ACCOUNT_ID', // Replace with actual account ID
    ),
  );

  // Register Candle Aggregator
  getIt.registerSingleton<CandleAggregator>(
    CandleAggregator(candleDuration: const Duration(minutes: 1)),
  );

  // Register Indicator Calculator
  getIt.registerSingleton<IndicatorCalculator>(
    IndicatorCalculator(),
  );

  // Register Virtual Exchange
  getIt.registerSingleton<VirtualExchange>(
    VirtualExchange(initialBalance: 10000),
  );

  // Register Strategy Engine
  getIt.registerSingleton<StrategyEngine>(
    StrategyEngine(),
  );

  // Register Backtest Engine
  getIt.registerSingleton<BacktestEngine>(
    BacktestEngine(
      strategyEngine: getIt<StrategyEngine>(),
      exchange: getIt<VirtualExchange>(),
    ),
  );
}
