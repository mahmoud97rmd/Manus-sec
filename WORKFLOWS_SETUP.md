# 🔄 إعداد GitHub Actions Workflows يدويًا

بسبب قيود الصلاحيات، ستحتاج إلى إنشاء الـ workflows يدويًا من واجهة GitHub.

---

## 📋 الخطوة 1: إنشاء build.yml

### اذهب إلى:
```
https://github.com/mahmoud97rmd/Manus-sec/actions
```

### اضغط: "New workflow"

### اختر: "set up a workflow yourself"

### اسم الملف: `build.yml`

### أضف هذا الكود:

```yaml
name: Build Flutter Trading App

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze:
    name: Analyze Code
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - name: Get dependencies
        run: flutter pub get
      - name: Analyze code
        run: flutter analyze

  test:
    name: Unit Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - name: Get dependencies
        run: flutter pub get
      - name: Run tests
        run: flutter test

  build-android:
    name: Build Android APK
    runs-on: ubuntu-latest
    needs: [analyze, test]
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      - name: Get dependencies
        run: flutter pub get
      - name: Build APK
        run: flutter build apk --release
        env:
          OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
          OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}
          OANDA_ENVIRONMENT: ${{ secrets.OANDA_ENVIRONMENT }}
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: flutter-trading-app-release.apk
          path: build/app/outputs/flutter-app-release.apk
```

### اضغط: "Commit changes"

---

## 📋 الخطوة 2: إنشاء test.yml

### اذهب إلى:
```
https://github.com/mahmoud97rmd/Manus-sec/actions
```

### اضغط: "New workflow"

### اختر: "set up a workflow yourself"

### اسم الملف: `test.yml`

### أضف هذا الكود:

```yaml
name: Test & Quality Checks

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  lint:
    name: Lint & Code Analysis
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - name: Get dependencies
        run: flutter pub get
      - name: Run analyzer
        run: flutter analyze
      - name: Check formatting
        run: dart format --set-exit-if-changed .

  test:
    name: Unit Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - name: Get dependencies
        run: flutter pub get
      - name: Run tests
        run: flutter test
        env:
          OANDA_ACCOUNT_ID: ${{ secrets.OANDA_ACCOUNT_ID }}
          OANDA_API_KEY: ${{ secrets.OANDA_API_KEY }}
          OANDA_ENVIRONMENT: ${{ secrets.OANDA_ENVIRONMENT }}
```

### اضغط: "Commit changes"

---

## 🔐 الخطوة 3: إضافة Secrets

### اذهب إلى:
```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

### اضغط: "New repository secret"

### أضف الـ Secrets التالية:

**Secret 1:**
- Name: `OANDA_ACCOUNT_ID`
- Value: `101-004-28533521-003`

**Secret 2:**
- Name: `OANDA_API_KEY`
- Value: `c89763686df34cbd8fad47aac42827fc-14dbf0e5fab1c88e022f2d3923c8960c`

**Secret 3:**
- Name: `OANDA_ENVIRONMENT`
- Value: `practice`

---

## ✅ التحقق

### 1. تحقق من الـ Workflows:
```
https://github.com/mahmoud97rmd/Manus-sec/actions
```

يجب أن تظهر:
- ✓ Build Flutter Trading App
- ✓ Test & Quality Checks

### 2. تحقق من الـ Secrets:
```
https://github.com/mahmoud97rmd/Manus-sec/settings/secrets/actions
```

يجب أن تظهر:
- ✓ OANDA_ACCOUNT_ID
- ✓ OANDA_API_KEY
- ✓ OANDA_ENVIRONMENT

---

## 🚀 تشغيل البناء التلقائي

بعد إضافة الـ Secrets والـ Workflows، ادفع تغيير صغير:

```bash
cd /home/ubuntu/Manus-sec
echo "# Build configured" >> README.md
git add README.md
git commit -m "trigger: Start automated builds"
git push
```

سيؤدي هذا إلى تشغيل الـ Workflows تلقائياً!

---

## 📊 ملخص الخطوات

| الخطوة | الإجراء |
|------|--------|
| 1 | إنشاء build.yml من GitHub |
| 2 | إنشاء test.yml من GitHub |
| 3 | إضافة 3 Secrets |
| 4 | دفع تغيير لتشغيل Workflows |

---

**ملاحظة**: هذه الخطوات يدوية لأن GitHub App لا يملك صلاحيات كافية لإضافة workflows برمجياً.
