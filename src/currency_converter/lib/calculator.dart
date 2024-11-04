import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Kalulator walutowy"));
  }
}
