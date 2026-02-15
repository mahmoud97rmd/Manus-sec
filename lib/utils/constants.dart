class AppConstants {
  // API Configuration
  static const String oandaBaseUrl = 'https://api-fxpractice.oanda.com';
  static const String oandaStreamingUrl = 'https://stream-fxpractice.oanda.com';

  // Trading Configuration
  static const double defaultLeverage = 100;
  static const double defaultLotSize = 100000;
  static const double defaultInitialBalance = 10000;

  // Strategy Parameters
  static const int defaultEMA50Period = 50;
  static const int defaultEMA150Period = 150;
  static const int defaultStochKPeriod = 14;
  static const int defaultStochDPeriod = 3;
  static const double defaultStochOversold = 20;
  static const double defaultStochOverbought = 80;
  static const double defaultTakeProfitPips = 50;
  static const double defaultStopLossPips = 20;

  // Timeframes
  static const List<String> timeframes = ['M1', 'M5', 'M15', 'H1', 'H4', 'D'];

  // Instruments
  static const List<String> instruments = [
    'XAU_USD',
    'EUR_USD',
    'GBP_USD',
    'USD_JPY',
    'USD_CHF',
    'AUD_USD',
  ];

  // UI Configuration
  static const double chartHeight = 400;
  static const double indicatorPanelHeight = 200;
  static const int maxCandlesDisplay = 500;
}

class AppStrings {
  static const String appTitle = 'Flutter Trading App';
  static const String chartTitle = 'Price Chart';
  static const String indicatorTitle = 'Technical Indicators';
  static const String accountTitle = 'Account Information';
  static const String positionsTitle = 'Positions';
  static const String strategyTitle = 'Strategy Controls';

  // Buttons
  static const String buyButton = 'BUY';
  static const String sellButton = 'SELL';
  static const String closeButton = 'CLOSE';
  static const String resetButton = 'RESET';
  static const String strategyOn = 'Strategy: ON';
  static const String strategyOff = 'Strategy: OFF';

  // Messages
  static const String loadingData = 'Loading data...';
  static const String noDataAvailable = 'No data available';
  static const String errorLoadingData = 'Error loading data';
  static const String insufficientBalance = 'Insufficient balance';
  static const String positionClosed = 'Position closed';
  static const String tradeExecuted = 'Trade executed';
}

class AppColors {
  static const int primary = 0xFF2196F3;
  static const int secondary = 0xFF03DAC6;
  static const int error = 0xFFB00020;
  static const int success = 0xFF4CAF50;
  static const int warning = 0xFFFFC107;
  static const int background = 0xFFFFFFFF;
  static const int surface = 0xFFF5F5F5;
  static const int text = 0xFF212121;
  static const int textSecondary = 0xFF757575;
  static const int buyColor = 0xFF4CAF50;
  static const int sellColor = 0xFFFF5252;
}
