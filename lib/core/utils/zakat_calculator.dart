import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ZakatCalculator {
  /// Fetches live exchange rates vs USD from open.er-api.com.
  /// Falls back to constants if offline or API fails.
  static Future<Map<String, double>> getLiveExchangeRates() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstants.exchangeRateApiUrl))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.map((k, v) => MapEntry(k, (v as num).toDouble()));
      }
    } catch (_) {}
    return Map<String, double>.from(AppConstants.fallbackExchangeRates);
  }

  /// Fetches current gold price per gram in USD.
  static Future<double> getGoldPricePerGram() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.gold-api.com/price/XAU'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pricePerOunce = (data['price'] as num).toDouble();
        return pricePerOunce / 31.1035; // troy ounce → gram
      }
    } catch (_) {
      // Offline or API error
    }
    return AppConstants.defaultGoldPricePerGram;
  }

  /// Calculates wealth zakat (mal) with currency support.
  static ZakatResult calculate({
    double goldGrams = 0,
    double silverGrams = 0,
    double cashAmount = 0,
    double investmentValue = 0,
    double businessGoods = 0,
    double debtsOwed = 0,
    required double goldPricePerGram,
    required double silverPricePerGram,
    required double exchangeRate,
    required String currencyCode,
  }) {
    // Gold price comes in USD; convert to local currency
    final localGoldPrice = goldPricePerGram * exchangeRate;
    final localSilverPrice = silverPricePerGram * exchangeRate;

    final goldValue = goldGrams * localGoldPrice;
    final silverValue = silverGrams * localSilverPrice;
    final totalAssets =
        goldValue + silverValue + cashAmount + investmentValue + businessGoods;
    final netAssets = totalAssets - debtsOwed;

    final nisabGold = AppConstants.goldNisabGrams * localGoldPrice;
    final nisabSilver = AppConstants.silverNisabGrams * localSilverPrice;
    final nisab = nisabSilver < nisabGold ? nisabSilver : nisabGold;

    final isEligible = netAssets >= nisab;
    final zakatAmount = isEligible ? netAssets * AppConstants.zakatRate : 0.0;

    return ZakatResult(
      totalAssets: totalAssets,
      debtsOwed: debtsOwed,
      netAssets: netAssets,
      nisabGold: nisabGold,
      nisabSilver: nisabSilver,
      nisabUsed: nisab,
      isEligible: isEligible,
      zakatAmount: zakatAmount,
      goldValue: goldValue,
      silverValue: silverValue,
      currencySymbol: AppConstants.currencySymbols[currencyCode] ?? '\$',
    );
  }

  /// Calculates zakat on crops (ushur).
  static CropZakatResult calculateCropZakat({
    required double harvestKg,
    required bool isRainIrrigated,
    required double pricePerKg,
    required String currencyCode,
  }) {
    const nisabKg = AppConstants.cropNisabKg;
    final isEligible = harvestKg >= nisabKg;
    final rate = isRainIrrigated
        ? AppConstants.cropRateRainIrrigated
        : AppConstants.cropRateMachineIrrigated;
    final zakatKg = isEligible ? harvestKg * rate : 0.0;
    final zakatValue = zakatKg * pricePerKg;

    return CropZakatResult(
      harvestKg: harvestKg,
      nisabKg: nisabKg,
      isEligible: isEligible,
      rate: rate,
      zakatKg: zakatKg,
      zakatValue: zakatValue,
      currencySymbol: AppConstants.currencySymbols[currencyCode] ?? '\$',
    );
  }

  /// Calculates zakat on livestock.
  static LivestockZakatResult calculateLivestockZakat({
    required int sheepCount,
    required int cattleCount,
    required int camelCount,
  }) {
    return LivestockZakatResult(
      sheepZakat: _sheepZakat(sheepCount),
      cattleZakat: _cattleZakat(cattleCount),
      camelZakat: _camelZakat(camelCount),
      sheepCount: sheepCount,
      cattleCount: cattleCount,
      camelCount: camelCount,
    );
  }

  static String _sheepZakat(int count) {
    if (count < 40) return 'Nuk ka zekat (nën 40 krerë)';
    if (count <= 120) return '1 dele/dhi';
    if (count <= 200) return '2 dele/dhi';
    if (count <= 399) return '3 dele/dhi';
    final extra = (count - 300) ~/ 100;
    return '${3 + extra} dele/dhi';
  }

  static String _cattleZakat(int count) {
    if (count < 30) return 'Nuk ka zekat (nën 30 krerë)';
    if (count <= 39) return '1 viç/mëshqerrë 1-vjeçare (tabi\')';
    if (count <= 59) return '1 lopë/ka 2-vjeçare (musinneh)';
    if (count <= 69) return '2 viça 1-vjeçarë';
    if (count <= 79) return '1 viç 1-vjeçar + 1 lopë 2-vjeçare';
    // Pattern continues
    final thirties = count ~/ 30;
    final forties = count ~/ 40;
    return '$thirties tabi\' (për çdo 30) ose $forties musinneh (për çdo 40)';
  }

  static String _camelZakat(int count) {
    if (count < 5) return 'Nuk ka zekat (nën 5 krerë)';
    if (count <= 9) return '1 dele/dhi';
    if (count <= 14) return '2 dele/dhi';
    if (count <= 19) return '3 dele/dhi';
    if (count <= 24) return '4 dele/dhi';
    if (count <= 35) return '1 deve femër 1-vjeçare (bintu mekhad)';
    if (count <= 45) return '1 deve femër 2-vjeçare (bintu lebun)';
    if (count <= 60) return '1 deve femër 3-vjeçare (hikkah)';
    if (count <= 75) return '1 deve femër 4-vjeçare (xhedh\'ah)';
    if (count <= 90) return '2 deve femra 2-vjeçare';
    if (count <= 120) return '2 deve femra 3-vjeçare';
    final forties = count ~/ 40;
    final fifties = count ~/ 50;
    return '$forties bintu lebun (për çdo 40) ose $fifties hikkah (për çdo 50)';
  }
}

class ZakatResult {
  final double totalAssets;
  final double debtsOwed;
  final double netAssets;
  final double nisabGold;
  final double nisabSilver;
  final double nisabUsed;
  final bool isEligible;
  final double zakatAmount;
  final double goldValue;
  final double silverValue;
  final String currencySymbol;

  const ZakatResult({
    required this.totalAssets,
    required this.debtsOwed,
    required this.netAssets,
    required this.nisabGold,
    required this.nisabSilver,
    required this.nisabUsed,
    required this.isEligible,
    required this.zakatAmount,
    required this.goldValue,
    required this.silverValue,
    required this.currencySymbol,
  });
}

class CropZakatResult {
  final double harvestKg;
  final double nisabKg;
  final bool isEligible;
  final double rate;
  final double zakatKg;
  final double zakatValue;
  final String currencySymbol;

  const CropZakatResult({
    required this.harvestKg,
    required this.nisabKg,
    required this.isEligible,
    required this.rate,
    required this.zakatKg,
    required this.zakatValue,
    required this.currencySymbol,
  });
}

class LivestockZakatResult {
  final String sheepZakat;
  final String cattleZakat;
  final String camelZakat;
  final int sheepCount;
  final int cattleCount;
  final int camelCount;

  const LivestockZakatResult({
    required this.sheepZakat,
    required this.cattleZakat,
    required this.camelZakat,
    required this.sheepCount,
    required this.cattleCount,
    required this.camelCount,
  });
}
