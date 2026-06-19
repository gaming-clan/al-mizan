import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/zakat_calculator.dart';

final goldPriceProvider = FutureProvider<double>((ref) async {
  return ZakatCalculator.getGoldPricePerGram();
});

final selectedCurrencyProvider = StateProvider<String>((ref) => 'EUR');

final exchangeRateProvider = Provider<double>((ref) {
  final currency = ref.watch(selectedCurrencyProvider);
  return AppConstants.fallbackExchangeRates[currency] ?? 1.0;
});
