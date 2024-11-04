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
  List<String> history = [""];

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
      final result = await exchangeRateService.fetchExchangeRates(selectedBaseCurrency);
      final rates = result['rates'] as Map<String, double>;
      final timeLastUpdated = result['time_last_updated'] as int;

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
    txt.text = result.toStringAsFixed(2);
    setState(() {
      history.add("${input} ${selectedBaseCurrency} = ${txt.text} ${selectedTargetCurrency}");
    });
    print(history);
  }

  double getExchangeRate(String base, String target) {
    fetchRates();
    return exchangeRates![base]!;
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
        Expanded(
            child: ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: history.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        child: Center(child: Text('${history[index]}')),
      );
    }
  ))
      ],
    );
  }
}
