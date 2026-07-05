import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sq')
  ];

  /// No description provided for @appTitle.
  ///
  /// In sq, this message translates to:
  /// **'Al Mizan - Mëso Fikhun'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In sq, this message translates to:
  /// **'Ballina'**
  String get navHome;

  /// No description provided for @navModules.
  ///
  /// In sq, this message translates to:
  /// **'Module'**
  String get navModules;

  /// No description provided for @navSearch.
  ///
  /// In sq, this message translates to:
  /// **'Kërko'**
  String get navSearch;

  /// No description provided for @navBookmarks.
  ///
  /// In sq, this message translates to:
  /// **'Shënime'**
  String get navBookmarks;

  /// No description provided for @navProfile.
  ///
  /// In sq, this message translates to:
  /// **'Profili'**
  String get navProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In sq, this message translates to:
  /// **'Es-selamu alejkum, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingDefault.
  ///
  /// In sq, this message translates to:
  /// **'Nxënës'**
  String get homeGreetingDefault;

  /// No description provided for @dailyMeditation.
  ///
  /// In sq, this message translates to:
  /// **'MEDITIMI I DITËS'**
  String get dailyMeditation;

  /// No description provided for @continueStudy.
  ///
  /// In sq, this message translates to:
  /// **'VAZHDIMI I STUDIMIT'**
  String get continueStudy;

  /// No description provided for @quickTools.
  ///
  /// In sq, this message translates to:
  /// **'VEGLA TË SHPEJTA'**
  String get quickTools;

  /// No description provided for @continueWhereYouLeft.
  ///
  /// In sq, this message translates to:
  /// **'VAZHDO KU MBETE'**
  String get continueWhereYouLeft;

  /// No description provided for @lessonsCount.
  ///
  /// In sq, this message translates to:
  /// **'{count} mësime'**
  String lessonsCount(int count);

  /// No description provided for @generalQuiz.
  ///
  /// In sq, this message translates to:
  /// **'Kuiz i Përgjithshëm'**
  String get generalQuiz;

  /// No description provided for @generalQuizSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Testo njohuritë nga të gjitha temat'**
  String get generalQuizSubtitle;

  /// No description provided for @timedChallenge.
  ///
  /// In sq, this message translates to:
  /// **'Sfida me Kohë'**
  String get timedChallenge;

  /// No description provided for @timedChallengeSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Kuiz me kohë të kufizuar — sa më i lartë niveli, aq më pak kohë'**
  String get timedChallengeSubtitle;

  /// No description provided for @dailyChallenge.
  ///
  /// In sq, this message translates to:
  /// **'Sfida Ditore'**
  String get dailyChallenge;

  /// No description provided for @dailyChallengeSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'10 pyetje të përziera çdo ditë — ruaj serinë!'**
  String get dailyChallengeSubtitle;

  /// No description provided for @zakatCalculator.
  ///
  /// In sq, this message translates to:
  /// **'Llogaritës Zekati'**
  String get zakatCalculator;

  /// No description provided for @zakatCalculatorSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Llogarit detyrimet e zekatit'**
  String get zakatCalculatorSubtitle;

  /// No description provided for @askScholar.
  ///
  /// In sq, this message translates to:
  /// **'Pyet Dijetarin'**
  String get askScholar;

  /// No description provided for @askScholarSubtitle.
  ///
  /// In sq, this message translates to:
  /// **'Pyetje dhe përgjigje rreth fesë'**
  String get askScholarSubtitle;

  /// No description provided for @levelBeginner.
  ///
  /// In sq, this message translates to:
  /// **'Fillestar'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In sq, this message translates to:
  /// **'Mesatar'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In sq, this message translates to:
  /// **'Avancuar'**
  String get levelAdvanced;

  /// No description provided for @settings.
  ///
  /// In sq, this message translates to:
  /// **'Cilësime'**
  String get settings;

  /// No description provided for @settingsTheme.
  ///
  /// In sq, this message translates to:
  /// **'TEMA'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In sq, this message translates to:
  /// **'GJUHA'**
  String get settingsLanguage;

  /// No description provided for @aboutApp.
  ///
  /// In sq, this message translates to:
  /// **'Rreth App-it'**
  String get aboutApp;

  /// No description provided for @startQuiz.
  ///
  /// In sq, this message translates to:
  /// **'Fillo Kuizin'**
  String get startQuiz;

  /// No description provided for @markCompleted.
  ///
  /// In sq, this message translates to:
  /// **'Shëno si të Përfunduar'**
  String get markCompleted;

  /// No description provided for @completed.
  ///
  /// In sq, this message translates to:
  /// **'I Përfunduar'**
  String get completed;

  /// No description provided for @nextLesson.
  ///
  /// In sq, this message translates to:
  /// **'Mësimi Pasardhës'**
  String get nextLesson;

  /// No description provided for @references.
  ///
  /// In sq, this message translates to:
  /// **'Referencat'**
  String get references;

  /// No description provided for @lessonMarkedCompleted.
  ///
  /// In sq, this message translates to:
  /// **'Mësimi u shënua si i përfunduar!'**
  String get lessonMarkedCompleted;

  /// No description provided for @bookmarkAdded.
  ///
  /// In sq, this message translates to:
  /// **'U shtua te shënimet!'**
  String get bookmarkAdded;

  /// No description provided for @questionOf.
  ///
  /// In sq, this message translates to:
  /// **'Pyetja {current}/{total}'**
  String questionOf(int current, int total);

  /// No description provided for @nextQuestion.
  ///
  /// In sq, this message translates to:
  /// **'Pyetja Tjetër'**
  String get nextQuestion;

  /// No description provided for @seeResult.
  ///
  /// In sq, this message translates to:
  /// **'Shiko Rezultatin'**
  String get seeResult;

  /// No description provided for @result.
  ///
  /// In sq, this message translates to:
  /// **'Rezultati'**
  String get result;

  /// No description provided for @goBack.
  ///
  /// In sq, this message translates to:
  /// **'Kthehu'**
  String get goBack;

  /// No description provided for @tryAgain.
  ///
  /// In sq, this message translates to:
  /// **'Provo Përsëri'**
  String get tryAgain;

  /// No description provided for @correctCount.
  ///
  /// In sq, this message translates to:
  /// **'Sakte'**
  String get correctCount;

  /// No description provided for @wrongCount.
  ///
  /// In sq, this message translates to:
  /// **'Gabim'**
  String get wrongCount;

  /// No description provided for @timeUp.
  ///
  /// In sq, this message translates to:
  /// **'Koha mbaroi!'**
  String get timeUp;

  /// No description provided for @noAnswerTimeUp.
  ///
  /// In sq, this message translates to:
  /// **'Pa përgjigje (koha mbaroi)'**
  String get noAnswerTimeUp;

  /// No description provided for @moduleQuiz.
  ///
  /// In sq, this message translates to:
  /// **'Kuiz i Modulit (3 Nivele)'**
  String get moduleQuiz;

  /// No description provided for @lockedLevel.
  ///
  /// In sq, this message translates to:
  /// **'Nivel i kyçur'**
  String get lockedLevel;

  /// No description provided for @error.
  ///
  /// In sq, this message translates to:
  /// **'Gabim'**
  String get error;

  /// No description provided for @loadingError.
  ///
  /// In sq, this message translates to:
  /// **'Gabim gjatë ngarkimit'**
  String get loadingError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sq':
      return AppLocalizationsSq();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
