/// OANDA Configuration
/// 
/// This file handles OANDA API configuration and credentials.
/// For production use, credentials should be stored in environment variables
/// or GitHub Secrets, NOT in the code.

class OandaConfig {
  // OANDA Account Configuration
  // Demo Account (Practice)
  static const String accountId = '101-004-28533521-003';
  
  // OANDA API Key - Should be stored in environment variables
  // For GitHub Actions, use: ${{ secrets.OANDA_API_KEY }}
  // For local development, use .env file
  static String get apiKey {
    // In production, this should come from environment variables
    // For now, return from environment or use a default
    return const String.fromEnvironment(
      'OANDA_API_KEY',
      defaultValue: 'c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c',
    );
  }

  // OANDA API Environment
  static const String environment = 'practice'; // 'practice' for demo, 'live' for production
  
  // OANDA API Base URLs
  static const String practiceBaseUrl = 'https://api-fxpractice.oanda.com';
  static const String liveBaseUrl = 'https://api-fxpractice.oanda.com'; // Note: Change for production
  
  // Get the appropriate base URL based on environment
  static String get baseUrl {
    return environment == 'practice' ? practiceBaseUrl : liveBaseUrl;
  }

  // API Version
  static const String apiVersion = 'v3';
  
  // Get full API endpoint
  static String get apiEndpoint => '$baseUrl/$apiVersion';
  
  // Get accounts endpoint
  static String get accountsEndpoint => '$apiEndpoint/accounts/$accountId';
  
  // Get instruments endpoint
  static String get instrumentsEndpoint => '$accountsEndpoint/instruments';
  
  // Get pricing endpoint
  static String get pricingEndpoint => '$accountsEndpoint/pricing';
  
  // Get candles endpoint
  static String get candlesEndpoint => '$apiEndpoint/instruments';
  
  // Get trades endpoint
  static String get tradesEndpoint => '$accountsEndpoint/trades';
  
  // Get orders endpoint
  static String get ordersEndpoint => '$accountsEndpoint/orders';
  
  // Get positions endpoint
  static String get positionsEndpoint => '$accountsEndpoint/positions';

  // Default headers for API requests
  static Map<String, String> get defaultHeaders {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'AcceptDatetimeFormat': 'UNIX',
    };
  }

  // Supported instruments (Forex pairs)
  static const List<String> supportedInstruments = [
    'EUR_USD',
    'GBP_USD',
    'USD_JPY',
    'USD_CHF',
    'AUD_USD',
    'USD_CAD',
    'NZD_USD',
    'EUR_GBP',
    'EUR_JPY',
    'GBP_JPY',
  ];

  // Default candle granularity
  static const String defaultGranularity = 'M5'; // 5 minutes

  // Connection timeout (milliseconds)
  static const int connectionTimeout = 30000;

  // Read timeout (milliseconds)
  static const int readTimeout = 30000;

  // Write timeout (milliseconds)
  static const int writeTimeout = 30000;

  /// Validate configuration
  /// Returns true if all required fields are set correctly
  static bool validateConfig() {
    if (accountId.isEmpty) {
      print('❌ Error: OANDA Account ID is not configured');
      return false;
    }
    
    if (apiKey.isEmpty) {
      print('❌ Error: OANDA API Key is not configured');
      return false;
    }
    
    if (environment != 'practice' && environment != 'live') {
      print('❌ Error: Invalid OANDA environment. Must be "practice" or "live"');
      return false;
    }
    
    print('✓ OANDA Configuration is valid');
    print('  Account ID: $accountId');
    print('  Environment: $environment');
    print('  Base URL: $baseUrl');
    
    return true;
  }

  /// Print configuration (for debugging)
  /// WARNING: Do not print API key in production!
  static void printConfig({bool showApiKey = false}) {
    print('\n=== OANDA Configuration ===');
    print('Account ID: $accountId');
    if (showApiKey) {
      print('API Key: $apiKey');
    } else {
      print('API Key: ${apiKey.substring(0, 8)}...${apiKey.substring(apiKey.length - 4)}');
    }
    print('Environment: $environment');
    print('Base URL: $baseUrl');
    print('API Endpoint: $apiEndpoint');
    print('Accounts Endpoint: $accountsEndpoint');
    print('Supported Instruments: ${supportedInstruments.length}');
    print('===========================\n');
  }
}
