import 'package:flutter/material.dart';

class PrintShackPage extends StatefulWidget {
  static const routeName = '/print';
  const PrintShackPage({Key? key}) : super(key: key);

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Shack - Personalise')),
      body: const Center(child: Text('Print Shack coming soon...')),
    );
  }
}
