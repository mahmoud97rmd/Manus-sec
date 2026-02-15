# Flutter Trading App - Architecture Documentation

## Overview

This document describes the architectural design of the Flutter Trading App, which follows **Clean Architecture** principles combined with the **MVVM** (Model-View-ViewModel) pattern for state management.

## Architecture Layers

### 1. Presentation Layer (UI)

**Location**: `lib/screens/` and `lib/widgets/`

Responsible for displaying data to the user and capturing user interactions.

#### Components:
- **Screens**: Full-page UI components
  - `ChartScreen`: Main trading interface
  
- **Widgets**: Reusable UI components
  - `ChartWidget`: Interactive candlestick charts
  - `IndicatorPanel`: Technical indicator display
  - `AccountInfoWidget`: Account statistics display
  - `PositionsWidget`: Position management UI
  - `StrategyControlsWidget`: Strategy control buttons

#### State Management:
- Uses **Provider** pattern for reactive state management
- Providers are injected via `MultiProvider` in `main.dart`
- UI automatically rebuilds when provider data changes

### 2. Provider Layer (ViewModel)

**Location**: `lib/providers/`

Acts as a bridge between UI and business logic, managing application state.

#### Components:
- **MarketProvider**: Manages market data
  - Handles candle data loading and updates
  - Manages indicator calculations
  - Tracks current price and selected instruments
  
- **StrategyProvider**: Manages trading strategy state
  - Controls strategy activation/deactivation
  - Manages open and closed positions
  - Handles trade execution
  
- **AccountProvider**: Manages account information
  - Tracks balance, equity, margin
  - Provides account statistics
  - Handles account reset and configuration

#### Pattern:
```
UI (Widget) 
  ↓ (calls methods)
Provider (ChangeNotifier)
  ↓ (uses)
Services (Business Logic)
  ↓ (uses)
Models (Data)
```

### 3. Domain Layer (Business Logic)

**Location**: `lib/services/`

Contains core business logic, independent of frameworks and UI.

#### Components:

**IndicatorCalculator**
- Calculates technical indicators
- Supports: EMA, SMA, RSI, Stochastic, MACD, Bollinger Bands
- Pure Dart implementation for testability

**StrategyEngine**
- Generates trading signals based on indicators
- Manages strategy parameters
- Executes trades through VirtualExchange

**VirtualExchange**
- Simulates a trading account
- Manages positions (open/close)
- Calculates P&L, margin, equity
- Implements risk management (TP/SL)

**CandleAggregator**
- Converts tick data to OHLC candles
- Manages candle lifecycle
- Handles timeframe aggregation

**BacktestEngine**
- Runs historical backtests
- Calculates performance metrics
- Optimizes strategy parameters

### 4. Data Layer

**Location**: `lib/models/` and `lib/services/oanda_service.dart`

Handles data sources and API communication.

#### Components:

**Models**
- `Candle`: OHLC candlestick data
- `Tick`: Real-time price tick
- `Position`: Trading position
- `IndicatorValue`: Indicator calculation result

**OandaService**
- REST API client for OANDA
- Fetches historical candles
- Gets current prices
- Manages orders and positions

### 5. Service Locator (Dependency Injection)

**Location**: `lib/services/service_locator.dart`

Manages object instantiation and dependency injection using GetIt.

```dart
void setupServiceLocator() {
  // Register all services as singletons
  getIt.registerSingleton<OandaService>(...);
  getIt.registerSingleton<CandleAggregator>(...);
  getIt.registerSingleton<IndicatorCalculator>(...);
  // ... etc
}
```

## Data Flow

### Real-time Trading Flow

```
1. User opens app
   ↓
2. ChartScreen initializes
   ↓
3. MarketProvider.loadCandles() called
   ↓
4. OandaService fetches historical data
   ↓
5. CandleAggregator processes candles
   ↓
6. IndicatorCalculator computes indicators
   ↓
7. UI renders chart with indicators
   ↓
8. Real-time ticks arrive
   ↓
9. CandleAggregator updates current candle
   ↓
10. StrategyEngine checks for signals
    ↓
11. If signal → VirtualExchange executes trade
    ↓
12. UI updates with new position
```

### Backtest Flow

```
1. User initiates backtest
   ↓
2. BacktestEngine.runBacktest() called
   ↓
3. Load historical candles from database
   ↓
4. For each candle:
   - Update indicators
   - Check for signals
   - Execute trades
   - Update equity curve
   ↓
5. Generate performance report
   ↓
6. Display results to user
```

## Design Patterns Used

### 1. Provider Pattern
- For reactive state management
- Automatic UI updates on state changes
- Decouples UI from business logic

### 2. Repository Pattern
- Abstraction layer for data access
- Could be extended with local caching

### 3. Service Locator Pattern
- Centralized dependency management
- Easy to mock for testing
- Flexible service configuration

### 4. Observer Pattern
- ChangeNotifier for state observation
- Listeners automatically notified of changes

### 5. Singleton Pattern
- Services instantiated once
- Shared across entire application

### 6. Strategy Pattern
- Different indicator calculations
- Pluggable strategy implementations

## Dependency Injection

All services are registered in `service_locator.dart`:

```dart
// Access anywhere in the app
final oandaService = getIt<OandaService>();
final strategyEngine = getIt<StrategyEngine>();
```

Benefits:
- Easy to swap implementations
- Simplified testing (mock services)
- Centralized configuration

## Error Handling

### Network Errors
- Try-catch in OandaService
- User-friendly error messages in UI
- Retry mechanism for failed requests

### Data Validation
- Model validation in constructors
- Type safety with Dart's strong typing

### State Consistency
- Providers ensure consistent state
- Atomic state updates

## Performance Considerations

### 1. Indicator Calculation
- Efficient algorithms (EMA uses recursive formula)
- Sliding window for Stochastic
- Cached calculations where possible

### 2. Chart Rendering
- FL Chart library for optimized rendering
- Limited data points displayed at once
- Lazy loading of historical data

### 3. Memory Management
- Services as singletons to reduce memory
- Efficient data structures
- Proper cleanup in dispose methods

### 4. Network Optimization
- Batch API requests where possible
- Caching of historical data
- WebSocket for real-time updates

## Testing Strategy

### Unit Tests
- Test services independently
- Mock external dependencies
- Test business logic in isolation

### Widget Tests
- Test UI components
- Mock providers
- Verify UI updates

### Integration Tests
- Test complete user flows
- Use real or mock API
- Verify end-to-end functionality

## Scalability

### Adding New Features
1. Create new models if needed
2. Add service logic
3. Create provider for state management
4. Build UI components
5. Wire up in main.dart

### Adding New Indicators
1. Add calculation method to IndicatorCalculator
2. Update StrategyEngine to use new indicator
3. Display in UI

### Adding New Strategies
1. Create new strategy class
2. Implement signal generation logic
3. Register in service locator
4. Allow user selection in UI

## Future Improvements

### Architecture
- [ ] Add repository layer for data abstraction
- [ ] Implement local database caching
- [ ] Add event bus for cross-component communication
- [ ] Implement CQRS pattern for complex queries

### Performance
- [ ] Implement data pagination
- [ ] Add background processing with Isolates
- [ ] Optimize indicator calculations
- [ ] Implement data compression

### Testing
- [ ] Increase unit test coverage
- [ ] Add integration tests
- [ ] Implement performance benchmarks
- [ ] Add UI automation tests

## References

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Provider Pattern](https://pub.dev/packages/provider)
- [GetIt Service Locator](https://pub.dev/packages/get_it)
