import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/modules/presentation/module_list_screen.dart';
import '../../features/modules/presentation/lesson_list_screen.dart';
import '../../features/modules/presentation/lesson_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/quiz/presentation/general_quiz_screen.dart';
import '../../features/quiz/presentation/module_quiz_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/bookmarks/presentation/bookmarks_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/about/presentation/about_screen.dart';
import '../../features/about/presentation/privacy_policy_screen.dart';
import '../../features/zakat_calculator/presentation/zakat_calculator_screen.dart';
import '../../features/ask_scholar/presentation/ask_scholar_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'shell_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_complete') ?? false;
    final loc = state.matchedLocation;
    if (!done && loc != '/onboarding') return '/onboarding';
    if (done && loc == '/onboarding') return '/';
    return null;
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/modules',
          builder: (context, state) => const ModuleListScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/bookmarks',
          builder: (context, state) => const BookmarksScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/module/:moduleId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        return LessonListScreen(moduleId: moduleId);
      },
    ),
    GoRoute(
      path: '/lesson/:moduleId/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final lessonId = state.pathParameters['lessonId']!;
        return LessonScreen(moduleId: moduleId, lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/quiz/:moduleId/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final lessonId = state.pathParameters['lessonId']!;
        return QuizScreen(moduleId: moduleId, lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/general-quiz',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GeneralQuizScreen(),
    ),
    GoRoute(
      path: '/module-quiz/:moduleId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        return ModuleQuizScreen(moduleId: moduleId);
      },
    ),
    GoRoute(
      path: '/zakat',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ZakatCalculatorScreen(),
    ),
    GoRoute(
      path: '/ask',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AskScholarScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/about',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/privacy',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);
