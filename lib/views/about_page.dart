import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, titleWidget: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 8),
          Text(
            'Welcome to the Union Shop!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round. We also offer an exclusive personalisation service.\n\nAll online purchases are available for delivery or in-store collection. We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please contact us at hello@upsu.net.\n\nHappy shopping!\nThe Union Shop & Reception Team',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
