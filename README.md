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
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-3DDC84?logo=android)](https://developer.android.com)

</div>

---

## 🇦🇱 Shqip

### Rreth aplikacionit

**Al Mizan** (الميزان — "Peshorja") është një aplikacion i plotë për mësimin e fikhut islam në gjuhën shqipe. Aplikacioni funksionon 100% offline dhe përmban mësime të strukturuara, kuize interaktive, evidenca nga Kurani dhe Sunneti, si dhe krahasime mes katër medhhebeve.

### Përmbajtja

| Moduli | Mësime | Kuize | Evidenca |
|--------|--------|-------|----------|
| Hyrje në Fikh | 3 | 9 | 11 |
| Taharet — Pastërtia | 6 | 35 | 38 |
| Namazi — Falja | 5 | 31 | 14 |
| Agjërimi | 4 | 18 | 8 |
| Zekati | 4 | 12 | 11 |
| Haxhi dhe Umreja | 4 | 18 | 6 |
| Muamelati — Tregtia | 4 | 16 | 2 |
| Hallalli dhe Harami | 4 | 32 | 37 |
| Nikahu — Martesa | 3 | 12 | 6 |
| Xhenazja | 4 | 19 | 7 |
| Betimet dhe Nedhri | 4 | 19 | 5 |
| Ushqimi dhe Pija | 4 | 18 | 10 |
| **Gjithsej** | **48** | **239** | **155** |

### Veçoritë kryesore

- **12 module fikhore** me **48 mësime** të ndara sipas niveleve (fillestar, mesatar, avancuar)
- **239 pyetje kuizi** me shpjegime të detajuara
- **155 evidenca** nga Kurani dhe hadithet me tekst arab dhe përkthim shqip
- **Krahasim i katër medhhebeve** (Hanefi, Maliki, Shafi'i, Hanbeli) për çdo çështje
- **Llogaritës Zekati** me shumë lloje pasurie dhe nisab
- **Kuiz i përgjithshëm** me pyetje nga të gjitha modulet
- **Kërkim i plotë** nëpër mësime dhe përmbajtje
- **Shënime/Bookmark** për ruajtjen e mësimeve të preferuara
- **Personalizim** — vendos emrin ose pseudonimin gjatë onboarding-ut; ndryshohet në çdo kohë nga profili
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
| Introduction to Fiqh | 3 | 9 | 11 |
| Taharah — Purification | 6 | 35 | 38 |
| Salah — Prayer | 5 | 31 | 14 |
| Sawm — Fasting | 4 | 18 | 8 |
| Zakat — Alms | 4 | 12 | 11 |
| Hajj & Umrah | 4 | 18 | 6 |
| Mu'amalat — Trade | 4 | 16 | 2 |
| Halal & Haram | 4 | 32 | 37 |
| Nikah — Marriage | 3 | 12 | 6 |
| Janazah — Funeral | 4 | 19 | 7 |
| Oaths & Vows | 4 | 19 | 5 |
| Food & Drink | 4 | 18 | 10 |
| **Total** | **48** | **239** | **155** |

### Key Features

- **12 Fiqh modules** with **48 lessons** organized by level (beginner, intermediate, advanced)
- **239 quiz questions** with detailed explanations
- **155 evidences** from the Quran and Hadith with Arabic text and Albanian translation
- **Four-madhab comparison** (Hanafi, Maliki, Shafi'i, Hanbali) for every ruling
- **Zakat calculator** with multiple asset types and nisab thresholds
- **General quiz** with questions across all modules
- **Full-text search** across lessons and content
- **Bookmarks** to save favorite lessons
- **Personalization** — set your name or nickname during onboarding; change it anytime from the profile card
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
| مقدمة في الفقه | ٣ | ٩ | ١١ |
| الطهارة | ٦ | ٣٥ | ٣٨ |
| الصلاة | ٥ | ٣١ | ١٤ |
| الصيام | ٤ | ١٨ | ٨ |
| الزكاة | ٤ | ١٢ | ١١ |
| الحج والعمرة | ٤ | ١٨ | ٦ |
| المعاملات — التجارة | ٤ | ١٦ | ٢ |
| الحلال والحرام | ٤ | ٣٢ | ٣٧ |
| النكاح — الزواج | ٣ | ١٢ | ٦ |
| الجنازة | ٤ | ١٩ | ٧ |
| الأيمان والنذور | ٤ | ١٩ | ٥ |
| الأطعمة والأشربة | ٤ | ١٨ | ١٠ |
| **المجموع** | **٤٨** | **٢٣٩** | **١٥٥** |

### المميزات الرئيسية

- **١٢ وحدة فقهية** بـ **٤٨ درساً** مرتّبة حسب المستوى (مبتدئ، متوسط، متقدم)
- **٢٣٩ سؤال اختبار** مع شروحات مفصّلة
- **١٥٥ دليل شرعي** من القرآن والأحاديث بالعربية مع ترجمة ألبانية
- **مقارنة المذاهب الأربعة** (الحنفي، المالكي، الشافعي، الحنبلي) في كل مسألة
- **حاسبة الزكاة** بأنواع أموال متعددة وحساب النصاب
- **اختبار شامل** بأسئلة من جميع الوحدات
- **بحث كامل** في الدروس والمحتوى
- **حفظ الملاحظات** لتخزين الدروس المفضلة
- **التخصيص** — أدخل اسمك أو لقبك عند الإعداد الأوّلي؛ يمكن تغييره في أي وقت من بطاقة الملف الشخصي
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

## 🇮🇹 Italiano

### Informazioni

**Al Mizan** (الميزان — "La Bilancia") è un'applicazione Flutter completa per l'apprendimento della giurisprudenza islamica (Fiqh) in lingua albanese. L'app funziona al 100% offline e contiene lezioni strutturate, quiz interattivi, prove dal Corano e dalla Sunnah, e confronti tra i quattro madhab.

### Contenuto

| Modulo | Lezioni | Quiz | Prove |
|--------|---------|------|-------|
| Introduzione al Fiqh | 3 | 9 | 11 |
| Taharah — Purificazione | 6 | 35 | 38 |
| Salah — Preghiera | 5 | 31 | 14 |
| Sawm — Digiuno | 4 | 18 | 8 |
| Zakat — Elemosina | 4 | 12 | 11 |
| Hajj & Umrah | 4 | 18 | 6 |
| Mu'amalat — Commercio | 4 | 16 | 2 |
| Halal & Haram | 4 | 32 | 37 |
| Nikah — Matrimonio | 3 | 12 | 6 |
| Janazah — Funerale | 4 | 19 | 7 |
| Giuramenti e Voti | 4 | 19 | 5 |
| Cibo & Bevande | 4 | 18 | 10 |
| **Totale** | **48** | **239** | **155** |

### Caratteristiche principali

- **12 moduli Fiqh** con **48 lezioni** organizzate per livello (principiante, intermedio, avanzato)
- **239 domande quiz** con spiegazioni dettagliate
- **155 prove** dal Corano e Hadith con testo arabo e traduzione albanese
- **Confronto tra quattro madhab** (Hanafi, Maliki, Shafi'i, Hanbali) per ogni sentenza
- **Calcolatore Zakat** con più tipologie di patrimonio e soglie di nisab
- **Quiz generale** con domande da tutti i moduli
- **Ricerca testuale completa** nelle lezioni e nei contenuti
- **Segnalibri** per salvare le lezioni preferite
- **Personalizzazione** — imposta il nome o soprannome durante l'onboarding; modificabile in qualsiasi momento dal profilo
- **Due temi** — Chiaro (Pergamena) e Scuro (Ossidiana)
- **100% offline** — nessuna connessione richiesta

---

## 🇹🇷 Türkçe

### Hakkında

**Al Mizan** (الميزان — "Terazi"), Arnavutça'da İslam fıkhını öğrenmek için kapsamlı bir Flutter uygulamasıdır. Uygulama %100 çevrimdışı çalışır ve yapılandırılmış dersler, etkileşimli sınavlar, Kuran ve Sünnet'ten deliller ile dört mezhebin karşılaştırmalarını içerir.

### İçerik

| Modül | Dersler | Sınav Soruları | Deliller |
|-------|---------|----------------|---------|
| Fıkha Giriş | 3 | 9 | 11 |
| Taharet — Temizlik | 6 | 35 | 38 |
| Namaz — İbadet | 5 | 31 | 14 |
| Oruç | 4 | 18 | 8 |
| Zekat | 4 | 12 | 11 |
| Hac & Umre | 4 | 18 | 6 |
| Muamelat — Ticaret | 4 | 16 | 2 |
| Helal & Haram | 4 | 32 | 37 |
| Nikah — Evlilik | 3 | 12 | 6 |
| Cenaze | 4 | 19 | 7 |
| Yeminler ve Adaklar | 4 | 19 | 5 |
| Yiyecek & İçecek | 4 | 18 | 10 |
| **Toplam** | **48** | **239** | **155** |

### Temel özellikler

- **12 fıkıh modülü** ile **48 ders** (başlangıç, orta, ileri seviye)
- **239 sınav sorusu** ayrıntılı açıklamalarla
- **155 delil** Kuran ve hadislerden, Arapça metin ve Arnavutça çeviriyle
- **Dört mezhep karşılaştırması** (Hanefi, Maliki, Şafii, Hanbeli) her hüküm için
- **Zekat hesaplayıcı** çoklu varlık türleri ve nisap eşikleri ile
- **Genel sınav** tüm modüllerden sorularla
- **Tam metin arama** dersler ve içerikler arasında
- **Yer imleri** favori dersleri kaydetmek için
- **Kişiselleştirme** — kayıt sırasında isim veya takma ad belirle; profil kartından istediğin zaman değiştir
- **İki tema** — Açık (Parşömen) ve Koyu (Obsidyen)
- **%100 çevrimdışı** — internet bağlantısı gerekmez

---

## 🇧🇦 Bosanski

### O aplikaciji

**Al Mizan** (الميزان — "Vaga") je sveobuhvatna Flutter aplikacija za učenje islamske jurisprudencije (fikha) na albanskom jeziku. Aplikacija radi 100% offline i sadrži strukturirane lekcije, interaktivne kvizove, dokaze iz Kur'ana i Sunneta te usporedbe četiri mezheba.

### Sadržaj

| Modul | Lekcije | Pitanja | Dokazi |
|-------|---------|---------|--------|
| Uvod u Fikh | 3 | 9 | 11 |
| Taharet — Čistoća | 6 | 35 | 38 |
| Salat — Namaz | 5 | 31 | 14 |
| Post — Ramazan | 4 | 18 | 8 |
| Zekat | 4 | 12 | 11 |
| Hadž & Umra | 4 | 18 | 6 |
| Muamelat — Trgovina | 4 | 16 | 2 |
| Halal & Haram | 4 | 32 | 37 |
| Nikah — Brak | 3 | 12 | 6 |
| Dženaza | 4 | 19 | 7 |
| Zakletve i Zavjeti | 4 | 19 | 5 |
| Hrana & Piće | 4 | 18 | 10 |
| **Ukupno** | **48** | **239** | **155** |

### Ključne funkcionalnosti

- **12 fikhskih modula** sa **48 lekcija** po nivoima (početnik, srednji, napredni)
- **239 kviz pitanja** s detaljnim objašnjenjima
- **155 dokaza** iz Kur'ana i hadisa s arapskim tekstom i albanskim prijevodom
- **Usporedba četiri mezheba** (Hanefi, Maliki, Šafii, Hanbeli) za svako pitanje
- **Kalkulator zekata** s više vrsta imovine i nisab pragovima
- **Opći kviz** s pitanjima iz svih modula
- **Pretraga cijelog teksta** kroz lekcije i sadržaj
- **Oznake** za čuvanje omiljenih lekcija
- **Personalizacija** — unesi ime ili nadimak tokom onboardinga; promjeni u bilo kom trenutku iz profila
- **Dvije teme** — Svjetla (Pergament) i Tamna (Opsidijan)
- **100% offline** — nije potrebna internet veza

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
