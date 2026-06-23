import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _webLinks = [
    _LinkItem(
      title: 'Urtësia Islame',
      subtitle: 'Faqja zyrtare e aplikacionit — thënie islame shqip',
      icon: Icons.format_quote_rounded,
      iconBg: Color(0xFF003527),
      iconColor: Color(0xFF80BEA6),
      url: 'https://urtesiaislame.com',
    ),
    _LinkItem(
      title: 'Lutje Ditore',
      subtitle: 'Lutje nga Kurani dhe Suneti',
      icon: Icons.auto_awesome_rounded,
      iconBg: Color(0xFF0F2E3A),
      iconColor: Color(0xFF60C4E8),
      url: 'https://lutjeditore.com/',
    ),
    _LinkItem(
      title: 'Mburoja',
      subtitle: 'Dhikër dhe lutje mbrojtëse sipas Sunetit',
      icon: Icons.shield_rounded,
      iconBg: Color(0xFF151B2E),
      iconColor: Color(0xFF7B9CFF),
      url: 'https://mburoja.al/',
    ),
    _LinkItem(
      title: 'Kurani Shqip',
      subtitle: 'Kurani Famëlartë me përkthim shqip dhe audio',
      icon: Icons.menu_book_rounded,
      iconBg: Color(0xFF2E1800),
      iconColor: Color(0xFFFFB347),
      url: 'https://kurani-shqip.com/',
    ),
    _LinkItem(
      title: 'Namazi për Fillestarë',
      subtitle: 'Mëso si të falesh hap pas hapi me ilustrime',
      icon: Icons.mosque_rounded,
      iconBg: Color(0xFF1A1040),
      iconColor: Color(0xFFAA88FF),
      url: 'https://namaziperfillestar.com/',
    ),
    _LinkItem(
      title: 'Mëso Arabisht',
      subtitle: 'Kurs arabisht falas i dedikuar shqiptarëve',
      icon: Icons.translate_rounded,
      iconBg: Color(0xFF2E0E00),
      iconColor: Color(0xFFFF8C5A),
      url: 'https://mesoarabisht.com/',
    ),
  ];

  static const _appLinks = [
    _LinkItem(
      title: 'Mburoja App',
      subtitle: 'Dhikër dhe lutje mbrojtëse',
      icon: Icons.shield_rounded,
      iconBg: Color(0xFF151B2E),
      iconColor: Color(0xFF7B9CFF),
      url: 'https://play.google.com/store/apps/details?id=al.mburoja.mburoja_app',
    ),
    _LinkItem(
      title: 'Namazi për Fillestarë',
      subtitle: 'Hap pas hapi si të falesh',
      icon: Icons.mosque_rounded,
      iconBg: Color(0xFF1A1040),
      iconColor: Color(0xFFAA88FF),
      url: 'https://play.google.com/store/apps/details?id=com.namaziperfillestar.app',
    ),
    _LinkItem(
      title: 'Kurani Shqip',
      subtitle: 'Kurani me audio dhe përkthim shqip',
      icon: Icons.menu_book_rounded,
      iconBg: Color(0xFF2E1800),
      iconColor: Color(0xFFFFB347),
      url: 'https://play.google.com/store/apps/details?id=com.kurani_shqip.app',
    ),
    _LinkItem(
      title: 'Lutje Ditore',
      subtitle: 'Lutje nga Kurani dhe Suneti',
      icon: Icons.auto_awesome_rounded,
      iconBg: Color(0xFF0F2E3A),
      iconColor: Color(0xFF60C4E8),
      url: 'https://play.google.com/store/apps/details?id=com.lutjeditore.app',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Rreth Nesh')),
      body: ListView(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          // ── App header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.balance_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Al Mizan',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: cs.primary)),
                    Text('Aplikacion edukativ i Fikhut Islam',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    Text('Versioni 1.0.0',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: cs.outlineVariant)),
                  ],
                ),
              ],
            ),
          ),

          // ── FAQET WEB ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'FAQET WEB',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.2,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          for (final item in _webLinks)
            _LinkTile(item: item, isApp: false),

          const SizedBox(height: 16),

          // ── APLIKACIONET ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'APLIKACIONET',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.2,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          for (final item in _appLinks)
            _LinkTile(item: item, isApp: true),

          const SizedBox(height: 24),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Aplikacionet dhe faqet web islame shqip nga i njëjti ekip.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String url;
  const _LinkItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.url,
  });
}

class _LinkTile extends StatelessWidget {
  final _LinkItem item;
  final bool isApp;
  const _LinkTile({required this.item, required this.isApp});

  Future<void> _open() async {
    final uri = Uri.parse(item.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _open,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(item.subtitle,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 2),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isApp
                      ? Icons.open_in_new_rounded
                      : Icons.open_in_new_rounded,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
