<div align="center">

# ⚖️ Al Mizan — الميزان

### Mëso Fikhun · تعلّم الفقه

A comprehensive Flutter educational app for Islamic jurisprudence (Fiqh) in Albanian

Aplikacion edukativ Flutter për jurisprudencën islame (Fikh) në gjuhën shqipe

تطبيق تعليمي بإطار Flutter للفقه الإسلامي باللغة الألبانية

---

[![Flutter](https://img.shields.io/badge/Flutter-3.35-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://developer.android.com)

</div>

---

## 🇦🇱 Shqip

### Rreth aplikacionit

**Al Mizan** (الميزان — "Peshorja") është një aplikacion i plotë për mësimin e fikhut islam në gjuhën shqipe. Aplikacioni funksionon 100% offline dhe përmban mësime të strukturuara, kuize interaktive, evidenca nga Kurani dhe Sunneti, si dhe krahasime mes katër medhhebeve.

### Përmbajtja

| Moduli | Mësime | Kuize | Evidenca |
|--------|--------|-------|----------|
| Hyrje në Fikh | 3 | 7 | 8 |
| Taharet — Pastërtia | 6 | 33 | 18 |
| Namazi — Falja | 5 | 30 | 12 |
| Agjërimi | 3 | 11 | 6 |
| Zekati | 3 | 10 | 6 |
| Haxhi dhe Umreja | 4 | 17 | 10 |
| Muamelati — Tregtia | 3 | 11 | 7 |
| Hallalli dhe Harami | 3 | 19 | 12 |
| Nikahu — Martesa | 3 | 13 | 14 |
| Xhenazja | 3 | 11 | 8 |
| Betimet dhe Nedhri | 2 | 7 | 8 |
| Ushqimi dhe Pija | 3 | 10 | 11 |
| **Gjithsej** | **41** | **179** | **120** |

### Veçoritë kryesore

- **12 module fikhore** me mësime të ndara sipas niveleve (fillestar, mesatar, avancuar)
- **179 pyetje kuizi** me shpjegime të detajuara
- **120 evidenca** nga Kurani dhe hadithet me tekst arab dhe përkthim shqip
- **Krahasim i katër medhhebeve** (Hanefi, Maliki, Shafi'i, Hanbeli) për çdo çështje
- **Llogaritës Zekati** me shumë lloje pasurie dhe nisab
- **Kuiz i përgjithshëm** me pyetje nga të gjitha modulet
- **Kërkim i plotë** nëpër mësime dhe përmbajtje
- **Shënime/Bookmark** për ruajtjen e mësimeve të preferuara
- **Dy tema** — e ndriçme (Parchment) dhe e errët (Obsidian)
- **100% offline** — nuk kërkon internet

### Burimet shkencore

Përmbajtja është nxjerrë dhe përshtatur nga vepra të njohura fikhore:

- Dr. Vehbe ez-Zuhejli — *Ligjet e Sheriatit Islam*
- Dr. Jusuf el-Kardavi — *Hallalli dhe Harami në Islam*
- Muhamed Nasirud-din el-Albani — *Dispozitat e Haxhit dhe Umres*
- Abedin Musallari — *Haxhi dhe Rregullat e Tij*
- Sejjid Sabik — *Fikhus-Sunneh*

### Teknologjia

- **Flutter** — framework cross-platform
- **Riverpod** — menaxhimi i gjendjes
- **GoRouter** — navigimi
- **Drift** — databaza lokale SQLite
- **Material 3** — dizajn modern me Google Fonts
- **Design System**: Al-Mizan (Google Stitch) — Source Serif 4, Plus Jakarta Sans, Amiri

### Ndërtimi

```bash
# Klono repo-n
git clone https://github.com/gaming-clan/al-mizan.git
cd al-mizan

# Instalo dependencies
flutter pub get

# Gjenero kodin e Drift
dart run build_runner build

# Ndërto APK
flutter build apk --debug
```

> **Shënim për Windows**: Vendos `JAVA_TOOL_OPTIONS=-Djava.net.preferIPv4Stack=true` para build-it.

### Struktura e projektit

```
lib/
├── core/           # Tema, ngjyra, routing, database, konstante
├── data/           # 12 skedarë JSON me përmbajtje fikhore
├── features/       # Home, Modules, Quiz, Search, Bookmarks, Profile, Zakat, Ask Scholar
└── shared/         # Widget-e të përbashkëta (QuranVerseCard, HadithCard, MadhabComparison)
```

---

## 🇬🇧 English

### About

**Al Mizan** (الميزان — "The Scale") is a comprehensive Flutter application for learning Islamic jurisprudence (Fiqh) in Albanian. The app works 100% offline and contains structured lessons, interactive quizzes, evidences from the Quran and Sunnah, and comparisons across the four madhabs.

### Content

| Module | Lessons | Quizzes | Evidences |
|--------|---------|---------|-----------|
| Introduction to Fiqh | 3 | 7 | 8 |
| Taharah — Purification | 6 | 33 | 18 |
| Salah — Prayer | 5 | 30 | 12 |
| Sawm — Fasting | 3 | 11 | 6 |
| Zakat — Alms | 3 | 10 | 6 |
| Hajj & Umrah | 4 | 17 | 10 |
| Mu'amalat — Trade | 3 | 11 | 7 |
| Halal & Haram | 3 | 19 | 12 |
| Nikah — Marriage | 3 | 13 | 14 |
| Janazah — Funeral | 3 | 11 | 8 |
| Oaths & Vows | 2 | 7 | 8 |
| Food & Drink | 3 | 10 | 11 |
| **Total** | **41** | **179** | **120** |

### Key Features

- **12 Fiqh modules** with lessons organized by level (beginner, intermediate, advanced)
- **179 quiz questions** with detailed explanations
- **120 evidences** from the Quran and Hadith with Arabic text and Albanian translation
- **Four-madhab comparison** (Hanafi, Maliki, Shafi'i, Hanbali) for every ruling
- **Zakat calculator** with multiple asset types and nisab thresholds
- **General quiz** with questions across all modules
- **Full-text search** across lessons and content
- **Bookmarks** to save favorite lessons
- **Two themes** — Light (Parchment) and Dark (Obsidian)
- **100% offline** — no internet required

### Academic Sources

Content is derived and adapted from well-known Fiqh works:

- Dr. Wahbah az-Zuhayli — *Islamic Legislation*
- Dr. Yusuf al-Qaradawi — *The Lawful and the Prohibited in Islam*
- Muhammad Nasiruddin al-Albani — *Rulings of Hajj and Umrah*
- Sayyid Sabiq — *Fiqh us-Sunnah*

### Tech Stack

- **Flutter** — cross-platform framework
- **Riverpod** — state management
- **GoRouter** — navigation
- **Drift** — local SQLite database
- **Material 3** — modern design with Google Fonts
- **Design System**: Al-Mizan (Google Stitch) — Source Serif 4, Plus Jakarta Sans, Amiri

### Build

```bash
# Clone the repo
git clone https://github.com/gaming-clan/al-mizan.git
cd al-mizan

# Install dependencies
flutter pub get

# Generate Drift code
dart run build_runner build

# Build APK
flutter build apk --debug
```

> **Windows note**: Set `JAVA_TOOL_OPTIONS=-Djava.net.preferIPv4Stack=true` before building.

### Project Structure

```
lib/
├── core/           # Themes, colors, routing, database, constants
├── data/           # 12 JSON files with Fiqh content
├── features/       # Home, Modules, Quiz, Search, Bookmarks, Profile, Zakat, Ask Scholar
└── shared/         # Reusable widgets (QuranVerseCard, HadithCard, MadhabComparison)
```

---

## 🇸🇦 العربية

### عن التطبيق

**الميزان** هو تطبيق تعليمي شامل لتعلّم الفقه الإسلامي باللغة الألبانية. يعمل التطبيق بالكامل بدون إنترنت ويحتوي على دروس منظّمة واختبارات تفاعلية وأدلة من القرآن والسنة ومقارنات بين المذاهب الأربعة.

### المحتوى

| الوحدة | الدروس | الاختبارات | الأدلة |
|--------|--------|-----------|--------|
| مقدمة في الفقه | ٣ | ٧ | ٨ |
| الطهارة | ٦ | ٣٣ | ١٨ |
| الصلاة | ٥ | ٣٠ | ١٢ |
| الصيام | ٣ | ١١ | ٦ |
| الزكاة | ٣ | ١٠ | ٦ |
| الحج والعمرة | ٤ | ١٧ | ١٠ |
| المعاملات — التجارة | ٣ | ١١ | ٧ |
| الحلال والحرام | ٣ | ١٩ | ١٢ |
| النكاح — الزواج | ٣ | ١٣ | ١٤ |
| الجنازة | ٣ | ١١ | ٨ |
| الأيمان والنذور | ٢ | ٧ | ٨ |
| الأطعمة والأشربة | ٣ | ١٠ | ١١ |
| **المجموع** | **٤١** | **١٧٩** | **١٢٠** |

### المميزات الرئيسية

- **١٢ وحدة فقهية** بدروس مرتّبة حسب المستوى (مبتدئ، متوسط، متقدم)
- **١٧٩ سؤال اختبار** مع شروحات مفصّلة
- **١٢٠ دليل شرعي** من القرآن والأحاديث بالعربية مع ترجمة ألبانية
- **مقارنة المذاهب الأربعة** (الحنفي، المالكي، الشافعي، الحنبلي) في كل مسألة
- **حاسبة الزكاة** بأنواع أموال متعددة وحساب النصاب
- **اختبار شامل** بأسئلة من جميع الوحدات
- **بحث كامل** في الدروس والمحتوى
- **حفظ الملاحظات** لتخزين الدروس المفضلة
- **سمتان** — فاتحة (رق) وداكنة (سبج)
- **يعمل بدون إنترنت بالكامل**

### المصادر العلمية

استُخرج المحتوى وأُعدّ من مؤلفات فقهية معروفة:

- د. وهبة الزحيلي — *التشريع الإسلامي*
- د. يوسف القرضاوي — *الحلال والحرام في الإسلام*
- محمد ناصر الدين الألباني — *أحكام الحج والعمرة*
- سيد سابق — *فقه السنة*

### التقنيات المستخدمة

- **Flutter** — إطار تطوير متعدد المنصات
- **Riverpod** — إدارة الحالة
- **GoRouter** — التنقل
- **Drift** — قاعدة بيانات SQLite المحلية
- **Material 3** — تصميم حديث مع خطوط Google
- **نظام التصميم**: الميزان (Google Stitch) — Source Serif 4, Plus Jakarta Sans, أميري

### البناء

```bash
# استنساخ المستودع
git clone https://github.com/gaming-clan/al-mizan.git
cd al-mizan

# تثبيت الحزم
flutter pub get

# إنشاء كود Drift
dart run build_runner build

# بناء APK
flutter build apk --debug
```

> **ملاحظة لنظام Windows**: عيّن `JAVA_TOOL_OPTIONS=-Djava.net.preferIPv4Stack=true` قبل البناء.

### هيكل المشروع

```
lib/
├── core/           # السمات، الألوان، التوجيه، قاعدة البيانات، الثوابت
├── data/           # ١٢ ملف JSON بمحتوى فقهي
├── features/       # الرئيسية، الوحدات، الاختبار، البحث، المحفوظات، الملف الشخصي، الزكاة
└── shared/         # عناصر مشتركة (بطاقة آية، بطاقة حديث، مقارنة مذاهب)
```

---

<div align="center">

### 📖 بسم الله الرحمن الرحيم

*"فَلَوْلَا نَفَرَ مِن كُلِّ فِرْقَةٍ مِّنْهُمْ طَائِفَةٌ لِّيَتَفَقَّهُوا فِي الدِّينِ"*

**التوبة: ١٢٢**

*"Përse të mos shkojë nga çdo grup prej tyre një palë që të thellohen në fe"*

**Et-Teube: 122**

---

Zhvilluar me ❤️ për komunitetin shqiptar musliman

تم تطويره بـ ❤️ للمجتمع الألباني المسلم

</div>
