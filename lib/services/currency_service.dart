import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  // Kurs terhadap USD sebagai patokan (offline fallback)
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.91,
    'JPY': 144.54,
    'GBP': 0.79,
    'AUD': 1.48,
    'CAD': 1.35,
    'CHF': 0.90,
    'CNY': 7.16,
    'SEK': 10.40,
    'NZD': 1.60,
    'IDR': 15000.0,
    'MYR': 4.55,
    'SGD': 1.34,
    'THB': 34.0,
    'KRW': 1315.0,
    'HKD': 7.85,
    'PHP': 55.5,
    'VND': 23400.0,
    'INR': 82.3,
    'RUB': 94.1,
  };

  // Konversi antar mata uang
  double convert(String from, String to, double amount) {
    if (!_rates.containsKey(from)) {
      throw Exception('Mata uang $from tidak didukung');
    }
    if (!_rates.containsKey(to)) {
      throw Exception('Mata uang $to tidak didukung');
    }
    double fromRate = _rates[from]!;
    double toRate = _rates[to]!;

    // Konversi: amount -> USD -> target
    double amountInUSD = amount / fromRate;
    double converted = amountInUSD * toRate;

    return converted;
  }

  // List kode mata uang untuk dropdown
  List<String> get currencies => _rates.keys.toList();
}