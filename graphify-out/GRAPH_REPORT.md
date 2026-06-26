# Graph Report - al-mizan  (2026-06-26)

## Corpus Check
- 100 files · ~1,000,483 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1171 nodes · 1479 edges · 67 communities (55 shown, 12 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `bbc08c49`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]

## God Nodes (most connected - your core abstractions)
1. `AL MIZAN — Claude Code Prompt` - 12 edges
2. `moduleProvider` - 10 edges
3. `Create()` - 10 edges
4. `MessageHandler()` - 10 edges
5. `WndProc()` - 9 edges
6. `themeProvider` - 8 edges
7. `_ZakatCalculatorScreenState` - 8 edges
8. `⚖️ Al Mizan — الميزان` - 8 edges
9. `🇦🇱 Shqip` - 8 edges
10. `🇬🇧 English` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Create()` --references--> `size`  [EXTRACTED]
  windows/runner/win32_window.cpp → lib/features/profile/presentation/profile_screen.dart
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `build` --references--> `themeProvider`  [EXTRACTED]
  lib/app.dart → lib/features/settings/providers/settings_provider.dart
- `BookmarksScreen` --references--> `databaseProvider`  [EXTRACTED]
  lib/features/bookmarks/presentation/bookmarks_screen.dart → lib/features/home/providers/home_provider.dart
- `build` --references--> `databaseProvider`  [EXTRACTED]
  lib/features/bookmarks/presentation/bookmarks_screen.dart → lib/features/home/providers/home_provider.dart

## Import Cycles
- None detected.

## Communities (67 total, 12 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.01
Nodes (215): accent, accentLight, AppColors, azureInverseOnSurface, azureInversePrimary, azureInverseSurface, azureOnPrimary, azureOnPrimaryContainer (+207 more)

### Community 1 - "Community 1"
Cohesion: 0.08
Nodes (37): DartProject, RegisterPlugins(), HWND, LPARAM, LRESULT, PluginRegistry, Point, size (+29 more)

### Community 2 - "Community 2"
Cohesion: 0.04
Nodes (44): additionalNote, allRulings, arabic, ayah, classification, collection, consensusNote, contentSq (+36 more)

### Community 3 - "Community 3"
Cohesion: 0.05
Nodes (39): About, Academic Sources, ⚖️ Al Mizan — الميزان, 🇧🇦 Bosanski, Build, Burimet shkencore, Caratteristiche principali, Content (+31 more)

### Community 4 - "Community 4"
Cohesion: 0.05
Nodes (37): 1.1 Welcome/Onboarding Screen, 1.2 Ndarja e mësimeve sipas niveleve me progresion, 1.3 Theme Toggle (Light/Dark), 2.1 Overflow fixes, 2.2 Animacione dhe tranzicione, 2.3 Empty states, 2.4 Error handling, 3.1 App Icon & Splash Screen (+29 more)

### Community 5 - "Community 5"
Cohesion: 0.07
Nodes (25): Any, Bool, Cocoa, file_selector_macos, Flutter, RegisterGeneratedPlugins(), FlutterAppDelegate, FlutterMacOS (+17 more)

### Community 6 - "Community 6"
Cohesion: 0.10
Nodes (20): static TextStyle get, AppTypography, arabicGeneral, arabicLight, bodyLarge, bodyMedium, bodySmall, displayLarge (+12 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (36): bool get, desertSands,
  azureMosaic,
  andalusianGarden,
  midnightIndigo,, ../../features/about/presentation/about_screen.dart, ../../features/about/presentation/privacy_policy_screen.dart, ../../features/ask_scholar/presentation/ask_scholar_screen.dart, ../../features/bookmarks/presentation/bookmarks_screen.dart, ../../features/home/presentation/home_screen.dart, ../../features/modules/presentation/lesson_list_screen.dart (+28 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (35): connection/connection.dart, addBookmark, completedAt, correctAnswers, countCompletedLessons, createdAt, date, _daysBetween (+27 more)

### Community 9 - "Community 9"
Cohesion: 0.06
Nodes (32): _answered, build, _buildFinalResult, _buildLevelIntro, _buildLevelResult, _buildQuestion, _correct, correctIndex (+24 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (33): ../constants/app_constants.dart, package:http/http.dart, calculate, calculateCropZakat, calculateLivestockZakat, camelCount, camelZakat, cattleCount (+25 more)

### Community 11 - "Community 11"
Cohesion: 0.07
Nodes (29): dart:convert, _assetPaths, _cache, findLesson, FiqhDataSource, _instance, lesson, loadAllModules (+21 more)

### Community 12 - "Community 12"
Cohesion: 0.06
Nodes (30): _businessCtrl, _calcLivestock, _camelCtrl, _cashCtrl, _cattleCtrl, createState, _cropResult, _cropsTab (+22 more)

### Community 13 - "Community 13"
Cohesion: 0.06
Nodes (34): AppConstants, appName, appNameAr, appTagline, cropNisabKg, cropRateMachineIrrigated, cropRateRainIrrigated, currencyNames (+26 more)

### Community 14 - "Community 14"
Cohesion: 0.09
Nodes (22): allQuestions, answered, color, correctIndex, createState, dataSource, difficulty, _DifficultyCard (+14 more)

### Community 15 - "Community 15"
Cohesion: 0.11
Nodes (22): FlPluginRegistry, fl_register_plugins(), FlView, GApplication, gboolean, gchar, GObject, GtkApplication (+14 more)

### Community 16 - "Community 16"
Cohesion: 0.25
Nodes (8): core/routing/app_router.dart, core/theme/app_theme.dart, ../../features/settings/providers/settings_provider.dart, build, FikhAcademyApp, _showThemePicker, build, themeProvider

### Community 17 - "Community 17"
Cohesion: 0.10
Nodes (20): package:image_picker/image_picker.dart, avatarPath, color, controller, current, hasPhoto, icon, label (+12 more)

### Community 18 - "Community 18"
Cohesion: 0.10
Nodes (20): body, build, _controller, createState, _currentPage, dispose, _finish, icon (+12 more)

### Community 19 - "Community 19"
Cohesion: 0.08
Nodes (24): package:url_launcher/url_launcher.dart, _appLinks, author, build, child, color, cs, detail (+16 more)

### Community 20 - "Community 20"
Cohesion: 0.09
Nodes (22): Color, error, _ErrorView, index, _isLevelUnlocked, isRead, lesson, lessons (+14 more)

### Community 21 - "Community 21"
Cohesion: 0.14
Nodes (14): dart:math, int?, answered, copyWith, correctCount, currentIndex, initialize, nextQuestion (+6 more)

### Community 22 - "Community 22"
Cohesion: 0.24
Nodes (8): ../../../core/database/app_database.dart, ../../home/providers/home_provider.dart, BookmarksScreen, build, bookmarksProvider, ../providers/bookmarks_provider.dart, db, getAllBookmarks

### Community 23 - "Community 23"
Cohesion: 0.12
Nodes (16): AboutScreen, _Divider, _FeatureRow, _HeroHeader, _InfoCard, _LinkTile, _SectionLabel, _SourceRow (+8 more)

### Community 24 - "Community 24"
Cohesion: 0.14
Nodes (13): ../../../core/constants/daily_quotes.dart, IconData, icon, _iconForModule, module, _ModuleGridCard, onTap, _QuickActionTile (+5 more)

### Community 25 - "Community 25"
Cohesion: 0.14
Nodes (13): ../../modules/providers/module_provider.dart, answered, correctIndex, createState, index, lessonId, moduleId, onTap (+5 more)

### Community 26 - "Community 26"
Cohesion: 0.14
Nodes (13): answer, build, createState, _expanded, isDark, _QA, _qaList, question (+5 more)

### Community 27 - "Community 27"
Cohesion: 0.21
Nodes (17): ConsumerWidget, allQuestionsProvider, build, _GeneralQuizBody, build, LessonListScreen, build, LessonScreen (+9 more)

### Community 28 - "Community 28"
Cohesion: 0.15
Nodes (12): ../data/fiqh_data_source.dart, completed, completedIds, db, isComplete, isRead, lessonIds, lessonProvider (+4 more)

### Community 29 - "Community 29"
Cohesion: 0.21
Nodes (10): ../../core/theme/app_typography.dart, ../../core/utils/arabic_text_helper.dart, Evidence, ../../features/modules/data/models/fiqh_models.dart, build, evidence, HadithCard, build (+2 more)

### Community 30 - "Community 30"
Cohesion: 0.17
Nodes (11): ../data/models/fiqh_models.dart, LessonSection, lessonId, moduleId, section, _SectionWidget, ../providers/module_provider.dart, ../../../shared/widgets/hadith_card.dart (+3 more)

### Community 31 - "Community 31"
Cohesion: 0.13
Nodes (14): app_colors.dart, package:google_fonts/google_fonts.dart, static ThemeData get, andalusianGarden, AppTheme, azureMosaic, _build, dark (+6 more)

### Community 32 - "Community 32"
Cohesion: 0.20
Nodes (8): openConnection, openConnection, dart:io, package:drift/drift.dart, package:drift/native.dart, package:drift/web.dart, package:path/path.dart, package:path_provider/path_provider.dart

### Community 33 - "Community 33"
Cohesion: 0.29
Nodes (6): ../../home/presentation/widgets/module_card.dart, package:shimmer/shimmer.dart, cols, error, _ModuleListError, _ModuleListShimmer

### Community 34 - "Community 34"
Cohesion: 0.19
Nodes (11): ../../modules/data/fiqh_data_source.dart, package:fikh_academy/app.dart, package:flutter_riverpod/flutter_riverpod.dart, package:flutter_test/flutter_test.dart, build, SearchScreen, ../providers/search_provider.dart, query (+3 more)

### Community 35 - "Community 35"
Cohesion: 0.25
Nodes (11): build, _calcCrops, _calcWealth, _wealthTab, ZakatCalculatorScreen, _ZakatCalculatorScreenState, exchangeRateProvider, goldPriceProvider (+3 more)

### Community 36 - "Community 36"
Cohesion: 0.10
Nodes (18): app.dart, ../../core/constants/app_constants.dart, ../../core/theme/app_colors.dart, main, MadhabRuling, MadhabRulings, package:flutter/material.dart, SettingsScreen (+10 more)

### Community 37 - "Community 37"
Cohesion: 0.18
Nodes (16): build, HomeScreen, build, ModuleListScreen, build, ProfileScreen, _showAvatarPicker, _showEditNameDialog (+8 more)

### Community 38 - "Community 38"
Cohesion: 0.15
Nodes (12): ColorScheme, List, build, bullets, content, cs, number, PrivacyPolicyScreen (+4 more)

### Community 39 - "Community 39"
Cohesion: 0.29
Nodes (6): ../../../core/utils/zakat_calculator.dart, currency, getGoldPricePerGram, getLiveExchangeRates, liveAsync, when

### Community 40 - "Community 40"
Cohesion: 0.32
Nodes (8): AskScholarScreen, _AskScholarScreenState, _QACard, _QACardState, OnboardingScreen, _OnboardingScreenState, State, StatefulWidget

### Community 41 - "Community 41"
Cohesion: 0.13
Nodes (13): FiqhModule, package:go_router/go_router.dart, build, child, _currentIndex, ShellScaffold, _tabs, static const (+5 more)

### Community 42 - "Community 42"
Cohesion: 0.33
Nodes (5): handle_new_rx_page(), __lldb_init_module(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages., SBDebugger, SBFrame

### Community 43 - "Community 43"
Cohesion: 0.33
Nodes (5): ArabicTextHelper, containsArabic, formatHadithRef, formatQuranRef, wrapRtl

### Community 44 - "Community 44"
Cohesion: 0.40
Nodes (5): Bookmarks, CompletedLessons, LearningStreak, QuizResults, Table

### Community 47 - "Community 47"
Cohesion: 0.29
Nodes (6): _, @DriftDatabase, AppDatabase, ../../modules/data/models/fiqh_models.dart, db, getCurrentStreak

### Community 52 - "Community 52"
Cohesion: 0.40
Nodes (6): ConsumerState, ConsumerStatefulWidget, GeneralQuizScreen, _GeneralQuizScreenState, ModuleQuizScreen, _ModuleQuizScreenState

## Knowledge Gaps
- **722 isolated node(s):** `flutter_export_environment.sh script`, `-registerWithRegistry`, `AppConstants`, `appName`, `appNameAr` (+717 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `size` connect `Community 1` to `Community 17`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Why does `CropZakatResult` connect `Community 10` to `Community 12`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `flutter_export_environment.sh script`, `-registerWithRegistry` to the rest of the system?**
  _723 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.009259259259259259 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07922705314009662 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.044444444444444446 - nodes in this community are weakly interconnected._
- **Should `Community 3` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._