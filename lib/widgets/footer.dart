import 'package:flutter/material.dart';

class SiteFooter extends StatelessWidget {
  final VoidCallback onAbout;
  final VoidCallback onHelp;
  final VoidCallback onTerms;
  final VoidCallback onContact;
  final VoidCallback? onSearch;

  const SiteFooter({
    Key? key,
    required this.onAbout,
    required this.onHelp,
    required this.onTerms,
    required this.onContact,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          const Text('Union Shop',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onSearch != null)
                TextButton(
                    key: const ValueKey('footer-search'),
                    onPressed: onSearch,
                    child: const Text('Search')),
              TextButton(onPressed: onHelp, child: const Text('Help')),
              TextButton(onPressed: onAbout, child: const Text('About')),
              TextButton(onPressed: onTerms, child: const Text('Terms')),
              TextButton(onPressed: onContact, child: const Text('Contact')),
            ],
          ),
          const SizedBox(height: 8),
          const Text('© University Union — All rights reserved',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
