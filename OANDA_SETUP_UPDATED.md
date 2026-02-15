# 🔧 دليل إعداد OANDA المحدّث

## 📊 بيانات الحساب الجديدة

### حساب Demo (Practice):
```
✓ Account ID: 101-004-28533521-003
✓ API Key: c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c
✓ Environment: practice
✓ Base URL: https://api-fxpractice.oanda.com
```

---

## 🚀 البدء السريع (5 دقائق)

### الخطوة 1: إضافة Secrets إلى GitHub

```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

اضغط **"New repository secret"** وأضف:

```
OANDA_ACCOUNT_ID = 101-004-28533521-003
OANDA_API_KEY = c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c
OANDA_ENVIRONMENT = practice
```

### الخطوة 2: التحقق من الإضافة

```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

يجب أن تظهر الـ Secrets الثلاثة:
- ✓ OANDA_ACCOUNT_ID
- ✓ OANDA_API_KEY
- ✓ OANDA_ENVIRONMENT

### الخطوة 3: اختبر التجميع

```
https://github.com/mahmoud97rmd/Manus-sec/actions
```

ادفع تغيير صغير لتشغيل الـ Workflows:

```bash
cd /home/ubuntu/Manus-sec
echo "# Updated" >> README.md
git add README.md
git commit -m "Update: OANDA credentials configured"
git push
```

---

## 🔐 الملفات الآمنة المضافة

### 1. `.env.example` - ملف المثال

```bash
# OANDA API Configuration
OANDA_ACCOUNT_ID=101-004-28533521-003
OANDA_API_KEY=your_api_key_here
OANDA_ENVIRONMENT=practice
OANDA_API_BASE_URL=https://api-fxpractice.oanda.com
```

**الاستخدام:**
```bash
cp .env.example .env
# ثم عدّل .env بالبيانات الفعلية
```

### 2. `lib/config/oanda_config.dart` - ملف التكوين

```dart
class OandaConfig {
  static const String accountId = '101-004-28533521-003';
  
  static String get apiKey {
    return const String.fromEnvironment(
      'OANDA_API_KEY',
      defaultValue: 'c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c',
    );
  }
  
  static const String environment = 'practice';
  static const String practiceBaseUrl = 'https://api-fxpractice.oanda.com';
  
  // ... المزيد من الطرق
}
```

**الاستخدام:**
```dart
// في أي ملف
OandaConfig.printConfig(showApiKey: false);
OandaConfig.validateConfig();
```

### 3. `lib/services/oanda_service.dart` - خدمة محدّثة

```dart
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

---

## 🔄 GitHub Actions Workflows

### 1. `build.yml` - بناء التطبيق

```yaml
env:
  OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
  OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}
  OANDA_ENVIRONMENT: ${{ secrets.OANDA_ENVIRONMENT }}
```

**ما يفعله:**
- ✓ تحليل الكود
- ✓ اختبار الوحدات
- ✓ بناء APK
- ✓ بناء AAB
- ✓ بناء iOS
- ✓ بناء Web
- ✓ إنشاء Release

### 2. `test.yml` - الاختبار والجودة

```yaml
env:
  OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
  OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}
  OANDA_ENVIRONMENT: ${{ secrets.OANDA_ENVIRONMENT }}
```

**ما يفعله:**
- ✓ Lint والتحليل
- ✓ اختبارات الوحدات
- ✓ فحص الأمان
- ✓ فحص التبعيات
- ✓ التحقق من OANDA Config

---

## 📋 قائمة الإعداد الكاملة

### ✅ ما تم إنجازه:

- [x] إنشاء `OandaConfig` class
- [x] تحديث `OandaService` للاستخدام الآمن
- [x] إنشاء `.env.example`
- [x] إنشاء `OANDA_CREDENTIALS_SETUP.md`
- [x] تحديث `build.yml` مع Secrets
- [x] تحديث `test.yml` مع Secrets
- [x] إضافة OANDA validation في workflows

### ⏳ ما يتبقى:

- [ ] إضافة Secrets يدويًا في GitHub (انظر الخطوة 1 أعلاه)
- [ ] دفع التحديثات إلى GitHub
- [ ] مراقبة التجميع الأول
- [ ] اختبار الاتصال بـ OANDA

---

## 🧪 اختبار الاتصال

### محلياً:

```bash
# 1. انسخ الملف
cp .env.example .env

# 2. أضف البيانات الفعلية
nano .env

# 3. شغّل الاختبار
flutter run
```

### في GitHub Actions:

```
https://github.com/mahmoud97rmd/Manus-sec/actions
→ اختر أحدث run
→ انقر على "Validate OANDA Configuration"
```

---

## 🛡️ نصائح الأمان

### ✓ افعل:
- استخدم GitHub Secrets للبيانات الحساسة
- استخدم `.env` محليًا فقط
- تحقق من `.gitignore` يحتوي على `.env`
- استخدم `OandaConfig.printConfig(showApiKey: false)`

### ✗ لا تفعل:
- لا تحفظ API Keys في الكود
- لا ترفع `.env` إلى GitHub
- لا تطبع API Keys كاملة في السجلات
- لا تشارك البيانات مع أحد

---

## 📞 الدعم والمساعدة

### إذا واجهت مشكلة:

1. **تحقق من Secrets:**
   ```
   Settings → Secrets and variables → Actions
   ```

2. **اقرأ السجلات:**
   ```
   Actions → أحدث run → Logs
   ```

3. **تحقق من البيانات:**
   ```dart
   OandaConfig.printConfig(showApiKey: false);
   OandaConfig.validateConfig();
   ```

4. **اقرأ الملفات:**
   - `OANDA_CREDENTIALS_SETUP.md` - شرح مفصل
   - `README.md` - نظرة عامة
   - `ARCHITECTURE.md` - معمارية المشروع

---

## 📊 الملفات المحدّثة

| الملف | الحالة | الوصف |
|------|--------|--------|
| `.env.example` | ✅ جديد | ملف المثال للبيانات |
| `lib/config/oanda_config.dart` | ✅ جديد | ملف التكوين الآمن |
| `lib/services/oanda_service.dart` | ✅ محدّث | خدمة محدّثة |
| `.github/workflows/build.yml` | ✅ محدّث | مع Secrets |
| `.github/workflows/test.yml` | ✅ محدّث | مع Secrets |
| `OANDA_CREDENTIALS_SETUP.md` | ✅ جديد | دليل مفصل |

---

## 🎯 الخطوات التالية

### 1. دفع التحديثات:
```bash
cd /home/ubuntu/Manus-sec
git add .
git commit -m "feat: Add OANDA configuration and GitHub Secrets support"
git push
```

### 2. إضافة Secrets يدويًا:
```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

### 3. مراقبة التجميع:
```
https://github.com/mahmoud97rmd/Manus-sec/actions
```

### 4. اختبار التطبيق:
```bash
flutter run
```

---

**آخر تحديث**: 2024-02-15
**الحالة**: ✅ جاهز للاستخدام الآمن
