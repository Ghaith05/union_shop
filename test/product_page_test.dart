import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data/sample_data.dart';
import 'package:union_shop/views/product_page.dart';

void main() {
  testWidgets('ProductPage placeholder renders', (WidgetTester tester) async {
   await tester.pumpWidget(MaterialApp(
  home: ProductPage(product: sampleProducts.first),
));

    expect(find.text('Product'), findsOneWidget); // app bar title
    expect(find.text('Product detail / list placeholder'), findsOneWidget);
  });
}
