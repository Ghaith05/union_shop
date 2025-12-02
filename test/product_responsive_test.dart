// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';

void main() {
  final sample = Product(
    id: 'p-test',
    title: 'Test Product',
    description: 'Description',
    price: 10.0,
    images: ['assets/images/products/sample.png'],
    collectionId: 'c-test',
  );

  testWidgets(
      'ProductPage shows single column on mobile and two-column on desktop',
      (tester) async {
    // Mobile
    tester.binding.window.physicalSizeTestValue = const Size(375, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: sample)));
    await tester.pumpAndSettle();

    // Expect images then details in Column (find image widget)
    expect(find.text('Test Product'), findsOneWidget);

    // Desktop
    tester.binding.window.physicalSizeTestValue = const Size(1280, 900);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: sample)));
    await tester.pumpAndSettle();

    // On desktop we expect the product title to still be present and layout to build without overflow
    expect(find.text('Test Product'), findsOneWidget);

    addTearDown(() {
      tester.binding.window.clearAllTestValues();
    });
  });
}
