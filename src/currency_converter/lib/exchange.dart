import 'package:flutter/material.dart';
import 'exchange_rate_service.dart';
import 'package:intl/intl.dart';

class Exchange extends StatefulWidget {
  const Exchange({super.key});

  @override
  State<Exchange> createState() => _Exchange();
}

class _Exchange extends State<Exchange> {
  List<String> baseCurrencies = [];
  String selectedBaseCurrency = 'PLN';
  Map<String, double>? exchangeRates;
  String? lastUpdatedTime;

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
        lastUpdatedTime = DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timeLastUpdated * 1000));
      });
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Wybierz walute bazową:"),
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
          const SizedBox(height: 20),
          Text("Kursy wymiany dla $selectedBaseCurrency:"),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchRates();
            },
            tooltip: "Odśwież kursy wymiany",
          ),
          if (lastUpdatedTime != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Ostatnio odświeżone: $lastUpdatedTime"),
          ),
          const SizedBox(height: 10),
          exchangeRates == null
            ? const CircularProgressIndicator()
            : Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: exchangeRates!.entries.map((entry) {
                        return ListTile(
                          title: Center(child: Text(entry.key)),
                          subtitle: Center(
                            child: Text("1 $selectedBaseCurrency = ${entry.value} ${entry.key}"),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
      ),
    );
  }
}
