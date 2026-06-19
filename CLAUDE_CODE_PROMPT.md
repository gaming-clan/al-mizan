# AL MIZAN — Claude Code Prompt

## PROJEKTI

"Al Mizan — Mëso Fikhun" është një aplikacion Flutter edukativ për jurisprudencën islame (Fikh) në gjuhën shqipe. Repo: https://github.com/gaming-clan/al-mizan — klonoje dhe puno mbi të.

## STACK TEKNIK

- **Flutter 3.35.3 / Dart 3.9.2** — Android (SDK 35, Java 21)
- **State Management**: Riverpod (flutter_riverpod + riverpod_annotation)
- **Navigation**: GoRouter me ShellRoute (5 tabs: Ballina, Module, Kërko, Shënime, Profili)
- **Database**: Drift ORM (SQLite) — tracks lesson progress, bookmarks, quiz scores, streaks
- **Theming**: Material 3 (useMaterial3: true), Google Fonts (Source Serif 4, Plus Jakarta Sans, Amiri, Scheherazade)
- **Design System**: "Al-Mizan" nga Google Stitch — Light (Parchment) + Dark (Obsidian). ZIP-i me themes ndodhet te `docs/stitch_fiqh_learning_academy.zip`
- **Të dhënat**: 12 module JSON të ngarkuara via rootBundle, jo API

## STRUKTURA E KODIT

```
lib/
├── main.dart, app.dart
├── core/
│   ├── constants/app_constants.dart    # Emri, nisab, madhabe, ikona
│   ├── database/app_database.dart      # Drift DB (progress, bookmarks, scores)
│   ├── routing/app_router.dart         # GoRouter — ShellRoute + full-screen routes
│   ├── routing/shell_scaffold.dart     # 5-tab bottom nav
│   ├── theme/app_colors.dart           # Ngjyrat light + dark
│   ├── theme/app_theme.dart            # ThemeData light + dark (Al-Mizan design)
│   ├── theme/app_typography.dart        # Font families
│   └── utils/                          # arabic_text_helper, zakat_calculator
├── data/fiqh_content/                  # 12 JSON module files
├── features/
│   ├── home/                           # Dashboard: greeting, daily quote, module grid, quick actions
│   ├── modules/                        # Module list, lesson list, lesson detail screen
│   │   ├── data/models/fiqh_models.dart  # FiqhModule, Lesson, LessonSection, Evidence, QuizQuestion, MadhabRulings
│   │   └── data/fiqh_data_source.dart    # JSON loader me cache
│   ├── quiz/                           # Per-lesson quiz + general cross-topic quiz
│   ├── search/                         # Full-text search across modules
│   ├── bookmarks/                      # Saved lessons
│   ├── ask_scholar/                    # Pre-populated Q&A screen
│   ├── profile/                        # Stats, dark mode, about
│   ├── settings/                       # Theme, preferences
│   └── zakat_calculator/               # Multi-asset zakat calculator with nisab
└── shared/widgets/                     # quran_verse_card, hadith_card, madhab_comparison
```

## PËRMBAJTJA — 12 MODULE FIKHORE

| # | module_id | Titulli | Mësime | Kuize | Evidenca |
|---|-----------|---------|--------|-------|----------|
| 1 | introduction | Hyrje në Fikh | 3 | 7 | 8 |
| 2 | taharah | Taharet — Pastërtia | 6 | 33 | 18 |
| 3 | salah | Namazi — Falja | 5 | 30 | 12 |
| 4 | sawm | Agjërimi | 3 | 11 | 6 |
| 5 | zakat | Zekati | 3 | 10 | 6 |
| 6 | hajj | Haxhi dhe Umreja | 4 | 17 | 10 |
| 7 | muamalat | Muamelati — Tregtia | 3 | 11 | 7 |
| 8 | halal_haram | Hallalli dhe Harami | 3 | 19 | 12 |
| 9 | nikah | Nikahu (Martesa) | 3 | 13 | 14 |
| 10 | xhenaze | Xhenazja (Funeral) | 3 | 11 | 8 |
| 11 | betim_nedhr | Betimet dhe Nedhri | 2 | 7 | 8 |
| 12 | ushqimi_pija | Ushqimi dhe Pija | 3 | 10 | 11 |
| **TOTAL** | | | **41** | **179** | **120** |

