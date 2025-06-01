import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'ae6e70683b65588d04ded764';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6/$_apiKey/latest/';

  // Untuk kebutuhan UI (offline/static)
  double convert(String from, String to, double amount) {
    final rates = {
      'IDR': {'USD': 0.000065, 'GBP': 0.000051, 'IDR': 1.0},
      'USD': {'IDR': 15385.0, 'GBP': 0.78, 'USD': 1.0},
      'GBP': {'IDR': 19615.0, 'USD': 1.28, 'GBP': 1.0},
    };

    if (!rates.containsKey(from) || !rates[from]!.containsKey(to)) {
      return 0;
    }
    return amount * rates[from]![to]!;
  }

  // Untuk kebutuhan API (opsional)
  Future<double?> convertCurrency(String from, String to, double amount) async {
    final response = await http.get(Uri.parse('$_baseUrl$from'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        final rates = data['conversion_rates'];
        if (rates.containsKey(to)) {
          double rate = rates[to];
          return amount * rate;
        }
      }
    }
    return null;
  }
}