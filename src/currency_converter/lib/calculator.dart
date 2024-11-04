import 'package:flutter/material.dart';
import 'exchange_rate_service.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  /* to z api */
  final List<String> currencies = ['PLN', 'GBP', 'EUR', 'USD'];
  String selectedBaseCurrency = 'PLN';
  String selectedTargetCurrency = 'USD';
  Map<String, double>? exchangeRates;
  double result = 10;
  String input = "";

  var txt = TextEditingController();

  void calculateExchangeValue() {
    double? tmp = double.tryParse(input);
    if (tmp != null) {
      result = tmp * getExchangeRate(selectedBaseCurrency, selectedTargetCurrency);
    }
    print(result);
    txt.text = result.toString();
  }

  @override
  void initState() {
    super.initState();
    fetchRates();
  }

  Future<void> fetchRates() async {
    var exchangeRateService = ExchangeRateService();
    try {
      final rates =
          await exchangeRateService.fetchExchangeRates(selectedBaseCurrency);
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
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(children: [
          Center(child: Text("waluta bazowa")),
          SizedBox(
            width:100 ,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (String value) {
                setState(() {
                  input = value;
                });
                print(input);
              },
            ),
          ),
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
        ]),
        Icon(Icons.arrow_forward_outlined),
        Column(children: [
          Center(child: Text("waluta bazowa")),
          SizedBox(
            width:100 ,
            child: TextField(
              controller: txt,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
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
        ]),
      ]),
      Container(
          child: ElevatedButton(
              onPressed: calculateExchangeValue, child: const Text("Oblicz")),
          margin: EdgeInsets.all(10)),
    ]);
  }
}
