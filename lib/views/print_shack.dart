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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: leftImage,
          );
        }),
      ),
    );
  }
}
