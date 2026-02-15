import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../providers/strategy_provider.dart';
import '../providers/account_provider.dart';
import '../widgets/chart_widget.dart';
import '../widgets/indicator_panel.dart';
import '../widgets/account_info_widget.dart';
import '../widgets/positions_widget.dart';
import '../widgets/strategy_controls_widget.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late MarketProvider _marketProvider;
  late StrategyProvider _strategyProvider;
  late AccountProvider _accountProvider;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _marketProvider = context.read<MarketProvider>();
    _strategyProvider = context.read<StrategyProvider>();
    _accountProvider = context.read<AccountProvider>();

    // Load initial data
    _marketProvider.loadCandles(
      instrument: 'XAU_USD',
      timeframe: 'M1',
      count: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Trading App'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<AccountProvider>(
              builder: (context, accountProvider, _) {
                return Center(
                  child: Text(
                    'Balance: ${accountProvider.formatCurrency(accountProvider.balance)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer3<MarketProvider, StrategyProvider, AccountProvider>(
        builder: (context, marketProvider, strategyProvider, accountProvider, _) {
          if (marketProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (marketProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${marketProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      marketProvider.loadCandles(
                        instrument: marketProvider.selectedInstrument,
                        timeframe: marketProvider.selectedTimeframe,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with instrument selector
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            marketProvider.selectedInstrument,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Price: ${marketProvider.currentPrice.toStringAsFixed(5)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Timeframe: ${marketProvider.selectedTimeframe}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  marketProvider.setTimeframe('M1');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: marketProvider.selectedTimeframe == 'M1'
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: const Text('M1'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  marketProvider.setTimeframe('M5');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: marketProvider.selectedTimeframe == 'M5'
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: const Text('M5'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  marketProvider.setTimeframe('M15');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: marketProvider.selectedTimeframe == 'M15'
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: const Text('M15'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chart
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: ChartWidget(
                    candles: marketProvider.candles,
                    ema50: marketProvider.ema50,
                    ema150: marketProvider.ema150,
                  ),
                ),

                // Account Info
                AccountInfoWidget(
                  balance: accountProvider.balance,
                  equity: accountProvider.equity,
                  margin: accountProvider.margin,
                  marginLevel: accountProvider.marginLevel,
                  floatingPL: accountProvider.floatingPL,
                ),

                // Indicator Panel
                IndicatorPanel(
                  stochastic: marketProvider.stochastic,
                ),

                // Strategy Controls
                StrategyControlsWidget(
                  isActive: strategyProvider.isActive,
                  onToggle: () {
                    strategyProvider.toggleStrategy();
                  },
                  onReset: () {
                    strategyProvider.reset();
                  },
                ),

                // Open Positions
                if (strategyProvider.openPositions.isNotEmpty)
                  PositionsWidget(
                    positions: strategyProvider.openPositions,
                    title: 'Open Positions',
                  ),

                // Closed Positions
                if (strategyProvider.closedPositions.isNotEmpty)
                  PositionsWidget(
                    positions: strategyProvider.closedPositions,
                    title: 'Closed Positions',
                  ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
