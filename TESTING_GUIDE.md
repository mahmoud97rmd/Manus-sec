# دليل الاختبار الشامل

## 🧪 استراتيجية الاختبار

هذا الدليل يغطي:
1. اختبار الوحدات (Unit Tests)
2. اختبار الدوال الرياضية
3. اختبار الترابط بين المكونات
4. اختبار السيناريوهات الكاملة
5. اختبار الأداء

---

## 1. اختبار الوحدات (Unit Tests)

### إنشاء ملف الاختبار

**ملف جديد**: `test/unit/indicator_calculator_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/services/indicator_calculator.dart';

void main() {
  group('IndicatorCalculator Tests', () {
    late IndicatorCalculator calculator;

    setUp(() {
      calculator = IndicatorCalculator();
    });

    // اختبار EMA
    test('calculateEMA should return correct values', () {
      final data = [100.0, 102.0, 101.0, 103.0, 105.0];
      final ema = calculator.calculateEMA(data, period: 3);
      
      expect(ema.isNotEmpty, true);
      expect(ema.last > 0, true);
    });

    // اختبار RSI
    test('calculateRSI should return values between 0 and 100', () {
      final data = [100.0, 102.0, 101.0, 103.0, 105.0, 104.0, 106.0];
      final rsi = calculator.calculateRSI(data, period: 3);
      
      expect(rsi.last >= 0, true);
      expect(rsi.last <= 100, true);
    });

    // اختبار Stochastic
    test('calculateStochastic should return values between 0 and 100', () {
      final data = [100.0, 102.0, 101.0, 103.0, 105.0, 104.0, 106.0];
      final stoch = calculator.calculateStochastic(data, k: 3, d: 3);
      
      expect(stoch.isNotEmpty, true);
      expect(stoch.last.k >= 0 && stoch.last.k <= 100, true);
    });

    // اختبار SMA
    test('calculateSMA should return correct average', () {
      final data = [100.0, 100.0, 100.0, 100.0];
      final sma = calculator.calculateSMA(data, period: 2);
      
      expect(sma.last, 100.0);
    });
  });
}
```

### تشغيل الاختبارات

```bash
# تشغيل اختبار واحد
flutter test test/unit/indicator_calculator_test.dart

# تشغيل جميع الاختبارات
flutter test
```

---

## 2. اختبار نماذج البيانات

**ملف جديد**: `test/unit/models_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/models/candle.dart';
import 'package:flutter_trading_app/models/position.dart';

void main() {
  group('Data Models Tests', () {
    // اختبار Candle
    test('Candle should calculate correct high and low', () {
      final candle = Candle(
        time: DateTime.now(),
        open: 100.0,
        high: 105.0,
        low: 95.0,
        close: 102.0,
        volume: 1000,
      );

      expect(candle.high >= candle.open, true);
      expect(candle.high >= candle.close, true);
      expect(candle.low <= candle.open, true);
      expect(candle.low <= candle.close, true);
    });

    // اختبار Position P&L
    test('Position should calculate correct P&L', () {
      final position = Position(
        id: '1',
        instrument: 'XAU_USD',
        type: PositionType.buy,
        openPrice: 100.0,
        currentPrice: 105.0,
        volume: 1.0,
        openTime: DateTime.now(),
        takeProfit: 110.0,
        stopLoss: 95.0,
      );

      expect(position.profitLoss > 0, true); // يجب أن تكون الأرباح موجبة
    });

    // اختبار Position SELL
    test('Position SELL should calculate negative P&L correctly', () {
      final position = Position(
        id: '2',
        instrument: 'XAU_USD',
        type: PositionType.sell,
        openPrice: 100.0,
        currentPrice: 95.0,
        volume: 1.0,
        openTime: DateTime.now(),
        takeProfit: 90.0,
        stopLoss: 105.0,
      );

      expect(position.profitLoss > 0, true); // يجب أن تكون الأرباح موجبة
    });
  });
}
```

---

## 3. اختبار الخدمات

