import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';

class PrintShackAboutPage extends StatelessWidget {
  const PrintShackAboutPage({Key? key}) : super(key: key);
  static const routeName = '/print-about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          titleWidget: const Text('About The Print Shack')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 8),
          Center(
            child: Text(
              'The Union Print Shack',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Make It Yours at The Union Print Shack',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Want to add a personal touch? We\'ve got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team\'s always happy to help you pick the right gear and answer any questions.',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'Uni Gear or Your Gear - We\'ll Personalise It',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Whether you\'re repping your university or putting your own spin on a hoodie you already own, we\'ve got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let\'s get creative!',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'Simple Pricing, No Surprises',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Customising your gear won\'t break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. Turnaround time is up to three working days, and we\'ll let you know as soon as it\'s ready to collect.',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'Personalisation Terms & Conditions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'We will print your clothing exactly as you have provided it to us, whether online or in person. We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. Refunds are not provided for any personalised items.',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'Ready to Make It Yours?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Pop in or get in touch today - let\'s create something uniquely you with our personalisation service - The Union Print Shack!',
            style: TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
