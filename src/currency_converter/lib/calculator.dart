import 'package:flutter/material.dart';
import 'exchange_rate_service.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  List<String> baseCurrencies = [];
  String selectedBaseCurrency = 'PLN';
  String selectedTargetCurrency = 'USD';
  Map<String, double>? exchangeRates;
  List<String> history = ["1 PLN = 10 USD"];

  @override
  void initState() {
    super.initState();
    fetchCurrencyList();
  }

  Future<void> fetchCurrencyList() async {
    var exchangeRateService = ExchangeRateService();
    try {
      final currencies = await exchangeRateService.fetchCurrencyNames('PLN');
      setState(() {
        baseCurrencies = currencies;
        if (!currencies.contains(selectedBaseCurrency)) {
          selectedBaseCurrency = currencies.first;
        }
      });
      fetchRates();
    } catch (e) {
      print('Error fetching currency list: $e');
    }
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
  /* to z api */
  double result = 10;
  String input = "";

  var txt = TextEditingController();

  void calculateExchangeValue() {
    double? tmp = double.tryParse(input);
    if (tmp != null) {
      result = tmp * getExchangeRate(selectedBaseCurrency, selectedTargetCurrency);
    }
    print(result);
    history.add(result.toStringAsFixed(2));
    txt.text = result.toStringAsFixed(2);
    print(history);
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
            items: baseCurrencies.map((String currency) {
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
            items: baseCurrencies.map((String currency) {
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
        const SizedBox(height: 20,),
        Text("HISTORIA"),
        const SizedBox(height: 20,),
        Expanded(
            child: ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: history.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        child: Center(child: Text('Entry ${history[index]}')),
      );
    }
  ))
      ],
    );
  }
}
