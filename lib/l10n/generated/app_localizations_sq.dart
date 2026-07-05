// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get appTitle => 'Al Mizan - Mëso Fikhun';

  @override
  String get navHome => 'Ballina';

  @override
  String get navModules => 'Module';

  @override
  String get navSearch => 'Kërko';

  @override
  String get navBookmarks => 'Shënime';

  @override
  String get navProfile => 'Profili';

  @override
  String homeGreeting(String name) {
    return 'Es-selamu alejkum, $name!';
  }

  @override
  String get homeGreetingDefault => 'Nxënës';

  @override
  String get dailyMeditation => 'MEDITIMI I DITËS';

  @override
  String get continueStudy => 'VAZHDIMI I STUDIMIT';

  @override
  String get quickTools => 'VEGLA TË SHPEJTA';

  @override
  String get continueWhereYouLeft => 'VAZHDO KU MBETE';

  @override
  String lessonsCount(int count) {
    return '$count mësime';
  }

  @override
  String get generalQuiz => 'Kuiz i Përgjithshëm';

  @override
  String get generalQuizSubtitle => 'Testo njohuritë nga të gjitha temat';

  @override
  String get timedChallenge => 'Sfida me Kohë';

  @override
  String get timedChallengeSubtitle =>
      'Kuiz me kohë të kufizuar — sa më i lartë niveli, aq më pak kohë';

  @override
  String get dailyChallenge => 'Sfida Ditore';

  @override
  String get dailyChallengeSubtitle =>
      '10 pyetje të përziera çdo ditë — ruaj serinë!';

  @override
  String get zakatCalculator => 'Llogaritës Zekati';

  @override
  String get zakatCalculatorSubtitle => 'Llogarit detyrimet e zekatit';

  @override
  String get askScholar => 'Pyet Dijetarin';

  @override
  String get askScholarSubtitle => 'Pyetje dhe përgjigje rreth fesë';

  @override
  String get levelBeginner => 'Fillestar';

  @override
  String get levelIntermediate => 'Mesatar';

  @override
  String get levelAdvanced => 'Avancuar';

  @override
  String get settings => 'Cilësime';

  @override
  String get settingsTheme => 'TEMA';

  @override
  String get settingsLanguage => 'GJUHA';

  @override
  String get aboutApp => 'Rreth App-it';

  @override
  String get startQuiz => 'Fillo Kuizin';

  @override
  String get markCompleted => 'Shëno si të Përfunduar';

  @override
  String get completed => 'I Përfunduar';

  @override
  String get nextLesson => 'Mësimi Pasardhës';

  @override
  String get references => 'Referencat';

  @override
  String get lessonMarkedCompleted => 'Mësimi u shënua si i përfunduar!';

  @override
  String get bookmarkAdded => 'U shtua te shënimet!';

  @override
  String questionOf(int current, int total) {
    return 'Pyetja $current/$total';
  }

  @override
  String get nextQuestion => 'Pyetja Tjetër';

  @override
  String get seeResult => 'Shiko Rezultatin';

  @override
  String get result => 'Rezultati';

  @override
  String get goBack => 'Kthehu';

  @override
  String get tryAgain => 'Provo Përsëri';

  @override
  String get correctCount => 'Sakte';

  @override
  String get wrongCount => 'Gabim';

  @override
  String get timeUp => 'Koha mbaroi!';

  @override
  String get noAnswerTimeUp => 'Pa përgjigje (koha mbaroi)';

  @override
  String get moduleQuiz => 'Kuiz i Modulit (3 Nivele)';

  @override
  String get lockedLevel => 'Nivel i kyçur';

  @override
  String get error => 'Gabim';

  @override
  String get loadingError => 'Gabim gjatë ngarkimit';
}
