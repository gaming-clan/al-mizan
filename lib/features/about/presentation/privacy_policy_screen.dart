import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Politika e Privatësisë')),
      body: ListView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 32 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          // ── Koka ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: cs.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.privacy_tip_rounded,
                    color: cs.primary, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Politika e Privatësisë',
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Al Mizan — Aplikacion edukativ i Fikhut Islam',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Hyrë në fuqi: 1 Janar 2025',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.outlineVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _Section(
            number: '1',
            title: 'Hyrje',
            cs: cs,
            theme: theme,
            content:
                'Mirë se vini në Politikën e Privatësisë të aplikacionit Al Mizan. '
                'Kjo politikë shpjegon se si aplikacioni ynë trajton informacionin tuaj personal.\n\n'
                'Al Mizan është ndërtuar mbi parimin e privatësisë së plotë të përdoruesit. '
                'Aplikacioni funksionon 100% offline dhe nuk mbledh, nuk dërgon dhe nuk ndan '
                'asnjë të dhënë personale me palë të treta.',
          ),

          _Section(
            number: '2',
            title: 'Të Dhënat që Ruajmë Lokalisht',
            cs: cs,
            theme: theme,
            content: 'Aplikacioni ruan vetëm të dhënat e mëposhtme '
                'drejtpërdrejt në pajisjen tuaj, duke përdorur SQLite dhe SharedPreferences:',
            bullets: const [
              'Emri ose pseudonimi që vendosni gjatë konfigurimit fillestar',
              'Foto e profilit (nëse zgjidhni të ngarkoni një)',
              'Progresi i mësimit (mësimet e përfunduara)',
              'Rezultatet e kuizeve',
              'Shënimet (bookmarks) të mësimeve të preferuara',
              'Seria e të nxënit (learning streak)',
              'Preferencat e pamjes (tema, modaliteti i errët)',
            ],
          ),

          _Section(
            number: '3',
            title: 'Të Dhëna që NUK Mbledhim',
            cs: cs,
            theme: theme,
            content:
                'Al Mizan nuk mbledh dhe nuk ka qasje në asnjë nga këto të dhëna:',
            bullets: const [
              'Emri i vërtetë, adresa e emailit ose numri i telefonit',
              'Vendndodhja gjeografike (GPS ose IP)',
              'Kontaktet e pajisjes',
              'Identifikuesit e pajisjes (IMEI, MAC address etj.)',
              'Historiku i shfletimit ose aktiviteti jashtë aplikacionit',
              'Të dhënat financiare',
              'Informacioni biometrik',
            ],
          ),

          _Section(
            number: '4',
            title: 'Lidhja me Internet',
            cs: cs,
            theme: theme,
            content:
                'Al Mizan është plotësisht offline. Aplikacioni nuk kërkon dhe nuk përdor '
                'lidhje interneti për asnjë funksion bazë. '
                'Nuk ekziston asnjë server, API ose shërbim cloud i lidhur me të dhënat tuaja.\n\n'
                'E vetmja rast kur mund të përdorni internet është nëse klikoni lidhje '
                'të jashtme tek seksioni "Rreth Nesh", të cilat ju ridrejtojnë '
                'në shfletuesin tuaj jashtë aplikacionit.',
          ),

          _Section(
            number: '5',
            title: 'Ndarja e të Dhënave me Palë të Treta',
            cs: cs,
            theme: theme,
            content:
                'Ne nuk ndajmë, shesim, japim me qira apo zbulojmë të dhëna personale '
                'të përdoruesve me asnjë palë të tretë. '
                'Meqenëse nuk mbledhim të dhëna, nuk ka asgjë për të ndarë.',
          ),

          _Section(
            number: '6',
            title: 'Siguria e të Dhënave',
            cs: cs,
            theme: theme,
            content:
                'Të gjitha të dhënat ruhen lokalisht në pajisjen tuaj dhe mbrohen '
                'nga sistemet standarde të sigurisë të Android. '
                'Aksesi në të dhënat e aplikacionit është i kufizuar vetëm tek aplikacioni.',
            bullets: const [
              'Databaza SQLite është e mbrojtur nga sistemi i skedarëve Android',
              'SharedPreferences është i aksesueshëm vetëm nga aplikacioni',
              'Nuk ka transmetim të të dhënave përmes rrjetit',
              'Çinstalimet e aplikacionit fshijnë të gjitha të dhënat automatikisht',
            ],
          ),

          _Section(
            number: '7',
            title: 'Privatësia e Fëmijëve',
            cs: cs,
            theme: theme,
            content:
                'Al Mizan është i përshtatshëm për të gjitha moshat. '
                'Meqenëse nuk mbledhim asnjë të dhënë personale, '
                'nuk ekziston rrezik specifik për privatësinë e fëmijëve. '
                'Aplikacioni nuk kërkon regjistrim dhe nuk ka profile të lidhura me llogari online.',
          ),

          _Section(
            number: '8',
            title: 'Leja e Galerisë (Foto Profili)',
            cs: cs,
            theme: theme,
            content:
                'Nëse zgjidhni të shtoni foto profili, aplikacioni kërkon leje '
                'për të aksesuar galerinë e pajisjes tuaj. Kjo leje:',
            bullets: const [
              'Përdoret vetëm për zgjedhjen e fotos së profilit',
              'Foto ruhet lokalisht në pajisjen tuaj',
              'Nuk ngarkohet në asnjë server',
              'Mund ta anuloni në çdo kohë nga Cilësimet e Android',
            ],
          ),

          _Section(
            number: '9',
            title: 'Të Drejtat Tuaja',
            cs: cs,
            theme: theme,
            content: 'Ju keni kontroll të plotë mbi të dhënat tuaja:',
            bullets: const [
              'Ndryshimi i emrit: në çdo kohë nga karta e profilit',
              'Ndryshimi i fotos: në çdo kohë nga profili',
              'Fshirja e progresit: duke çinstaluar aplikacionin',
              'Fshirja e të dhënave specifike: nga menuja e cilësimeve të Android',
            ],
          ),

          _Section(
            number: '10',
            title: 'Ndryshimet në Politikë',
            cs: cs,
            theme: theme,
            content:
                'Nëse bëjmë ndryshime në këtë Politikë Privatësie, '
                'do t\'ju njoftojmë përmes një përditësimi të aplikacionit. '
                'Versioni i fundit i kësaj politike do të jetë gjithmonë i aksesueshëm '
                'brenda aplikacionit në seksionin "Rreth Al Mizan".\n\n'
                'Vazhdimi i përdorimit të aplikacionit pas ndryshimeve '
                'nënkupton pranimin e politikës së re.',
          ),

          _Section(
            number: '11',
            title: 'Na Kontaktoni',
            cs: cs,
            theme: theme,
            content:
                'Nëse keni pyetje ose shqetësime rreth kësaj Politike Privatësie, '
                'mund të na kontaktoni:\n\n'
                '📧 dariolloshi02@gmail.com\n\n'
                'Do të bëjmë çmos t\'u përgjigjemi brenda 7 ditëve pune.',
          ),

          const SizedBox(height: 24),

          // ── Footer ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                const Icon(Icons.verified_user_rounded,
                    color: AppColors.success, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Të dhënat tuaja janë 100% private',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: cs.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Asnjë server · Asnjë regjistrim · Asnjë gjurmim',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
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

class _Section extends StatelessWidget {
  final String number;
  final String title;
  final String content;
  final List<String>? bullets;
  final ColorScheme cs;
  final ThemeData theme;

  const _Section({
    required this.number,
    required this.title,
    required this.content,
    required this.cs,
    required this.theme,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: cs.primary.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          if (bullets != null) ...[
            const SizedBox(height: 10),
            ...bullets!.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          b,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 8),
          Divider(
              color: cs.outlineVariant.withValues(alpha: 0.3),
              height: 1),
        ],
      ),
    );
  }
}
