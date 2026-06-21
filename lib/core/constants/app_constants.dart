class AppConstants {
  AppConstants._();

  static const String appName = 'Al Mizan';
  static const String appNameAr = 'الميزان';
  static const String appTagline = 'Mëso Fikhun';

  // Zakat
  static const double zakatRate = 0.025; // 2.5%
  static const double defaultGoldPricePerGram = 75.0; // USD fallback
  static const double goldNisabGrams = 85.0; // standard nisabi (85g ar)
  static const double silverNisabGrams = 612.36; // ~52.5 tola

  // Crop zakat
  static const double cropNisabKg = 653.0; // 5 wasaq
  static const double cropRateRainIrrigated = 0.10; // 10% ushur
  static const double cropRateMachineIrrigated = 0.05; // 5%

  // Currency data (fallback rates vs USD)
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'ALL': 'L',
    'TRY': '₺',
    'SAR': '﷼',
  };

  static const Map<String, String> currencyNames = {
    'USD': 'Dollar Amerikan',
    'EUR': 'Euro',
    'GBP': 'Paund Britanik',
    'ALL': 'Lek Shqiptar',
    'TRY': 'Lira Turke',
    'SAR': 'Rial Saudit',
  };

  static const Map<String, double> fallbackExchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'ALL': 83.0, // 1 USD ≈ 83 ALL → 85g × $75 × 83 ≈ 530,000 ALL (nisabi)
    'TRY': 38.5,
    'SAR': 3.75,
  };

  // Exchange rate API (free, no key)
  static const String exchangeRateApiUrl =
      'https://open.er-api.com/v6/latest/USD';

  // Madhab keys
  static const String hanafi = 'hanafi';
  static const String maliki = 'maliki';
  static const String shafii = 'shafii';
  static const String hanbali = 'hanbali';

  static const List<String> madhabKeys = [hanafi, maliki, shafii, hanbali];

  static const Map<String, String> madhabNames = {
    hanafi: 'Hanefi',
    maliki: 'Maliki',
    shafii: "Shafi'i",
    hanbali: 'Hanbeli',
  };

  static const Map<String, String> madhabNamesAr = {
    hanafi: 'الحنفي',
    maliki: 'المالكي',
    shafii: 'الشافعي',
    hanbali: 'الحنبلي',
  };

  // Ruling types
  static const Map<String, String> rulingLabels = {
    'farz': 'Farz',
    'vaxhib': 'Vaxhib',
    'sunnet_muekede': 'Sunnet Muekede',
    'sunnet_gajr_muekede': 'Sunnet Gajr Muekede',
    'mustehab': 'Mustehab',
    'mubah': 'Mubah',
    'mekruh_tahrimen': 'Mekruh Tahrimen',
    'mekruh_tenzihen': 'Mekruh Tenzihen',
    'haram': 'Haram',
  };

  // Module icons
  static const Map<String, String> moduleIcons = {
    'introduction': 'book_open',
    'taharah': 'droplets',
    'salah': 'landmark', // mosque-like
    'sawm': 'moon',
    'zakat': 'hand_coins',
    'hajj': 'map_pin',
    'muamalat': 'handshake',
    'halal_haram': 'utensils',
    'nikah': 'family',
    'xhenaze': 'cemetery',
    'betim_nedhr': 'oath',
    'ushqimi_pija': 'food',
  };
}