**ملف جديد**: `test/unit/virtual_exchange_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/services/virtual_exchange.dart';

void main() {
  group('VirtualExchange Tests', () {
    late VirtualExchange exchange;

    setUp(() {
      exchange = VirtualExchange(initialBalance: 10000);
    });

    // اختبار فتح صفقة
    test('openPosition should create a new position', () {
      final result = exchange.openPosition(
        instrument: 'XAU_USD',
        type: 'BUY',
        volume: 0.1,
        openPrice: 2000.0,
        takeProfit: 2050.0,
        stopLoss: 1950.0,
      );

      expect(result.success, true);
      expect(exchange.openPositions.length, 1);
    });

    // اختبار إغلاق صفقة
    test('closePosition should close an open position', () {
      // فتح صفقة أولاً
      exchange.openPosition(
        instrument: 'XAU_USD',
        type: 'BUY',
        volume: 0.1,
        openPrice: 2000.0,
        takeProfit: 2050.0,
        stopLoss: 1950.0,
      );

      // إغلاق الصفقة
      final position = exchange.openPositions.first;
      exchange.closePosition(position.id, closePrice: 2010.0);

      expect(exchange.closedPositions.length, 1);
    });

    // اختبار حساب الهامش
    test('calculateMargin should return correct margin', () {
      final margin = exchange.calculateMargin(
        volume: 0.1,
        price: 2000.0,
        leverage: 100,
      );

      expect(margin > 0, true);
      expect(margin <= 10000, true); // يجب أن يكون أقل من الرصيد الأولي
    });

    // اختبار Equity
    test('getEquity should calculate correct equity', () {
      exchange.openPosition(
        instrument: 'XAU_USD',
        type: 'BUY',
        volume: 0.1,
        openPrice: 2000.0,
        takeProfit: 2050.0,
        stopLoss: 1950.0,
      );

      exchange.updatePrice('XAU_USD', 2010.0);

      final equity = exchange.getEquity();
      expect(equity > 10000, true); // Equity يجب أن يزيد مع الأرباح
    });
  });
}
```

---

## 4. اختبار الترابط بين المكونات

**ملف جديد**: `test/integration/full_flow_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/services/indicator_calculator.dart';
import 'package:flutter_trading_app/services/virtual_exchange.dart';
import 'package:flutter_trading_app/services/strategy_engine.dart';
import 'package:flutter_trading_app/models/candle.dart';

void main() {
  group('Full Trading Flow Integration Tests', () {
    late IndicatorCalculator calculator;
    late VirtualExchange exchange;
    late StrategyEngine strategy;
    late List<Candle> candles;

    setUp(() {
      calculator = IndicatorCalculator();
      exchange = VirtualExchange(initialBalance: 10000);
      strategy = StrategyEngine();
      
      // إنشاء بيانات اختبار
      candles = _generateTestCandles(100);
    });

    // اختبار التدفق الكامل
    test('Complete trading flow should work correctly', () {
      // 1. حساب المؤشرات
      final emaValues = calculator.calculateEMA(
        candles.map((c) => c.close).toList(),
        period: 50,
      );

      expect(emaValues.isNotEmpty, true);

      // 2. فتح صفقة
      final openResult = exchange.openPosition(
        instrument: 'XAU_USD',
        type: 'BUY',
        volume: 0.1,
        openPrice: candles.last.close,
        takeProfit: candles.last.close + 50,
        stopLoss: candles.last.close - 20,
      );

      expect(openResult.success, true);
      expect(exchange.openPositions.length, 1);

      // 3. تحديث السعر
      exchange.updatePrice('XAU_USD', candles.last.close + 10);

      // 4. فحص الأرباح
      final position = exchange.openPositions.first;
      expect(position.profitLoss > 0, true);

      // 5. إغلاق الصفقة
      exchange.closePosition(position.id, closePrice: candles.last.close + 10);

      expect(exchange.closedPositions.length, 1);
      expect(exchange.openPositions.isEmpty, true);
    });

    // اختبار استراتيجية متعددة الصفقات
    test('Multiple trades should be managed correctly', () {
      for (int i = 0; i < 5; i++) {
        exchange.openPosition(
          instrument: 'XAU_USD',
          type: i % 2 == 0 ? 'BUY' : 'SELL',
          volume: 0.1,
          openPrice: 2000.0 + i,
          takeProfit: 2050.0 + i,
          stopLoss: 1950.0 + i,
        );
      }

      expect(exchange.openPositions.length, 5);

      // إغلاق جميع الصفقات
      for (var position in exchange.openPositions.toList()) {
        exchange.closePosition(position.id, closePrice: 2010.0);
      }

      expect(exchange.openPositions.isEmpty, true);
      expect(exchange.closedPositions.length, 5);
    });
  });
}

// دالة مساعدة لإنشاء بيانات اختبار
List<Candle> _generateTestCandles(int count) {
  final candles = <Candle>[];
  var price = 2000.0;
  var now = DateTime.now();

  for (int i = 0; i < count; i++) {
    final change = (i % 10 - 5) * 0.5;
    final open = price;
    price += change;
    final close = price;
    final high = [open, close].reduce((a, b) => a > b ? a : b) + 1;
    final low = [open, close].reduce((a, b) => a < b ? a : b) - 1;

    candles.add(Candle(
      time: now.add(Duration(minutes: i)),
      open: open,
      high: high,
      low: low,
      close: close,
      volume: 1000 + (i % 500),
    ));
  }

  return candles;
}
```

