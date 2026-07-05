import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  static const _tabs = [
    ('/', Icons.home_rounded, 'Ballina'),
    ('/modules', Icons.menu_book_rounded, 'Module'),
    ('/search', Icons.search_rounded, 'Kërko'),
    ('/bookmarks', Icons.bookmark_rounded, 'Shënime'),
    ('/profile', Icons.person_rounded, 'Profili'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].$1) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
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
              onDestinationSelected: (i) => context.go(_tabs[i].$1),
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
                for (final tab in _tabs)
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
          onTap: (i) => context.go(_tabs[i].$1),
          items: [
            for (final tab in _tabs)
              BottomNavigationBarItem(icon: Icon(tab.$2), label: tab.$3),
          ],
        ),
      ),
    );
  }
}