Çdo mësim ka një `level`: beginner, intermediate, ose advanced.

### Formati JSON i moduleve (duhet respektuar pikë për pikë):

```json
{
  "module_id": "taharah",
  "module_title_sq": "Taharet — Pastërtia",
  "module_title_ar": "الطهارة",
  "module_icon": "droplets",
  "description": "...",
  "lessons": [
    {
      "id": "taharah_1",
      "title_sq": "...",
      "title_ar": "...",
      "level": "beginner",
      "source_references": ["..."],
      "sections": [
        {
          "heading": "...",
          "content_sq": "...",
          "evidences": [
            {
              "type": "quran",
              "surah": "El-Maide",
              "surah_number": 5,
              "ayah": 6,
              "arabic": "...",
              "translation_sq": "..."
            },
            {
              "type": "hadith",
              "collection": "Buhariu",
              "hadith_number": 135,
              "narrator": "...",
              "arabic": "...",
              "translation_sq": "..."
            }
          ],
          "madhab_rulings": {
            "hanafi": { "ruling": "...", "source": "..." },
            "maliki": { "ruling": "...", "source": "..." },
            "shafii": { "ruling": "...", "source": "..." },
            "hanbali": { "ruling": "...", "source": "..." }
          }
        }
      ],
      "quiz": [
        {
          "question": "...",
          "options": ["A", "B", "C", "D"],
          "correct_index": 0,
          "explanation": "..."
        }
      ]
    }
  ]
}
```

**KUJDES**: Çelësat DUHET të jenë pikërisht si më sipër. Modelet Dart i lexojnë kështu:
- Moduli: `module_title_sq`, `module_title_ar`, `module_icon`, `module_id`
- Evidenca: `arabic`, `translation_sq` (JO `text_ar`/`text_sq`)
- Kuizi: `correct_index` (int, JO `correct_answer`)

## BURIMET PËRMBAJTËSORE (në `docs/`)

PDF-të nga të cilat u nxorën mësimet:
- Dr. Vehbe ez-Zuhejli — Ligjet e Sheriatit (2 vëllime)
- Abedin Musallari — Haxhi dhe rregullat e tij
- Dispozitat e Haxhit — Albani
- Dr. Jusuf Kardavi — Hallalli dhe Harami
- E Drejta Penale Islame
- Fikhu Praktik (faqe 83-279)
- Normat e Shitblerjes
- Shtyllat e Namazit
- Simple Fiqh (anglisht)
- Concise Presentation of the Fiqh (anglisht, 50MB via Git LFS)

## DESIGN SYSTEM — Al-Mizan (Stitch)

Dy tema të plota:

### Light Theme (Parchment)
- Primary: #003527 (Deep Emerald), onPrimary: #FFFFFF
- Surface: #FBF9F5 (Warm Parchment), onSurface: #1A1C19
- Secondary: #4A6357, SecondaryContainer: #CCE8D8
- PrimaryContainer: #6AFFC2, Outline: #717971

### Dark Theme (Obsidian)
- Primary: #4EDEA3 (Luminous Emerald), onPrimary: #003824
- Surface: #131313 (Deep Obsidian), onSurface: #E2E3DE
- Secondary: #B1CCBE, SecondaryContainer: #334B40
- SurfaceContainerHigh: #2B2B2B, Outline: #8B918C

Fonts: Source Serif 4 (display/headline), Plus Jakarta Sans (body/labels), Amiri + Scheherazade New (Arabic)

## ÇFARË ËSHTË BËRË DERI TANI

