import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/zakat_calculator.dart';
import '../providers/zakat_provider.dart';

class ZakatCalculatorScreen extends ConsumerStatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  ConsumerState<ZakatCalculatorScreen> createState() =>
      _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState
    extends ConsumerState<ZakatCalculatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Wealth controllers
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _cashCtrl = TextEditingController();
  final _investCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _debtCtrl = TextEditingController();

  // Crop controllers
  final _harvestCtrl = TextEditingController();
  final _pricePerKgCtrl = TextEditingController();
  bool _isRainIrrigated = true;

  // Livestock controllers
  final _sheepCtrl = TextEditingController();
  final _cattleCtrl = TextEditingController();
  final _camelCtrl = TextEditingController();

  ZakatResult? _wealthResult;
  CropZakatResult? _cropResult;
  LivestockZakatResult? _livestockResult;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _goldCtrl.dispose();
    _silverCtrl.dispose();
    _cashCtrl.dispose();
    _investCtrl.dispose();
    _businessCtrl.dispose();
    _debtCtrl.dispose();
    _harvestCtrl.dispose();
    _pricePerKgCtrl.dispose();
    _sheepCtrl.dispose();
    _cattleCtrl.dispose();
    _camelCtrl.dispose();
    super.dispose();
  }

  void _calcWealth(double goldPriceUsd) {
    final code = ref.read(selectedCurrencyProvider);
    final rate = ref.read(exchangeRateProvider);
    final silverPriceUsd = goldPriceUsd / 80;
    final result = ZakatCalculator.calculate(
      goldGrams: double.tryParse(_goldCtrl.text) ?? 0,
      silverGrams: double.tryParse(_silverCtrl.text) ?? 0,
      cashAmount: double.tryParse(_cashCtrl.text) ?? 0,
      investmentValue: double.tryParse(_investCtrl.text) ?? 0,
      businessGoods: double.tryParse(_businessCtrl.text) ?? 0,
      debtsOwed: double.tryParse(_debtCtrl.text) ?? 0,
      goldPricePerGram: goldPriceUsd,
      silverPricePerGram: silverPriceUsd,
      exchangeRate: rate,
      currencyCode: code,
    );
    setState(() => _wealthResult = result);
  }

  void _calcCrops() {
    final code = ref.read(selectedCurrencyProvider);
    final result = ZakatCalculator.calculateCropZakat(
      harvestKg: double.tryParse(_harvestCtrl.text) ?? 0,
      isRainIrrigated: _isRainIrrigated,
      pricePerKg: double.tryParse(_pricePerKgCtrl.text) ?? 0,
      currencyCode: code,
    );
    setState(() => _cropResult = result);
  }

  void _calcLivestock() {
    final result = ZakatCalculator.calculateLivestockZakat(
      sheepCount: int.tryParse(_sheepCtrl.text) ?? 0,
      cattleCount: int.tryParse(_cattleCtrl.text) ?? 0,
      camelCount: int.tryParse(_camelCtrl.text) ?? 0,
    );
    setState(() => _livestockResult = result);
  }

  @override
  Widget build(BuildContext context) {
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final theme = Theme.of(context);
    final currencyCode = ref.watch(selectedCurrencyProvider);
    final sym = AppConstants.currencySymbols[currencyCode] ?? '\$';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Llogaritës Zekati'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(icon: Icon(Icons.account_balance_wallet_rounded), text: 'Pasuria'),
            Tab(icon: Icon(Icons.grass_rounded), text: 'Të Mbjella'),
            Tab(icon: Icon(Icons.pets_rounded), text: 'Bagëtia'),
          ],
        ),
      ),
      body: goldPriceAsync.when(
        data: (goldPriceUsd) => Column(
          children: [
            // Currency selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text('Valuta:', style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: currencyCode,
                      isExpanded: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      items: AppConstants.currencyNames.entries
                          .map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(
                                  '${AppConstants.currencySymbols[e.key]} ${e.key} — ${e.value}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          ref.read(selectedCurrencyProvider.notifier).state = v;
                          setState(() {
                            _wealthResult = null;
                            _cropResult = null;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _wealthTab(goldPriceUsd, sym, theme),
                  _cropsTab(sym, theme),
                  _livestockTab(theme),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gabim gjatë ngarkimit.')),
      ),
    );
  }

  // ── Wealth tab ──

  Widget _wealthTab(double goldPriceUsd, String sym, ThemeData theme) {
    final rate = ref.watch(exchangeRateProvider);
    final localGoldPrice = goldPriceUsd * rate;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.accent.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Çmimi i arit: $sym${localGoldPrice.toStringAsFixed(2)}/gram',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _field('Ari (gram)', _goldCtrl, Icons.diamond_rounded),
        _field('Argjendi (gram)', _silverCtrl, Icons.circle_outlined),
        _field('Para cash ($sym)', _cashCtrl, Icons.payments_rounded),
        _field('Investime ($sym)', _investCtrl, Icons.trending_up_rounded),
        _field('Mallra biznesi ($sym)', _businessCtrl, Icons.storefront_rounded),
        _field('Borxhe ($sym)', _debtCtrl, Icons.remove_circle_outline),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => _calcWealth(goldPriceUsd),
          icon: const Icon(Icons.calculate_rounded),
          label: const Text('Llogarit Zekatin'),
        ),
        if (_wealthResult != null) ...[
          const SizedBox(height: 24),
          _WealthResultCard(result: _wealthResult!),
        ],
      ],
    );
  }

  // ── Crops tab ──

  Widget _cropsTab(String sym, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.accent.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Nisabi i të mbjellave: ${AppConstants.cropNisabKg.toStringAsFixed(0)} kg (5 vesak).\n'
              'Ushri: 10% nëse ujitet me shi, 5% nëse ujitet me makineri.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _field('Sasia e korrjes (kg)', _harvestCtrl, Icons.grass_rounded),
        _field('Çmimi për kg ($sym)', _pricePerKgCtrl,
            Icons.price_change_rounded),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Ujitet me shi / ujë natyral'),
          subtitle: Text(_isRainIrrigated
              ? 'Ushri: 10%'
              : 'Ushri: 5% (ujitje me makineri)'),
          value: _isRainIrrigated,
          onChanged: (v) => setState(() => _isRainIrrigated = v),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _calcCrops,
          icon: const Icon(Icons.calculate_rounded),
          label: const Text('Llogarit Zekatin e të Mbjellave'),
        ),
        if (_cropResult != null) ...[
          const SizedBox(height: 24),
          _CropResultCard(result: _cropResult!),
        ],
      ],
    );
  }

  // ── Livestock tab ──

  Widget _livestockTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.accent.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Nisabi: Dhen/dhi ≥ 40, Lopë/ka ≥ 30, Deve ≥ 5.\n'
              'Bagëtia duhet të jetë kullotuese (saime) — jo e ushqyer me blerje.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _field('Dele / Dhi (krerë)', _sheepCtrl, Icons.pets_rounded,
            decimal: false),
        _field('Lopë / Ka (krerë)', _cattleCtrl, Icons.pets_rounded,
            decimal: false),
        _field('Deve (krerë)', _camelCtrl, Icons.pets_rounded,
            decimal: false),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _calcLivestock,
          icon: const Icon(Icons.calculate_rounded),
          label: const Text('Llogarit Zekatin e Bagëtisë'),
        ),
        if (_livestockResult != null) ...[
          const SizedBox(height: 24),
          _LivestockResultCard(result: _livestockResult!),
        ],
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool decimal = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// ── Result cards ──

