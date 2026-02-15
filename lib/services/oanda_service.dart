import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/candle.dart';
import '../models/tick.dart';

class OandaService {
  static const String baseUrl = 'https://api-fxpractice.oanda.com';
  static const String streamingUrl = 'https://stream-fxpractice.oanda.com';
  
  final String apiToken;
  final String accountId;
  final Dio dio;
  final Logger logger = Logger();

  OandaService({
    required this.apiToken,
    required this.accountId,
  }) : dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
      'Accept-Datetime-Format': 'UNIX',
    },
  ));

  /// Fetch historical candles from OANDA
  Future<List<Candle>> fetchCandles({
    required String instrument,
    required String granularity,
    int count = 500,
  }) async {
    try {
      final response = await dio.get(
        '/v3/accounts/$accountId/candles',
        queryParameters: {
          'instrument': instrument,
          'granularity': granularity,
          'count': count,
        },
      );

      final List<dynamic> candlesJson = response.data['candles'] ?? [];
      final candles = candlesJson.map((c) {
        return Candle(
          time: DateTime.fromMillisecondsSinceEpoch(c['time'] * 1000),
          open: double.parse(c['mid']['o'].toString()),
          high: double.parse(c['mid']['h'].toString()),
          low: double.parse(c['mid']['l'].toString()),
          close: double.parse(c['mid']['c'].toString()),
          volume: c['volume'] ?? 0,
        );
      }).toList();

      logger.i('Fetched ${candles.length} candles for $instrument ($granularity)');
      return candles;
    } catch (e) {
      logger.e('Error fetching candles: $e');
      rethrow;
    }
  }

  /// Get current account information
  Future<Map<String, dynamic>> getAccountInfo() async {
    try {
      final response = await dio.get('/v3/accounts/$accountId');
      return response.data['account'] ?? {};
    } catch (e) {
      logger.e('Error fetching account info: $e');
      rethrow;
    }
  }

  /// Get current price for an instrument
  Future<Map<String, double>> getCurrentPrice(String instrument) async {
    try {
      final response = await dio.get(
        '/v3/accounts/$accountId/pricing',
        queryParameters: {'instruments': instrument},
      );

      final prices = response.data['prices'][0];
      return {
        'bid': double.parse(prices['bids'][0]['price'].toString()),
        'ask': double.parse(prices['asks'][0]['price'].toString()),
      };
    } catch (e) {
      logger.e('Error fetching current price: $e');
      rethrow;
    }
  }

  /// Create a market order
  Future<Map<String, dynamic>> createMarketOrder({
    required String instrument,
    required int units,
    required double? takeProfit,
    required double? stopLoss,
  }) async {
    try {
      final orderData = {
        'order': {
          'type': 'MARKET',
          'instrument': instrument,
          'units': units,
          if (takeProfit != null)
            'takeProfitOnFill': {'price': takeProfit.toStringAsFixed(5)},
          if (stopLoss != null)
            'stopLossOnFill': {'price': stopLoss.toStringAsFixed(5)},
        }
      };

      final response = await dio.post(
        '/v3/accounts/$accountId/orders',
        data: orderData,
      );

      logger.i('Market order created: ${response.data}');
      return response.data;
    } catch (e) {
      logger.e('Error creating market order: $e');
      rethrow;
    }
  }

  /// Close a position
  Future<Map<String, dynamic>> closePosition({
    required String instrument,
  }) async {
    try {
      final response = await dio.put(
        '/v3/accounts/$accountId/openPositions/$instrument/close',
        data: {
          'longUnits': 'ALL',
          'shortUnits': 'ALL',
        },
      );

      logger.i('Position closed: ${response.data}');
      return response.data;
    } catch (e) {
      logger.e('Error closing position: $e');
      rethrow;
    }
  }

  /// Get open positions
  Future<List<Map<String, dynamic>>> getOpenPositions() async {
    try {
      final response = await dio.get('/v3/accounts/$accountId/openPositions');
      return List<Map<String, dynamic>>.from(response.data['positions'] ?? []);
    } catch (e) {
      logger.e('Error fetching open positions: $e');
      rethrow;
    }
  }
}
