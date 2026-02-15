# 📤 دليل النشر على GitHub مع التجميع التلقائي

## 🎯 الهدف
رفع تطبيق Flutter للتداول إلى GitHub وتفعيل التجميع التلقائي عند كل push.

---

## 📋 المتطلبات

- [ ] حساب GitHub (مجاني)
- [ ] Git مثبت على جهازك
- [ ] ملفات المشروع كاملة
- [ ] اتصال بالإنترنت

---

## 🚀 الخطوات الكاملة

### المرحلة 1: التحضير

#### الخطوة 1: تثبيت Git

**على Windows:**
```bash
# اذهب إلى: https://git-scm.com/download/win
# وثبّت الإصدار الأحدث
```

**على macOS:**
```bash
brew install git
```

**على Linux:**
```bash
sudo apt-get install git
```

#### الخطوة 2: التحقق من التثبيت

```bash
git --version
# يجب أن تظهر نسخة Git
```

#### الخطوة 3: تكوين Git

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@gmail.com"

# التحقق:
git config --list
```

---

### المرحلة 2: إنشاء المستودع على GitHub

#### الخطوة 1: اذهب إلى GitHub

```
https://github.com/new
```

#### الخطوة 2: ملء البيانات

| الحقل | القيمة |
|------|--------|
| Repository name | `flutter_trading_app` |
| Description | `Professional Flutter Trading App with OANDA Integration` |
| Visibility | Private (خاص) |
| .gitignore | Flutter |
| License | MIT |

#### الخطوة 3: اضغط "Create repository"

---

### المرحلة 3: رفع الملفات

#### الطريقة 1: استخدام Terminal (الموصى بها)

##### الخطوة 1: افتح Terminal

```bash
# على Windows: استخدم Git Bash
# على macOS/Linux: استخدم Terminal العادي
```

##### الخطوة 2: انتقل إلى مجلد المشروع

```bash
cd /path/to/flutter_trading_app_source
```

##### الخطوة 3: هيّئ المستودع المحلي

```bash
# تهيئة git
git init

# إضافة جميع الملفات
git add .

# إنشاء أول commit
git commit -m "Initial commit: Flutter Trading App with CI/CD"

# تعيين الفرع الرئيسي
git branch -M main

# إضافة المستودع البعيد
git remote add origin https://github.com/YOUR_USERNAME/flutter_trading_app.git

# الدفع إلى GitHub
git push -u origin main
```

**ملاحظة:** استبدل `YOUR_USERNAME` باسم مستخدمك على GitHub

##### الخطوة 4: أدخل بيانات اعتماد GitHub

```
Username: your_github_username
Password: your_github_personal_access_token
```

**كيفية الحصول على Personal Access Token:**
1. اذهب إلى: https://github.com/settings/tokens
2. اضغط "Generate new token"
3. اختر "Generate new token (classic)"
4. اختر الصلاحيات: `repo`, `workflow`
5. اضغط "Generate token"
6. انسخ الـ token (يظهر مرة واحدة فقط!)
7. استخدمه كـ password

---

#### الطريقة 2: استخدام GitHub Desktop (للمبتدئين)

##### الخطوة 1: تحميل GitHub Desktop

```
https://desktop.github.com/
```

##### الخطوة 2: تثبيت وتسجيل الدخول

- ثبّت البرنامج
- سجّل الدخول بحسابك على GitHub

##### الخطوة 3: إضافة المستودع المحلي

1. اضغط "File" → "Add Local Repository"
2. اختر مجلد `flutter_trading_app_source`
3. اضغط "Add Repository"

##### الخطوة 4: نشر المستودع

1. اضغط "Publish Repository"
2. اختر "Keep this code private"
3. اضغط "Publish Repository"

---

### المرحلة 4: التحقق من رفع الملفات

#### من الويب:

```
https://github.com/YOUR_USERNAME/flutter_trading_app
```

يجب أن ترى:
- ✅ جميع الملفات والمجلدات
- ✅ `.github/workflows/` مع `build.yml` و `test.yml`
- ✅ `lib/` مع جميع ملفات Dart
- ✅ `pubspec.yaml`

#### من Terminal:

```bash
git log --oneline
# يجب أن تظهر commit الأولى
```

---

### المرحلة 5: مراقبة التجميع التلقائي

#### الخطوة 1: اذهب إلى Actions

```
https://github.com/YOUR_USERNAME/flutter_trading_app/actions
```

#### الخطوة 2: شاهد التجميع

يجب أن تظهر workflow جديدة:
- `build.yml` أو `Build Flutter Trading App`

#### الخطوة 3: انتظر الانتهاء

```
⏳ Analyze Code - جاري...
⏳ Unit Tests - في الانتظار...
⏳ Build Android APK - في الانتظار...
```

#### الخطوة 4: تحقق من النتائج

```
✅ Analyze Code - اكتمل (2 دقيقة)
✅ Unit Tests - اكتمل (3 دقائق)
✅ Build Android APK - اكتمل (5 دقائق)
✅ Build Android AAB - اكتمل (5 دقائق)
✅ Build iOS - اكتمل (8 دقائق)
✅ Build Web - اكتمل (3 دقائق)
✅ Create Release - اكتمل (1 دقيقة)
```

---

## 📥 تحميل التطبيق المجمع

### الخطوة 1: اذهب إلى Artifacts

```
https://github.com/YOUR_USERNAME/flutter_trading_app/actions
→ اختر أحدث run
→ انقر على "Artifacts"
```

### الخطوة 2: اختر الملف

| الملف | الحجم | الاستخدام |
|------|-------|----------|
| `flutter-trading-app-release.apk` | ~50 MB | تثبيت على Android |
| `flutter-trading-app-release.aab` | ~45 MB | Google Play Store |
| `flutter-trading-app-ios` | ~100 MB | iOS (يحتاج Xcode) |
| `flutter-trading-app-web` | ~30 MB | نشر على الويب |

### الخطوة 3: حمّل الملف

اضغط على الملف المراد تحميله

---

## 🔄 تحديث الملفات

### بعد إجراء تغييرات محلية:

```bash
# 1. أضف التغييرات
git add .

