import 'package:flutter/material.dart';
import 'exchange_rate_service.dart';

class Exchange extends StatefulWidget {
  const Exchange({super.key});

  @override
  State<Exchange> createState() => _Exchange();
}

class _Exchange extends State<Exchange> {
  final List<String> currencies = ['PLN', 'GBP', 'EUR', 'USD'];
  String selectedBaseCurrency = 'PLN';
  String selectedTargetCurrency = 'USD';
  Map<String, double>? exchangeRates;

  @override
  void initState() {
    super.initState();
    fetchRates(); 
  }

  Future<void> fetchRates() async {
    var exchangeRateService = ExchangeRateService();
    try {
      final rates = await exchangeRateService.fetchExchangeRates(selectedBaseCurrency);
      setState(() {
        exchangeRates = rates.cast<String, double>();
      });
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  double getExchangeRate(String base, String target) {
    if (exchangeRates == null || !exchangeRates!.containsKey(target)) {
      throw Exception('Exchange rate not available');
    }
    double baseRate = exchangeRates![base] ?? 1.0;
    double targetRate = exchangeRates![target]!;
    return targetRate / baseRate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Wybierz walutę bazową:"),
        DropdownButton<String>(
          value: selectedBaseCurrency,
          items: currencies.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBaseCurrency = value!;
              fetchRates();
            });
          },
        ),
        SizedBox(height: 20),
        Text("Wybierz walutę docelową:"),
        DropdownButton<String>(
          value: selectedTargetCurrency,
          items: currencies.map((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedTargetCurrency = value!;
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            try {
              double rate = getExchangeRate(selectedBaseCurrency, selectedTargetCurrency);
              print('Kurs wymiany z $selectedBaseCurrency na $selectedTargetCurrency: $rate');
            } catch (e) {
              print(e);
            }
          },
          child: Text("Uzyskaj kurs wymiany"),
        ),
      ],
    );
  }
}
