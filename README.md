# Flutter Trading App - Professional Trading Platform

A comprehensive Flutter application that simulates MetaTrader 5, featuring real-time charting, technical indicators, automated trading strategies, and backtesting capabilities.

## 🎯 Features

### Core Trading Features
- **Real-time Charts**: Interactive candlestick charts with multiple timeframes (M1, M5, M15, H1, etc.)
- **Technical Indicators**: 
  - Exponential Moving Average (EMA)
  - Simple Moving Average (SMA)
  - Stochastic Oscillator
  - Relative Strength Index (RSI)
  - MACD
  - Bollinger Bands
- **Live Price Updates**: Real-time price streaming from OANDA
- **Multiple Instruments**: Support for Forex, Commodities, and other instruments

### Trading Engine
- **Virtual Account Simulator**: Realistic trading simulation with margin management
- **Position Management**: Open, modify, and close positions with TP/SL
- **Account Statistics**: Real-time P&L, margin level, equity tracking
- **Risk Management**: Leverage control, margin requirements, drawdown tracking

### Strategy Automation
- **Automated Strategy**: EMA Crossover + Stochastic Signal Generator
- **Customizable Parameters**: Adjust EMA periods, Stochastic levels, lot sizes
- **Trade Execution**: Automatic buy/sell signals with configurable TP/SL
- **Strategy Monitoring**: Real-time signal tracking and trade execution

### Backtesting Engine
- **Historical Data Analysis**: Test strategies on past data
- **Performance Metrics**: Win rate, profit factor, max drawdown, Sharpe ratio
- **Equity Curve**: Visual representation of account growth
- **Parameter Optimization**: Find optimal strategy parameters
- **Trade History**: Detailed record of all backtest trades

### User Interface
- **Professional Dashboard**: Clean, intuitive interface
- **Real-time Updates**: Live price and indicator updates
- **Position Tracking**: Monitor open and closed positions
- **Account Overview**: Balance, equity, margin, and P&L display
- **Responsive Design**: Works on phones, tablets, and desktops

## 🏗️ Architecture

### Clean Architecture Layers

#### Data Layer (`lib/data/`)
- **OandaService**: REST API client for OANDA integration
- **CandleAggregator**: Converts tick data to OHLC candles
- **Local Storage**: SQLite database for historical data caching

#### Domain Layer (`lib/domain/`)
- **IndicatorCalculator**: Technical indicator calculations
- **StrategyEngine**: Trading signal generation
- **VirtualExchange**: Account simulation and position management

#### Presentation Layer (`lib/screens/` & `lib/widgets/`)
- **ChartScreen**: Main trading interface
- **ChartWidget**: Interactive candlestick charts
- **IndicatorPanel**: Technical indicator display
- **PositionsWidget**: Position management UI

#### Providers (`lib/providers/`)
- **MarketProvider**: Market data management (Provider pattern)
- **StrategyProvider**: Strategy state management
- **AccountProvider**: Account information management

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── candle.dart
│   ├── tick.dart
│   ├── position.dart
│   └── indicator.dart
├── services/                      # Business logic
│   ├── oanda_service.dart
│   ├── candle_aggregator.dart
│   ├── indicator_calculator.dart
│   ├── virtual_exchange.dart
│   ├── strategy_engine.dart
│   ├── backtest_engine.dart
│   └── service_locator.dart
├── providers/                     # State management
│   ├── market_provider.dart
│   ├── strategy_provider.dart
│   └── account_provider.dart
├── screens/                       # UI screens
│   └── chart_screen.dart
└── widgets/                       # Reusable UI components
    ├── chart_widget.dart
    ├── indicator_panel.dart
    ├── account_info_widget.dart
    ├── positions_widget.dart
    └── strategy_controls_widget.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.13.0 or higher
- Dart 3.0.0 or higher
- OANDA API account (for live trading)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd flutter_trading_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure OANDA API**
   - Update `lib/services/service_locator.dart` with your OANDA credentials:
   ```dart
   getIt.registerSingleton<OandaService>(
     OandaService(
       apiToken: 'YOUR_OANDA_API_TOKEN',
       accountId: 'YOUR_ACCOUNT_ID',
     ),
   );
   ```

4. **Run the app**
```bash
flutter run
```

## 🔧 Configuration

