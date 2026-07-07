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
| Hyrje në Fikh | 5 | 12 | 12 |
| Taharet — Pastërtia | 6 | 33 | 18 |
| Namazi — Falja | 6 | 35 | 20 |
| Agjërimi | 5 | 18 | 14 |
| Zekati | 4 | 14 | 9 |
| Haxhi dhe Umreja | 4 | 17 | 10 |
| Muamelati — Tregtia | 5 | 19 | 17 |
| Hallalli dhe Harami | 4 | 23 | 15 |
| Nikahu — Martesa | 4 | 22 | 26 |
| Xhenazja | 4 | 15 | 12 |
| Betimet dhe Nedhri | 4 | 15 | 14 |
| Ushqimi dhe Pija | 4 | 14 | 15 |
| E Drejta Penale Islame | 5 | 24 | 32 |
| **Gjithsej** | **60** | **261** | **214** |

### Veçoritë kryesore

- **13 module fikhore** me **60 mësime** të ndara sipas niveleve (fillestar, mesatar, avancuar)
- **261 pyetje kuizi** me shpjegime të detajuara
- **213 evidenca** nga Kurani dhe hadithet me tekst arab dhe përkthim shqip
- **Krahasim i katër medhhebeve** (Hanefi, Maliki, Shafi'i, Hanbeli) për çdo çështje
- **Sfida me Kohë** — kuize me kohëmatës: sa më i lartë niveli, aq më pak kohë për pyetje
- **Sfida Ditore** — 10 pyetje të përziera çdo ditë, me seri ditore (streak)
- **Njoftim ditor** me thënie dijetarësh — ora e konfigurueshme nga përdoruesi (parazgjedhja 08:00)
- **Shfletim i dyfishtë** — sipas moduleve ose sipas niveleve (mësimet e një niveli nga të gjitha modulet)
- **Provo Përsëri** në çdo kuiz — përfshirë rifillimin e një niveli të vetëm te kuizi i modulit
- **Vazhdo ku mbete** — kartë në ballinë që të kthen te mësimi i fundit i hapur
- **Kalim automatik** — buton për mësimin pasardhës dhe për nivelin tjetër pas përfundimit
- **Llogaritës Zekati** me shumë lloje pasurie dhe nisab
- **Kuiz i përgjithshëm** dhe **kuiz moduli me 3 nivele**
- **Kërkim i plotë** nëpër mësime dhe përmbajtje
- **Shënime/Bookmark** për ruajtjen e mësimeve të preferuara
- **Personalizim** — vendos emrin ose pseudonimin gjatë onboarding-ut; ndryshohet në çdo kohë nga profili
- **7 tema** (Parchment, Night, Desert Sands, Azure Mosaic, Andalusian Garden, Midnight Indigo, Ebony Gold) + **temë automatike** sipas orës së ditës
- **Përshtatje për tableta dhe foldable** — layout responsiv në ekranet e mëdha
- **100% offline** — nuk kërkon internet

### Burimet shkencore

Përmbajtja është nxjerrë dhe përshtatur nga vepra të njohura fikhore:

- Dr. Vehbe ez-Zuhejli — *Ligjet e Sheriatit Islam* / *El-Fikhu el-Islami ve Edil'letuhu*
- Dr. Abdul-Azim el-Bedevi — *El-Vexhiz* (The Concise Presentation of the Fiqh of the Sunnah and the Noble Book)
- Dr. Jusuf el-Kardavi — *Hallalli dhe Harami në Islam*
- Muhamed Nasirud-din el-Albani — *Dispozitat e Haxhit dhe Umres*
- Abedin Musallari — *Haxhi dhe Rregullat e Tij*
- Sejjid Sabik — *Fikhus-Sunneh*
- Ibn Kudame — *El-Mugni*

### Teknologjia

- **Flutter** — framework cross-platform
- **Riverpod** — menaxhimi i gjendjes
- **GoRouter** — navigimi
- **Drift** — databaza lokale SQLite
- **flutter_local_notifications** — njoftimet ditore lokale
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
├── data/           # 13 skedarë JSON me përmbajtje fikhore
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
| Introduction to Fiqh | 5 | 12 | 12 |
| Taharah — Purification | 6 | 33 | 18 |
| Salah — Prayer | 6 | 35 | 20 |
| Sawm — Fasting | 5 | 18 | 14 |
| Zakat — Alms | 4 | 14 | 9 |
| Hajj & Umrah | 4 | 17 | 10 |
| Mu'amalat — Trade | 5 | 19 | 17 |
| Halal & Haram | 4 | 23 | 15 |
| Nikah — Marriage | 4 | 22 | 26 |
| Janazah — Funeral | 4 | 15 | 12 |
| Oaths & Vows | 4 | 15 | 14 |
| Food & Drink | 4 | 14 | 15 |
| Islamic Criminal Law | 5 | 24 | 32 |
| **Total** | **60** | **261** | **214** |

### Key Features

- **13 Fiqh modules** with **60 lessons** organized by level (beginner, intermediate, advanced)
- **261 quiz questions** with detailed explanations
- **213 evidences** from the Quran and Hadith with Arabic text and Albanian translation
- **Four-madhab comparison** (Hanafi, Maliki, Shafi'i, Hanbali) for every ruling
- **Timed Challenge** — quizzes against the clock: the higher the level, the less time per question
- **Daily Challenge** — 10 mixed-level questions every day, with a daily streak
- **Daily notification** with scholars' sayings — user-configurable time (default 08:00)
- **Dual browsing** — by module or by level (lessons of one level across all modules)
- **Try Again** on every quiz — including retrying a single level in the module quiz
- **Continue where you left off** — home card that takes you back to the last opened lesson
- **Auto progression** — next-lesson button and next-level navigation on completion
- **Zakat calculator** with multiple asset types and nisab thresholds
- **General quiz** and **3-level module quiz**
- **Full-text search** across lessons and content
- **Bookmarks** to save favorite lessons
- **Personalization** — set your name or nickname during onboarding; change it anytime from the profile card
- **7 themes** (Parchment, Night, Desert Sands, Azure Mosaic, Andalusian Garden, Midnight Indigo, Ebony Gold) + **auto theme** by time of day
- **Tablet & foldable support** — responsive layout on large screens
- **100% offline** — no internet required

### Academic Sources

Content is derived and adapted from well-known Fiqh works:

- Dr. Wahbah az-Zuhayli — *Islamic Legislation* / *al-Fiqh al-Islami wa Adillatuhu*
- Dr. Abdul-Azeem Badawi — *al-Wajiz* (The Concise Presentation of the Fiqh of the Sunnah and the Noble Book)
- Dr. Yusuf al-Qaradawi — *The Lawful and the Prohibited in Islam*
- Muhammad Nasiruddin al-Albani — *Rulings of Hajj and Umrah*
- Sayyid Sabiq — *Fiqh us-Sunnah*
- Ibn Qudamah — *al-Mughni*

### Tech Stack

- **Flutter** — cross-platform framework
- **Riverpod** — state management
- **GoRouter** — navigation
- **Drift** — local SQLite database
- **flutter_local_notifications** — local daily notifications
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
├── data/           # 13 JSON files with Fiqh content
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
| مقدمة في الفقه | ٥ | ١٢ | ١٢ |
| الطهارة | ٦ | ٣٣ | ١٨ |
| الصلاة | ٦ | ٣٥ | ٢٠ |
| الصيام | ٥ | ١٨ | ١٤ |
| الزكاة | ٤ | ١٤ | ٩ |
| الحج والعمرة | ٤ | ١٧ | ١٠ |
| المعاملات — التجارة | ٥ | ١٩ | ١٧ |
| الحلال والحرام | ٤ | ٢٣ | ١٥ |
| النكاح — الزواج | ٤ | ٢٢ | ٢٦ |
| الجنازة | ٤ | ١٥ | ١٢ |
| الأيمان والنذور | ٤ | ١٥ | ١٤ |
| الأطعمة والأشربة | ٤ | ١٤ | ١٥ |
| العقوبات — الفقه الجنائي | ٥ | ٢٤ | ٣٢ |
| **المجموع** | **٦٠** | **٢٦١** | **٢١٤** |

### المميزات الرئيسية

- **١٣ وحدة فقهية** بـ **٦٠ درساً** مرتّبة حسب المستوى (مبتدئ، متوسط، متقدم)
- **٢٦١ سؤال اختبار** مع شروحات مفصّلة
- **٢١٣ دليل شرعي** من القرآن والأحاديث بالعربية مع ترجمة ألبانية
- **مقارنة المذاهب الأربعة** (الحنفي، المالكي، الشافعي، الحنبلي) في كل مسألة
- **تحدي الوقت** — اختبارات بعدّاد تنازلي: كلما ارتفع المستوى قلّ الوقت لكل سؤال
- **التحدي اليومي** — ١٠ أسئلة منوّعة كل يوم مع سلسلة أيام متتالية
- **إشعار يومي** بأقوال العلماء — وقت قابل للتخصيص (الافتراضي ٠٨:٠٠)
- **تصفّح مزدوج** — حسب الوحدات أو حسب المستويات (دروس مستوى واحد من جميع الوحدات)
- **حاول مرة أخرى** في كل اختبار — بما في ذلك إعادة مستوى واحد في اختبار الوحدة
- **تابع من حيث توقفت** — بطاقة في الرئيسية تعيدك إلى آخر درس فتحته
- **تنقّل تلقائي** — زر للدرس التالي وللمستوى التالي عند الإتمام
- **حاسبة الزكاة** بأنواع أموال متعددة وحساب النصاب
- **اختبار شامل** واختبار وحدة **بثلاثة مستويات**
- **بحث كامل** في الدروس والمحتوى
- **حفظ الملاحظات** لتخزين الدروس المفضلة
- **التخصيص** — أدخل اسمك أو لقبك عند الإعداد الأوّلي؛ يمكن تغييره في أي وقت من بطاقة الملف الشخصي
- **٧ سمات** + **سمة تلقائية** حسب وقت اليوم
- **دعم الأجهزة اللوحية والقابلة للطي** — تصميم متجاوب للشاشات الكبيرة
- **يعمل بدون إنترنت بالكامل**

### المصادر العلمية

استُخرج المحتوى وأُعدّ من مؤلفات فقهية معروفة:

- د. وهبة الزحيلي — *الفقه الإسلامي وأدلته*
- د. عبد العظيم بدوي — *الوجيز في فقه السنة والكتاب العزيز*
- د. يوسف القرضاوي — *الحلال والحرام في الإسلام*
- محمد ناصر الدين الألباني — *أحكام الحج والعمرة*
- سيد سابق — *فقه السنة*
- ابن قدامة — *المغني*

### التقنيات المستخدمة

- **Flutter** — إطار تطوير متعدد المنصات
- **Riverpod** — إدارة الحالة
- **GoRouter** — التنقل
- **Drift** — قاعدة بيانات SQLite المحلية
- **flutter_local_notifications** — الإشعارات اليومية المحلية
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
├── data/           # ١٣ ملف JSON بمحتوى فقهي
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
| Introduzione al Fiqh | 5 | 12 | 12 |
| Taharah — Purificazione | 6 | 33 | 18 |
| Salah — Preghiera | 6 | 35 | 20 |
| Sawm — Digiuno | 5 | 18 | 14 |
| Zakat — Elemosina | 4 | 14 | 9 |
| Hajj & Umrah | 4 | 17 | 10 |
| Mu'amalat — Commercio | 5 | 19 | 17 |
| Halal & Haram | 4 | 23 | 15 |
| Nikah — Matrimonio | 4 | 22 | 26 |
| Janazah — Funerale | 4 | 15 | 12 |
| Giuramenti e Voti | 4 | 15 | 14 |
| Cibo & Bevande | 4 | 14 | 15 |
| Diritto Penale Islamico | 5 | 24 | 32 |
| **Totale** | **60** | **261** | **214** |

### Caratteristiche principali

- **13 moduli Fiqh** con **60 lezioni** organizzate per livello (principiante, intermedio, avanzato)
- **261 domande quiz** con spiegazioni dettagliate
- **213 prove** dal Corano e Hadith con testo arabo e traduzione albanese
- **Confronto tra quattro madhab** (Hanafi, Maliki, Shafi'i, Hanbali) per ogni sentenza
- **Sfida a tempo** — quiz con timer: più alto il livello, meno tempo per domanda
- **Sfida giornaliera** — 10 domande miste ogni giorno, con serie giornaliera (streak)
- **Notifica giornaliera** con detti degli studiosi — orario configurabile (predefinito 08:00)
- **Navigazione doppia** — per modulo o per livello (lezioni di un livello da tutti i moduli)
- **Riprova** in ogni quiz — incluso il retry di un singolo livello nel quiz del modulo
- **Riprendi da dove eri** — scheda nella home che riporta all'ultima lezione aperta
- **Progressione automatica** — pulsante per la lezione successiva e per il livello successivo
- **Calcolatore Zakat** con più tipologie di patrimonio e soglie di nisab
- **Quiz generale** e **quiz del modulo a 3 livelli**
- **Ricerca testuale completa** nelle lezioni e nei contenuti
- **Segnalibri** per salvare le lezioni preferite
- **Personalizzazione** — imposta il nome o soprannome durante l'onboarding; modificabile in qualsiasi momento dal profilo
- **7 temi** + **tema automatico** in base all'ora del giorno
- **Supporto tablet e foldable** — layout responsivo sugli schermi grandi
- **100% offline** — nessuna connessione richiesta

---

## 🇹🇷 Türkçe

### Hakkında

**Al Mizan** (الميزان — "Terazi"), Arnavutça'da İslam fıkhını öğrenmek için kapsamlı bir Flutter uygulamasıdır. Uygulama %100 çevrimdışı çalışır ve yapılandırılmış dersler, etkileşimli sınavlar, Kuran ve Sünnet'ten deliller ile dört mezhebin karşılaştırmalarını içerir.

### İçerik

| Modül | Dersler | Sınav Soruları | Deliller |
|-------|---------|----------------|---------|
| Fıkha Giriş | 5 | 12 | 12 |
| Taharet — Temizlik | 6 | 33 | 18 |
| Namaz — İbadet | 6 | 35 | 20 |
| Oruç | 5 | 18 | 14 |
| Zekat | 4 | 14 | 9 |
| Hac & Umre | 4 | 17 | 10 |
| Muamelat — Ticaret | 5 | 19 | 17 |
| Helal & Haram | 4 | 23 | 15 |
| Nikah — Evlilik | 4 | 22 | 26 |
| Cenaze | 4 | 15 | 12 |
| Yeminler ve Adaklar | 4 | 15 | 14 |
| Yiyecek & İçecek | 4 | 14 | 15 |
| İslam Ceza Hukuku | 5 | 24 | 32 |
| **Toplam** | **60** | **261** | **214** |

### Temel özellikler

- **13 fıkıh modülü** ile **60 ders** (başlangıç, orta, ileri seviye)
- **261 sınav sorusu** ayrıntılı açıklamalarla
- **213 delil** Kuran ve hadislerden, Arapça metin ve Arnavutça çeviriyle
- **Dört mezhep karşılaştırması** (Hanefi, Maliki, Şafii, Hanbeli) her hüküm için
- **Zamana Karşı Meydan Okuma** — süre sayaçlı sınavlar: seviye yükseldikçe soru başına süre azalır
- **Günlük Meydan Okuma** — her gün 10 karışık soru, günlük seri (streak) ile
- **Günlük bildirim** — âlimlerin sözleriyle, kullanıcı tarafından ayarlanabilir saat (varsayılan 08:00)
- **Çift görünüm** — modüllere göre veya seviyelere göre (bir seviyenin dersleri tüm modüllerden)
- **Tekrar Dene** her sınavda — modül sınavında tek bir seviyeyi yeniden deneme dahil
- **Kaldığın yerden devam et** — ana ekrandaki kart son açılan derse götürür
- **Otomatik ilerleme** — sonraki ders ve sonraki seviye düğmeleri
- **Zekat hesaplayıcı** çoklu varlık türleri ve nisap eşikleri ile
- **Genel sınav** ve **3 seviyeli modül sınavı**
- **Tam metin arama** dersler ve içerikler arasında
- **Yer imleri** favori dersleri kaydetmek için
- **Kişiselleştirme** — kayıt sırasında isim veya takma ad belirle; profil kartından istediğin zaman değiştir
- **7 tema** + günün saatine göre **otomatik tema**
- **Tablet ve katlanabilir desteği** — büyük ekranlarda duyarlı tasarım
- **%100 çevrimdışı** — internet bağlantısı gerekmez

---

## 🇧🇦 Bosanski

### O aplikaciji

**Al Mizan** (الميزان — "Vaga") je sveobuhvatna Flutter aplikacija za učenje islamske jurisprudencije (fikha) na albanskom jeziku. Aplikacija radi 100% offline i sadrži strukturirane lekcije, interaktivne kvizove, dokaze iz Kur'ana i Sunneta te usporedbe četiri mezheba.

### Sadržaj

| Modul | Lekcije | Pitanja | Dokazi |
|-------|---------|---------|--------|
| Uvod u Fikh | 5 | 12 | 12 |
| Taharet — Čistoća | 6 | 33 | 18 |
| Salat — Namaz | 6 | 35 | 20 |
| Post — Ramazan | 5 | 18 | 14 |
| Zekat | 4 | 14 | 9 |
| Hadž & Umra | 4 | 17 | 10 |
| Muamelat — Trgovina | 5 | 19 | 17 |
| Halal & Haram | 4 | 23 | 15 |
| Nikah — Brak | 4 | 22 | 26 |
| Dženaza | 4 | 15 | 12 |
| Zakletve i Zavjeti | 4 | 15 | 14 |
| Hrana & Piće | 4 | 14 | 15 |
| Islamsko krivično pravo | 5 | 24 | 32 |
| **Ukupno** | **60** | **261** | **214** |

### Ključne funkcionalnosti

- **13 fikhskih modula** sa **60 lekcija** po nivoima (početnik, srednji, napredni)
- **261 kviz pitanja** s detaljnim objašnjenjima
- **213 dokaza** iz Kur'ana i hadisa s arapskim tekstom i albanskim prijevodom
- **Usporedba četiri mezheba** (Hanefi, Maliki, Šafii, Hanbeli) za svako pitanje
- **Izazov na vrijeme** — kvizovi sa tajmerom: što je viši nivo, manje vremena po pitanju
- **Dnevni izazov** — 10 miješanih pitanja svaki dan, s dnevnim nizom (streak)
- **Dnevna notifikacija** s izrekama učenjaka — vrijeme podesivo (zadano 08:00)
- **Dvostruki pregled** — po modulima ili po nivoima (lekcije jednog nivoa iz svih modula)
- **Pokušaj ponovo** u svakom kvizu — uključujući ponavljanje jednog nivoa u kvizu modula
- **Nastavi gdje si stao** — kartica na početnoj vraća na zadnju otvorenu lekciju
- **Automatski napredak** — dugme za sljedeću lekciju i sljedeći nivo
- **Kalkulator zekata** s više vrsta imovine i nisab pragovima
- **Opći kviz** i **kviz modula na 3 nivoa**
- **Pretraga cijelog teksta** kroz lekcije i sadržaj
- **Oznake** za čuvanje omiljenih lekcija
- **Personalizacija** — unesi ime ili nadimak tokom onboardinga; promjeni u bilo kom trenutku iz profila
- **7 tema** + **automatska tema** prema dobu dana
- **Podrška za tablete i preklopne uređaje** — responzivan raspored na velikim ekranima
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
