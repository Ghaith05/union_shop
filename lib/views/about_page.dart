import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 8),
          Text(
            'About the Union Shop',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'The Union Shop provides official university merchandise and campus essentials. ',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Opening Hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Mon - Fri: 9:00 - 17:00\nSat: 10:00 - 16:00\nSun: Closed'),
          SizedBox(height: 16),
          Text(
            'Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Email: unionshop@example.edu\nPhone: +44 1234 567890'),
        ],
      ),
    );
  }
}