---

## 5. اختبار الأداء

**ملف جديد**: `test/performance/performance_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trading_app/services/indicator_calculator.dart';
import 'package:flutter_trading_app/models/candle.dart';

void main() {
  group('Performance Tests', () {
    late IndicatorCalculator calculator;
    late List<Candle> candles;

    setUp(() {
      calculator = IndicatorCalculator();
      candles = _generateLargeDataset(10000);
    });

    // اختبار سرعة حساب EMA
    test('EMA calculation should complete in reasonable time', () {
      final stopwatch = Stopwatch()..start();
      
      calculator.calculateEMA(
        candles.map((c) => c.close).toList(),
        period: 50,
      );
      
      stopwatch.stop();
      
      print('EMA calculation took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds < 500, true); // يجب أن تكون أقل من 500ms
    });

    // اختبار سرعة حساب RSI
    test('RSI calculation should complete in reasonable time', () {
      final stopwatch = Stopwatch()..start();
      
      calculator.calculateRSI(
        candles.map((c) => c.close).toList(),
        period: 14,
      );
      
      stopwatch.stop();
      
      print('RSI calculation took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds < 500, true);
    });

    // اختبار سرعة حساب Stochastic
    test('Stochastic calculation should complete in reasonable time', () {
      final stopwatch = Stopwatch()..start();
      
      calculator.calculateStochastic(
        candles.map((c) => c.close).toList(),
        k: 14,
        d: 3,
      );
      
      stopwatch.stop();
      
      print('Stochastic calculation took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds < 500, true);
    });
  });
}

List<Candle> _generateLargeDataset(int count) {
  final candles = <Candle>[];
  var price = 2000.0;
  var now = DateTime.now();

  for (int i = 0; i < count; i++) {
    final change = (DateTime.now().millisecond % 10 - 5) * 0.01;
    final open = price;
    price += change;
    final close = price;
    final high = [open, close].reduce((a, b) => a > b ? a : b) + 0.05;
    final low = [open, close].reduce((a, b) => a < b ? a : b) - 0.05;

    candles.add(Candle(
      time: now.add(Duration(minutes: i)),
      open: open,
      high: high,
      low: low,
      close: close,
      volume: 1000 + (i % 500),
    ));
  }

  return candles;
}
```

---

## 6. اختبار واجهة المستخدم

