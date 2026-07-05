// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Al Mizan - Learn Fiqh';

  @override
  String get navHome => 'Home';

  @override
  String get navModules => 'Modules';

  @override
  String get navSearch => 'Search';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navProfile => 'Profile';

  @override
  String homeGreeting(String name) {
    return 'As-salamu alaykum, $name!';
  }

  @override
  String get homeGreetingDefault => 'Student';

  @override
  String get dailyMeditation => 'DAILY MEDITATION';

  @override
  String get continueStudy => 'CONTINUE STUDYING';

  @override
  String get quickTools => 'QUICK TOOLS';

  @override
  String get continueWhereYouLeft => 'CONTINUE WHERE YOU LEFT OFF';

  @override
  String lessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String get generalQuiz => 'General Quiz';

  @override
  String get generalQuizSubtitle => 'Test your knowledge across all topics';

  @override
  String get timedChallenge => 'Timed Challenge';

  @override
  String get timedChallengeSubtitle =>
      'Quiz against the clock — the higher the level, the less time';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get dailyChallengeSubtitle =>
      '10 mixed questions every day — keep your streak!';

  @override
  String get zakatCalculator => 'Zakat Calculator';

  @override
  String get zakatCalculatorSubtitle => 'Calculate your zakat obligations';

  @override
  String get askScholar => 'Ask the Scholar';

  @override
  String get askScholarSubtitle => 'Questions and answers about the religion';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get settings => 'Settings';

  @override
  String get settingsTheme => 'THEME';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get aboutApp => 'About the App';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String get markCompleted => 'Mark as Completed';

  @override
  String get completed => 'Completed';

  @override
  String get nextLesson => 'Next Lesson';

  @override
  String get references => 'References';

  @override
  String get lessonMarkedCompleted => 'Lesson marked as completed!';

  @override
  String get bookmarkAdded => 'Added to bookmarks!';

  @override
  String questionOf(int current, int total) {
    return 'Question $current/$total';
  }

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get seeResult => 'See Result';

  @override
  String get result => 'Result';

  @override
  String get goBack => 'Go Back';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get correctCount => 'Correct';

  @override
  String get wrongCount => 'Wrong';

  @override
  String get timeUp => 'Time\'s up!';

  @override
  String get noAnswerTimeUp => 'No answer (time ran out)';

  @override
  String get moduleQuiz => 'Module Quiz (3 Levels)';

  @override
  String get lockedLevel => 'Locked level';

  @override
  String get error => 'Error';

  @override
  String get loadingError => 'Loading error';
}
