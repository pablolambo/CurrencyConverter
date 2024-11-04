import 'package:flutter/material.dart';
import 'package:currency_converter/exchange.dart';
import 'package:currency_converter/calculator.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'waluter3000',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    Calculator(),
    Exchange(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waluty'),
        foregroundColor: Colors.white,
        //backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.deepPurple,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calculate_sharp),
            icon: Icon(Icons.calculate_sharp),
            label: 'Kalkulator walutowy',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_sharp),
            label: 'Kursy walut',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