### Strategy Parameters
Customize strategy behavior in `lib/providers/strategy_provider.dart`:
- `ema50Period`: Fast EMA period (default: 50)
- `ema150Period`: Slow EMA period (default: 150)
- `stochKPeriod`: Stochastic K period (default: 14)
- `stochOversold`: Oversold threshold (default: 20)
- `stochOverbought`: Overbought threshold (default: 80)
- `lotSize`: Position size in lots (default: 0.1)
- `takeProfitPips`: Take profit in pips (default: 50)
- `stopLossPips`: Stop loss in pips (default: 20)

### Account Settings
Configure initial balance in `lib/services/service_locator.dart`:
```dart
getIt.registerSingleton<VirtualExchange>(
  VirtualExchange(initialBalance: 10000),
);
```

## 📊 Technical Indicators

### Exponential Moving Average (EMA)
Faster-responding moving average using exponential weighting.
```
EMA = (Close - PrevEMA) × Multiplier + PrevEMA
Multiplier = 2 / (Period + 1)
```

### Stochastic Oscillator
Momentum indicator comparing closing price to price range.
```
%K = (Close - Lowest Low) / (Highest High - Lowest Low) × 100
%D = SMA(%K, 3)
```

### RSI (Relative Strength Index)
Momentum oscillator measuring speed and change of price movements.
```
RSI = 100 - (100 / (1 + RS))
RS = Average Gain / Average Loss
```

### MACD (Moving Average Convergence Divergence)
Trend-following momentum indicator.
```
MACD = EMA(12) - EMA(26)
Signal = EMA(MACD, 9)
Histogram = MACD - Signal
```

## 🤖 Strategy Logic

### Buy Signal
```
IF EMA50 > EMA150 
  AND Stochastic %K crosses above oversold (20)
THEN Generate BUY signal
```

### Sell Signal
```
IF EMA50 < EMA150 
  AND Stochastic %K crosses below overbought (80)
THEN Generate SELL signal
```

## 📈 Backtesting

Run backtests to evaluate strategy performance:

```dart
final backtest = getIt<BacktestEngine>();
final result = await backtest.runBacktest(
  historicalCandles,
  startDate: DateTime(2023, 1, 1),
  endDate: DateTime(2023, 12, 31),
);

print(result.totalProfit);
print(result.winRate);
print(result.maxDrawdown);
```

## 🔐 Security Considerations

- **API Token**: Store OANDA API token securely (use environment variables or secure storage)
- **Account ID**: Keep account ID confidential
- **Demo Account**: Use practice/demo account for testing
- **Data Encryption**: Consider encrypting sensitive data in local storage

## 📝 API Integration

### OANDA v20 API
- **Base URL**: `https://api-fxpractice.oanda.com` (practice)
- **Streaming URL**: `https://stream-fxpractice.oanda.com`
- **Authentication**: Bearer token in Authorization header

### Supported Endpoints
- `GET /v3/accounts/{accountID}/candles` - Fetch historical candles
- `GET /v3/accounts/{accountID}/pricing` - Get current prices
- `POST /v3/accounts/{accountID}/orders` - Create orders
- `PUT /v3/accounts/{accountID}/openPositions/{instrument}/close` - Close positions

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test --tags=widget
```

### Integration Tests
```bash
flutter test integration_test/
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🐛 Known Limitations

- Real-time streaming requires active internet connection
- Backtesting limited to available historical data
- Some advanced indicators not yet implemented
- Drawing tools on charts not yet implemented

## 🚧 Future Enhancements

- [ ] Advanced drawing tools (trendlines, support/resistance)
- [ ] Multiple strategy templates
- [ ] Strategy optimization with machine learning
- [ ] Social trading features
- [ ] Mobile push notifications
- [ ] Advanced charting library integration
- [ ] Real-time news feed
- [ ] Economic calendar integration
- [ ] Risk calculator tools
- [ ] Portfolio analytics

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [OANDA API Documentation](https://developer.oanda.com/rest-live-v20/introduction/)
- [Technical Analysis Guide](https://www.investopedia.com/terms/t/technicalanalysis.asp)
- [Trading Strategy Development](https://www.investopedia.com/terms/t/trading-strategy.asp)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support, email support@example.com or open an issue on GitHub.

## ⚠️ Disclaimer

This application is for educational and simulation purposes only. It is not intended for real trading. Always use a demo account first and thoroughly test any trading strategies before using real money. Trading involves substantial risk of loss. Past performance does not guarantee future results.

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Author**: Flutter Trading App Team
