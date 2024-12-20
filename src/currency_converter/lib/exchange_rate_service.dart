import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/';

  Future<Map<String, dynamic>> fetchExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl$baseCurrency'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = (data['rates'] as Map<String, dynamic>).map((key, value) => MapEntry(key, (value as num).toDouble()));
        rates.remove(baseCurrency);
        final timeLastUpdated = data['time_last_updated'] as int;

        return {
          'rates': rates,
          'time_last_updated': timeLastUpdated,
        };
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  Future<List<String>> fetchCurrencyNames(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl$baseCurrency'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        return rates.keys.toList();
      } else {
        throw Exception('Failed to load currency names');
      }
    } catch (e) {
      throw Exception('Error fetching currency names: $e');
    }
  }
}
