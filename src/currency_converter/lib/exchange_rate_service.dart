import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/';
  final List<String> targetCurrencies = ['PLN', 'GBP', 'EUR', 'USD'];

  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl$baseCurrency'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        final filteredRates = Map.fromEntries(
          rates.entries
              .map((entry) => MapEntry(entry.key, entry.value.toDouble()))
              .where((entry) => targetCurrencies.contains(entry.key)),
        );

        return filteredRates;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }
}