# 2. أنشئ commit
git commit -m "وصف التغييرات"

# 3. ادفع إلى GitHub
git push
```

### سيحدث تلقائياً:

```
✅ تحليل الكود الجديد
✅ تشغيل الاختبارات
✅ بناء التطبيق الجديد
✅ إنشاء release جديد (إذا كان في main)
```

---

## 🔐 إضافة بيانات OANDA بشكل آمن

### الخطوة 1: اذهب إلى Settings

```
https://github.com/YOUR_USERNAME/flutter_trading_app/settings/secrets/actions
```

### الخطوة 2: أضف Secrets

اضغط "New repository secret" وأضف:

| الاسم | القيمة |
|------|--------|
| `OANDA_API_TOKEN` | رمز API من OANDA |
| `OANDA_ACCOUNT_ID` | معرّف الحساب من OANDA |

### الخطوة 3: استخدمها في build.yml

```yaml
- name: Build APK
  env:
    OANDA_API_TOKEN: ${{ secrets.OANDA_API_TOKEN }}
    OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
  run: flutter build apk --release
```

---

## 🐛 استكشاف الأخطاء

### المشكلة: فشل التجميع

**الحل:**
1. اذهب إلى "Actions"
2. اضغط على الـ workflow الفاشل
3. اضغط على الـ job الفاشل
4. اقرأ الـ error message
5. أصلح الخطأ محلياً
6. ادفع التغييرات

### المشكلة: لم تظهر Workflows

**الحل:**
```bash
# تحقق من وجود الملفات:
ls -la .github/workflows/

# يجب أن تظهر:
# build.yml
# test.yml
```

### المشكلة: Timeout في التجميع

**الحل:**
```yaml
# في build.yml، زيادة timeout:
jobs:
  build-android:
    timeout-minutes: 60
```

---

## 📊 مراقبة الأداء

### عرض إحصائيات التجميع:

```bash
# استخدام GitHub CLI:
gh run list
gh run view <run-id>
gh run view <run-id> --log
```

### من الويب:

```
https://github.com/YOUR_USERNAME/flutter_trading_app/actions
```

---

## 🎯 الخطوات التالية

### 1. اختبر التطبيق

```bash
# تحميل APK
gh run download <run-id> -n flutter-trading-app-release.apk

# ثبّت على جهازك
adb install flutter-trading-app-release.apk
```

### 2. نشر على Google Play

```
1. اذهب إلى: https://play.google.com/console
2. أنشئ تطبيق جديد
3. ارفع AAB من Artifacts
```

### 3. نشر على App Store

```
1. اذهب إلى: https://appstoreconnect.apple.com
2. أنشئ تطبيق جديد
3. ارفع IPA
```

---

## ✅ قائمة التحقق النهائية

- [ ] تم إنشاء حساب GitHub
- [ ] تم إنشاء مستودع جديد
- [ ] تم رفع جميع الملفات
- [ ] ظهرت Workflows في Actions
- [ ] اكتملت جميع الـ jobs بنجاح
- [ ] تم تحميل APK بنجاح
- [ ] تم اختبار التطبيق على جهاز فعلي
- [ ] تم إضافة Secrets (اختياري)

---

## 📞 الدعم والمساعدة

| الموضوع | الرابط |
|--------|--------|
| GitHub Docs | https://docs.github.com |
| GitHub Actions | https://docs.github.com/en/actions |
| Flutter Docs | https://flutter.dev/docs |
| Git Tutorial | https://git-scm.com/doc |

---

## 🎓 نصائح مفيدة

### 1. استخدم .gitignore الصحيح

```bash
# تحقق من أن .gitignore يتضمن:
.env
*.apk
*.aab
build/
.dart_tool/
```

### 2. اكتب رسائل commits جيدة

```bash
# ❌ سيء:
git commit -m "fix"

# ✅ جيد:
git commit -m "Fix indicator calculation for EMA50"
```

### 3. استخدم branches للميزات الجديدة

```bash
# إنشاء branch جديد
git checkout -b feature/new-indicator

# العمل على الميزة
git add .
git commit -m "Add MACD indicator"

# دمج في main
git checkout main
git merge feature/new-indicator
git push
```

### 4. راجع الـ logs قبل الدفع

```bash
git log --oneline -5
```

---

**آخر تحديث**: 2024
**الحالة**: ✅ جاهز للنشر
