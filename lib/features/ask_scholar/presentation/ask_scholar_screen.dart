import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pre-populated Q&A screen — curated answers from scholars.
/// Follows the Stitch "Ask a Scholar" design pattern.
class AskScholarScreen extends StatefulWidget {
  const AskScholarScreen({super.key});

  @override
  State<AskScholarScreen> createState() => _AskScholarScreenState();
}

class _AskScholarScreenState extends State<AskScholarScreen> {
  String _selectedTopic = 'Të gjitha';

  static const _topics = [
    'Të gjitha',
    'Namazi',
    'Agjërimi',
    'Zekati',
    'Ushqimi',
    'Familja',
    'Tregtia',
    'Shoqëria',
  ];

  static const List<_QA> _qaList = [
    _QA(
      topic: 'Namazi',
      question: 'A prishet namazi nëse nuk e lexon Fatihanë?',
      answer:
          'Sipas medhhebit Hanefi, leximi i Fatihasë në namaz është vaxhib (i domosdoshëm). Nëse lihet qëllimisht, namazi duhet përsëritur. Nëse harrohet, bëhet sehvi sexhde. '
          'Sipas tre medhhebeve tjera (Maliki, Shafi\'i, Hanbeli), Fatihaja është rukn (kusht), pa të cilin namazi nuk pranohet fare.',
      scholar: 'Dr. Vehbe ez-Zuhajli',
      source: 'El-Fikhu el-Islami ue Edil-letuhu',
    ),
    _QA(
      topic: 'Agjërimi',
      question: 'A e prish agjërimin injeksioni?',
      answer:
          'Injeksionet intramuskulare dhe nënlëkurore nuk e prishin agjërimin sepse nuk hyjnë në stomak nëpërmjet rrugëve natyrale. '
          'Injeksionet intravenoze ushqyese (glukozë, vitamina) e prishin agjërimin sipas shumicës së dijetarëve sepse kanë funksion ushqyes.',
      scholar: 'Shejh Ibn Uthejmin',
      source: 'Mexhmu Fetava',
    ),
    _QA(
      topic: 'Ushqimi',
      question: 'A lejohet ngrënia e ushqimit nga Ehli Kitabi?',
      answer:
          'Allahu ka lejuar ushqimin e Ehli Kitabit (të Krishterëve dhe Çifutëve): "Ushqimi i atyre që iu dha Libri është hallall për ju" (Maide 5). '
          'Kjo përfshin mishin e therur me emrin e Zotit sipas ritit të tyre, me kushtin që mënyra e therjes mos e vuajë kafshën.',
      scholar: 'Dr. Jusuf el-Kardavi',
      source: 'Hallalli dhe Harami në Islam',
    ),
    _QA(
      topic: 'Zekati',
      question: 'A jepet zekat për paratë e kursyera për shtëpi?',
      answer:
          'Po, sipas shumicës së dijetarëve, nëse kursimet arrijnë nisabin (sasinë minimale) dhe kalon një vit hixhri mbi to, '
          'duhet dhënë zekat 2.5% edhe nëse paratë janë caktuar për blerje shtëpie. '
          'Qëllimi i përdorimit nuk e heq detyrimin e zekatit.',
      scholar: 'Akademia Ndërkombëtare e Fikhut (OIC)',
      source: 'Vendimi nr. 3, sesioni i 2-të',
    ),
    _QA(
      topic: 'Tregtia',
      question: 'A lejohen kreditë bankare me kamatë?',
      answer:
          'Kamata (ribaja) është e ndaluar me tekst kur\'anor: "Allahu ka lejuar tregtinë dhe ka ndaluar kamatën" (Bekare 275). '
          'Shumica dërrmuese e dijetarëve e ndalon kredinë me kamatë. Alternativa janë financimi islam sipas principit murabaha, ixharah, ose musharekah.',
      scholar: 'Akademia e Fikhut Islam (Mekë)',
      source: 'Vendimi i sesionit të 2-të, 1985',
    ),
    _QA(
      topic: 'Familja',
      question: 'Cilat janë kushtet e nikahut (martesës) në Islam?',
      answer:
          'Kushtet kryesore janë: 1) Pëlqimi i dy palëve, 2) Kujdestari (Veli) i nuses sipas Shafiive e Hanbelive, '
          '3) Dy dëshmitarë meshkuj, 4) Mehri (dhurata martesore), 5) Shpallja publike e martesës. '
          'Pa dëshmitarë, martesa konsiderohet e pavlefshme sipas shumicës.',
      scholar: 'Dr. Vehbe ez-Zuhajli',
      source: 'El-Fikhu el-Islami ue Edil-letuhu',
    ),
    _QA(
      topic: 'Namazi',
      question: 'A falet namazi i ikindisë pas akshamit nëse harrohet?',
      answer:
          'Po, namazi i lënë pa dashje (harresë ose gjumë) falet sapo të kujtohet, pavarësisht kohës. '
          'Profeti ﷺ ka thënë: "Kush harron një namaz, le ta falë kur t\'i kujtohet — nuk ka kompensim tjetër përveç kësaj" (Buhariu & Muslimi).',
      scholar: 'Imam Neveviu',
      source: 'Sherh Sahih Muslim',
    ),
    _QA(
      topic: 'Agjërimi',
      question: 'A agjërohet dita e shtunë vetëm?',
      answer:
          'Ka mosmarrëveshje ndërmjet dijetarëve. Hadithi "Mos agjëroni ditën e shtunë përveç asaj që ju është bërë detyrë" (Ahmedi, Ebu Daudi) ka diskutim mbi vërtetësinë. '
          'Sipas Hanefive lejohet agjërimi vullnetar i shtunës. Shumica këshillojnë bashkimin e shtunës me të premten ose të dielën.',
      scholar: 'Ibn Tejmijje',
      source: 'Mexhmu el-Fetava',
    ),
    _QA(
      topic: 'Namazi',
      question:
          'A duhet falur namaz i veçantë kur ndodh zënia e diellit ose hënës?',
      answer:
          'Po, quhet namazi i Kusufit — dy rekate me katër ruku e katër sexhde (dy ruku në çdo rekat), të falura me xhemat ose vetëm. Profeti ﷺ na mësoi se dielli e hëna nuk errësohen për vdekjen a jetën e ndonjë njeriu, por janë argumente të fuqisë së Allahut; kur të ndodhë kjo, shpejtohet për namaz, lutje e sadaka derisa të largohet.',
      scholar: 'Talha Kurtishi',
      source: 'Namazi me rastin e zënies së Diellit apo Hënës',
    ),
    _QA(
      topic: 'Namazi',
      question: 'A thirret ezani për namazin e Bajramit?',
      answer:
          'Jo, namazi i Bajramit falet pa ezan e pa ikamet. Ai ka dy rekate, me shtatë tekbire shtesë në rekatin e parë dhe pesë në të dytin. Hutbeja mbahet PAS namazit (ndryshe nga xhumaja), dhe prania për ta dëgjuar është sunet, jo obligim.',
      scholar: 'Ibrahim b. Muhamed El-Hukajl',
      source: 'Rregullat e Bajrameve',
    ),
    _QA(
      topic: 'Namazi',
      question: 'Sa rekate falet namazi i teravisë?',
      answer:
          'Shumica e dijetarëve thonë 20 rekate, ndërsa disa e konsiderojnë 11 (me vitrin, sipas praktikës më të njohur të Profetit ﷺ) mendimin më të saktë. Lejohet edhe më shumë a më pak, pasi sahabet e kanë falur me numër të ndryshëm rekatesh — ka liri në këtë çështje, me kusht që të falet dy e nga dy.',
      scholar: 'Fehd ibn Jahja El-Ammarij',
      source: 'Përmbledhje e Rregullave të Taravisë',
    ),
    _QA(
      topic: 'Namazi',
      question: 'Si falet një person i sëmurë që nuk mund të qëndrojë në këmbë?',
      answer:
          'Falet ulur (këmbëkryq preferohet); nëse nuk mundet, në një anë të kthyer nga kibla (e djathta e preferuar); nëse nuk mundet, i shtrirë me shpinë e këmbët nga kibla. Nëse nuk mund të bëjë ruku e sexhde fizikisht, bën me shenjë me kokë (sexhdja më ulët); e në gradën e fundit, falet me zemër, duke bërë nijetin për çdo pjesë të namazit.',
      scholar: 'Muhamed b. Salih El-Uthejmin',
      source: 'Pastërtia dhe namazi i të sëmurit',
    ),
    _QA(
      topic: 'Familja',
      question: 'Çka bëhet kur lind një fëmijë në Islam?',
      answer:
          'Nga rregullat kryesore: 1) ezani në veshin e djathtë të foshnjës, 2) tahniku — t\'i vendoset një hurme e përtypur në gojë, 3) rruajtja e kokës ditën e shtatë dhe dhënia e sadakasë sipas peshës së flokëve në argjend, 4) akika — kurbani i lindjes (dy dele për djalin, një për vajzën), 5) vendosja e një emri të bukur, zakonisht ditën e shtatë.',
      scholar: 'Irfan Tota',
      source: 'Disa rregulla për fëmijën e porsalindur',
    ),
    _QA(
      topic: 'Tregtia',
      question: 'A lejohen lojërat shpërblyese që organizojnë qendrat tregtare?',
      answer:
          'Nuk lejohet blerja e një kuponi vetëm për të hyrë në short (kjo është bixhoz i kulluar). Por lojërat e lidhura me blerje të zakonshme lejohen sipas Sheikh Uthejminit me dy kushte: çmimi i produktit të mos rritet artificialisht për të financuar shpërblimin, dhe blerësi ta blejë sepse ka nevojë reale, jo thjesht për të hyrë në short.',
      scholar: 'Alaudin Abazi',
      source: 'Pjesëmarrja në lojërat shpërblyese',
    ),
    _QA(
      topic: 'Shoqëria',
      question:
          'A lejohet të pranohet dhuratë nga një jobesimtar ditën e festës së tij?',
      answer:
          'Po, pranimi i dhuratës nuk llogaritet pjesëmarrje në festë, por përfitim e afrim drejt Islamit — me kusht që të mos jetë mish i therur për atë festë a simbol i ritit të saj (qirinj, vezë të ngjyrosura). Ndryshe qëndron urimi për festat e tyre fetare, i cili është haram me pajtimin e dijetarëve, sepse përmban pohim të simboleve të kufrit.',
      scholar: 'Alaudin Abazi & Muhamed Salih El-Munexhid',
      source:
          'Pranimi i dhuratave nga jomuslimanët / Urimi i jobesimtarëve për festat e tyre',
    ),
  ];