### Faza 1 — Ndërtimi bazë
- [x] Inicializimi i projektit Flutter me të gjitha dependencies
- [x] Krijimi i modeleve Dart (FiqhModule, Lesson, Evidence, QuizQuestion, MadhabRulings)
- [x] Drift database me tabela për progress, bookmarks, quiz scores, streaks
- [x] GoRouter me ShellRoute (5 tabs) + full-screen routes për lessons/quizzes
- [x] Shared widgets: QuranVerseCard, HadithCard, MadhabComparison

### Faza 2 — Përmbajtja
- [x] Krijimi i 12 moduleve JSON me mësime, kuize, evidenca
- [x] Pasurimi i moduleve nga 14 burime PDF (shqip + anglisht)
- [x] Integrimi i librit të Kardavit në modulin Hallall/Haram
- [x] Validimi dhe normalizimi i të gjitha JSON keys (correct_index, arabic, translation_sq)

### Faza 3 — UI/UX
- [x] Al-Mizan design system (light + dark ThemeData)
- [x] Home screen me greeting, daily quote, module grid, quick actions
- [x] Ask a Scholar screen (pre-populated Q&A)
- [x] Profile screen me stats, motivational quote
- [x] 5-tab navigation (Ballina, Module, Kërko, Shënime, Profili)
- [x] Kuiz i përgjithshëm me difficulty levels
- [x] Llogaritës Zekati (multi-asset, nisab)
- [x] Search full-text across modules
- [x] Bookmarks system

### Faza 4 — Fixes
- [x] SafeArea bottom: false (quiz button visibility)
- [x] Randomizimi i pyetjeve dhe përgjigjeve të kuizit
- [x] Fix JSON schema mismatches në të 12 modulet
- [x] Git repo + push me LFS për PDF-në 50MB

## ÇFARË DUHET TË BËHET TANI (DETYRAT E TUA)

Ti duhet ta çosh këtë aplikacion deri në pikën ku është i gatshëm për dy fazat finale para-lëshimit:
1. **Kontrolli fetar** — rishikimi nga hoxhallarë për saktësinë e përmbajtjes
2. **Testimi teknik** — performanca, stabilitet, UX polish

### PRIORITETI 1 — Features të reja

#### 1.1 Welcome/Onboarding Screen
- Multi-page onboarding (3-4 faqe) me Al-Mizan branding
- Shfaqet vetëm në nisjen e parë (SharedPreferences flag)
- Faqet: Mirëseardhje + logo, Çfarë mëson, Si funksionon, Fillo
- Butoni "Fillo" → navigon te Home

#### 1.2 Ndarja e mësimeve sipas niveleve me progresion
- Mësimet grupohen sipas `level`: Fillestar (beginner), Mesatar (intermediate), Avancuar (advanced)
- Çdo nivel shfaqet si seksion i veçantë në lesson list screen
- Nivelet e mëvonshme janë të kyçura (locked) derisa përdoruesi përfundon mësimet e nivelit para
- "Përfunduar" = ka lexuar mësimin + ka kaluar kuizin (≥60% correct)
- Shfaq progress bar për çdo nivel
- Përdor Drift DB për të ruajtur progresion

#### 1.3 Theme Toggle (Light/Dark)
- ThemeMode provider me Riverpod (StateNotifier ose similar)
- Ruaj preferencën me SharedPreferences
- Toggle button në Profile screen dhe/ose Settings
- Duhet të punojë me dy temat Al-Mizan (Parchment light, Obsidian dark)
- Referenco `docs/stitch_fiqh_learning_academy.zip` për detaje ngjyrash

### PRIORITETI 2 — Polish & UX

#### 2.1 Overflow fixes
- Disa module cards kanë "BOTTOM OVERFLOWED BY 0.242 PIXELS" — rregullo aspect ratio ose padding
- Sigurohu që tituj të gjatë nuk shkaktojnë overflow (maxLines + ellipsis)

#### 2.2 Animacione dhe tranzicione
- Page transitions për lesson navigation
- Animacion kur hap/mbyll seksione
- Progress animation kur plotëson kuizin
- Subtle fade-in për module cards

