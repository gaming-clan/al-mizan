import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  static const _tabRoutes = [
    ('/', Icons.home_rounded),
    ('/modules', Icons.menu_book_rounded),
    ('/search', Icons.search_rounded),
    ('/bookmarks', Icons.bookmark_rounded),
    ('/profile', Icons.person_rounded),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location == _tabRoutes[i].$1) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = [
      (_tabRoutes[0].$1, _tabRoutes[0].$2, l10n.navHome),
      (_tabRoutes[1].$1, _tabRoutes[1].$2, l10n.navModules),
      (_tabRoutes[2].$1, _tabRoutes[2].$2, l10n.navSearch),
      (_tabRoutes[3].$1, _tabRoutes[3].$2, l10n.navBookmarks),
      (_tabRoutes[4].$1, _tabRoutes[4].$2, l10n.navProfile),
    ];
    final index = _currentIndex(context);
    final width = MediaQuery.sizeOf(context).width;
    final cs = Theme.of(context).colorScheme;

    // Tablet: NavigationRail on the left side
    if (width >= 600) {
      final extended = width >= 1024;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (i) => context.go(tabs[i].$1),
              extended: extended,
              minWidth: 72,
              minExtendedWidth: 180,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              backgroundColor: cs.surface,
              indicatorColor: cs.primaryContainer,
              selectedIconTheme: IconThemeData(color: cs.onPrimaryContainer),
              unselectedIconTheme:
                  IconThemeData(color: cs.onSurfaceVariant),
              selectedLabelTextStyle: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 11,
              ),
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.$2),
                    label: Text(tab.$3),
                  ),
              ],
            ),
            VerticalDivider(
              thickness: 0.5,
              width: 0.5,
              color: cs.outlineVariant,
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Phone: BottomNavigationBar
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: cs.outlineVariant, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => context.go(tabs[i].$1),
          items: [
            for (final tab in tabs)
              BottomNavigationBarItem(icon: Icon(tab.$2), label: tab.$3),
          ],
        ),
      ),
    );
  }
}
