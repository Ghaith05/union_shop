import 'package:flutter/material.dart';

class PrintShackPage extends StatefulWidget {
  static const routeName = '/print';
  const PrintShackPage({Key? key}) : super(key: key);

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  // Minimal state for thumbnails only
  int _selectedImageIndex = 0;
  final List<String> _imagePaths = [
    'assets/images/print_shack/print_shack.png',
    'assets/images/print_shack/print_shack.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Shack - Personalise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 720;
          Widget leftImage = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                _imagePaths[_selectedImageIndex],
                width: double.infinity,
                height: isDesktop ? 360 : 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], height: isDesktop ? 360 : 220),
              ),
              const SizedBox(height: 12),
              Row(
                children: List<Widget>.generate(_imagePaths.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedImageIndex = i),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          border: Border.all(color: i == _selectedImageIndex ? Colors.blue : Colors.black),
                        ),
                        child: Image.asset(
                          _imagePaths[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
          Widget rightForm = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Personalisation', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('£3.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Tax included.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              const Text('Per Line:'),
              const SizedBox(height: 8),
              DropdownButton<String>(
                key: const ValueKey('print-lines'),
                value: 'One Line of Text',
                items: const [
                  DropdownMenuItem(value: 'One Line of Text', child: Text('One Line of Text')),
                  DropdownMenuItem(value: 'Two Lines of Text', child: Text('Two Lines')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const Text('Personalisation Line 1:'),
              const SizedBox(height: 8),
              const TextField(key: ValueKey('print-line1'), decoration: InputDecoration(border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const Text('Personalisation Line 2:'),
              const SizedBox(height: 8),
              const TextField(key: ValueKey('print-line2'), decoration: InputDecoration(border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const Text('Quantity'),
              const SizedBox(height: 8),
              SizedBox(
                width: 88,
                child: DropdownButton<int>(
                  key: const ValueKey('print-qty'),
                  value: 1,
                  items: List<DropdownMenuItem<int>>.generate(10, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  key: const ValueKey('print-add-to-cart'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4d2963)),
                    foregroundColor: const Color(0xFF4d2963),
                  ),
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('ADD TO CART', style: TextStyle(letterSpacing: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('£3 for one line of text! £5 for two!', style: TextStyle(color: Colors.grey)),
            ],
          );

          // Commit B: show left image + right form skeleton on desktop; stack on mobile
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: leftImage),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: rightForm),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [leftImage, const SizedBox(height: 12), rightForm],
                  ),
          );
        }),
      ),
    );
  }
}
