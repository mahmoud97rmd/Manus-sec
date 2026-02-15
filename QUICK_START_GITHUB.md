# 🚀 دليل البدء السريع - GitHub و التجميع التلقائي

## ⚡ 5 خطوات فقط للبدء

### 1️⃣ إنشاء مستودع GitHub

```bash
# اذهب إلى: https://github.com/new
# أو استخدم CLI:
gh repo create flutter_trading_app --private
```

### 2️⃣ استنساخ المستودع محلياً

```bash
git clone https://github.com/your-username/flutter_trading_app.git
cd flutter_trading_app
```

### 3️⃣ نسخ ملفات المشروع

```bash
# انسخ جميع ملفات المشروع إلى المجلد
# بما فيها:
# - lib/
# - pubspec.yaml
# - .github/workflows/
# - إلخ
```

### 4️⃣ رفع الملفات

```bash
git add .
git commit -m "Initial commit: Flutter Trading App with CI/CD"
git push -u origin main
```

### 5️⃣ مراقبة التجميع

```bash
# اذهب إلى: https://github.com/your-username/flutter_trading_app/actions
# أو استخدم CLI:
gh run list
```

---

## 📊 ما سيحدث تلقائياً

### عند كل push:

```
✅ تحليل الكود (Analyze)
✅ اختبار الوحدات (Unit Tests)
✅ فحص الأمان (Security Scan)
✅ فحص الأداء (Performance)
```

### عند push إلى main:

```
(جميع الخطوات أعلاه)
✅ بناء APK (Android)
✅ بناء AAB (Google Play)
✅ بناء iOS
✅ بناء Web
✅ إنشاء Release
```

---

## 📥 تحميل التطبيق المجمع

### من GitHub:

1. اذهب إلى "Actions" → أحدث run
2. انقر على "Artifacts"
3. اختر الملف المراد تحميله

### من CLI:

```bash
# تحميل APK
gh run download <run-id> -n flutter-trading-app-release.apk

# تحميل AAB
gh run download <run-id> -n flutter-trading-app-release.aab
```

---

## 🔧 إضافة بيانات OANDA

### الطريقة الآمنة:

```bash
# 1. إضافة Secrets في GitHub:
gh secret set OANDA_API_TOKEN --body "your_token"
gh secret set OANDA_ACCOUNT_ID --body "your_account_id"

# 2. استخدامها في build.yml:
env:
  OANDA_API_TOKEN: ${{ secrets.OANDA_API_TOKEN }}
  OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
```

---

## ❌ استكشاف الأخطاء

### فشل التجميع؟

```bash
# عرض الـ logs:
gh run view <run-id> --log

# أو من الويب:
# https://github.com/your-username/flutter_trading_app/actions
```

### خطأ في الاختبارات؟

```bash
# تشغيل الاختبارات محلياً:
flutter test

# عرض التفاصيل:
flutter test --verbose
```

---

## 📋 قائمة التحقق

- [ ] تم إنشاء مستودع GitHub
- [ ] تم دفع جميع الملفات
- [ ] ظهرت "Actions" في GitHub
- [ ] اكتملت جميع الـ jobs بنجاح
- [ ] تم تحميل الـ APK بنجاح
- [ ] تم اختبار التطبيق على جهاز

---

## 🎯 الخطوات التالية

1. **اختبر التطبيق**: ثبّت APK على جهازك
2. **أضف Secrets**: أضف بيانات OANDA بشكل آمن
3. **نشر على Store**: ارفع AAB إلى Google Play
4. **راقب الأداء**: تابع الـ logs والـ metrics

---

**📖 للمزيد من التفاصيل**: اقرأ `GITHUB_SETUP.md`

**🆘 هل تحتاج مساعدة؟**
- GitHub Docs: https://docs.github.com/en/actions
- Flutter Docs: https://flutter.dev/docs
