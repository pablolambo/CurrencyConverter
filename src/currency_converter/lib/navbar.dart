import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar(
      {super.key, required this.currentPage});
  final int currentPage;

  @override
  State<Navbar> createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
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

    );
  }
}
