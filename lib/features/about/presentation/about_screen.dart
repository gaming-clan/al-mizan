import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _webLinks = [
    _LinkItem(
      title: 'Urtësia Islame',
      subtitle: 'Thënie islame shqip',
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
      url:
          'https://play.google.com/store/apps/details?id=com.namaziperfillestar.app',
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
      appBar: AppBar(title: const Text('Rreth Al Mizan')),
      body: ListView(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 24 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          // ── Hero header ──
          _HeroHeader(theme: theme, cs: cs),

          const SizedBox(height: 8),

          // ── Misioni ──
          _SectionLabel(label: 'MISIONI', cs: cs),
          _InfoCard(
            cs: cs,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ"',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    color: cs.primary,
                    height: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  '"Kërkimi i dijes është detyrë për çdo musliman."',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '— Ibn Maxheh',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.outlineVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Al Mizan (الميزان — "Peshorja") është aplikacioni i parë shqiptar i dedikuar tërësisht mësimit të Fikhut Islam. '
                  'Qëllimi ynë është t\'i sjellim dispozitat fetare nga burimet autentike çdo shqiptari musliman, '
                  'në formë të strukturuar, të kuptueshme dhe të aksesueshme pa internet.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant, height: 1.6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Përmbajtja ──
          _SectionLabel(label: 'PËRMBAJTJA', cs: cs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _StatBox(value: '12', label: 'Module', cs: cs, theme: theme),
                const SizedBox(width: 8),
                _StatBox(value: '48', label: 'Mësime', cs: cs, theme: theme),
                const SizedBox(width: 8),
                _StatBox(value: '239', label: 'Kuize', cs: cs, theme: theme),
                const SizedBox(width: 8),
                _StatBox(
                    value: '155', label: 'Evidenca', cs: cs, theme: theme),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _InfoCard(
            cs: cs,
            theme: theme,
            child: Column(
              children: [
                _FeatureRow(
                  icon: Icons.school_rounded,
                  color: cs.primary,
                  title: '4 Medhhebe',
                  subtitle:
                      'Krahasim mes Hanefit, Malikut, Shafiit dhe Hanbelit',
                  theme: theme,
                  cs: cs,
                ),
                _Divider(cs: cs),
                _FeatureRow(
                  icon: Icons.quiz_rounded,
                  color: AppColors.info,
                  title: 'Kuize Interaktive',
                  subtitle: '239 pyetje me shpjegime të detajuara',
                  theme: theme,
                  cs: cs,
                ),
                _Divider(cs: cs),
                _FeatureRow(
                  icon: Icons.menu_book_rounded,
                  color: cs.secondary,
                  title: 'Evidenca Shkencore',
                  subtitle: '155 ajete Kuranore dhe hadithe me tekst arab',
                  theme: theme,
                  cs: cs,
                ),
                _Divider(cs: cs),
                _FeatureRow(
                  icon: Icons.calculate_rounded,
                  color: const Color(0xFF059669),
                  title: 'Llogaritës Zekati',
                  subtitle: 'Me nisab dhe lloje të ndryshme pasurie',
                  theme: theme,
                  cs: cs,
                ),
                _Divider(cs: cs),
                _FeatureRow(
                  icon: Icons.wifi_off_rounded,
                  color: cs.onSurfaceVariant,
                  title: '100% Offline',
                  subtitle: 'Nuk kërkon asnjë lidhje interneti',
                  theme: theme,
                  cs: cs,
                ),
                _Divider(cs: cs),
                _FeatureRow(
                  icon: Icons.palette_rounded,
                  color: const Color(0xFFF2CA50),
                  title: '7 Tema Vizuale',
                  subtitle:
                      'Parchment, Night, Desert Sands, Azure Mosaic dhe të tjera',
                  theme: theme,
                  cs: cs,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Teknologjia ──
          _SectionLabel(label: 'TEKNOLOGJIA', cs: cs),
          _InfoCard(
            cs: cs,
            theme: theme,
            child: Column(
              children: [
                _TechRow(
                    name: 'Flutter',
                    detail: 'Framework cross-platform',
                    theme: theme,
                    cs: cs),
                _Divider(cs: cs),
                _TechRow(
                    name: 'Riverpod',
                    detail: 'Menaxhimi i gjendjes',
                    theme: theme,
                    cs: cs),
                _Divider(cs: cs),
                _TechRow(
                    name: 'Drift / SQLite',
                    detail: 'Databaza lokale',
                    theme: theme,
                    cs: cs),
                _Divider(cs: cs),
                _TechRow(
                    name: 'Material 3',
                    detail: 'Dizajn modern me Google Fonts',
                    theme: theme,
                    cs: cs),
                _Divider(cs: cs),
                _TechRow(
                    name: 'Source Serif 4 · Plus Jakarta Sans · Amiri',
                    detail: 'Tipografi',
                    theme: theme,
                    cs: cs),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Burimet shkencore ──
          _SectionLabel(label: 'BURIMET SHKENCORE', cs: cs),
          _InfoCard(
            cs: cs,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SourceRow('Dr. Vehbe ez-Zuhejli',
                    'Ligjet e Sheriatit Islam', theme, cs),
                _Divider(cs: cs),
                _SourceRow('Dr. Jusuf el-Kardavi',
                    'Hallalli dhe Harami në Islam', theme, cs),
                _Divider(cs: cs),
                _SourceRow('Muhamed Nasirud-din el-Albani',
                    'Dispozitat e Haxhit dhe Umres', theme, cs),
                _Divider(cs: cs),
                _SourceRow('Abedin Musallari',
                    'Haxhi dhe Rregullat e Tij', theme, cs),
                _Divider(cs: cs),
                _SourceRow(
                    'Sejjid Sabik', 'Fikhus-Sunneh', theme, cs),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Faqet web ──
          _SectionLabel(label: 'FAQET WEB', cs: cs),
          for (final item in _webLinks)
            _LinkTile(item: item, isApp: false),

          const SizedBox(height: 16),

          // ── Aplikacionet ──
          _SectionLabel(label: 'APLIKACIONET TONA', cs: cs),
          for (final item in _appLinks)
            _LinkTile(item: item, isApp: true),

          const SizedBox(height: 16),

          // ── Lidhje ligjore ──
          _SectionLabel(label: 'LIGJORE', cs: cs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Material(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              child: Column(
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14)),
                    ),
                    leading: Icon(Icons.privacy_tip_outlined,
                        color: cs.primary, size: 22),
                    title: Text('Politika e Privatësisë',
                        style: theme.textTheme.titleSmall),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: cs.onSurfaceVariant, size: 20),
                    onTap: () => context.push('/privacy'),
                  ),
                  Divider(
                      height: 1,
                      indent: 56,
                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(14)),
                    ),
                    leading:
                        Icon(Icons.info_outline_rounded, color: cs.primary, size: 22),
                    title: Text('Versioni 1.0.0',
                        style: theme.textTheme.titleSmall),
                    subtitle: Text(
                        'Al Mizan — © 2025 Të gjitha të drejtat janë të rezervuara',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: cs.onSurfaceVariant, size: 20),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Al Mizan',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          '© 2025 Al Mizan\nAplikacion edukativ për jurisprudencën islame.\nTë gjitha të drejtat janë të rezervuara.',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Zhvilluar me ❤️ për komunitetin shqiptar musliman',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'تم تطويره بـ ❤️ للمجتمع الألباني المسلم',
                  style: GoogleFonts.amiri(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _HeroHeader({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.balance_rounded,
                color: Colors.white, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Al Mizan',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: cs.primary)),
                Text('الميزان — Peshorja',
                    style: GoogleFonts.amiri(
                        fontSize: 15, color: cs.onSurfaceVariant)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Text('Versioni 1.0.0',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: cs.primary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _SectionLabel({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          letterSpacing: 1.2,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;
  final Widget child;
  const _InfoCard(
      {required this.cs, required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: child,
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final ColorScheme cs;
  final ThemeData theme;
  const _StatBox(
      {required this.value,
      required this.label,
      required this.cs,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.sourceSerif4(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                )),
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final ThemeData theme;
  final ColorScheme cs;
  const _FeatureRow(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle,
      required this.theme,
      required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                  maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechRow extends StatelessWidget {
  final String name;
  final String detail;
  final ThemeData theme;
  final ColorScheme cs;
  const _TechRow(
      {required this.name,
      required this.detail,
      required this.theme,
      required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(name,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600))),
        Text(detail,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  final String author;
  final String title;
  final ThemeData theme;
  final ColorScheme cs;
  const _SourceRow(this.author, this.title, this.theme, this.cs);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(author,
            style:
                theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        Text(title,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: cs.onSurfaceVariant, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final ColorScheme cs;
  const _Divider({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 20,
        color: cs.outlineVariant.withValues(alpha: 0.4));
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
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
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
                Icon(Icons.open_in_new_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
