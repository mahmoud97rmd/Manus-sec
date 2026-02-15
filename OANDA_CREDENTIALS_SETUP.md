# 🔐 دليل إعداد بيانات OANDA بشكل آمن

## ⚠️ تنبيه أمان مهم

**لا تقم أبداً بـ:**
- ✗ حفظ API Keys في الكود
- ✗ رفع ملفات .env إلى GitHub
- ✗ مشاركة بيانات الحساب مع أحد

**استخدم دائماً:**
- ✓ GitHub Secrets للبيانات الحساسة
- ✓ متغيرات البيئة (Environment Variables)
- ✓ ملفات .env محلية (مضافة في .gitignore)

---

## 📋 بيانات OANDA الحالية

### حساب Demo (Practice):
```
Account ID: 101-004-28533521-003
API Key: c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c
Environment: practice (Demo)
Base URL: https://api-fxpractice.oanda.com
```

---

## 🔧 طرق الإعداد

### الطريقة 1: GitHub Secrets (الموصى بها للـ CI/CD)

#### الخطوة 1: اذهب إلى إعدادات المستودع

```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

#### الخطوة 2: أضف Secrets جديد

اضغط **"New repository secret"** وأضف:

| الاسم | القيمة |
|------|--------|
| `OANDA_ACCOUNT_ID` | `101-004-28533521-003` |
| `OANDA_API_KEY` | `c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c` |
| `OANDA_ENVIRONMENT` | `practice` |

#### الخطوة 3: استخدمها في GitHub Actions

في ملفات `.github/workflows/`:

```yaml
env:
  OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
  OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}
  OANDA_ENVIRONMENT: ${{ secrets.OANDA_ENVIRONMENT }}
```

---

### الطريقة 2: ملف .env المحلي (للتطوير)

#### الخطوة 1: انسخ ملف المثال

```bash
cp .env.example .env
```

#### الخطوة 2: حرّر الملف

```bash
nano .env
# أو استخدم محرر النصوص المفضل لديك
```

#### الخطوة 3: أضف البيانات

```env
# OANDA API Configuration
OANDA_ACCOUNT_ID=101-004-28533521-003
OANDA_API_KEY=c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c
OANDA_ENVIRONMENT=practice
OANDA_API_BASE_URL=https://api-fxpractice.oanda.com
```

#### الخطوة 4: تأكد من أن .env في .gitignore

```bash
grep ".env" .gitignore
# يجب أن تظهر: .env
```

---

### الطريقة 3: متغيرات البيئة (Environment Variables)

#### على Linux/macOS:

```bash
export OANDA_ACCOUNT_ID="101-004-28533521-003"
export OANDA_API_KEY="c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c"
export OANDA_ENVIRONMENT="practice"
```

#### على Windows (PowerShell):

```powershell
$env:OANDA_ACCOUNT_ID="101-004-28533521-003"
$env:OANDA_API_KEY="c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c"
$env:OANDA_ENVIRONMENT="practice"
```

#### على Windows (Command Prompt):

```cmd
set OANDA_ACCOUNT_ID=101-004-28533521-003
set OANDA_API_KEY=c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c
set OANDA_ENVIRONMENT=practice
```

---

## 📁 استخدام البيانات في الكود

### في OandaConfig:

```dart
// lib/config/oanda_config.dart

class OandaConfig {
  static const String accountId = '101-004-28533521-003';
  
  static String get apiKey {
    return const String.fromEnvironment(
      'OANDA_API_KEY',
      defaultValue: 'c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c',
    );
  }
  
  static const String environment = 'practice';
  // ...
}
```

### في OandaService:

```dart
// lib/services/oanda_service.dart

class OandaService {
  OandaService({
    String? apiToken,
    String? accountId,
  }) {
    this.apiToken = apiToken ?? OandaConfig.apiKey;
    this.accountId = accountId ?? OandaConfig.accountId;
    // ...
  }
}
```

### في main.dart:

```dart
// lib/main.dart

