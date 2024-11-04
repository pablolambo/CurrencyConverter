import 'package:flutter/material.dart';

class Exchange extends StatefulWidget {
  const Exchange({super.key});

  @override
  State<Exchange> createState() => _Exchange();
}

class _Exchange extends State<Exchange> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Kursy walut"));
  }
}