#### 2.3 Empty states
- Mesazhe kur s'ka bookmarks
- Mesazhe kur search nuk gjen asgjë
- State kur s'ka quiz scores akoma

#### 2.4 Error handling
- Graceful fallback kur JSON nuk ngarkohet
- Offline mode (app duhet të funksionojë 100% offline)
- Loading states me shimmer/skeleton

### PRIORITETI 3 — Pregaditje për Production

#### 3.1 App Icon & Splash Screen
- Dizajno app icon me motivin Al-Mizan (peshore/balance)
- Splash screen me logo + emrin
- Përdor flutter_native_splash ose të ngjashme

#### 3.2 Performance
- Lazy loading për module JSON (ngarko vetëm kur hapet)
- Image/asset optimization
- Profiling — sigurohu <16ms frame time
- Minimizzo APK size (proguard, shrink resources)

#### 3.3 Play Store Readiness
- Ndrysho `version` në pubspec.yaml sipas semver
- Krijo signing key për release build
- Krijo `android/app/proguard-rules.pro` nëse duhet
- App Bundle (AAB) në vend të APK për Play Store
- Screenshots për listing
- Privacy policy URL (kërkohet nga Play Store)

#### 3.4 Accessibility
- Semantics labels për screen readers
- Kontrast i mjaftueshëm ngjyrash (WCAG AA)
- Font scaling support
- RTL layout support për tekstin arab

### PRIORITETI 4 — Përmirësime të mundshme (nice-to-have)

- Daily hadith/ayah rotation (jo i hardkoduar)
- Statistika të detajuara (grafik progresioni, kohë studimi)
- Notification reminders për studim
- Export/share quiz results
- Favorite evidences (ruaj ajete/hadithe të preferuara)

## RREGULLA TË RËNDËSISHME

### Build process (Windows)
```bat
@echo off
cd /d D:\fikh-academy
set JAVA_TOOL_OPTIONS=-Djava.net.preferIPv4Stack=true -Djdk.net.unixdomain.tmpdir=C:\temp\gradle_unix
mkdir C:\temp\gradle_unix 2>nul
call flutter build apk --debug
```
JAVA_TOOL_OPTIONS **duhet** vendosur, përndryshe Gradle dështon.

### JSON validation
Para çdo build, valido JSON-et me:
```python
python3 -c "
import json, os
for f in sorted(os.listdir('lib/data/fiqh_content')):
    if not f.endswith('.json'): continue
    d = json.load(open(f'lib/data/fiqh_content/{f}'))
    assert 'module_title_sq' in d
    for l in d['lessons']:
        for q in l['quiz']:
            assert isinstance(q['correct_index'], int)
        for s in l['sections']:
            for e in s.get('evidences', []):
                assert e.get('arabic') and e.get('translation_sq')
    print(f'OK {f}')
"
```

### Gjëra që s'duhet bërë
- MOS ndrysho çelësat e JSON (formati aktual funksionon — mos e prish)
- MOS hiq module ekzistuese
- MOS përdor API për përmbajtje (app duhet 100% offline)
- MOS përdor localStorage/sessionStorage në artifacts

## SI TA TESTOSH

1. `flutter build apk --debug` → instalo në telefon/emulator
2. Verifiko që të 12 modulet shfaqen te tab "Module"
3. Hap çdo modul → kontrollo mësimet, evidencat, kuizet
4. Testo theme toggle (light ↔ dark)
5. Testo search, bookmarks, zakat calculator
6. Kontrollo për overflow/layout issues

## PËRMBLEDHJE

Aplikacioni ka kodin, përmbajtjen, dhe dizajnin bazë gati. Ti duhet të shtosh welcome screen, progresion me nivele, theme toggle, dhe ta polish-osh deri në pikën ku mbetet vetëm:
1. Rishikimi fetar nga hoxhallarë (përmbajtja e JSON-eve)
2. Testimi final teknik para Play Store

Puno sistematikisht — fillo me features të reja (onboarding, levels, theme toggle), pastaj polish, pastaj production readiness. Commit shpesh me mesazhe të qarta.