  List<_QA> get _filteredList {
    if (_selectedTopic == 'Të gjitha') return _qaList;
    return _qaList.where((qa) => qa.topic == _selectedTopic).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pyet Dijetarin'),
      ),
      body: Column(
        children: [
          // Topic chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _topics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final topic = _topics[index];
                final selected = topic == _selectedTopic;
                return FilterChip(
                  label: Text(topic),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedTopic = topic),
                  selectedColor: cs.primaryContainer,
                  checkmarkColor: cs.onPrimary,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Q&A list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 24),
              itemCount: _filteredList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final qa = _filteredList[index];
                return _QACard(qa: qa, isDark: isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QACard extends StatefulWidget {
  final _QA qa;
  final bool isDark;
  const _QACard({required this.qa, required this.isDark});

  @override
  State<_QACard> createState() => _QACardState();
}

class _QACardState extends State<_QACard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.qa.topic.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Question
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.qa.question,
                      style: GoogleFonts.sourceSerif4(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: cs.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                ],
              ),
              // Answer (expandable)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            left: BorderSide(
                              color: cs.primary,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.qa.answer,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Source attribution
                      Row(
                        children: [
                          Icon(Icons.person_rounded,
                              size: 14, color: cs.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${widget.qa.scholar} — ${widget.qa.source}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QA {
  final String topic;
  final String question;
  final String answer;
  final String scholar;
  final String source;
  const _QA({
    required this.topic,
    required this.question,
    required this.answer,
    required this.scholar,
    required this.source,
  });
}