class _WealthResultCard extends StatelessWidget {
  final ZakatResult result;
  const _WealthResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = result.currencySymbol;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rezultati', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            _row('Pasuria totale', '$s${_fmt(result.totalAssets)}'),
            _row('Borxhe', '- $s${_fmt(result.debtsOwed)}'),
            _row('Pasuria neto', '$s${_fmt(result.netAssets)}'),
            const Divider(height: 20),
            _row('Nisab (ari)', '$s${_fmt(result.nisabGold)}'),
            _row('Nisab (argjendi)', '$s${_fmt(result.nisabSilver)}'),
            _row('Nisab i përdorur', '$s${_fmt(result.nisabUsed)}'),
            const Divider(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: result.isEligible
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    result.isEligible ? 'Zekati i detyruar:' : 'Nuk je i obliguar',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (result.isEligible) ...[
                    const SizedBox(height: 8),
                    Text(
                      '$s${_fmt(result.zakatAmount)}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(2);
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CropResultCard extends StatelessWidget {
  final CropZakatResult result;
  const _CropResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = result.currencySymbol;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rezultati i Ushrit', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            _row('Korrja', '${result.harvestKg.toStringAsFixed(1)} kg'),
            _row('Nisabi', '${result.nisabKg.toStringAsFixed(0)} kg'),
            _row('Norma', '${(result.rate * 100).toStringAsFixed(0)}%'),
            const Divider(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: result.isEligible
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    result.isEligible ? 'Zekati i detyruar:' : 'Nuk arrin nisabin',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (result.isEligible) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${result.zakatKg.toStringAsFixed(1)} kg',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (result.zakatValue > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '≈ $s${result.zakatValue.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LivestockResultCard extends StatelessWidget {
  final LivestockZakatResult result;
  const _LivestockResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rezultati i Bagëtisë', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (result.sheepCount > 0) ...[
              _livestockRow(
                  'Dele/Dhi (${result.sheepCount})', result.sheepZakat, theme),
              const SizedBox(height: 8),
            ],
            if (result.cattleCount > 0) ...[
              _livestockRow(
                  'Lopë/Ka (${result.cattleCount})', result.cattleZakat, theme),
              const SizedBox(height: 8),
            ],
            if (result.camelCount > 0) ...[
              _livestockRow(
                  'Deve (${result.camelCount})', result.camelZakat, theme),
            ],
            if (result.sheepCount == 0 &&
                result.cattleCount == 0 &&
                result.camelCount == 0)
              const Center(
                  child:
                      Text('Shkruaj numrin e krerëve për të llogaritur.')),
          ],
        ),
      ),
    );
  }

  Widget _livestockRow(String label, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value.startsWith('Nuk')
            ? Colors.grey.withValues(alpha: 0.08)
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
