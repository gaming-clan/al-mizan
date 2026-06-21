import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/zakat_calculator.dart';

final goldPriceProvider = FutureProvider<double>((ref) async {
  return ZakatCalculator.getGoldPricePerGram();
});

/// Fetches all exchange rates once (cached by Riverpod).
final liveRatesProvider = FutureProvider<Map<String, double>>((ref) async {
  return ZakatCalculator.getLiveExchangeRates();
});

final selectedCurrencyProvider = StateProvider<String>((ref) => 'ALL');

/// Returns live rate if fetched, fallback constant otherwise.
final exchangeRateProvider = Provider<double>((ref) {
  final currency = ref.watch(selectedCurrencyProvider);
  final liveAsync = ref.watch(liveRatesProvider);
  return liveAsync.when(
    data: (rates) =>
        rates[currency] ?? AppConstants.fallbackExchangeRates[currency] ?? 1.0,
    loading: () => AppConstants.fallbackExchangeRates[currency] ?? 1.0,
    error: (_, __) => AppConstants.fallbackExchangeRates[currency] ?? 1.0,
  );
});
