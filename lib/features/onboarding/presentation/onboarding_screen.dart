import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _nameController = TextEditingController();
  int _currentPage = 0;

  static const _infoPages = [
    _OnboardingPage(
      icon: Icons.balance_rounded,
      title: 'Al Mizan',
      subtitle: 'Mëso Fikhun',
      body:
          'Aplikacioni juaj shqip për jurisprudencën islame. Mësoni dispozitat fetare nga burimet autentike.',
    ),
    _OnboardingPage(
      icon: Icons.menu_book_rounded,
      title: 'Çfarë mësoni',
      subtitle: '12 module fikhore',
      body:
          'Namazi, Agjërimi, Zekati, Haxhi dhe shumë më tepër — çdo modul me mësime, prova Kuranore & Hadith, dhe krahasim midis 4 medhhebeve.',
    ),
    _OnboardingPage(
      icon: Icons.trending_up_rounded,
      title: 'Si funksionon',
      subtitle: 'Progresion me nivele',
      body:
          'Fillo si Fillestar → kalo kuizin me 60% → hap nivelin Mesatar → pastaj Avancuar. Ndiqni progresin tuaj çdo ditë.',
    ),
    _OnboardingPage(
      icon: Icons.school_rounded,
      title: 'Gati për të filluar?',
      subtitle: 'Udhëtimi fillon këtu',
      body:
          'طَلَبُ العِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ\n\n"Kërkimi i dijes është detyrë për çdo musliman."\n— Ibn Maxheh',
    ),
  ];

  static const _totalPages = 5;

  Future<void> _finish(BuildContext context) async {
    final name = _nameController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    if (name.isNotEmpty) {
      await prefs.setString('user_name', name);
    }
    await prefs.setBool('onboarding_complete', true);
    if (context.mounted) context.go('/');
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLast = _currentPage == _totalPages - 1;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: AnimatedOpacity(
                  opacity: isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLast ? null : () => _finish(context),
                    child: Text(
                      'Kalo',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  if (index < _infoPages.length) {
                    return _PageContent(page: _infoPages[index]);
                  }
                  return _NameInputContent(controller: _nameController);
                },
              ),
            ),

            // Dot indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? cs.primary
                          : cs.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: isLast ? () => _finish(context) : _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isLast ? 'Fillo Mësimin' : 'Vazhdo',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameInputContent extends StatelessWidget {
  final TextEditingController controller;
  const _NameInputContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primaryContainer.withValues(alpha: 0.4),
                      border: Border.all(
                          color: cs.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child:
                        Icon(Icons.person_rounded, size: 56, color: cs.primary),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Mirë se vini!',
                    style: GoogleFonts.sourceSerif4(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Si dëshironi të quheni?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                    decoration: InputDecoration(
                      hintText: 'Emri ose pseudonimi juaj',
                      hintStyle: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mund ta ndryshoni në çdo kohë nga karta e profilit.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primaryContainer.withValues(alpha: 0.4),
              border: Border.all(color: cs.primary.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(page.icon, size: 56, color: cs.primary),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: GoogleFonts.sourceSerif4(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            page.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Text(
              page.body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String body;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
  });
}
