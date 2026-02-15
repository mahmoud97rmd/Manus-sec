# دليل إعداد GitHub و التجميع التلقائي

## 📋 المحتويات
1. [إنشاء مستودع GitHub](#إنشاء-مستودع-github)
2. [إعداد GitHub Actions](#إعداد-github-actions)
3. [رفع الملفات](#رفع-الملفات)
4. [مراقبة التجميع](#مراقبة-التجميع)
5. [استخدام الـ Artifacts](#استخدام-الـ-artifacts)
6. [إعدادات متقدمة](#إعدادات-متقدمة)

---

## 1. إنشاء مستودع GitHub

### الخطوة 1: إنشاء حساب GitHub (إذا لم تكن تملك واحداً)
- اذهب إلى: https://github.com/signup
- أنشئ حساب جديد بـ بريد إلكتروني فريد
- تحقق من البريد الإلكتروني

### الخطوة 2: إنشاء مستودع جديد
```bash
# اذهب إلى: https://github.com/new
# أو استخدم GitHub CLI:
gh repo create flutter_trading_app --private --source=. --remote=origin --push
```

### الخطوة 3: تكوين المستودع
```bash
# انسخ رابط المستودع (HTTPS أو SSH)
# مثال: https://github.com/your-username/flutter_trading_app.git
```

---

## 2. إعداد GitHub Actions

### الملفات الموجودة:
- `.github/workflows/build.yml` - بناء التطبيق
- `.github/workflows/test.yml` - اختبار الكود

### ما يفعله build.yml:
```
┌─────────────────────────────────────────┐
│  عند الدفع إلى main أو develop         │
└──────────────┬──────────────────────────┘
               │
        ┌──────┴──────┬──────────┬──────────┐
        ▼             ▼          ▼          ▼
    ┌────────┐  ┌─────────┐ ┌────────┐ ┌─────┐
    │Analyze │  │  Test   │ │Android │ │iOS  │
    │  Code  │  │  Units  │ │  APK   │ │ App │
    └────────┘  └─────────┘ └────────┘ └─────┘
        │             │          │          │
        └─────────────┴──────────┴──────────┘
                      │
                      ▼
            ┌──────────────────┐
            │ Create Release   │
            │ (في main فقط)    │
            └──────────────────┘
```

### ما يفعله test.yml:
```
┌──────────────────────────────────────┐
│  عند كل push أو pull request        │
└──────────┬───────────────────────────┘
           │
    ┌──────┴──────┬──────────┬────────────┐
    ▼             ▼          ▼            ▼
┌────────┐  ┌────────┐  ┌──────────┐  ┌─────────┐
│ Tests  │  │ Lint   │  │Security  │  │Performance
│        │  │ Check  │  │  Scan    │  │  Check
└────────┘  └────────┘  └──────────┘  └─────────┘
```

---

## 3. رفع الملفات

### الطريقة 1: استخدام Git CLI (الموصى بها)

#### الخطوة 1: تثبيت Git
```bash
# على Windows
# اذهب إلى: https://git-scm.com/download/win

# على macOS
brew install git

# على Linux
sudo apt-get install git
```

#### الخطوة 2: تكوين Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### الخطوة 3: تهيئة المستودع المحلي
```bash
cd /path/to/flutter_trading_app_source

# إذا لم تكن قد هيأت المستودع بعد:
git init
git add .
git commit -m "Initial commit: Flutter Trading App"

# إضافة المستودع البعيد
git remote add origin https://github.com/your-username/flutter_trading_app.git

# الدفع إلى GitHub
git branch -M main
git push -u origin main
```

#### الخطوة 4: الدفع المستقبلية
```bash
# بعد إجراء تغييرات:
git add .
git commit -m "وصف التغييرات"
git push
```

### الطريقة 2: استخدام GitHub CLI

```bash
# تثبيت GitHub CLI
# https://cli.github.com/

# تسجيل الدخول
gh auth login

# إنشاء ومشاركة المستودع
gh repo create flutter_trading_app \
  --private \
  --source=. \
  --remote=origin \
  --push
```

### الطريقة 3: استخدام GitHub Desktop (للمبتدئين)

1. تحميل: https://desktop.github.com/
2. تسجيل الدخول بحسابك
3. اختر "Add Local Repository"
4. اختر مجلد المشروع
5. اضغط "Publish Repository"

---

## 4. مراقبة التجميع

### عرض حالة التجميع:

```bash
# استخدام GitHub CLI
gh run list
gh run view <run-id>
gh run view <run-id> --log
```

### عبر الويب:
1. اذهب إلى: `https://github.com/your-username/flutter_trading_app`
2. انقر على علامة التبويب "Actions"
3. اختر أحدث workflow run
4. شاهد التفاصيل والـ logs

### ما تتوقعه:

#### عند الدفع إلى develop:
```
✅ Analyze Code - 2 دقيقة
✅ Unit Tests - 3 دقائق
✅ Build Android APK - 5 دقائق
✅ Build Android AAB - 5 دقائق
✅ Build iOS - 8 دقائق
✅ Build Web - 3 دقائق
```

#### عند الدفع إلى main:
```
(جميع الخطوات أعلاه)
✅ Create Release - 1 دقيقة
```

---

## 5. استخدام الـ Artifacts

### تحميل الملفات المجمعة:

#### من الويب:
1. اذهب إلى "Actions" → أحدث run
2. انقر على "Artifacts" في الأسفل
3. اختر الملف المراد تحميله

#### من CLI:
```bash
# تحميل جميع artifacts
gh run download <run-id>

# تحميل artifact معين
gh run download <run-id> -n flutter-trading-app-release.apk
```

### الملفات المتاحة:

| الملف | الحجم | الاستخدام |
|------|-------|----------|
| `flutter-trading-app-release.apk` | ~50 MB | تثبيت مباشر على Android |
| `flutter-trading-app-release.aab` | ~45 MB | رفع إلى Google Play Store |
| `flutter-trading-app-ios` | ~100 MB | بناء iOS (يحتاج Xcode) |
| `flutter-trading-app-web` | ~30 MB | نشر على الويب |

---

## 6. إعدادات متقدمة

### إضافة Secrets (للبيانات الحساسة)

#### الخطوة 1: إضافة Secrets في GitHub
```bash
# عبر الويب:
# Settings → Secrets and variables → Actions → New repository secret

# أو عبر CLI:
gh secret set OANDA_API_TOKEN --body "your_token_here"
gh secret set OANDA_ACCOUNT_ID --body "your_account_id_here"
```

#### الخطوة 2: استخدام Secrets في Workflow
```yaml
- name: Build with Secrets
  env:
    OANDA_API_TOKEN: ${{ secrets.OANDA_API_TOKEN }}
    OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
  run: flutter build apk --release
```

### إضافة Slack Notifications

#### الخطوة 1: إنشاء Webhook في Slack
1. اذهب إلى: https://api.slack.com/apps
2. اختر "Create New App"
3. اختر "From scratch"
4. أدخل اسم التطبيق والـ workspace
5. اذهب إلى "Incoming Webhooks"
6. اضغط "Add New Webhook to Workspace"
7. انسخ الـ Webhook URL

#### الخطوة 2: إضافة Webhook كـ Secret
```bash
gh secret set SLACK_WEBHOOK_URL --body "https://hooks.slack.com/..."
```

### تحديد الفترة الزمنية للتجميع

```yaml
# في build.yml:
schedule:
  - cron: '0 0 * * *'  # يومياً في منتصف الليل
```

### تجاهل التجميع لـ commits معينة

```bash
# في رسالة الـ commit:
git commit -m "Update README [skip ci]"
```

---

## 7. استكشاف الأخطاء

### المشكلة: فشل التجميع

**الحل:**
1. اذهب إلى "Actions" → أحدث run
2. انقر على الـ job الفاشل
3. اقرأ الـ error message
4. تحقق من الـ logs

### المشكلة: Timeout

**الحل:**
```yaml
# زيادة timeout في build.yml:
jobs:
  build-android:
    timeout-minutes: 60  # بدلاً من 360
```

### المشكلة: Out of Disk Space

**الحل:**
```yaml
# تنظيف المساحة:
- name: Clean up
  run: |
    rm -rf build/
    flutter clean
```

---

## 8. نصائح للأداء الأفضل

### تسريع التجميع:

```yaml
# استخدام cache:
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: ~/.pub-cache
    key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
    restore-keys: |
      ${{ runner.os }}-pub-

# استخدام parallel jobs:
jobs:
  build-android:
    runs-on: ubuntu-latest
  build-ios:
    runs-on: macos-latest
```

### تقليل حجم الـ artifacts:

```bash
# في build.yml:
- name: Build APK (Split per ABI)
  run: flutter build apk --release --split-per-abi
```

---

## 9. قائمة التحقق النهائية

- [ ] تم إنشاء مستودع GitHub
- [ ] تم دفع جميع الملفات
- [ ] تم تشغيل build.yml بنجاح
- [ ] تم تشغيل test.yml بنجاح
- [ ] تم تحميل الـ APK بنجاح
- [ ] تم اختبار التطبيق على جهاز فعلي
- [ ] تم إضافة Secrets (اختياري)
- [ ] تم تكوين Slack notifications (اختياري)

---

## 10. الخطوات التالية

### نشر على Google Play Store:
```bash
# 1. إنشاء حساب Google Play Developer
# 2. إنشاء تطبيق جديد
# 3. إضافة signing key
# 4. رفع AAB
```

### نشر على App Store:
```bash
# 1. إنشاء حساب Apple Developer
# 2. إنشاء certificate و provisioning profile
# 3. رفع IPA
```

### نشر على الويب:
```bash
# 1. استخدام GitHub Pages
# 2. أو Netlify
# 3. أو Vercel
```

---

## 📞 الدعم والمساعدة

- **GitHub Docs**: https://docs.github.com/en/actions
- **Flutter Docs**: https://flutter.dev/docs
- **GitHub CLI**: https://cli.github.com/

---

**آخر تحديث**: 2024
**الحالة**: ✅ جاهز للاستخدام
