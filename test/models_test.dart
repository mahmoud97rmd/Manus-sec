import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/models/candle.dart';
import 'package:flutter_trading_app/models/tick.dart';
import 'package:flutter_trading_app/models/position.dart';

void main() {
  group('Candle Model Tests', () {
    test('Create Candle with valid data', () {
      final now = DateTime.now();
      final candle = Candle(
        time: now,
        open: 1.0500,
        high: 1.0600,
        low: 1.0400,
        close: 1.0550,
        volume: 1000,
      );

      expect(candle.time, equals(now));
      expect(candle.open, equals(1.0500));
      expect(candle.high, equals(1.0600));
      expect(candle.low, equals(1.0400));
      expect(candle.close, equals(1.0550));
      expect(candle.volume, equals(1000));
    });

    test('Candle JSON serialization', () {
      final now = DateTime.now();
      final candle = Candle(
        time: now,
        open: 1.0500,
        high: 1.0600,
        low: 1.0400,
        close: 1.0550,
        volume: 1000,
      );

      final json = candle.toJson();
      expect(json['open'], equals(1.0500));
      expect(json['close'], equals(1.0550));

      final candleFromJson = Candle.fromJson(json);
      expect(candleFromJson.open, equals(candle.open));
      expect(candleFromJson.close, equals(candle.close));
    });

    test('Candle copyWith', () {
      final candle = Candle(
        time: DateTime.now(),
        open: 1.0500,
        high: 1.0600,
        low: 1.0400,
        close: 1.0550,
        volume: 1000,
      );

      final updatedCandle = candle.copyWith(close: 1.0600);
      expect(updatedCandle.close, equals(1.0600));
      expect(updatedCandle.open, equals(candle.open));
    });
  });

  group('Tick Model Tests', () {
    test('Create Tick with valid data', () {
      final now = DateTime.now();
      final tick = Tick(
        time: now,
        bid: 1.0500,
        ask: 1.0510,
      );

      expect(tick.time, equals(now));
      expect(tick.bid, equals(1.0500));
      expect(tick.ask, equals(1.0510));
    });

    test('Tick mid price calculation', () {
      final tick = Tick(
        time: DateTime.now(),
        bid: 1.0500,
        ask: 1.0510,
      );

      expect(tick.mid, equals(1.0505));
    });

    test('Tick JSON serialization', () {
      final now = DateTime.now();
      final tick = Tick(
        time: now,
        bid: 1.0500,
        ask: 1.0510,
      );

      final json = tick.toJson();
      final tickFromJson = Tick.fromJson(json);
      
      expect(tickFromJson.bid, equals(tick.bid));
      expect(tickFromJson.ask, equals(tick.ask));
      expect(tickFromJson.mid, equals(tick.mid));
    });
  });

  group('Position Model Tests', () {
    test('Create Position with valid data', () {
      final now = DateTime.now();
      final position = Position(
        id: 'pos_001',
        type: PositionType.buy,
        entryPrice: 1.0500,
        currentPrice: 1.0600,
        lots: 1.0,
        takeProfit: 1.0700,
        stopLoss: 1.0400,
        openTime: now,
      );

      expect(position.id, equals('pos_001'));
      expect(position.type, equals(PositionType.buy));
      expect(position.entryPrice, equals(1.0500));
      expect(position.currentPrice, equals(1.0600));
      expect(position.lots, equals(1.0));
    });

    test('Position profit calculation for buy', () {
      final position = Position(
        id: 'pos_001',
        type: PositionType.buy,
        entryPrice: 1.0500,
        currentPrice: 1.0600,
        lots: 1.0,
        openTime: DateTime.now(),
      );

      // Profit = (1.0600 - 1.0500) * 1.0 * 100 = 10
      expect(position.profitLoss, equals(10.0));
      expect(position.isProfit, isTrue);
    });

    test('Position profit calculation for sell', () {
      final position = Position(
        id: 'pos_002',
        type: PositionType.sell,
        entryPrice: 1.0600,
        currentPrice: 1.0500,
        lots: 1.0,
        openTime: DateTime.now(),
      );

      // Profit = (1.0600 - 1.0500) * 1.0 * 100 = 10
      expect(position.profitLoss, equals(10.0));
      expect(position.isProfit, isTrue);
    });

    test('Position JSON serialization', () {
      final now = DateTime.now();
      final position = Position(
        id: 'pos_001',
        type: PositionType.buy,
        entryPrice: 1.0500,
        currentPrice: 1.0600,
        lots: 1.0,
        openTime: now,
      );

      final json = position.toJson();
      final positionFromJson = Position.fromJson(json);
      
      expect(positionFromJson.id, equals(position.id));
      expect(positionFromJson.type, equals(position.type));
      expect(positionFromJson.entryPrice, equals(position.entryPrice));
    });
  });
}