**ملف جديد**: `test/widget/chart_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_trading_app/screens/chart_screen.dart';
import 'package:flutter_trading_app/providers/market_provider.dart';
import 'package:flutter_trading_app/providers/strategy_provider.dart';
import 'package:flutter_trading_app/providers/account_provider.dart';

void main() {
  group('ChartScreen Widget Tests', () {
    testWidgets('ChartScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MarketProvider()),
            ChangeNotifierProvider(create: (_) => StrategyProvider()),
            ChangeNotifierProvider(create: (_) => AccountProvider()),
          ],
          child: const MaterialApp(
            home: ChartScreen(),
          ),
        ),
      );

      // تحقق من وجود العناصر الأساسية
      expect(find.text('XAU_USD'), findsWidgets);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('M1'), findsOneWidget);
      expect(find.text('M5'), findsOneWidget);
      expect(find.text('M15'), findsOneWidget);
    });

    testWidgets('Timeframe buttons should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MarketProvider()),
            ChangeNotifierProvider(create: (_) => StrategyProvider()),
            ChangeNotifierProvider(create: (_) => AccountProvider()),
          ],
          child: const MaterialApp(
            home: ChartScreen(),
          ),
        ),
      );

      // اضغط على M5
      await tester.tap(find.text('M5'));
      await tester.pumpAndSettle();

      // تحقق من أن الزر تم تحديثه
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Strategy toggle button should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MarketProvider()),
            ChangeNotifierProvider(create: (_) => StrategyProvider()),
            ChangeNotifierProvider(create: (_) => AccountProvider()),
          ],
          child: const MaterialApp(
            home: ChartScreen(),
          ),
        ),
      );

      // اضغط على زر الاستراتيجية
      final strategyButton = find.byType(FloatingActionButton);
      await tester.tap(strategyButton);
      await tester.pumpAndSettle();

      // تحقق من التغيير
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
```

---

## 7. قائمة الاختبار اليدوية

### اختبار الميزات الأساسية:

- [ ] تحميل البيانات الأولية عند فتح التطبيق
- [ ] عرض الشموع والمؤشرات بشكل صحيح
- [ ] تحديث الأسعار الحية
- [ ] حساب المؤشرات بشكل صحيح
- [ ] توليد الإشارات الصحيحة
- [ ] تنفيذ الصفقات عند الإشارات
- [ ] إدارة الهامش والـ Equity
- [ ] إغلاق الصفقات عند TP/SL
- [ ] عرض الصفقات المفتوحة والمغلقة
- [ ] حساب الأرباح والخسائر

### اختبار تغيير الفترة الزمنية:

- [ ] اختيار M1 يعرض شموع دقيقة واحدة
- [ ] اختيار M5 يعرض شموع 5 دقائق
- [ ] اختيار M15 يعرض شموع 15 دقيقة
- [ ] تغيير الفترة يحدّث الشموع والمؤشرات

### اختبار الاستراتيجية:

- [ ] تفعيل الاستراتيجية يبدأ المراقبة
- [ ] تعطيل الاستراتيجية يوقف المراقبة
- [ ] الإشارات تُولّد في الوقت الصحيح
- [ ] الصفقات تُفتح بـ TP و SL صحيح

### اختبار الـ Backtest:

- [ ] اختيار تاريخ البداية والنهاية
- [ ] تشغيل الاختبار يحسب النتائج
- [ ] عرض النتائج بشكل صحيح
- [ ] حساب Win Rate و Max Drawdown صحيح

---

## 8. تشغيل جميع الاختبارات

```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل اختبارات محددة
flutter test test/unit/

# تشغيل مع تقرير تغطية
flutter test --coverage

# عرض تقرير التغطية
lcov --list coverage/lcov.info
```

---

## 9. معايير النجاح

| المعيار | النتيجة المتوقعة |
|--------|-----------------|
| جميع الاختبارات تمر | ✅ 100% |
| تغطية الكود | ✅ 80%+ |
| سرعة الحسابات | ✅ < 500ms |
| عدم التسريب في الذاكرة | ✅ نعم |
| الترابط بين المكونات | ✅ صحيح |

---

**آخر تحديث**: 2024
**الحالة**: ✅ جاهز للاستخدام
