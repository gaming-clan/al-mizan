import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation shell — 5 tabs:
/// Home, Modules, Search, Bookmarks, Profile
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
    final cs = Theme.of(context).colorScheme;

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