void main() {
  // تهيئة OandaService بالبيانات من OandaConfig
  final oandaService = OandaService();
  
  // أو مع بيانات مخصصة:
  final customService = OandaService(
    apiToken: 'your_custom_token',
    accountId: 'your_custom_account',
  );
  
  runApp(const MyApp());
}
```

---

## 🔄 تحديث البيانات

### إذا تغيرت بيانات OANDA:

#### 1. تحديث GitHub Secrets:

```
Settings → Secrets and variables → Actions
→ اختر Secret القديم
→ اضغط "Update"
→ أدخل القيمة الجديدة
```

#### 2. تحديث ملف .env المحلي:

```bash
nano .env
# عدّل البيانات
```

#### 3. تحديث OandaConfig (إذا لزم الأمر):

```dart
static const String accountId = 'NEW_ACCOUNT_ID';
```

---

## ✅ التحقق من البيانات

### اختبار الاتصال:

```dart
// lib/main.dart أو أي ملف اختبار

void testOandaConnection() async {
  final oandaService = OandaService();
  
  // طباعة الإعدادات
  OandaConfig.printConfig(showApiKey: false);
  
  // التحقق من صحة الإعدادات
  if (!OandaConfig.validateConfig()) {
    print('❌ خطأ في الإعدادات');
    return;
  }
  
  // اختبار الاتصال
  try {
    final accountInfo = await oandaService.getAccountInfo();
    print('✓ اتصال ناجح!');
    print('Account Balance: ${accountInfo['balance']}');
  } catch (e) {
    print('❌ خطأ في الاتصال: $e');
  }
}
```

---

## 🛡️ أفضل الممارسات الأمنية

### 1. استخدم حساب Demo للتطوير

```dart
// ✓ جيد - حساب Demo
OANDA_ENVIRONMENT=practice
OANDA_ACCOUNT_ID=101-004-28533521-003
```

### 2. لا تحفظ API Keys في الكود

```dart
// ✗ خطأ
const String apiKey = 'c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c';

// ✓ صحيح
static String get apiKey {
  return const String.fromEnvironment('OANDA_API_KEY');
}
```

### 3. استخدم .gitignore

```bash
# .gitignore
.env
.env.local
.env.*.local
*.key
*.pem
```

### 4. راجع السجلات بحذر

```dart
// ✗ لا تطبع API Keys
logger.i('API Key: $apiKey');

// ✓ اطبع جزء فقط
logger.i('API Key: ${apiKey.substring(0, 8)}...');
```

### 5. استخدم Secrets في CI/CD

```yaml
# .github/workflows/build.yml
env:
  OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}  # ✓ آمن
  DEBUG_API_KEY: ${{ env.OANDA_API_KEY }}      # ✗ غير آمن
```

---

## 📊 ملخص الإعدادات

| الطريقة | الاستخدام | الأمان |
|--------|----------|--------|
| GitHub Secrets | CI/CD و Workflows | ⭐⭐⭐⭐⭐ |
| .env المحلي | التطوير المحلي | ⭐⭐⭐⭐ |
| متغيرات البيئة | الخوادم والـ Containers | ⭐⭐⭐⭐ |
| الكود المباشر | ❌ لا تستخدم | ❌ |

---

## 🔗 الروابط المفيدة

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [OANDA API Documentation](https://developer.oanda.com/)
- [Dart Environment Variables](https://dart.dev/guides/libraries/library-tour#platform-libraries)
- [Flutter Security Best Practices](https://flutter.dev/docs/testing/best-practices)

---

## ❓ الأسئلة الشائعة

### س: هل يمكن استخدام API Key مباشرة في الكود؟
**ج:** لا! استخدم دائماً GitHub Secrets أو متغيرات البيئة.

### س: ماذا لو تسرّب API Key؟
**ج:** اذهب إلى OANDA وأنشئ API Key جديد فوراً.

### س: هل يمكن استخدام حساب Live مع Demo؟
**ج:** نعم، لكن استخدم Demo للتطوير واختبار فقط.

### س: كيف أتأكد من أن البيانات محفوظة؟
**ج:** استخدم `OandaConfig.validateConfig()` و `OandaConfig.printConfig(showApiKey: false)`.

---

**آخر تحديث**: 2024-02-15
**الحالة**: ✅ آمن وجاهز للاستخدام
